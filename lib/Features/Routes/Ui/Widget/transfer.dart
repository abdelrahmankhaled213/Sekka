import 'package:flutter/material.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';

class TransferWidget extends StatelessWidget {
  final SegmentModel fromSegment;
  final SegmentModel toSegment;

  const TransferWidget({
    super.key,
    required this.fromSegment,
    required this.toSegment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.orange),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              "Transfer from ${fromSegment.lineName ?? fromSegment.type.name}"
              " → ${toSegment.lineName ?? toSegment.type.name}",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}