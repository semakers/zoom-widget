import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
 
void main() => runApp(MyApp());
 
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
          width: 1800,
          height: 1800,
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