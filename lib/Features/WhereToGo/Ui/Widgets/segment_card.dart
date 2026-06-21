import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Core/theme/app_colors.dart';
import 'package:sekka/Core/theme/app_radius.dart';
import 'package:sekka/Features/Routes/Ui/Widget/stop_item.dart';

class SegmentCard extends StatefulWidget {
  final SegmentModel segment;
  final bool isLast;

  const SegmentCard({super.key, required this.segment, required this.isLast});

  @override
  State<SegmentCard> createState() => _SegmentCardState();
}

class _SegmentCardState extends State<SegmentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final seg     = widget.segment;
    final preview = _expanded
        ? seg.stops
        : (seg.stops.length > 4 ? seg.stops.sublist(0, 4) : seg.stops);

    return Container(
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: AppRadius.allLG,
        border:       Border.all(color: AppColors.outline, width: 0.5),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width:  32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color:       AppColors.success.withOpacity(0.2),
                    borderRadius: AppRadius.allMD,
                  ),
                  child: Icon(
                      TransportUIHelper.icon(seg.type),
                      size:  15.sp,
                      color: AppColors.success.withOpacity(0.7)),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seg.lineName ?? '',
                        style: TextStyle(
                          fontSize:   13.sp,
                          fontWeight: FontWeight.w500,
                          color:      AppColors.textPrimary,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      if (seg.direction?.isNotEmpty == true)
                        Text(
                          seg.direction!,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color:    AppColors.textSecondary,
                              fontFamily: 'Roboto'),
                        ),
                    ],
                  ),
                ),
                _PositionBadge(segment: seg, accent: AppColors.warning),
              ],
            ),
          ),

          // ── Cost row ─────────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              border: Border(
                top:    BorderSide(color: AppColors.outline, width: 0.5),
                bottom: BorderSide(color: AppColors.outline, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                _CostChip(
                  icon:  Icons.access_time_rounded,
                  label: '${seg.durationMinutes} min',
                ),
                SizedBox(width: 14.w),
                _CostChip(
                  icon:  Icons.payments_outlined,
                  label: 'EGP ${seg.ticketPrice.toStringAsFixed(0)}',
                ),
                SizedBox(width: 14.w),
                _CostChip(
                  icon:  Icons.place_rounded,
                  label: '${seg.stopsCount} stops',
                ),
              ],
            ),
          ),

          // ── Stops list ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h),
            child: ListView.builder(
              shrinkWrap: true,
              physics:    const NeverScrollableScrollPhysics(),
              itemCount:  preview.length,
              itemBuilder: (_, i) {
                final isFirst = i == 0;
                final isLast  = i == preview.length - 1 &&
                    (seg.stops.length <= 4 || _expanded);
                return StopItem(
                  stop:    preview[i],
                  isFirst: isFirst,
                  isLast:  isLast,
                );
              },
            ),
          ),

          // ── Expand button ────────────────────────────────────────────────
          if (seg.stops.length > 4)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.remove_circle_outline_rounded
                          : Icons.add_circle_outline_rounded,
                      size:  13.sp,
                      color: AppColors.muted,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _expanded
                          ? 'Show less'
                          : 'View all ${seg.stops.length} stops',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color:    AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          // ── Transfer ─────────────────────────────────────────────────────
          if (seg.transferAtStop != null && seg.nextLineName != null)
            _TransferRow(
                atStop:   seg.transferAtStop!,
                nextLine: seg.nextLineName!),

          // ── Destination ──────────────────────────────────────────────────
          if (widget.isLast)
            _DestinationRow(name: seg.alightingStop, accent: AppColors.grey.withOpacity(0.7)),

          SizedBox(height: 6.h),
        ],
      ),
    );
  }
}

// ── Cost chip ─────────────────────────────────────────────────────────────────

class _CostChip extends StatelessWidget {
  final IconData icon;
  final String   label;

  const _CostChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 12.sp, color: AppColors.muted),
          SizedBox(width: 4.w),
          Text(label,
              style: TextStyle(
                  fontSize: 11.sp, color: AppColors.textSecondary)),
        ],
      );
}

// ── Position badge ────────────────────────────────────────────────────────────

class _PositionBadge extends StatelessWidget {
  final SegmentModel segment;
  final Color        accent;

  const _PositionBadge({required this.segment, required this.accent});

  @override
  Widget build(BuildContext context) {
    final Color    color;
    final String   label;
    final IconData icon;

    if (segment.isStart) {
      color = accent;
      label = 'start';
      icon  = Icons.radio_button_checked_rounded;
    } else if (segment.isTransfer) {
      color = AppColors.warning;
      label = 'transfer';
      icon  = Icons.swap_horiz_rounded;
    } else {
      color = AppColors.darkGreen;
      label = 'end';
      icon  = Icons.location_on_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 3.w),
          Text(label,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize:   10.sp,
                  fontWeight: FontWeight.w500,
                  color:      color)),
        ],
      ),
    );
  }
}

// ── Transfer row ──────────────────────────────────────────────────────────────

class _TransferRow extends StatelessWidget {
  final String atStop;
  final String nextLine;

  const _TransferRow({required this.atStop, required this.nextLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:        AppColors.warningContainer,
        borderRadius: AppRadius.allMD,
        border: Border.all(
            color: AppColors.warning.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width:  24.w,
            height: 24.w,
            decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.3),
                shape: BoxShape.circle),
            child: Icon(Icons.swap_horiz_rounded,
                size: 13, color: AppColors.warning),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer at $atStop',
                  style: TextStyle(
                      fontSize:   11.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      color:      AppColors.textPrimary),
                ),
                Text(
                  'Take $nextLine',
                  style: TextStyle(
                      fontSize:   10.sp,
                      fontFamily: 'Roboto',
                      color:      AppColors.warning),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 10.sp, color: AppColors.warning),
        ],
      ),
    );
  }
}

// ── Destination row ───────────────────────────────────────────────────────────

class _DestinationRow extends StatelessWidget {
  final String name;
  final Color  accent;

  const _DestinationRow({required this.name, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:        accent.withOpacity(0.06),
        borderRadius: AppRadius.allMD,
        border: Border.all(color: accent.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width:  24.w,
            height: 24.w,
            decoration:
                BoxDecoration(color: accent, shape: BoxShape.circle),
            child: Icon(Icons.flag_rounded,
                size: 12.sp, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destination',
                    style: TextStyle(
                        fontSize:   10.sp,
                        fontWeight: FontWeight.w500,
                        color:      accent)),
                Text(name,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color:    accent.withOpacity(0.8))),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: accent, size: 16.sp),
        ],
      ),
    );
  }
}