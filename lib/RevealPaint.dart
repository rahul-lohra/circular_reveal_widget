import 'package:circular_reveal/RevealAnimationController.dart';
import 'package:flutter/material.dart';

import 'HexColor.dart';


class RevealPaint extends CustomPainter {
  double fraction = 0.0;
  double radius = 0;
  Paint mPaint;
  Offset offset;
  int alpha = RevealAnimationController.MAX_ALPHA;
  String revealColor = "F2F3F4";

  RevealPaint() {
    mPaint = Paint();
    mPaint.color = HexColor("#$alpha$revealColor");
    mPaint.style = PaintingStyle.fill;
    offset = Offset(0, 0);
  }

  setAlpha(int alpha){
    this.alpha = alpha;
    mPaint.color = HexColor("#${alpha}$revealColor");
  }

  @override
  void paint(Canvas canvas, Size size) {
    double finalRadius = (radius * fraction);
    canvas.drawCircle(offset, finalRadius, mPaint);
  }

  @override
  bool shouldRepaint(RevealPaint oldDelegate) {
    return true;
  }
}
