import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      final icon = await _createMarkerIcon(station.type);
      markers.add(
        Marker(
          markerId: MarkerId(station.id?.toString() ?? station.name),
          position: LatLng(
            station.location.lat,
            station.location.lng,
          ),
          icon:    icon,
          onTap:   () => selectStation(station),
          infoWindow: InfoWindow(title: station.name),
        ),
      );
    }

    return markers;
  }

 
  Future<BitmapDescriptor> _createMarkerIcon(TransportType? type) async {
    const size = 80.0;
    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);

   
    final paint = Paint()
      ..color = TransportUIHelper.color(type)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      paint,
    );

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final IconData icon = TransportUIHelper.icon(type);
    final tp    = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: const TextStyle(fontSize: 28, fontFamily: 'MaterialIcons'),
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
}
