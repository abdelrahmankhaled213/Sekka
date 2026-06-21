import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgrest/postgrest.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/capacity_prediction_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';
import 'package:bloc/bloc.dart';

import '../../../Core/Constants/app_color.dart';

class NearestStationCubit extends Cubit<NearestStationState> {

  final NearestStationRepo        repo;
  final CapacityPredictionService predictionService;

  GoogleMapController? _mapController;

  NearestStationCubit(this.repo, this.predictionService)
      : super(const NearestStationState());

  // ── map controller ──────────────────────────────────────────────────────────

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void disposeMapController() {
    _mapController?.dispose();
    _mapController = null;
  }

  // ── select station ──────────────────────────────────────────────────────────

  void selectStation(NearestStationModel station) {
    emit(state.copyWith(selectedStation: station));
    _animateTo(station.location.lat, station.location.lng, zoom: 16);
  }

  void clearSelection() => emit(state.copyWith(clearSelected: true));

  // ── animate camera ──────────────────────────────────────────────────────────

  Future<void> _animateTo(double lat, double lng, {double zoom = 14}) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom),
      ),
    );
  }

  Future<void> goToUserLocation() async {
    if (state.userLat != null && state.userLng != null) {
      await _animateTo(state.userLat!, state.userLng!);
    }
  }

  // ── build markers ───────────────────────────────────────────────────────────

  Future<Set<Marker>> _buildMarkers(List<NearestStationModel> stations) async {
    final markers = <Marker>{};

    for (final s in stations) {
      final icon = await _markerIcon(
        type:   s.type,
        isBest: s.isBestPrediction,
      );
      markers.add(Marker(
        markerId:   MarkerId(s.id?.toString() ?? s.name),
        position:   LatLng(s.location.lat, s.location.lng),
        icon:       icon,
        zIndex:     s.isBestPrediction ? 2 : 1,
        onTap:      () => selectStation(s),
        infoWindow: InfoWindow(
          title:   s.name,
          snippet: '${s.distanceKm.toStringAsFixed(2)} km away',
        ),
      ));
    }

    return markers;
  }

  Future<BitmapDescriptor> _markerIcon({
    TransportType? type,
    bool isBest = false,
  }) async {
    const size = 84.0;
    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);

    final bgColor = isBest ? const Color(0xFFF59E0B) : _typeColor(type);

    if (isBest) {
      canvas.drawCircle(
        const Offset(size / 2, size / 2),
        size / 2,
        Paint()..color = bgColor.withOpacity(0.25),
      );
    }

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - (isBest ? 8 : 6),
      Paint()..color = bgColor,
    );

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - (isBest ? 8 : 6),
      Paint()
        ..color       = Colors.white
        ..style       = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final tp = TextPainter(
      text: TextSpan(
        text:  isBest ? '⭐' : _typeEmoji(type),
        style: TextStyle(fontSize: isBest ? 26 : 28),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(
      (size - tp.width)  / 2,
      (size - tp.height) / 2,
    ));

    final img   = await recorder.endRecording()
        .toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Color _typeColor(TransportType? type) {
    switch (type) {
      case TransportType.metro:    return AppColor.main;
      case TransportType.monorail: return const Color(0xFF8B5CF6);
      case TransportType.bus:      return const Color(0xFF10B981);
      case TransportType.microbus: return const Color(0xFFF59E0B);
      default:                     return AppColor.main;
    }
  }

  String _typeEmoji(TransportType? type) {
    switch (type) {
      case TransportType.metro:    return '🚇';
      case TransportType.monorail: return '🚝';
      case TransportType.bus:      return '🚌';
      case TransportType.microbus: return '🚐';
      default:                     return '📍';
    }
  }

  // ── fit camera ──────────────────────────────────────────────────────────────

  Future<void> _fitCamera(List<NearestStationModel> stations) async {
    if (stations.isEmpty || _mapController == null) return;

    final points = stations
        .map((s) => LatLng(s.location.lat, s.location.lng))
        .toList();

    double minLat = points.first.latitude,  maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude  < minLat) minLat = p.latitude;
      if (p.latitude  > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        80,
      ),
    );
  }

  // ── internal: fetch + rank + emit ───────────────────────────────────────────

  Future<void> _fetchAndEmit({
    required double lat,
    required double lng,
    required String locationName,
    TransportType?  type,
    bool saveAsUserLocation     = false,
    bool saveAsSearchedLocation = false,
    bool clearSearched          = false,
  }) async {
    try {
      final rawStations = await repo.getNearestStops(
        lat:  lat,
        lng:  lng,
        type: type,
      );

      for (final s in rawStations) {
        debugPrint('Raw station: ${s.name}, distance: ${s.distanceKm} km');
      }

      final stations = await _withPredictions(rawStations);
      final markers  = await _buildMarkers(stations);

      if (isClosed) return;

      emit(state.copyWith(
        status:       NearestStationStatus.loaded,
        stations:     stations,
        markers:      markers,
        locationName: locationName,
        // user real GPS — بيتحدث بس لما loadNearestStations يتكاله
        userLat:      saveAsUserLocation ? lat : state.userLat,
        userLng:      saveAsUserLocation ? lng : state.userLng,
        // searched place — بيتحدث لما user يختار من الـ search
        searchedLat:   saveAsSearchedLocation ? lat : state.searchedLat,
        searchedLng:   saveAsSearchedLocation ? lng : state.searchedLng,
        clearSearched: clearSearched,
      ));

      await _fitCamera(stations);

      if (stations.isNotEmpty && stations.first.isBestPrediction) {
        await _animateTo(
          stations.first.location.lat,
          stations.first.location.lng,
          zoom: 15,
        );
      }
    } catch (e) {
      if (isClosed) return;
      final msg = e is PostgrestException
          ? e.message
          : ErrorHandler.handleError(e).message;
      emit(state.copyWith(
        status:       NearestStationStatus.error,
        errorMessage: msg,
      ));
    }
  }

  // ── public methods ──────────────────────────────────────────────────────────

  /// يتكاله عند أول load أو لما user يضغط clear search
  Future<void> loadNearestStations() async {
    emit(state.copyWith(status: NearestStationStatus.loading));

    try {
      final position = await LocationHelper.determinePosition();
      if (position == null) {
        emit(state.copyWith(
          status:       NearestStationStatus.error,
          errorMessage: 'Could not get your location.',
        ));
        return;
      }

      String locationName = 'Your Location';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          locationName = p.subLocality?.isNotEmpty == true
              ? p.subLocality!
              : p.locality ?? 'Your Location';
        }
      } catch (_) {}

      await _fetchAndEmit(
        lat:                position.latitude,
        lng:                position.longitude,
        locationName:       locationName,
        type:               state.selectedFilter,
        saveAsUserLocation: true, // ✅ احفظ كـ user GPS
        clearSearched:      true, // ✅ امسح الـ searched location
      );
    } catch (e) {
      if (isClosed) return;
      final msg = e is PostgrestException
          ? e.message
          : ErrorHandler.handleError(e).message;
      emit(state.copyWith(
        status:       NearestStationStatus.error,
        errorMessage: msg,
      ));
    }
  }

  /// يتكاله لما user يختار مكان من الـ search
  Future<void> loadNearestStationsForSearchedLocation({
    required double lat,
    required double lng,
    required String overrideName,
  }) async {
    emit(state.copyWith(
      status:       NearestStationStatus.loading,
      locationName: overrideName,
    ));

    await _fetchAndEmit(
      lat:                    lat,          // ✅ coords الـ searched place
      lng:                    lng,
      locationName:           overrideName,
      type:                   state.selectedFilter,
      saveAsSearchedLocation: true,         // ✅ احفظهم منفصلين عن user GPS
    );
  }

  /// يتكاله لما user يغير الـ filter chips
  Future<void> applyFilter(TransportType? type) async {
    // ✅ لو في searched location استخدمه، غيره استخدم user GPS
    final lat = state.searchedLat ?? state.userLat;
    final lng = state.searchedLng ?? state.userLng;

    if (lat == null || lng == null) return;

    final newType = type == state.selectedFilter ? null : type;

    emit(state.copyWith(
      status:         NearestStationStatus.loading,
      selectedFilter: newType,
      clearFilter:    newType == null,
    ));

    await _fetchAndEmit(
      lat:          lat,
      lng:          lng,
      locationName: state.locationName,
      type:         newType,
    );
  }

  // ── predictions & ranking ───────────────────────────────────────────────────

  Future<List<NearestStationModel>> _withPredictions(
      List<NearestStationModel> stations) async {
    final predictions = await Future.wait(
      stations.map((s) => s.id != null
          ? predictionService.getPredictionForStation(s.id!)
          : Future.value(null)),
    );

final withPred = List.generate(stations.length, (i) {
  final p = predictions[i];
  return p != null
      ? stations[i].copyWith(
          crowding:      p.crowdingLevel,
          occupiedSeats: p.occupiedSeats,
          totalSeats:    p.totalSeats,
        )
      : stations[i];
});

    return _rankStations(withPred);
  }

  List<NearestStationModel> _rankStations(List<NearestStationModel> stations) {
    final scored = stations.map((s) {
      double score = 0;
      score += (1.0 / (s.distanceKm + 0.1) * 10).clamp(0, 40);
      switch (s.crowding) {
        case CrowdingLevel.low:     score += 30; break;
        case CrowdingLevel.medium:  score += 20; break;
        case CrowdingLevel.high:    score += 10; break;
        case CrowdingLevel.unknown: score += 15; break;
      }
      switch (s.type) {
        case TransportType.metro:    score += 20; break;
        case TransportType.monorail: score += 18; break;
        case TransportType.bus:      score += 15; break;
        case TransportType.microbus: score += 12; break;
        default:                     score += 10; break;
      }
      final routeCount = s.routes?.split(',').length ?? 0;
      score += (routeCount * 2).clamp(0, 10);
      return s.copyWith(predictionScore: score);
    }).toList();

    scored.sort((a, b) => b.predictionScore.compareTo(a.predictionScore));
    if (scored.isNotEmpty) {
      scored[0] = scored[0].copyWith(isBestPrediction: true);
    }
    return scored;
  }

  @override
  Future<void> close() {
    disposeMapController();
    return super.close();
  }
}