
import 'package:flutter/material.dart';

class RevealAnimationController {
  Animation<double> tweenExpand;
  Animation<double> tweenFade;
  VoidCallback tweenFadeCallback;
  VoidCallback tweenExpandCallback;
  AnimationController animaController;
  AnimationController fadeAnimController;

  double fraction = 0;
  double x = 0;
  double y = 0;
  Offset offset;
  static final int MAX_ALPHA = 40;
  static final int MIN_ALPHA = 0;
  double MAX_TWEEN_VALUE = 1;
  double MIN_TWEEN_VALUE = 0;
  int alpha = 0;
  ControllerCallback callback;
  bool stopAnim = false;

  AnimStates animationState = AnimStates.NOT_STARTED;

  RevealAnimationController(
      TickerProviderStateMixin mixin, ControllerCallback callback) {
    this.callback = callback;
    alpha = MAX_ALPHA;
    fraction = MIN_TWEEN_VALUE;
    animationState = AnimStates.NOT_STARTED;
    offset = Offset(x, y);
    animaController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: mixin);
    fadeAnimController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: mixin);

    tweenFade =
        Tween<double>(begin: MAX_ALPHA.toDouble(), end: MIN_ALPHA.toDouble())
            .animate(fadeAnimController);

    tweenExpand = Tween<double>(begin: MIN_TWEEN_VALUE, end: MAX_TWEEN_VALUE)
        .animate(animaController);

    _prepareTweenCallback();
  }

  startAnimation() {
    animationState = AnimStates.CANCELLING;
    stopAnim = false;
    if (animaController.isAnimating) {
      return;
    }
    if (animaController.isCompleted) {
      //Do nothing
    } else {
      if (callback != null) {
        callback.onAlphaUpdate(MAX_ALPHA);
      }

      animaController.addListener(tweenExpandCallback);
      fadeAnimController.removeListener(tweenFadeCallback);
      animaController.forward();
      fadeAnimController.reset();
    }
  }

  startFadeOutAnim() {
    if (callback != null) {
      tweenFade.addListener(tweenFadeCallback);
      fadeAnimController.forward();
    }
  }

  _prepareTweenCallback() {
    tweenFadeCallback = () {
      if (callback != null && tweenFade != null) {
        int val = tweenFade.value.toInt();
        callback.onAlphaUpdate(val);
      }
    };

    tweenExpandCallback = () {
      if (stopAnim) {
      } else {
        alpha = MAX_ALPHA;
      }
      fraction = tweenExpand.value;

      if (callback != null) {
        if (tweenExpand.value == MAX_TWEEN_VALUE) {
          callback.onAnimationComplete(fraction);
          animationState = AnimStates.COMPLETED;
          resetExpandAnim();
        } else {
          animationState = AnimStates.RUNNING;
          callback.onAnimationUpdate(fraction, alpha);
        }
      }
    };
  }

  resetExpandAnim() {
    animaController.removeListener(tweenExpandCallback);
    animaController.reset();
  }

  stopAnimation() {
    stopAnim = true;
    startFadeOutAnim();
  }

  dispose() {
    animaController.dispose();
    fadeAnimController.dispose();
  }
}

abstract class ControllerCallback {
  void onAnimationUpdate(double fraction, int alpha);

  void onAlphaUpdate(int alpha);

  void onAnimationComplete(double fraction);
}

enum AnimStates { NOT_STARTED, RUNNING, COMPLETED, CANCELLING }
