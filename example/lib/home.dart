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
        zoomSensibility: 0.05,
        coverChild: true,
        child: Center(child: FlutterLogo(size: 3000)),
      ),
    );
  }
}
