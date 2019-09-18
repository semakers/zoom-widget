library zoom_widget;

import 'package:flutter/material.dart';
import 'package:zoom_widget/MultiTouchGestureRecognizer.dart';

class Zoom extends StatefulWidget {
  final double width, height;
  final Widget child;
  final Color backgroundColor;
  final Color canvasColor;
  final void Function(Offset) onPositionUpdate;
  final void Function(double, double) onScaleUpdate;
  final double scrollWeight;
  final double opacityScrollBars;
  final Color colorScrollBars;
  final bool centerOnScale;
  final double initZoom;
  final bool enableScroll;
  final double zoomSensibility;
  final bool doubleTapZoom;

  Zoom(
      {Key key,
      this.width,
      this.height,
      this.child,
      this.onPositionUpdate,
      this.onScaleUpdate,
      this.backgroundColor = Colors.grey,
      this.canvasColor = Colors.white,
      this.scrollWeight = 7.0,
      this.opacityScrollBars = 0.5,
      this.colorScrollBars = Colors.black,
      this.centerOnScale = true,
      this.initZoom = 1.0,
      this.enableScroll = true,
      this.zoomSensibility = 1.0,
      this.doubleTapZoom = true})
      : super(key: key);

  _ZoomState createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> with TickerProviderStateMixin {
  double localTop = 0.0;
  double changeTop = 0.0;
  double auxTop = 0.0;
  double centerTop = 0.0;
  double scaleTop = 0.0;
  double downTouchTop = 0.0;
  double localLeft = 0.0;
  double changeLeft = 0.0;
  double auxLeft = 0.0;
  double centerLeft = 0.0;
  double downTouchLeft = 0.0;
  double scaleLeft = 0.0;
  double scale = 1.0;
  double changeScale = 0.0;
  double zoom = 0.0;
  Offset midlePoint = Offset(0.0, 0.0);
  Offset relativeMidlePoint = Offset(0.0, 0.0);
  bool initOrientation = false;
  bool portrait;
  AnimationController scaleAnimation;
  bool doubleTapDown;
  double doubleTapScale = 0.0;
  BoxConstraints globalConstraints;

  @override
  void initState() {
    scaleAnimation = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 250));
    scaleAnimation.addListener(() {
      setState(() {
        if (doubleTapDown) {
          scale = map(scaleAnimation.value, 0.0, 1.0, doubleTapScale, 1.0);
        } else {
          scale = map(
              scaleAnimation.value,
              0.0,
              1.0,
              doubleTapScale,
              (globalConstraints.maxHeight > globalConstraints.maxWidth)
                  ? globalConstraints.maxWidth / widget.width
                  : globalConstraints.maxHeight / widget.height);
        }

        scaleProcess(globalConstraints);
        scaleFixPosition(globalConstraints);
      });
      if (scaleAnimation.value == 1.0) {
        if(widget.onScaleUpdate!=null){
          widget.onScaleUpdate(scale, zoom);
        }
        if( widget.onPositionUpdate!=null){
           widget.onPositionUpdate(Offset(
            (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
            (auxTop + localTop + centerTop + scaleTop) * -1));
        }
       
        endEscale(globalConstraints);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    super.dispose();
  }

  double map(
      double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  void scaleFixPosition(constraints) {
    if (((widget.height * scale) > constraints.maxHeight) &&
        ((auxTop + localTop + centerTop + scaleTop) + (widget.height * scale)) <
            constraints.maxHeight) {
      localTop += constraints.maxHeight -
          ((auxTop + localTop + centerTop + scaleTop) + widget.height * scale);
    }

    if (((widget.width * scale) > constraints.maxWidth) &&
        ((auxLeft + localLeft + centerLeft + scaleLeft) +
                (widget.width * scale)) <
            constraints.maxWidth) {
      localLeft += constraints.maxWidth -
          ((auxLeft + localLeft + centerLeft + scaleLeft) +
              widget.width * scale);
    }

    if ((widget.height * scale) < constraints.maxHeight) {
      if (widget.centerOnScale) {
        centerTop = (constraints.maxHeight - widget.height * scale) / 2;
      }
    } else
      centerTop = 0.0;

    if ((widget.width * scale) < constraints.maxWidth) {
      if (widget.centerOnScale) {
        centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
      }
    } else
      centerLeft = 0.0;

    zoom = map(
        scale,
        1.0,
        (constraints.maxHeight > constraints.maxWidth)
            ? constraints.maxWidth / widget.width
            : constraints.maxHeight / widget.height,
        1.0,
        0.0);
  }

  void scaleProcess(constraints) {
    Offset currentMidlePoint = Offset(
        ((auxLeft + localLeft + centerLeft) * -1 + midlePoint.dx) *
                (1 / scale) -
            localLeft,
        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) * (1 / scale));

    if (currentMidlePoint.dx > relativeMidlePoint.dx) {
      double preScaleLeft =
          (currentMidlePoint.dx - relativeMidlePoint.dx) * scale;
      if (auxLeft + localLeft + preScaleLeft < 0) {
        scaleLeft = preScaleLeft;
      }
    } else {
      double preScaleLeft =
          (relativeMidlePoint.dx - currentMidlePoint.dx) * -scale;
      if ((auxLeft + localLeft + preScaleLeft) >
          -((widget.width * scale) - constraints.maxWidth * scale))
        scaleLeft = preScaleLeft;
    }

    if (currentMidlePoint.dy > relativeMidlePoint.dy) {
      double preScaleTop =
          (currentMidlePoint.dy - relativeMidlePoint.dy) * scale;
      if (auxTop + localTop + preScaleTop < 0) {
        scaleTop = preScaleTop;
      }
    } else {
      double preScaleTop =
          (relativeMidlePoint.dy - currentMidlePoint.dy) * -scale;
      if ((auxTop + localTop + preScaleTop) >
          -((widget.height * scale) - constraints.maxHeight * scale))
        scaleTop = preScaleTop;
    }
  }

  void endEscale(constraints) {
    auxTop += localTop + scaleTop;
    auxLeft += localLeft + scaleLeft;
    scaleLeft = 0;
    scaleTop = 0;
    localTop = 0;
    localLeft = 0;
    downTouchLeft = 0;
    downTouchTop = 0;
    if (auxLeft > 0) auxLeft = 0;
    if (auxTop > 0) auxTop = 0;

    if (widget.height * scale < constraints.maxHeight && auxTop < 0) {
      auxTop = 0;
    }

    if (widget.width * scale < constraints.maxWidth && auxLeft < 0) {
      auxLeft = 0;
    }

    if (widget.centerOnScale) {
      if (portrait) {
        if (widget.height * scale < constraints.maxHeight) {
          centerTop = (constraints.maxHeight - widget.height * scale) / 2;
        }
      } else {
        if (widget.width * scale < constraints.maxWidth) {
          centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
        }
      }
    }

    if (constraints.maxHeight > constraints.maxWidth &&
        widget.width * scale < constraints.maxWidth) {
      setState(() {
        scale = constraints.maxWidth / widget.width;
      });
    }

    if (constraints.maxWidth > constraints.maxHeight &&
        widget.height * scale < constraints.maxHeight) {
      setState(() {
        scale = constraints.maxHeight / widget.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        globalConstraints = constraints;
        if (!initOrientation) {
          scale = map(
              widget.initZoom,
              1.0,
              0.0,
              1.0,
              (constraints.maxHeight > constraints.maxWidth)
                  ? constraints.maxWidth / widget.width
                  : constraints.maxHeight / widget.height);
          initOrientation = true;
          portrait =
              (constraints.maxHeight > constraints.maxWidth) ? true : false;

          if (widget.centerOnScale) {
            if (portrait) {
              if (widget.height * scale < constraints.maxHeight) {
                centerTop = (constraints.maxHeight - widget.height * scale) / 2;
              }
            } else {
              if (widget.width * scale < constraints.maxWidth) {
                centerLeft = (constraints.maxWidth - widget.width * scale) / 2;
              }
            }
          }
          if(widget.onScaleUpdate!=null){
             widget.onScaleUpdate(scale, widget.initZoom);
          }
       
          if(widget.onPositionUpdate!=null){
            widget.onPositionUpdate(Offset(
            (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
            (auxTop + localTop + centerTop + scaleTop) * -1));
          }
        
        }

        if (!portrait && constraints.maxHeight > constraints.maxWidth) {
          portrait = true;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        } else if (portrait && constraints.maxHeight <= constraints.maxWidth) {
          portrait = false;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        }

        return RawGestureDetector(
          gestures: {
            MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                MultiTouchGestureRecognizer>(
              () => MultiTouchGestureRecognizer(),
              (MultiTouchGestureRecognizer instance) {
                instance.onSingleTap = (point) {
                  if (widget.doubleTapZoom) {
                    midlePoint = point;
                    relativeMidlePoint = Offset(
                        ((auxLeft + localLeft + centerLeft) * -1 +
                                midlePoint.dx) *
                            (1 / scale),
                        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                            (1 / scale));
                  }
                };
                instance.onMultiTap = (firstPoint, secondPoint) {
                  midlePoint = Offset((firstPoint.dx + secondPoint.dx) / 2.0,
                      (firstPoint.dy + secondPoint.dy) / 2.0);

                  relativeMidlePoint = Offset(
                      ((auxLeft + localLeft + centerLeft) * -1 +
                              midlePoint.dx) *
                          (1 / scale),
                      ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                          (1 / scale));
                };
              },
            ),
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onDoubleTap: () {
                  if (widget.doubleTapZoom) {
                    doubleTapScale = scale;

                    if (scale >= 0.99) {
                      doubleTapDown = false;
                    } else {
                      doubleTapDown = true;
                    }
                    scaleAnimation.forward(from: 0.0);
                  }
                },
              child: GestureDetector(
                onScaleStart: (details) {
                  downTouchLeft = details.focalPoint.dx * (1 / scale);
                  downTouchTop = details.focalPoint.dy * (1 / scale);

                  changeScale = 1.0;
                  scaleLeft = 0;
                  changeTop = details.focalPoint.dy;
                  changeLeft = details.focalPoint.dx;
                },
                onScaleUpdate: (details) {
                  double up = details.focalPoint.dy - changeTop;
                  double down = (changeTop - details.focalPoint.dy) * -1;
                  double left = details.focalPoint.dx - changeLeft;
                  double right = (changeLeft - details.focalPoint.dx) * -1;

                  setState(() {
                    if (details.scale != 1.0) {
                      if (details.scale > changeScale) {
                        double preScale = scale +
                            (details.scale - changeScale) / widget.zoomSensibility;
                        if (preScale < 1.0) {
                          scale = preScale;
                        }
                      } else if (changeScale > details.scale &&
                          (widget.width * scale > constraints.maxWidth ||
                              widget.height * scale > constraints.maxHeight)) {
                        double preScale = scale -
                            (changeScale - details.scale) / widget.zoomSensibility;

                        if (portrait) {
                          if (preScale > (constraints.maxWidth / widget.width)) {
                            scale = preScale;
                          }
                        } else {
                          if (preScale > (constraints.maxHeight / widget.height)) {
                            scale = preScale;
                          }
                        }
                      }

                      scaleProcess(constraints);
                      scaleFixPosition(constraints);

                      if( widget.onScaleUpdate!=null){
                          widget.onScaleUpdate(scale, zoom);
                      }

                      
                      changeScale = details.scale;
                    } else {
                      if (details.focalPoint.dy > changeTop &&
                          (auxTop + up) < 0 &&
                          (auxTop + up) >
                              -((widget.height) * scale - constraints.maxHeight)) {
                        localTop = up;
                      } else if (changeTop > details.focalPoint.dy &&
                          (auxTop + down) < 0 &&
                          (auxTop + down) >
                              -((widget.height) * scale - constraints.maxHeight)) {
                        localTop = down;
                      }
                      if (details.focalPoint.dx > changeLeft &&
                          (auxLeft + right) < 0 &&
                          (auxLeft + right) >
                              -((widget.width * scale) - constraints.maxWidth)) {
                        localLeft = right;
                      } else if (changeLeft > details.focalPoint.dx &&
                          (auxLeft + left) < 0 &&
                          (auxLeft + left) >
                              -((widget.width * scale) - constraints.maxWidth)) {
                        localLeft = left;
                      }
                    }
                  });

                  if(widget.onPositionUpdate!=null){
                    widget.onPositionUpdate(Offset(
                      (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
                      (auxTop + localTop + centerTop + scaleTop) * -1));
                  }
                },
                onScaleEnd: (details) {
                  endEscale(constraints);
                },
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: widget.backgroundColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: auxTop + localTop + centerTop + scaleTop,
                        left: auxLeft + localLeft + centerLeft + scaleLeft,
                        child: Transform.scale(
                          scale: scale,
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.canvasColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius:
                                        20.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        5.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      10.0, // horizontal, move right 10
                                      10.0, // vertical, move down 10
                                    ),
                                  )
                                ]),
                            width: widget.width,
                            height: widget.height,
                            child: widget.child,
                          ),
                        ),
                      ),
                      Positioned(
                        top: constraints.maxHeight - widget.scrollWeight,
                        left: -(auxLeft + localLeft + centerLeft + scaleLeft) /
                            ((widget.width * scale) / constraints.maxWidth),
                        child: Opacity(
                          opacity: (widget.width * scale <= constraints.maxWidth ||
                                  !widget.enableScroll)
                              ? 0
                              : widget.opacityScrollBars,
                          child: Container(
                            height: widget.scrollWeight,
                            width: constraints.maxWidth /
                                ((widget.width * scale) / constraints.maxWidth),
                            color: widget.colorScrollBars,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -(auxTop + localTop + centerTop + scaleTop) /
                            ((widget.height * scale) / constraints.maxHeight),
                        left: constraints.maxWidth - widget.scrollWeight,
                        child: Opacity(
                          opacity:
                              (widget.height * scale <= constraints.maxHeight ||
                                      !widget.enableScroll)
                                  ? 0
                                  : widget.opacityScrollBars,
                          child: Container(
                            width: widget.scrollWeight,
                            height: constraints.maxHeight /
                                ((widget.height * scale) / constraints.maxHeight),
                            color: widget.colorScrollBars,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
