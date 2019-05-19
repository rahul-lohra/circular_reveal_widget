import 'dart:math';

import 'package:flutter/material.dart';

import 'RevealAnimationController.dart';
import 'RevealPaint.dart';

class RevealState extends State
    with TickerProviderStateMixin, ControllerCallback {
  Widget child;
  bool enableReveal = false;
  RevealAnimationController controller;

  Offset offset;
  RevealPaint revealPaint;
  Size renderBoxSize;
  double oldLongPressDis = 0;
  double THRESHOLD_DIFF = 0.2;
  bool canRunFingerUpAnim = false;

  RevealState(Widget child) {
    this.child = child;
    controller = RevealAnimationController(this, this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List();
    widgetList.add(child);

    if (enableReveal) {
      revealPaint = RevealPaint();
      revealPaint.radius = max(renderBoxSize.height, renderBoxSize.width) + 10;
      revealPaint.fraction = controller.fraction;
      revealPaint.setAlpha(controller.alpha);
      revealPaint.offset = offset;

      widgetList.add(revealWidget(renderBoxSize, revealPaint));
    }

    return getTapWidget(widgetList);
  }

  Widget getTapWidget(List<Widget> widgetList) {
    return GestureDetector(
      child: Stack(children: widgetList),
      onLongPressMoveUpdate: (e) {
        print("onLongPressMoveUpdate");
        handleFingerMove(e.globalPosition.distance);
      },
      onHorizontalDragUpdate: (e){
        print("onHorizontalDragUpdate");
        handleFingerMove(e.globalPosition.distance);
      },
      onVerticalDragUpdate: (e){
        print("onVerticalDragUpdate");
        handleFingerMove(e.globalPosition.distance);
      },
      onTapUp: (e){
        print("onTapUp");
        handleTapUp();
      },
      onLongPressUp: (){
        print("onLongPressUp");
        handleTapUp();
      },
      onTapDown: (e) {
        handleTapDown(e);
      },
    );
  }

  void handleFingerMove(double pos) {
    if(canRunFingerUpAnim) {
      if (oldLongPressDis == 0) {
        oldLongPressDis = pos;
      } else {
        double diff = (oldLongPressDis - pos).abs();
        oldLongPressDis = 0;
        if (diff > THRESHOLD_DIFF) {
          handleTapUp();
        }
      }
    }
  }

  void handleTapDown(TapDownDetails e) {
    setState(() {
      canRunFingerUpAnim = true;
      RenderBox box = context.findRenderObject();
      offset = box.globalToLocal(e.globalPosition);
      renderBoxSize = Size(box.size.width, box.size.height);
      startAnimation();
      enableReveal = true;
    });
  }

  void handleTapUp() {
    canRunFingerUpAnim = false;
    controller.stopAnimation();
  }

  void startAnimation() {
    controller.startAnimation();
  }

  Widget revealWidget(Size _size, CustomPainter paint) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: CustomPaint(
        size: _size,
        painter: paint,
      ),
    );
  }

  @override
  void onAnimationUpdate(double fraction, int alpha) {
    setState(() {
      controller.fraction = fraction;
    });
  }

  @override
  void onAnimationComplete(double fraction) {
    setState(() {
      controller.fraction = fraction;
    });
  }

  @override
  void onAlphaUpdate(int alpha) {
    setState(() {
      controller.alpha = alpha;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}
