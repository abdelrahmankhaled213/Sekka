import 'package:flutter/material.dart';
import 'package:sekka/Core/Helper/segment_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Routes/Ui/Widget/stop_time_line.helper.dart';

class StopItem extends StatelessWidget {
  final StepModel stop;
  final bool isFirst;
  final bool isLast;

  const StopItem({
    super.key,
    required this.stop,
    this.isFirst = false,
    this.isLast = false,
  });


  @override
  Widget build(BuildContext context) {
    final bool isMuted = !isFirst && !isLast;

    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: CustomPaint(
              painter: StopTimelinePainter(
                lineColor: isMuted ? Colors.grey : const Color(0xFF1A1A1A),
                dotColor: isMuted ? Colors.grey : const Color(0xFF1A1A1A),
                isFirst: isFirst,
                isLast: isLast,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: isLast
                  ? null
                  : BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.1),
                          width: 0.5,
                        ),
                      ),
                    ),
              alignment: Alignment.centerLeft,
              child: Text(
                stop.stopName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      (isFirst || isLast) ? FontWeight.w600 : FontWeight.w400,
                  color: isMuted
                      ? const Color(0xFF888888)
                      : const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}