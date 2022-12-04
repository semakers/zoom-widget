import 'package:flutter/material.dart';
import 'package:mobile/examples/custom_zoom.dart';
import 'package:mobile/examples/init_total_zoom_out.dart';
import 'package:mobile/examples/simple_zoom.dart';
import 'package:mobile/examples/zoomeable_image_gallery.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zoom examples'),
      ),
      body: ListView(
        padding: EdgeInsets.all(
          8.0,
        ),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SimpleZoom(),
                ),
              );
            },
            child: Text(
              'Simple zoom',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InitTotalZoomOut(),
                ),
              );
            },
            child: Text(
              'Init total zoom out',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CustomZoom(),
                ),
              );
            },
            child: Text(
              'Custom zoom',
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ZoomeableImageGallery(),
                ),
              );
            },
            child: Text(
              'Zoomeable image gallery',
            ),
          ),
        ],
      ),
    );
  }
}
