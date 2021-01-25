import "package:flutter/gestures.dart";

class MultiTouchGestureRecognizer extends MultiTapGestureRecognizer {
  MultiTouchGestureRecognizerCallback onMultiTap;
  SingleTouchGestureRecognizerCallback onSingleTap;
  Offset firstPoint;
  var numberOfTouches = 0;

  MultiTouchGestureRecognizer() {
    super.onTapDown = (pointer, details) => this.addTouch(pointer, details);
    super.onTapUp = (pointer, details) => this.removeTouch(pointer, details);
    super.onTapCancel = (pointer) => this.cancelTouch(pointer);
    super.onTap = (pointer) => this.captureDefaultTap(pointer);
  }

  void addTouch(int pointer, TapDownDetails details) {
    this.numberOfTouches++;
    if (this.numberOfTouches == 1) {
      firstPoint = details.localPosition;
      this.onSingleTap(details.localPosition);
    }

    if (this.numberOfTouches == 2) {
      this.onMultiTap(firstPoint, details.localPosition);
    }
  }

  void removeTouch(int pointer, TapUpDetails details) {
    this.numberOfTouches = 0;
  }

  void cancelTouch(int pointer) {
    this.numberOfTouches = 0;
  }

  void captureDefaultTap(int pointer) {}

  @override
  set onTapDown(_onTapDown) {}

  @override
  set onTapUp(_onTapUp) {}

  @override
  set onTapCancel(_onTapCancel) {}

  @override
  set onTap(_onTap) {}
}

typedef MultiTouchGestureRecognizerCallback = void Function(
    Offset firstPoint, Offset secondPoint);
typedef SingleTouchGestureRecognizerCallback = void Function(Offset point);
