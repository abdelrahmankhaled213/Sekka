import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Features/Map/Data/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/core/constants/app_color.dart';
import '../../../../../Core/Helper/transport_type_helper.dart';
import 'maps_state.dart';

class MapCubit extends Cubit<MapState> {

  final MapRepo repo;

  GoogleMapController? _mapController;

  MapCubit({required this.repo})
      : super(const MapState());


  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void disposeController() {
    _mapController?.dispose();
    _mapController = null;
  }

  Future<void> initLocation() async {

    emit(state.copyWith(status: MapStatus.locationLoading));

    final permission = await _checkPermission();
    if (permission != null) {
      emit(state.copyWith(status: permission));
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLatLng = LatLng(pos.latitude, pos.longitude);

      emit(state.copyWith(userLocation: userLatLng));

      await fetchStations(lat: pos.latitude, lng: pos.longitude);

    } catch (e) {
      emit(state.copyWith(
        status:   MapStatus.stationsError,
        errorMsg: e.toString(),
      ));
    }
  }

  Future<MapStatus?> _checkPermission() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return MapStatus.locationDenied;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        return MapStatus.locationDenied;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      return MapStatus.locationDeniedForever;
    }
    return null;
  }


  Future<void> fetchStations({
    required double lat,
    required double lng,
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(status: MapStatus.stationsLoading));

    try {
      final stations = await repo.getNearestStations(
        lat:          lat,
        lng:          lng,
        type:         state.selectedType,
        forceRefresh: forceRefresh,
      );

      if (stations.isEmpty) {
        emit(state.copyWith(status: MapStatus.stationsEmpty));
        return;
      }

      final markers = await _buildMarkers(stations);

      emit(state.copyWith(
        status:   MapStatus.stationsLoaded,
        stations: stations,
        markers:  markers,
      ));

      if (stations.isNotEmpty) {
        await animateTo(stations.first.location.lat,
                        stations.first.location.lng);
      }
    } catch (e, stackTrace) {
      debugPrint('MapCubit fetchStations error: $e');
      debugPrint('StackTrace: $stackTrace');
      emit(state.copyWith(
        status:   MapStatus.stationsError,
        errorMsg: e.toString(),
      ));
    }
  }


  Future<void> filterByType(TransportType? type) async {

    final loc = state.userLocation;
    
    if (loc == null) return;

    emit(state.copyWith(
      selectedType:  type,
      clearType:     type == null,
      clearSelected: true,
    ));

    await fetchStations(
      lat:  loc.latitude,
      lng:   loc.longitude,
      forceRefresh: true,
    );

  }



  Future<void> selectStation(NearestStationModel station) async {
    emit(state.copyWith(selectedStation: station));
    await animateTo(
      station.location.lat,
      station.location.lng,
      zoom: 16,
    );
  }

  Future<void> zoomIn() async {
    await _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> zoomOut() async {
    await _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> zoomToLevel(double zoomLevel) async {
    await _mapController?.animateCamera(CameraUpdate.zoomTo(zoomLevel));
  }

  void clearSelection() => emit(state.copyWith(clearSelected: true));

  Future<void> animateTo(double lat, double lng, {double zoom = 15}) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom),
      ),
    );
  }

  Future<void> goToUserLocation() async {
    final loc = state.userLocation;
    if (loc == null) return;
    await animateTo(loc.latitude, loc.longitude, zoom: 14);
  }


  Future<Set<Marker>> _buildMarkers(List<NearestStationModel> stations) async {

    final markers = <Marker>{};

    for (final station in stations) {
      final icon = await _createMarkerIcon(station.type, station.isBestPrediction);
      markers.add(
        Marker(
          markerId: MarkerId(station.id?.toString() ?? station.name),
          position: LatLng(
            station.location.lat,
            station.location.lng,
          ),
          icon:    icon,
          onTap:   () => selectStation(station),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: 'Score: ${station.predictionScore.toStringAsFixed(1)} • ${station.distanceKm.toStringAsFixed(2)} km',
          ),
        ),
      );
    }

    return markers;
  }


  Future<BitmapDescriptor> _createMarkerIcon(TransportType? type, [bool isBest = false]) async {
    const size = 80.0;
    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);

    // Use larger size and different color for best predicted station
    final paint = Paint()
      ..color = isBest ? Colors.green : TransportUIHelper.color(type)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      isBest ? size / 2 - 2 : size / 2 - 4,
      paint,
    );

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      isBest ? size / 2 - 2 : size / 2 - 4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = isBest ? 4 : 3,
    );

    final IconData icon = TransportUIHelper.icon(type);
    final tp    = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: isBest ? 32 : 28,
          fontFamily: 'MaterialIcons',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset((size - tp.width) / 2, (size - tp.height) / 2),
    );

    final picture = recorder.endRecording();
    final image   = await picture.toImage(size.toInt(), size.toInt());
    final bytes   = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }






  @override
  Future<void> close() {
    disposeController();
    return super.close();
  }

  // ─── Route Display Methods ─────────────────────────────────────────────────────

  Future<void> loadRoute(List<SegmentModel> segments) async {
    emit(state.copyWith(
      status: MapStatus.routeLoading,
      routeSegments: segments,
    ));

    try {
      final polylines = await _buildRoutePolylines(segments);
      final markers = await _buildRouteMarkers(segments);

      emit(state.copyWith(
        status: MapStatus.routeLoaded,
        polylines: polylines,
        markers: markers,
      ));

      // Fit camera to show entire route
      await _fitCameraToRoute(segments);
    } catch (e, stackTrace) {
      debugPrint('MapCubit loadRoute error: $e');
      debugPrint('StackTrace: $stackTrace');
      emit(state.copyWith(
        status: MapStatus.stationsError,
        errorMsg: e.toString(),
      ));
    }
  }

  Future<Set<Polyline>> _buildRoutePolylines(List<SegmentModel> segments) async {
    final polylines = <Polyline>{};

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final points = <LatLng>[];

      // Collect all stop coordinates for this segment
      for (final stop in segment.stops) {
        if (stop.latitude != null && stop.longitude != null) {
          points.add(LatLng(stop.latitude!, stop.longitude!));
        }
      }

      if (points.isNotEmpty) {
        polylines.add(Polyline(
          polylineId: PolylineId('segment_$i'),
          points: points,
          color: _getSegmentColor(segment.type, i),
          width: 5,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
          jointType: JointType.round,
        ));
      }
    }

    return polylines;
  }

  Future<Set<Marker>> _buildRouteMarkers(List<SegmentModel> segments) async {
    final markers = <Marker>{};

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];

      // Start marker (first segment only)
      if (i == 0 && segment.stops.isNotEmpty) {
        final firstStop = segment.stops.first;
        if (firstStop.latitude != null && firstStop.longitude != null) {
          markers.add(Marker(
            markerId: MarkerId('start'),
            position: LatLng(firstStop.latitude!, firstStop.longitude!),
            icon: await _createCustomMarker('start', segment.type),
            infoWindow: InfoWindow(
              title: 'Start: ${firstStop.stopName}',
              snippet: segment.lineName ?? '',
            ),
          ));
        }
      }

      // Transfer markers with labels
      if (segment.isTransfer && segment.stops.isNotEmpty) {
        final lastStop = segment.stops.last;
        if (lastStop.latitude != null && lastStop.longitude != null) {
          markers.add(Marker(
            markerId: MarkerId('transfer_$i'),
            position: LatLng(lastStop.latitude!, lastStop.longitude!),
            icon: await _createCustomMarker('transfer', segment.type),
            infoWindow: InfoWindow(
              title: 'Transfer ${i + 1}: ${lastStop.stopName}',
              snippet: 'From ${segment.lineName} to ${segment.nextLineName}',
            ),
          ));
        }
      }

      // End marker (last segment only)
      if (i == segments.length - 1 && segment.stops.isNotEmpty) {
        final lastStop = segment.stops.last;
        if (lastStop.latitude != null && lastStop.longitude != null) {
          markers.add(Marker(
            markerId: MarkerId('end'),
            position: LatLng(lastStop.latitude!, lastStop.longitude!),
            icon: await _createCustomMarker('end', segment.type),
            infoWindow: InfoWindow(
              title: 'Destination: ${lastStop.stopName}',
              snippet: segment.lineName ?? '',
            ),
          ));
        }
      }
    }

    return markers;
  }

  Color _getSegmentColor(TransportType type, int index) {
    // Use different colors for different segments to show route changes
    final colors = [
      AppColor.lightBlue,   // Metro
      AppColor.lightPurple, // Monorail
      AppColor.lightGreen,  // Bus
      AppColor.orange,      // Microbus
    ];

    final baseColor = TransportUIHelper.color(type);
    // If it's a transfer, use a different color
    if (type == TransportType.transfer) {
      return colors[index % colors.length];
    }
    return baseColor;
  }

  Future<void> _fitCameraToRoute(List<SegmentModel> segments) async {
    final bounds = _calculateRouteBounds(segments);
    if (bounds != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds? _calculateRouteBounds(List<SegmentModel> segments) {
    double? minLat, maxLat, minLng, maxLng;

    for (final segment in segments) {
      for (final stop in segment.stops) {
        if (stop.latitude != null && stop.longitude != null) {
          minLat = minLat == null ? stop.latitude! : (minLat < stop.latitude! ? minLat : stop.latitude!);
          maxLat = maxLat == null ? stop.latitude! : (maxLat > stop.latitude! ? maxLat : stop.latitude!);
          minLng = minLng == null ? stop.longitude! : (minLng < stop.longitude! ? minLng : stop.longitude!);
          maxLng = maxLng == null ? stop.longitude! : (maxLng > stop.longitude! ? maxLng : stop.longitude!);
        }
      }
    }

    if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
      return null;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<BitmapDescriptor> _createCustomMarker(String type, TransportType? transportType) async {
    const size = 80.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    Color markerColor;
    IconData iconData;

    switch (type) {
      case 'start':
        markerColor = Colors.green;
        iconData = Icons.trip_origin;
        break;
      case 'end':
        markerColor = Colors.red;
        iconData = Icons.flag;
        break;
      case 'transfer':
        markerColor = Colors.orange;
        iconData = Icons.swap_horiz;
        break;
      default:
        markerColor = TransportUIHelper.color(transportType);
        iconData = TransportUIHelper.icon(transportType);
    }

    // Draw circle background
    final paint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      paint,
    );

    // Draw white border
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Draw icon
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: const TextStyle(fontSize: 28, fontFamily: 'MaterialIcons', color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset((size - tp.width) / 2, (size - tp.height) / 2),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void clearRoute() {
    emit(state.copyWith(
      polylines: {},
      routeSegments: null,
      status: MapStatus.stationsLoaded,
    ));
  }
}
