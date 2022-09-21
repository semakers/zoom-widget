import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CustomZoom extends StatefulWidget {
  const CustomZoom({Key? key}) : super(key: key);

  @override
  State<CustomZoom> createState() => _CustomZoomState();
}

class _CustomZoomState extends State<CustomZoom> {
  double x = 0;
  double y = 0;
  double zoom = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom zoom'),
      ),
      body: Zoom(
        initTotalZoomOut: true,
        backgroundColor: Colors.orange,
        canvasColor: Colors.grey,
        centerOnScale: true,
        colorScrollBars: Colors.purple,
        doubleTapZoom: true,
        enableScroll: true,
        maxZoomHeight: 1800,
        maxZoomWidth: 1800,
        opacityScrollBars: 0.9,
        scrollWeight: 10.0,
        zoomSensibility: 0.05,
        onTap: () {
          print("Widget clicked");
        },
        onPositionUpdate: (position) {
          setState(() {
            x = position.dx;
            y = position.dy;
          });
        },
        onScaleUpdate: (scale, zoom) {
          setState(() {
            this.zoom = zoom;
          });
        },
        child: Center(
          child: Text(
            "x:${x.toStringAsFixed(2)} y:${y.toStringAsFixed(2)} zoom:${zoom.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
