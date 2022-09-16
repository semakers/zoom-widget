import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zoom example'),
      ),
      body: Zoom(
        maxScale: 2,
        maxZoomHeight: 1500,
        maxZoomWidth: 1500,
        zoomSensibility: 0.05,
        centerOnScale: true,
        child: Center(child: FlutterLogo(size: 1500)),
      ),
    );
  }
}
