import 'package:flutter/material.dart';

class StopTimelinePainter extends CustomPainter {

  final Color lineColor;
  final Color dotColor;
  final bool isFirst;
  final bool isLast;
  final bool isFilled;

  StopTimelinePainter({
    required this.lineColor,
    required this.dotColor,
    this.isFirst = false,
    this.isLast = false,
    this.isFilled = false,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final cx = size.width / 2;
    final cy = size.height / 2;
    const dotRadius = 5.0;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;


    if (!isFirst) {
      canvas.drawLine(Offset(cx, 0), Offset(cx, cy - dotRadius), linePaint);
    }

    if (!isLast) {
      canvas.drawLine(
          Offset(cx, cy + dotRadius), Offset(cx, size.height), linePaint);
    }

    final dotPaint = Paint()
      ..color = (isFirst || isLast || isFilled) ? dotColor : Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = dotColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(cx, cy), dotRadius, dotPaint);
    if (!isFirst && !isLast && !isFilled) {
      canvas.drawCircle(Offset(cx, cy), dotRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(StopTimelinePainter oldDelegate) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor ||
      oldDelegate.isFirst != isFirst ||
      oldDelegate.isLast != isLast;

}