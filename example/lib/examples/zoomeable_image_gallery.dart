import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ZoomeableImageGallery extends StatelessWidget {
  const ZoomeableImageGallery({Key? key}) : super(key: key);

  Widget circularButton(
    Function() onTap,
    IconData icon,
  ) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              25,
            ),
            color: Colors.grey.withAlpha(170),
          ),
          child: Center(
              child: Icon(
            icon,
            color: Colors.white,
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Zoomeable image gallery'),
      ),
      body: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: List.generate(
                4,
                (index) => Zoom(
                      maxScale: 5,
                      maxZoomHeight: 1000,
                      maxZoomWidth: 1000,
                      initTotalZoomOut: true,
                      backgroundColor: Colors.black,
                      canvasColor: Colors.black,
                      colorScrollBars: Colors.grey,
                      centerOnScale: true,
                      child: Image.asset(
                        'assets/image${(index + 1)}.png',
                      ),
                    )),
          ),
          Row(
            children: [
              circularButton(() {
                controller.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              }, Icons.arrow_back_ios),
              Spacer(),
              circularButton(() {
                controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              }, Icons.arrow_forward_ios),
            ],
          )
        ],
      ),
    );
  }
}
