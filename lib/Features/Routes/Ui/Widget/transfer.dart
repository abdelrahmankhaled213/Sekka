import 'package:flutter/material.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';

class TransferWidget extends StatelessWidget {
  final SegmentModel segment;

  const TransferWidget({super.key, required this.segment});

  @override
  Widget build(BuildContext context) {
    if (segment.transferAtStop == null || segment.nextLineName == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        border: Border.all(color: const Color(0xFFF5C97A), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFFF5C97A),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.swap_horiz_rounded,
                size: 14,
                color: Color(0xFF7A4F00),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer at ${segment.transferAtStop}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A4F00),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Take ${segment.nextLineName}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB07A20),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 11,
            color: Color(0xFFB07A20),
          ),
        ],
      ),
    );
  }
}