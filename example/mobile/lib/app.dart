import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zoom example'),
        ),
        body: Zoom(
          maxZoomWidth: 1800,
          maxZoomHeight: 1800,
          onTap: () {
            print("You click the widget!");
          },
          initZoom: 0.0,
          child: Center(
            child: Container(
              child: Text('Hello World'),
            ),
          ),
        ),
      ),
    );
  }
}
