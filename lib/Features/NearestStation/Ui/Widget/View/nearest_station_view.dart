// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sekka/Core/Constants/app_color.dart';
// import 'package:sekka/Core/Helper/transport_type_helper.dart';
// import 'package:sekka/Core/theme/app_colors.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
// import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
// import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> _openInGoogleMaps(double lat, double lng, String name) async {
//   final uri = Uri.parse(
//     'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=${Uri.encodeComponent(name)}',
//   );
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   }
// }

// // ── map styles ─────────────────────────────────────────────────────────────────

// const _lightStyle = '''[
//   {"featureType":"all","elementType":"geometry.fill","stylers":[{"color":"#f5f4fb"}]},
//   {"featureType":"water","elementType":"geometry","stylers":[{"color":"#bfdbfe"}]},
//   {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
//   {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#e5e7eb"}]},
//   {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#ede9fe"}]},
//   {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#374151"}]},
//   {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"weight":2}]}
// ]''';

// const _darkStyle = '''[
//   {"featureType":"all","elementType":"geometry","stylers":[{"color":"#1e1b4b"}]},
//   {"featureType":"water","elementType":"geometry","stylers":[{"color":"#1e3a5f"}]},
//   {"featureType":"road","elementType":"geometry","stylers":[{"color":"#312e81"}]},
//   {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#c7d2fe"}]},
//   {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#1e1b4b"},{"weight":2}]}
// ]''';

// // ── main view ──────────────────────────────────────────────────────────────────

// class NearestStationView extends StatefulWidget {
//   const NearestStationView({super.key});

//   @override
//   State<NearestStationView> createState() => _NearestStationViewState();
// }

// class _NearestStationViewState extends State<NearestStationView> {

//   static const _defaultCamera = CameraPosition(
//     target: LatLng(30.0444, 31.2357),
//     zoom:   12,
//   );

//   @override
//   void initState() {
//     super.initState();
//     context.read<NearestStationCubit>().loadNearestStations();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: AppColor.background,
//       body: BlocConsumer<NearestStationCubit, NearestStationState>(
//         listenWhen: (p, c) => p.selectedStation != c.selectedStation,
//         listener: (context, state) {
//           if (state.selectedStation != null) {
//             _showStationSheet(context, state.selectedStation!);
//           }
//         },
//         builder: (context, state) {
//           return Stack(
//             children: [

//               // ── Google Map ────────────────────────────────────────────────
//               GoogleMap(
//                 initialCameraPosition: _defaultCamera,
//                 markers:               state.markers,
//                 myLocationEnabled:     true,
//                 myLocationButtonEnabled: false,
//                 zoomControlsEnabled:   false,
//                 compassEnabled:        false,
//                 mapToolbarEnabled:     false,
//                 onMapCreated: (ctrl) {
//                   context.read<NearestStationCubit>().onMapCreated(ctrl);
//                   ctrl.setMapStyle(isDark ? _darkStyle : _lightStyle);
//                 },
//                 onTap: (_) =>
//                     context.read<NearestStationCubit>().clearSelection(),
//               ),

//               // ── loading overlay ───────────────────────────────────────────
//               // ✅ Positioned.fill هنا بره، مش جوا الـ widget
//               if (state.status == NearestStationStatus.loading)
//                 Positioned.fill(child: _LoadingOverlay()),

//               // ── top: search bar ───────────────────────────────────────────
//               SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
//                   child: _MapSearchBar(locationName: state.locationName),
//                 ),
//               ),

//               // ── filter chips ──────────────────────────────────────────────
//               Positioned(
//                 top:  MediaQuery.of(context).padding.top + 72.h,
//                 left: 0, right: 0,
//                 child: MapFilterChips(selected: state.selectedFilter),
//               ),

//               // ── current location FAB ──────────────────────────────────────
//               Positioned(
//                 right:  16.w,
//                 bottom: 210.h,
//                 child: _LocationFab(),
//               ),

//               // ── error bar ─────────────────────────────────────────────────
//               if (state.status == NearestStationStatus.error)
//                 Positioned(
//                   bottom: 220.h,
//                   left: 16.w, right: 16.w,
//                   child: _ErrorBar(
//                     message: state.errorMessage ?? 'Something went wrong',
//                     onRetry: () =>
//                         context.read<NearestStationCubit>().loadNearestStations(),
//                   ),
//                 ),

//               // ── bottom stations strip ──────────────────────────────────────
//               if (state.status == NearestStationStatus.loaded &&
//                   state.stations.isNotEmpty)
//                 Positioned(
//                   bottom: 0, left: 0, right: 0,
//                   child: _StationsStrip(stations: state.stations),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _showStationSheet(BuildContext context, NearestStationModel station) {
//     showModalBottomSheet(
//       context:         context,
//       backgroundColor: Colors.transparent,
//       isDismissible:   true,
//       enableDrag:      true,
//       builder: (_) => _StationDetailSheet(
//         station: station,
//         onClose: () {
//           Navigator.pop(context);
//           context.read<NearestStationCubit>().clearSelection();
//         },
//       ),
//     );
//   }
// }

// // ── helpers ────────────────────────────────────────────────────────────────────

// Color transportColor(TransportType? type) {
//   switch (type) {
//     case TransportType.metro:    return AppColor.main;
//     case TransportType.monorail: return const Color(0xFF8B5CF6);
//     case TransportType.bus:      return AppColor.green;
//     case TransportType.microbus: return AppColor.orange;
//     case TransportType.BRT:      return AppColors.darkGreen;
//     default:                     return AppColor.grey;
//   }
// }

// String transportEmoji(TransportType? type) {
//   switch (type) {
//     case TransportType.metro:    return '🚇';
//     case TransportType.monorail: return '🚝';
//     case TransportType.bus:      return '🚌';
//     case TransportType.microbus: return '🚐';
//     case TransportType.BRT:      return '🚀';
//     default:                     return '🗺️';
//   }
// }

// String transportLabel(TransportType? type) {
//   switch (type) {
//     case TransportType.metro:    return 'Metro';
//     case TransportType.monorail: return 'Monorail';
//     case TransportType.bus:      return 'Bus';
//     case TransportType.microbus: return 'Microbus';
//     case TransportType.BRT:      return 'BRT';
//     default:                     return 'All';
//   }
// }

// // ── Search Bar ─────────────────────────────────────────────────────────────────

// class _MapSearchBar extends StatefulWidget {
//   final String locationName;
//   const _MapSearchBar({super.key, required this.locationName});

//   @override
//   State<_MapSearchBar> createState() => _MapSearchBarState();
// }

// class _MapSearchBarState extends State<_MapSearchBar> {

//   final _ctrl      = TextEditingController();
//   final _service   = PlaceAutocompleteService();
//   final _focusNode = FocusNode();

//   List<PlacePrediction> _predictions = [];
//   bool   _loading   = false;
//   bool   _showList  = false;
//   String _selecting = '';
//   Timer? _debounce;

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _focusNode.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onChanged(String value) {
//     _debounce?.cancel();
//     if (value.trim().isEmpty) {
//       setState(() { _predictions = []; _showList = false; });
//       return;
//     }
//     setState(() => _loading = true);
//     _debounce = Timer(const Duration(milliseconds: 380), () async {
//       final results = await _service.getSuggestions(value);
//       if (!mounted) return;
//       setState(() {
//         _predictions = results;
//         _loading     = false;
//         _showList    = results.isNotEmpty;
//       });
//     });
//   }

//   Future<void> _onSelect(PlacePrediction p) async {
//     setState(() => _selecting = p.placeId);

//     final loc = await _service.getPlaceLocation(p.placeId);

//     if (!mounted) return;
//     setState(() { _selecting = ''; _showList = false; _predictions = []; });

//     if (loc == null) return;

//     _ctrl.text = p.mainText;
//     _focusNode.unfocus();

//     context.read<NearestStationCubit>().loadNearestStationsForSearchedLocation(
//       lat:          loc.lat,
//       lng:          loc.lng,
//       overrideName: p.mainText,
//     );
//   }

//   void _clearSearch() {
//     _ctrl.clear();
//     setState(() { _predictions = []; _showList = false; });
//     _focusNode.unfocus();

//     context.read<NearestStationCubit>().loadNearestStations();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // ── search field ───────────────────────────────────────────────────
//         ClipRRect(
//           borderRadius: BorderRadius.circular(16.r),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: Container(
//               decoration: BoxDecoration(
//                 color:        Colors.white.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(color: Colors.white.withOpacity(0.5)),
//                 boxShadow: [
//                   BoxShadow(
//                     color:      Colors.black.withOpacity(0.08),
//                     blurRadius: 16,
//                     offset:     const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _ctrl,
//                 focusNode:  _focusNode,
//                 onChanged:  _onChanged,
//                 style: TextStyle(
//                   fontSize:   14.sp,
//                   fontFamily: 'Roboto',
//                   color:      AppColor.textPrimary,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: widget.locationName.isNotEmpty
//                       ? widget.locationName
//                       : 'Search for a place...',
//                   hintStyle: TextStyle(
//                     fontSize:   14.sp,
//                     fontFamily: 'Roboto',
//                     color:      AppColor.muted,
//                   ),
//                   prefixIcon: Padding(
//                     padding: EdgeInsets.all(12.w),
//                     child: Icon(Icons.search_rounded,
//                         color: AppColor.main, size: 20.sp),
//                   ),
//                   suffixIcon: _loading
//                       ? Padding(
//                           padding: EdgeInsets.all(14.w),
//                           child: SizedBox(
//                             width: 16.w, height: 16.w,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2, color: AppColor.main,
//                             ),
//                           ),
//                         )
//                       : _ctrl.text.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(Icons.close_rounded,
//                                   color: AppColor.muted, size: 18.sp),
//                               onPressed: _clearSearch,
//                             )
//                           : null,
//                   border:         InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w, vertical: 14.h),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // ── predictions dropdown ───────────────────────────────────────────
//         if (_showList && _predictions.isNotEmpty)
//           Container(
//             margin:      EdgeInsets.only(top: 6.h),
//             constraints: BoxConstraints(maxHeight: 250.h),
//             decoration: BoxDecoration(
//               color:        Colors.white,
//               borderRadius: BorderRadius.circular(14.r),
//               boxShadow: [
//                 BoxShadow(
//                   color:      Colors.black.withOpacity(0.1),
//                   blurRadius: 16,
//                   offset:     const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(14.r),
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 padding:    EdgeInsets.symmetric(vertical: 6.h),
//                 itemCount:  _predictions.length,
//                 separatorBuilder: (_, __) =>
//                     Divider(height: 0.5, color: AppColor.outline),
//                 itemBuilder: (_, i) {
//                   final p         = _predictions[i];
//                   final isLoading = _selecting == p.placeId;

//                   return ListTile(
//                     dense: true,
//                     leading: Container(
//                       width:  34.w,
//                       height: 34.w,
//                       decoration: BoxDecoration(
//                         color:        AppColor.main.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                       child: isLoading
//                           ? Padding(
//                               padding: EdgeInsets.all(8.w),
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2, color: AppColor.main,
//                               ),
//                             )
//                           : Icon(Icons.location_on_rounded,
//                               color: AppColor.main, size: 16.sp),
//                     ),
//                     title: Text(
//                       p.mainText,
//                       style: TextStyle(
//                         fontSize:   13.sp,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Roboto',
//                         color:      AppColor.textPrimary,
//                       ),
//                     ),
//                     subtitle: p.secondaryText.isNotEmpty
//                         ? Text(
//                             p.secondaryText,
//                             style: TextStyle(
//                               fontSize:   11.sp,
//                               fontFamily: 'Roboto',
//                               color:      AppColor.textSecondary,
//                             ),
//                           )
//                         : null,
//                     onTap: isLoading ? null : () => _onSelect(p),
//                   );
//                 },
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// // ── Filter Chips ───────────────────────────────────────────────────────────────

// class MapFilterChips extends StatelessWidget {

//   final TransportType? selected;

//   const MapFilterChips({super.key, required this.selected});

//   static const _types = [
//     null,
//     TransportType.metro,
//     TransportType.monorail,
//     TransportType.bus,
//     TransportType.microbus,
//     TransportType.BRT
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 36.h,
//       child: ListView.separated(
//         scrollDirection:  Axis.horizontal,
//         padding:          EdgeInsets.symmetric(horizontal: 16.w),
//         itemCount:        _types.length,
//         separatorBuilder: (_, __) => SizedBox(width: 8.w),
//         itemBuilder: (_, i) {
//           final type       = _types[i];
//           final isSelected = selected == type;
//           final color      = transportColor(type);

//           return GestureDetector(
//             onTap: () =>
//                 context.read<NearestStationCubit>().applyFilter(type),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//               decoration: BoxDecoration(
//                 color: isSelected ? color : Colors.white,
//                 borderRadius: BorderRadius.circular(20.r),
//                 border: Border.all(
//                   color: isSelected ? color : AppColor.outline,
//                   width: isSelected ? 0 : 0.8,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color:      isSelected
//                         ? color.withOpacity(0.25)
//                         : Colors.black.withOpacity(0.05),
//                     blurRadius: isSelected ? 8 : 4,
//                     offset:     const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(transportEmoji(type),
//                       style: TextStyle(fontSize: 13.sp)),
//                   SizedBox(width: 5.w),
//                   Text(
//                     transportLabel(type),
//                     style: TextStyle(
//                       fontSize:   12.sp,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Roboto',
//                       color: isSelected ? Colors.white : AppColor.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ── Location FAB ───────────────────────────────────────────────────────────────

// class _LocationFab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => context.read<NearestStationCubit>().goToUserLocation(),
//       child: Container(
//         width:  44.w,
//         height: 44.w,
//         decoration: BoxDecoration(
//           color:  Colors.white,
//           shape:  BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color:      Colors.black.withOpacity(0.12),
//               blurRadius: 12,
//               offset:     const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Icon(Icons.my_location_rounded,
//             color: AppColor.main, size: 20.sp),
//       ),
//     );
//   }
// }

// // ── Stations Strip ─────────────────────────────────────────────────────────────

// class _StationsStrip extends StatelessWidget {
//   final List<NearestStationModel> stations;
//   const _StationsStrip({required this.stations});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: EdgeInsets.fromLTRB(0, 12.h, 0, 20.h),
//           decoration: BoxDecoration(
//             color:        Colors.white.withOpacity(0.92),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//             boxShadow: [
//               BoxShadow(
//                 color:      Colors.black.withOpacity(0.07),
//                 blurRadius: 16,
//                 offset:     const Offset(0, -4),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Container(
//                   width:  36.w, height: 4.h,
//                   margin: EdgeInsets.only(bottom: 12.h),
//                   decoration: BoxDecoration(
//                     color:        AppColor.outline,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Row(
//                   children: [
//                     Text(
//                       'Nearest Stations',
//                       style: TextStyle(
//                         fontSize:   15.sp,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'Roboto',
//                         color:      AppColor.textPrimary,
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       '${stations.length} found',
//                       style: TextStyle(
//                         fontSize:   12.sp,
//                         fontFamily: 'Roboto',
//                         color:      AppColor.muted,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               SizedBox(
//                 height: 130.h,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   padding:         EdgeInsets.symmetric(horizontal: 16.w),
//                   itemCount:       stations.length,
//                   itemBuilder: (_, i) => _StationMiniCard(
//                     station:    stations[i],
//                     isSelected: context
//                             .watch<NearestStationCubit>()
//                             .state
//                             .selectedStation
//                             ?.id ==
//                         stations[i].id,
//                     onTap: () => context
//                         .read<NearestStationCubit>()
//                         .selectStation(stations[i]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Station Mini Card ──────────────────────────────────────────────────────────

// class _StationMiniCard extends StatelessWidget {

//   final NearestStationModel station;
//   final bool                isSelected;
//   final VoidCallback        onTap;

//   const _StationMiniCard({
//     required this.station,
//     required this.isSelected,
//     required this.onTap,
//   });

//   Color get _color {
//     switch (station.type) {
//       case TransportType.metro:    return AppColor.main;
//       case TransportType.monorail: return AppColor.secondary;
//       case TransportType.bus:      return AppColor.green;
//       case TransportType.microbus: return AppColor.orange;
//       case TransportType.BRT:      return AppColors.darkGreen;
//       default:                     return AppColor.secondary;
//     }
//   }

//   String get _emoji {
//     switch (station.type) {
//       case TransportType.metro:    return '🚇';
//       case TransportType.monorail: return '🚝';
//       case TransportType.bus:      return '🚌';
//       case TransportType.microbus: return '🚐';
//       case TransportType.BRT:      return '🚀';
//       default:                     return '🚝';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 220),
//         curve:    Curves.easeOutCubic,
//         width:    150.w,
//         margin:   EdgeInsets.only(right: 10.w),
//         padding:  EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: isSelected ? _color : Colors.white,
//           borderRadius: BorderRadius.circular(14.r),
//           border: Border.all(
//             color: isSelected ? _color : AppColor.outline,
//             width: isSelected ? 0 : 0.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color:      isSelected
//                   ? _color.withOpacity(0.3)
//                   : Colors.black.withOpacity(0.05),
//               blurRadius: isSelected ? 12 : 6,
//               offset:     const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (station.isBestPrediction)
//               Container(
//                 margin:  EdgeInsets.only(bottom: 4.h),
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Colors.white.withOpacity(0.25)
//                       : const Color(0xFFFEF3C7),
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: Text(
//                   '⭐ Best',
//                   style: TextStyle(
//                     fontSize:   9.sp,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Roboto',
//                     color: isSelected
//                         ? Colors.white
//                         : const Color(0xFFF59E0B),
//                   ),
//                 ),
//               ),
//             Text(_emoji, style: TextStyle(fontSize: 22.sp)),
//             SizedBox(height: 4.h),
//             Text(
//               station.name,
//               style: TextStyle(
//                 fontSize:   12.sp,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Roboto',
//                 color: isSelected ? Colors.white : AppColor.textPrimary,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(height: 3.h),
//             Row(
//               children: [
//                 Icon(Icons.near_me_rounded,
//                     size:  10.sp,
//                     color: isSelected ? Colors.white70 : AppColor.muted),
//                 SizedBox(width: 3.w),
//                 Text(
//                   '${station.distanceKm.toStringAsFixed(2)} km',
//                   style: TextStyle(
//                     fontSize:   10.sp,
//                     fontFamily: 'Roboto',
//                     color: isSelected ? Colors.white70 : AppColor.muted,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Station Detail Sheet ───────────────────────────────────────────────────────

// List<int>fakeData=[1,2,8,3,2,4,10,20,12,13,32,31,18];


// class _StationDetailSheet extends StatelessWidget {
//   final NearestStationModel station;
//   final VoidCallback        onClose;

//   const _StationDetailSheet({required this.station, required this.onClose});

//   Color get _color {
//     switch (station.type) {
//       case TransportType.metro:    return AppColor.main;
//       case TransportType.monorail: return AppColor.secondary;
//       case TransportType.bus:      return AppColor.green;
//       case TransportType.microbus: return AppColor.orange;
//       case TransportType.BRT :  return AppColors.darkGreen;
//       default:                     return AppColor.secondary;
//     }
//   }

//   String get _emoji {
//     switch (station.type) {
//       case TransportType.metro:    return '🚇';
//       case TransportType.monorail: return '🚝';
//       case TransportType.bus:      return '🚌';
//       case TransportType.microbus: return '🚐';
//       case TransportType.BRT :     return '🚝';
//       default:                     return '🚝';
//     }
//   }

//   /// لو السيتس متوفرة يبني label زي "30/35 (86%)"
//   /// لو مش متوفرة يرجع label الزحمة العادي
//   String get _seatsLabel {
//     if (station.totalSeats != null && station.availableSeats != null) {
//       final pct = station.occupancyPercentage!.toStringAsFixed(0);
//       return '${station.availableSeats}/${station.totalSeats} Avaliable • $pct%';
//     }
//     return station.crowding.label;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin:  EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color:        Colors.white,
//         borderRadius: BorderRadius.circular(24.r),
//         boxShadow: [
//           BoxShadow(
//             color:      Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset:     const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Center(
//             child: Container(
//               width:  36.w,
//               height: 4.h,
//               margin: EdgeInsets.only(bottom: 16.h),
//               decoration: BoxDecoration(
//                 color:        AppColor.outline,
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//           ),

//           Row(
//             children: [
//               Container(
//                 width:  48.w,
//                 height: 48.w,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [_color, _color.withOpacity(0.7)],
//                     begin:  Alignment.topLeft,
//                     end:    Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(14.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color:      _color.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset:     const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(_emoji, style: TextStyle(fontSize: 24.sp)),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (station.isBestPrediction)
//                       Container(
//                         margin:  EdgeInsets.only(bottom: 3.h),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 7.w, vertical: 2.h),
//                         decoration: BoxDecoration(
//                           color:        const Color(0xFFFEF3C7),
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         child: Text(
//                           '⭐ Best Recommended',
//                           style: TextStyle(
//                             fontSize:   10.sp,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: 'Roboto',
//                             color:      const Color(0xFFF59E0B),
//                           ),
//                         ),
//                       ),
//                     Text(
//                       station.name,
//                       style: TextStyle(
//                         fontSize:   15.sp,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'Roboto',
//                         color:      AppColor.textPrimary,
//                       ),
//                     ),
//                     Text(
//                       station.type?.name ?? 'Station',
//                       style: TextStyle(
//                         fontSize:   12.sp,
//                         fontFamily: 'Roboto',
//                         color:      _color,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: onClose,
//                 child: Container(
//                   width:  30.w,
//                   height: 30.w,
//                   decoration: BoxDecoration(
//                     color:        AppColor.offWhite,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(Icons.close_rounded,
//                       size: 14.sp, color: AppColor.grey),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 16.h),

//           Row(
//             children: [
//               _Chip(
//                 icon:  Icons.near_me_rounded,
//                 label: '${station.distanceKm.toStringAsFixed(2)} km',
//                 color: AppColor.main,
//               ),

//               if (station.predictionScore > 0) ...[
//                 SizedBox(width: 8.w),
//                 _Chip(
//                   icon:  Icons.analytics_rounded,
//                   label: '${station.predictionScore.toStringAsFixed(0)}%',
//                   color: AppColor.secondary,
//                 ),
//                 SizedBox(width: 8.w),
//                 _Chip(
//                   icon:  Icons.event_seat_rounded,
//                   label: "${fakeData[Random().nextInt(fakeData.length)].toString()} of 35",
//                   color: AppColor.primaryColor,
//                 ),

//               ],

//             ],
//           ),

//           if (station.routes != null && station.routes!.isNotEmpty) ...[
//             SizedBox(height: 14.h),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Routes',
//                 style: TextStyle(
//                   fontSize:   13.sp,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'Roboto',
//                   color:      AppColor.textPrimary,
//                 ),
//               ),
//             ),
//             SizedBox(height: 6.h),
//             Wrap(
//               spacing: 6.w, runSpacing: 6.h,
//               children: station.routes!
//                   .split(' | ')
//                   .map((r) => Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 10.w, vertical: 4.h),
//                         decoration: BoxDecoration(
//                           color:        _color.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(8.r),
//                           border: Border.all(color: _color.withOpacity(0.2)),
//                         ),
//                         child: Text(
//                           r,
//                           style: TextStyle(
//                             fontSize:   11.sp,
//                             fontFamily: 'Roboto',
//                             color:      _color,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ],

//           SizedBox(height: 16.h),

//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () => _openInGoogleMaps(
//                 station.location.lat,
//                 station.location.lng,
//                 station.name,
//               ),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: _color,
//                 side:            BorderSide(color: _color, width: 1.5),
//                 padding:         EdgeInsets.symmetric(vertical: 13.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14.r),
//                 ),
//               ),
//               icon:  Icon(Icons.directions_rounded, size: 18.sp),
//               label: Text(
//                 'Open in Google Maps',
//                 style: TextStyle(
//                   fontSize:   14.sp,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'Roboto',
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _crowdingColor(CrowdingLevel l) {
//     switch (l) {
//       case CrowdingLevel.low:    return AppColor.success;
//       case CrowdingLevel.medium: return AppColor.warning;
//       case CrowdingLevel.high:   return AppColor.error;
//       default:                   return AppColor.muted;
//     }
//   }
// }

// // ── Chip ──────────────────────────────────────────────────────────────────────

// class _Chip extends StatelessWidget {
//   final IconData icon;
//   final String   label;
//   final Color    color;

//   const _Chip({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color:        color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 13.sp, color: color),
//           SizedBox(width: 4.w),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize:   11.sp,
//               fontFamily: 'Roboto',
//               color:      color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








// // ✅ شيلنا Positioned.fill من جوا الـ widget وحطيناه بره في الـ Stack
// class _LoadingOverlay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black.withOpacity(0.15),
//       child: Center(
//         child: Container(
//           padding:    EdgeInsets.all(20.w),
//           decoration: BoxDecoration(
//             color:        Colors.white,
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(
//                   color: AppColor.main, strokeWidth: 2),
//               SizedBox(height: 10.h),
//               Text(
//                 'Finding stations...',
//                 style: TextStyle(
//                   fontSize:   13.sp,
//                   fontFamily: 'Roboto',
//                   color:      AppColor.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }

// // ── Error Bar ──────────────────────────────────────────────────────────────────
// class _ErrorBar extends StatelessWidget {
//   final String       message;
//   final VoidCallback onRetry;
//   const _ErrorBar({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color:        AppColor.errorContainer,
//         borderRadius: BorderRadius.circular(14.r),
//         border: Border.all(color: AppColor.error.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline_rounded,
//               color: AppColor.error, size: 18.sp),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(
//               message,
//               style: TextStyle(
//                 fontSize:   12.sp,
//                 fontFamily: 'Roboto',
//                 color:      AppColor.error,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: onRetry,
//             child: Text(
//               'Retry',
//               style: TextStyle(
//                 fontSize:   12.sp,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w600,
//                 color:      AppColor.error,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openInGoogleMaps(double lat, double lng, String name) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=${Uri.encodeComponent(name)}',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ── map styles ─────────────────────────────────────────────────────────────────

const _lightStyle = '''[
  {"featureType":"all","elementType":"geometry.fill","stylers":[{"color":"#f5f4fb"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#bfdbfe"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#e5e7eb"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#ede9fe"}]},
  {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#374151"}]},
  {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"weight":2}]}
]''';

const _darkStyle = '''[
  {"featureType":"all","elementType":"geometry","stylers":[{"color":"#1e1b4b"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#1e3a5f"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#312e81"}]},
  {"featureType":"all","elementType":"labels.text.fill","stylers":[{"color":"#c7d2fe"}]},
  {"featureType":"all","elementType":"labels.text.stroke","stylers":[{"color":"#1e1b4b"},{"weight":2}]}
]''';

// ── shared helpers (single source of truth for colors/emojis/labels) ──────────

Color transportColor(TransportType? type) {
  switch (type) {
    case TransportType.metro:    return AppColor.main;
    case TransportType.monorail: return const Color(0xFF8B5CF6);
    case TransportType.bus:      return AppColor.green;
    case TransportType.microbus: return AppColor.orange;
    case TransportType.BRT:      return AppColors.darkGreen;
    default:                     return AppColor.grey;
  }
}

String transportEmoji(TransportType? type) {
  switch (type) {
    case TransportType.metro:    return '🚇';
    case TransportType.monorail: return '🚝';
    case TransportType.bus:      return '🚌';
    case TransportType.microbus: return '🚐';
    case TransportType.BRT:      return '🚀';
    default:                     return '🗺️';
  }
}

String transportLabel(TransportType? type) {
  switch (type) {
    case TransportType.metro:    return 'Metro';
    case TransportType.monorail: return 'Monorail';
    case TransportType.bus:      return 'Bus';
    case TransportType.microbus: return 'Microbus';
    case TransportType.BRT:      return 'BRT';
    default:                     return 'All';
  }
}

Color crowdingColor(CrowdingLevel l) {
  switch (l) {
    case CrowdingLevel.low:    return AppColor.success;
    case CrowdingLevel.medium: return AppColor.warning;
    case CrowdingLevel.high:   return AppColor.error;
    default:                   return AppColor.muted;
  }
}

// fake seats data — stable per-station via hashCode, no Random() in build
const List<int> _fakeSeats = [1, 2, 8, 3, 2, 4, 10, 20, 12, 13, 32, 31, 18];

int stableSeats(String stationId) =>
    _fakeSeats[stationId.hashCode.abs() % _fakeSeats.length];

// ── main view ──────────────────────────────────────────────────────────────────

class NearestStationView extends StatefulWidget {
  const NearestStationView({super.key});

  @override
  State<NearestStationView> createState() => _NearestStationViewState();
}

class _NearestStationViewState extends State<NearestStationView> {

  static const _defaultCamera = CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom:   12,
  );

  @override
  void initState() {
    super.initState();
    context.read<NearestStationCubit>().loadNearestStations();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocConsumer<NearestStationCubit, NearestStationState>(
        listenWhen: (p, c) => p.selectedStation != c.selectedStation,
        listener: (context, state) {
          if (state.selectedStation != null) {
            _showStationSheet(context, state.selectedStation!);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [

              // ── Google Map ────────────────────────────────────────────────
              GoogleMap(
                initialCameraPosition: _defaultCamera,
                markers:               state.markers,
                myLocationEnabled:     true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled:   false,
                compassEnabled:        false,
                mapToolbarEnabled:     false,
                onMapCreated: (ctrl) {
                  context.read<NearestStationCubit>().onMapCreated(ctrl);
                  ctrl.setMapStyle(isDark ? _darkStyle : _lightStyle);
                },
                onTap: (_) =>
                    context.read<NearestStationCubit>().clearSelection(),
              ),

              // ── loading overlay ───────────────────────────────────────────
              if (state.status == NearestStationStatus.loading)
                Positioned.fill(child: _LoadingOverlay()),

              // ── top: search bar ───────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _MapSearchBar(locationName: state.locationName),
                ),
              ),

              // ── filter chips ──────────────────────────────────────────────
              Positioned(
                top:  MediaQuery.of(context).padding.top + 72.h,
                left: 0, right: 0,
                child: MapFilterChips(selected: state.selectedFilter),
              ),

              // ── current location FAB ──────────────────────────────────────
              Positioned(
                right:  16.w,
                bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 16.h,
                child: _LocationFab(),
              ),

              // ── error bar ─────────────────────────────────────────────────
              if (state.status == NearestStationStatus.error)
                Positioned(
                  bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom + 16.h,
                  left: 16.w, right: 16.w,
                  child: _ErrorBar(
                    message: state.errorMessage ?? 'Something went wrong',
                    onRetry: () =>
                        context.read<NearestStationCubit>().loadNearestStations(),
                  ),
                ),

              // ── bottom stations strip (draggable) ─────────────────────────
              if (state.status == NearestStationStatus.loaded &&
                  state.stations.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left:   0,
                  right:  0,
                  top:    0,
                  child: _DraggableStationsStrip(stations: state.stations),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── FIX: isScrollControlled + DraggableScrollableSheet ───────────────────
  void _showStationSheet(BuildContext context, NearestStationModel station) {
    showModalBottomSheet(
      context:            context,
      backgroundColor:    Colors.transparent,
      isDismissible:      true,
      enableDrag:         true,
      isScrollControlled: true, // required for DraggableScrollableSheet
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize:     0.35,
        maxChildSize:     0.90,
        expand:           false,
        builder: (_, scrollController) => _StationDetailSheet(
          station:          station,
          scrollController: scrollController,
          onClose: () {
            Navigator.pop(context);
            context.read<NearestStationCubit>().clearSelection();
          },
        ),
      ),
    );
  }
}

// ── Search Bar ─────────────────────────────────────────────────────────────────

class _MapSearchBar extends StatefulWidget {
  final String locationName;
  const _MapSearchBar({super.key, required this.locationName});

  @override
  State<_MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<_MapSearchBar> {

  final _ctrl      = TextEditingController();
  final _service   = PlaceAutocompleteService();
  final _focusNode = FocusNode();

  List<PlacePrediction> _predictions = [];
  bool   _loading   = false;
  bool   _showList  = false;
  String _selecting = '';
  Timer? _debounce;

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() { _predictions = []; _showList = false; });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 380), () async {
      final results = await _service.getSuggestions(value);
      if (!mounted) return;
      setState(() {
        _predictions = results;
        _loading     = false;
        _showList    = results.isNotEmpty;
      });
    });
  }

  Future<void> _onSelect(PlacePrediction p) async {
    setState(() => _selecting = p.placeId);

    final loc = await _service.getPlaceLocation(p.placeId);

    if (!mounted) return;
    setState(() { _selecting = ''; _showList = false; _predictions = []; });

    if (loc == null) return;

    _ctrl.text = p.mainText;
    _focusNode.unfocus();

    context.read<NearestStationCubit>().loadNearestStationsForSearchedLocation(
      lat:          loc.lat,
      lng:          loc.lng,
      overrideName: p.mainText,
    );
  }

  void _clearSearch() {
    _ctrl.clear();
    setState(() { _predictions = []; _showList = false; });
    _focusNode.unfocus();
    context.read<NearestStationCubit>().loadNearestStations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── search field ───────────────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color:        Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color:      Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset:     const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _ctrl,
                focusNode:  _focusNode,
                onChanged:  _onChanged,
                style: TextStyle(
                  fontSize:   14.sp,
                  fontFamily: 'Roboto',
                  color:      AppColor.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.locationName.isNotEmpty
                      ? widget.locationName
                      : 'Search for a place...',
                  hintStyle: TextStyle(
                    fontSize:   14.sp,
                    fontFamily: 'Roboto',
                    color:      AppColor.muted,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(Icons.search_rounded,
                        color: AppColor.main, size: 20.sp),
                  ),
                  suffixIcon: _loading
                      ? Padding(
                    padding: EdgeInsets.all(14.w),
                    child: SizedBox(
                      width: 16.w, height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColor.main,
                      ),
                    ),
                  )
                      : _ctrl.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: AppColor.muted, size: 18.sp),
                    onPressed: _clearSearch,
                  )
                      : null,
                  border:         InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
          ),
        ),

        // ── predictions dropdown ───────────────────────────────────────────
        if (_showList && _predictions.isNotEmpty)
          Container(
            margin:      EdgeInsets.only(top: 6.h),
            constraints: BoxConstraints(maxHeight: 250.h),
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color:      Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset:     const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: ListView.separated(
                shrinkWrap: true,
                padding:    EdgeInsets.symmetric(vertical: 6.h),
                itemCount:  _predictions.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 0.5, color: AppColor.outline),
                itemBuilder: (_, i) {
                  final p         = _predictions[i];
                  final isLoading = _selecting == p.placeId;

                  return ListTile(
                    dense: true,
                    leading: Container(
                      width:  34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color:        AppColor.main.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: isLoading
                          ? Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColor.main,
                        ),
                      )
                          : Icon(Icons.location_on_rounded,
                          color: AppColor.main, size: 16.sp),
                    ),
                    title: Text(
                      p.mainText,
                      style: TextStyle(
                        fontSize:   13.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color:      AppColor.textPrimary,
                      ),
                    ),
                    subtitle: p.secondaryText.isNotEmpty
                        ? Text(
                      p.secondaryText,
                      style: TextStyle(
                        fontSize:   11.sp,
                        fontFamily: 'Roboto',
                        color:      AppColor.textSecondary,
                      ),
                    )
                        : null,
                    onTap: isLoading ? null : () => _onSelect(p),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

// ── Filter Chips ───────────────────────────────────────────────────────────────

class MapFilterChips extends StatelessWidget {

  final TransportType? selected;

  const MapFilterChips({super.key, required this.selected});

  static const _types = [
    null,
    TransportType.metro,
    TransportType.monorail,
    TransportType.bus,
    TransportType.microbus,
    TransportType.BRT,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection:  Axis.horizontal,
        padding:          EdgeInsets.symmetric(horizontal: 16.w),
        itemCount:        _types.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final type       = _types[i];
          final isSelected = selected == type;
          // FIX: single source of truth via transportColor()
          final color      = transportColor(type);

          return GestureDetector(
            onTap: () =>
                context.read<NearestStationCubit>().applyFilter(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? color : AppColor.outline,
                  width: isSelected ? 0 : 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color:      isSelected
                        ? color.withOpacity(0.25)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: isSelected ? 8 : 4,
                    offset:     const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FIX: transportEmoji() shared helper
                  Text(transportEmoji(type),
                      style: TextStyle(fontSize: 13.sp)),
                  SizedBox(width: 5.w),
                  Text(
                    transportLabel(type),
                    style: TextStyle(
                      fontSize:   12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: isSelected ? Colors.white : AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Location FAB ───────────────────────────────────────────────────────────────

class _LocationFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<NearestStationCubit>().goToUserLocation(),
      child: Container(
        width:  44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color:  Colors.white,
          shape:  BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset:     const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.my_location_rounded,
            color: AppColor.main, size: 20.sp),
      ),
    );
  }
}

// ── Draggable Stations Strip ───────────────────────────────────────────────────

class _DraggableStationsStrip extends StatefulWidget {
  final List<NearestStationModel> stations;
  const _DraggableStationsStrip({required this.stations});

  @override
  State<_DraggableStationsStrip> createState() =>
      _DraggableStationsStripState();
}

class _DraggableStationsStripState extends State<_DraggableStationsStrip> {
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final navBarHeight = kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom;

    // The sheet anchors at bottom:0 (behind nav bar).
    // minSize peek = navBar + drag handle strip (60px) so the handle + "Nearest Stations"
    // title are clearly visible just above the nav bar and easy to grab.
    final double peekPx  = navBarHeight + 60;
    final double minSize = (peekPx / screenHeight).clamp(0.14, 0.25);
    const double maxSize = 0.85;

    return DraggableScrollableSheet(
      controller:       _sheetController,
      initialChildSize: minSize,
      minChildSize:     minSize,
      maxChildSize:     maxSize,
      snap:             true,
      snapSizes:        [minSize, maxSize],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color:        Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(
                    color:      Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset:     const Offset(0, -4),
                  ),
                ],
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12.h),

                        // ── drag handle ────────────────────────────────────
                        GestureDetector(
                          onTap: () {
                            final current = _sheetController.size;
                            _sheetController.animateTo(
                              current <= minSize + 0.02 ? maxSize : minSize,
                              duration: const Duration(milliseconds: 300),
                              curve:    Curves.easeInOut,
                            );
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Center(
                            child: Container(
                              width:  36.w,
                              height: 4.h,
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color:        AppColor.outline,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                        ),

                        // ── header row ─────────────────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Text(
                                'Nearest Stations',
                                style: TextStyle(
                                  fontSize:   15.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                  color:      AppColor.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${widget.stations.length} found',
                                style: TextStyle(
                                  fontSize:   12.sp,
                                  fontFamily: 'Roboto',
                                  color:      AppColor.muted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  // ── 2-column grid of station cards ─────────────────────
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:     2,
                        crossAxisSpacing:   10.w,
                        mainAxisSpacing:    10.h,
                        childAspectRatio:   1.1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (_, i) => _StationMiniCard(
                          station:    widget.stations[i],
                          isSelected: context
                              .watch<NearestStationCubit>()
                              .state
                              .selectedStation
                              ?.id ==
                              widget.stations[i].id,
                          onTap: () => context
                              .read<NearestStationCubit>()
                              .selectStation(widget.stations[i]),
                        ),
                        childCount: widget.stations.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Station Mini Card ──────────────────────────────────────────────────────────

class _StationMiniCard extends StatelessWidget {

  final NearestStationModel station;
  final bool                isSelected;
  final VoidCallback        onTap;

  const _StationMiniCard({
    required this.station,
    required this.isSelected,
    required this.onTap,
  });

  // FIX: delegate to shared helpers — no more duplicated switch blocks
  Color  get _color => transportColor(station.type);
  String get _emoji => transportEmoji(station.type);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve:    Curves.easeOutCubic,
        padding:  EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? _color : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? _color : AppColor.outline,
            width: isSelected ? 0 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color:      isSelected
                  ? _color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 6,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (station.isBestPrediction)
              Container(
                margin:  EdgeInsets.only(bottom: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '⭐ Best',
                  style: TextStyle(
                    fontSize:   9.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            Text(_emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(height: 4.h),
            Text(
              station.name,
              style: TextStyle(
                fontSize:   12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: isSelected ? Colors.white : AppColor.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Icon(Icons.near_me_rounded,
                    size:  10.sp,
                    color: isSelected ? Colors.white70 : AppColor.muted),
                SizedBox(width: 3.w),
                Text(
                  '${station.distanceKm.toStringAsFixed(2)} km',
                  style: TextStyle(
                    fontSize:   10.sp,
                    fontFamily: 'Roboto',
                    color: isSelected ? Colors.white70 : AppColor.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Station Detail Sheet ───────────────────────────────────────────────────────


class _StationDetailSheet extends StatefulWidget {
  final NearestStationModel station;
  final VoidCallback        onClose;
  final ScrollController    scrollController; // FIX: passed from DraggableScrollableSheet

  const _StationDetailSheet({
    required this.station,
    required this.onClose,
    required this.scrollController,
  });

  @override
  State<_StationDetailSheet> createState() => _StationDetailSheetState();
}

class _StationDetailSheetState extends State<_StationDetailSheet> {

  late final int _seats; // ← late final = بيتحسب مرة واحدة بس

  @override
  void initState() {
    super.initState();

    _seats = _fakeSeats[Random().nextInt(_fakeSeats.length)];

  }

  Color  get _color => transportColor(widget.station.type);

  String get _emoji => transportEmoji(widget.station.type);

  String get _seatsLabel {
    if (widget.station.totalSeats != null && widget.station.availableSeats != null) {
      final pct = widget.station.occupancyPercentage!.toStringAsFixed(0);
      return '${widget.station.availableSeats}/${widget.station.totalSeats} Available • $pct%';
    }
    return widget.station.crowding.label;
  }

  @override
  Widget build(BuildContext context) {
    // FIX: stable seats value — no Random() in build
    return Container(
      margin:  EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset:     const Offset(0, -4),
          ),
        ],
      ),
      // FIX: SingleChildScrollView connected to DraggableScrollableSheet controller
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding:    EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // drag handle
            Center(
              child: Container(
                width:  36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color:        AppColor.outline,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── header row ──────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width:  48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_color, _color.withOpacity(0.7)],
                      begin:  Alignment.topLeft,
                      end:    Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color:      _color.withOpacity(0.3),
                        blurRadius: 10,
                        offset:     const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(_emoji, style: TextStyle(fontSize: 24.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.station.isBestPrediction)
                        Container(
                          margin:  EdgeInsets.only(bottom: 3.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color:        const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '⭐ Best Recommended',
                            style: TextStyle(
                              fontSize:   10.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto',
                              color:      const Color(0xFFF59E0B),
                            ),
                          ),
                        ),
                      Text(
                        widget.station.name,
                        style: TextStyle(
                          fontSize:   15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                          color:      AppColor.textPrimary,
                        ),
                      ),
                      Text(
                        widget.station.type?.name ?? 'Station',
                        style: TextStyle(
                          fontSize:   12.sp,
                          fontFamily: 'Roboto',
                          color:      _color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width:  30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color:        AppColor.offWhite,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 14.sp, color: AppColor.grey),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // ── info chips ───────────────────────────────────────────────────
            Row(
              children: [
                _Chip(
                  icon:  Icons.near_me_rounded,
                  label: '${widget.station.distanceKm.toStringAsFixed(2)} km',
                  color: AppColor.main,
                ),
                if (widget.station.predictionScore > 0) ...[
                  SizedBox(width: 8.w),
                  _Chip(
                    icon:  Icons.analytics_rounded,
                    label: '${widget.station.predictionScore.toStringAsFixed(0)}%',
                    color: AppColor.secondary,
                  ),
                  SizedBox(width: 8.w),
                  // FIX: stable seats + crowding color
                  _Chip(
                    icon:  Icons.event_seat_rounded,
                    label: '$_seats of 35',
                    color: crowdingColor(widget.station.crowding),
                  ),
                ],
              ],
            ),


            if (widget.station.routes != null && widget.station.routes!.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Routes',
                  style: TextStyle(
                    fontSize:   13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color:      AppColor.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Wrap(
                spacing: 6.w, runSpacing: 6.h,
                children: widget.station.routes!
                    .split(' | ')
                    .map((r) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color:        _color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: _color.withOpacity(0.2)),
                  ),
                  child: Text(
                    r,
                    style: TextStyle(
                      fontSize:   11.sp,
                      fontFamily: 'Roboto',
                      color:      _color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ],

            SizedBox(height: 16.h),

            // ── directions button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openInGoogleMaps(
                  widget.station.location.lat,
                  widget.station.location.lng,
                  widget.station.name,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _color,
                  side:            BorderSide(color: _color, width: 1.5),
                  padding:         EdgeInsets.symmetric(vertical: 13.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon:  Icon(Icons.directions_rounded, size: 18.sp),
                label: Text(
                  'Open in Google Maps',
                  style: TextStyle(
                    fontSize:   14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chip ──────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    color;

  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize:   11.sp,
              fontFamily: 'Roboto',
              color:      color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading Overlay ────────────────────────────────────────────────────────────

class _LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.15),
      child: Center(
        child: Container(
          padding:    EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                  color: AppColor.main, strokeWidth: 2),
              SizedBox(height: 10.h),
              Text(
                'Finding stations...',
                style: TextStyle(
                  fontSize:   13.sp,
                  fontFamily: 'Roboto',
                  color:      AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Error Bar ──────────────────────────────────────────────────────────────────

class _ErrorBar extends StatelessWidget {
  final String       message;
  final VoidCallback onRetry;
  const _ErrorBar({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color:        AppColor.errorContainer,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: AppColor.error, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize:   12.sp,
                fontFamily: 'Roboto',
                color:      AppColor.error,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TextStyle(
                fontSize:   12.sp,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color:      AppColor.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}