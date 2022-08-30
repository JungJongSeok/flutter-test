import 'dart:developer' as Logger;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testing_app/screens/home.dart';

class CityPage extends StatelessWidget {
  static const routeName = '/city_page';

  const CityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Page'),
      ),
      body: const Center(
        child: CityWidget(),
      ),
    );
  }
}

class CityWidget extends StatefulWidget {

  const CityWidget({super.key});

  @override
  State<CityWidget> createState() => CityWidgetState();
}

class CityWidgetState extends State<CityWidget> {
  late final PageController controller = PageController(
    viewportFraction: .8,
    initialPage: currentPage,
  );
  late int currentPage = -1;
  bool pageHasChanged = false;

  List<String> fileNames = [
    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
  ];

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return PageView.builder(
      itemCount: fileNames.length,
      onPageChanged: (value) {
        setState(() {
          pageHasChanged = true;
          currentPage = value;
        });
      },
      controller: controller,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          var result =
              pageHasChanged ? (controller.page ?? 0.0) : currentPage * 1.0;

          // The horizontal position of the page between a 1 and 0
          var value = result - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: Curves.easeOut.transform(value) * size.height,
                width: Curves.easeOut.transform(value) * size.width,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: (() {
            Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false, arguments: HomeArguments(
              city: currentPage.toString(),
            ));
          }),
          child: Image.network(fileNames[index], fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
