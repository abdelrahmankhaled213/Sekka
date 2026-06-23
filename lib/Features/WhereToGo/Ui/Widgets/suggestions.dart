// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:sekka/Core/theme/app_colors.dart';
// import 'package:sekka/Core/theme/app_radius.dart';
// import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
// import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';
// import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

// class SuggestionsList extends StatelessWidget {
//   final WhereToGoState state;

//   const SuggestionsList({
//     super.key,
//     required this.state,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final suggestions = state.suggestions;

//     if (state.status == WhereToGoStatus.searching) {
//       return _buildSkeletons();
//     }

//     if (suggestions.isEmpty) {
//       return _EmptySearch();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
//           child: Row(
//             children: [
//               Text(
//                 'Suggestions',
//                 style: TextStyle(
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(99.r),
//                 ),
//                 child: Text(
//                   '${suggestions.length} found',
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.separated(
//             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
//             itemCount: suggestions.length,
//             separatorBuilder: (_, __) => SizedBox(height: 10.h),
//             itemBuilder: (context, index) {
//               return _SuggestionCard(
//                 place: suggestions[index],
//                 index: index,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSkeletons() {
//     return ListView.separated(
//       padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h),
//       itemCount: 4,
//       separatorBuilder: (_, __) => SizedBox(height: 10.h),
//       itemBuilder: (_, __) => _SkeletonCard(),
//     );
//   }
// }

// // ── Single suggestion card ────────────────────────────────────────────────────

// class _SuggestionCard extends StatefulWidget {
//   final PlacePrediction place;
//   final int index;

//   const _SuggestionCard({required this.place, required this.index});

//   @override
//   State<_SuggestionCard> createState() => _SuggestionCardState();
// }

// class _SuggestionCardState extends State<_SuggestionCard> {
//   static const _apiKey = 'AIzaSyD8wJ57Gu5X__PvixWBSbknjnDL41YBjcY';

//   // New Places API base
//   static const _newPlacesBase = 'https://places.googleapis.com/v1';

//   String? _photoUrl;
//   bool _photoLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPhoto();
//   }

//   /// Step 1 — call the new Places API details endpoint to get the photo name.
//   /// Step 2 — build the media URL from the returned photo resource name.
//   Future<void> _loadPhoto() async {
//     try {
//       // ── Step 1: get place details (photos field only) ──────────────────
//       final detailsUri = Uri.parse(
//         '$_newPlacesBase/places/${widget.place.placeId}'
//             '?fields=photos'
//             '&key=$_apiKey',
//       );

//       final detailsResp = await http.get(
//         detailsUri,
//         headers: {
//           'Content-Type': 'application/json',
//           'X-Goog-Api-Key': _apiKey,
//           'X-Goog-FieldMask': 'photos',
//         },
//       );

//       if (!mounted) return;

//       if (detailsResp.statusCode != 200) {
//         setState(() => _photoLoaded = true);
//         return;
//       }

//       final data = json.decode(detailsResp.body) as Map<String, dynamic>;
//       final photos = data['photos'] as List<dynamic>?;

//       if (photos == null || photos.isEmpty) {
//         setState(() => _photoLoaded = true);
//         return;
//       }

//       // photo resource name looks like:
//       // "places/ChIJ.../photos/AXCi2Q..."
//       final photoName = photos.first['name'] as String?;
//       if (photoName == null) {
//         setState(() => _photoLoaded = true);
//         return;
//       }

//       // ── Step 2: build the media URL ────────────────────────────────────
//       // Format: /v1/{photoName}/media?maxHeightPx=400&maxWidthPx=400&key=...
//       setState(() {
//         _photoUrl =
//         '$_newPlacesBase/$photoName/media'
//             '?maxHeightPx=400&maxWidthPx=400&key=$_apiKey';
//         _photoLoaded = true;
//       });
//     } catch (_) {
//       if (mounted) setState(() => _photoLoaded = true);
//     }
//   }

//   IconData _typeIcon(String secondary) {
//     final s = secondary.toLowerCase();
//     if (s.contains('airport')) return Icons.flight_takeoff_rounded;
//     if (s.contains('mall') || s.contains('shopping')) return Icons.local_mall_rounded;
//     if (s.contains('station') || s.contains('metro')) return Icons.subway_rounded;
//     if (s.contains('hospital') || s.contains('clinic')) return Icons.local_hospital_rounded;
//     if (s.contains('university') || s.contains('school')) return Icons.school_rounded;
//     if (s.contains('park') || s.contains('garden')) return Icons.park_rounded;
//     return Icons.location_on_rounded;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 280 + widget.index * 50),
//       curve: Curves.easeOutCubic,
//       builder: (context, v, child) => Opacity(
//         opacity: v,
//         child: Transform.translate(offset: Offset(0, 18 * (1 - v)), child: child),
//       ),
//       child: Material(
//         color: AppColors.surface,
//         borderRadius: AppRadius.allLG,
//         child: InkWell(
//           onTap: () => context.read<WhereToGoCubit>().selectPlace(widget.place),
//           borderRadius: AppRadius.allLG,
//           splashColor: AppColors.primary.withOpacity(0.08),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: AppRadius.allLG,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: AppRadius.allLG,
//               child: Row(
//                 children: [
//                   // ── Photo block ──────────────────────────────────────────
//                   SizedBox(
//                     width: 80.w,
//                     height: 80.w,
//                     child: !_photoLoaded
//                         ? _PhotoSkeleton()
//                         : (_photoUrl != null
//                         ? Image.network(
//                       _photoUrl!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => _PlaceholderIcon(
//                         icon: _typeIcon(widget.place.secondaryText),
//                       ),
//                     )
//                         : _PlaceholderIcon(
//                       icon: _typeIcon(widget.place.secondaryText),
//                     )),
//                   ),

//                   // ── Text block ───────────────────────────────────────────
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 12.w, vertical: 12.h),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.place.mainText,
//                             style: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 3.h),
//                           Row(
//                             children: [
//                               Icon(Icons.location_on_outlined,
//                                   size: 10.sp, color: AppColors.muted),
//                               SizedBox(width: 3.w),
//                               Expanded(
//                                 child: Text(
//                                   widget.place.secondaryText,
//                                   style: TextStyle(
//                                     fontSize: 11.sp,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ── Arrow ────────────────────────────────────────────────
//                   Padding(
//                     padding: EdgeInsets.only(right: 12.w),
//                     child: Icon(Icons.arrow_forward_ios_rounded,
//                         size: 12.sp, color: AppColors.muted),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Placeholder when no photo ─────────────────────────────────────────────────

// class _PlaceholderIcon extends StatelessWidget {
//   final IconData icon;
//   const _PlaceholderIcon({required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primary.withOpacity(0.07),
//       child: Center(
//         child: Icon(icon,
//             size: 28.sp, color: AppColors.primary.withOpacity(0.45)),
//       ),
//     );
//   }
// }

// // ── Shimmer skeleton for photo ────────────────────────────────────────────────

// class _PhotoSkeleton extends StatefulWidget {
//   @override
//   State<_PhotoSkeleton> createState() => _PhotoSkeletonState();
// }

// class _PhotoSkeletonState extends State<_PhotoSkeleton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 900))
//       ..repeat(reverse: true);
//     _anim = Tween<double>(begin: 0.3, end: 0.8)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) =>
//           Container(color: AppColors.outline.withOpacity(_anim.value)),
//     );
//   }
// }

// // ── Full card skeleton for searching state ────────────────────────────────────

// class _SkeletonCard extends StatefulWidget {
//   @override
//   State<_SkeletonCard> createState() => _SkeletonCardState();
// }

// class _SkeletonCardState extends State<_SkeletonCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 900))
//       ..repeat(reverse: true);
//     _anim = Tween<double>(begin: 0.3, end: 0.8)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => Container(
//         height: 80.h,
//         decoration: BoxDecoration(
//           color: AppColors.outline.withOpacity(_anim.value),
//           borderRadius: AppRadius.allLG,
//         ),
//       ),
//     );
//   }
// }

// // ── Empty state ───────────────────────────────────────────────────────────────

// class _EmptySearch extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 64.w,
//             height: 64.w,
//             decoration: BoxDecoration(
//               color: AppColors.offWhite,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.search_off_rounded,
//                 size: 28.sp, color: AppColors.muted),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'No places found',
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             'Try a different search term',
//             style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Features/NearestStation/Data/Model/place_prediction_model.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_state.dart';

/// Suggestions list for both FROM and TO fields.
/// Pass [onSelectFrom] or [onSelectTo] depending on context.
class SuggestionsList extends StatelessWidget {
  final WhereToGoState state;
  final ValueChanged<PlacePrediction>? onSelectFrom;
  final ValueChanged<PlacePrediction>? onSelectTo;

  const SuggestionsList({
    super.key,
    required this.state,
    this.onSelectFrom,
    this.onSelectTo,
  });

  bool get _isFromField => state.activeField == ActiveSearchField.from;

  List<PlacePrediction> get _items =>
      _isFromField ? state.fromSuggestions : state.suggestions;

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _items.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 52.w,
        color: AppColors.outline.withOpacity(0.5),
      ),
      itemBuilder: (context, i) {
        final place = _items[i];
        return _SuggestionTile(
          place: place,
          isFrom: _isFromField,
          onTap: () {
            if (_isFromField) {
              onSelectFrom?.call(place);
            } else {
              onSelectTo?.call(place);
            }
          },
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final PlacePrediction place;
  final bool isFrom;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.place,
    required this.isFrom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: isFrom
                    ? AppColors.lightGreen.withOpacity(0.12)
                    : AppColors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.place_rounded,
                size: 16.sp,
                color: isFrom ? AppColors.darkGreen : AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.mainText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (place.secondaryText.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      place.secondaryText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.north_west_rounded,
              size: 14.sp,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}