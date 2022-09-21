import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class SimpleZoom extends StatelessWidget {
  const SimpleZoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom zoom'),
      ),
      body: Zoom(
          maxZoomHeight: 1000,
          maxZoomWidth: 1000,
          child: Center(
            child: Text('Happy zoom!'),
          )),
    );
  }
}
