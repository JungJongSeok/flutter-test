import 'dart:developer' as Logger;
import 'dart:ui';

import 'package:flutter/material.dart';

class CarouselDemo extends StatelessWidget {
  static const routeName = '/carousels_page';

  const CarouselDemo({super.key});

  static const List<String> fileNames = [
    'assets/eat_cape_town_sm.jpg',
    'assets/eat_new_orleans_sm.jpg',
    'assets/eat_sydney_sm.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel Demo'),
      ),
      body: const Center(
        child: Carousel(files: fileNames),
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  final List<String> files;

  const Carousel({super.key, required this.files});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller = PageController(
    viewportFraction: .8,
    initialPage: _currentPage,
  );
  late int _currentPage = -1;
  bool _pageHasChanged = false;

  @override
  Widget build(context) {
    var size = MediaQuery.of(context).size;
    return PageView.builder(
      itemCount: widget.files.length,
      onPageChanged: (value) {
        setState(() {
          _pageHasChanged = true;
          _currentPage = value;
        });
      },
      controller: _controller,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          var result =
              _pageHasChanged ? (_controller.page ?? 0.0) : _currentPage * 1.0;

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
        child: Image.asset(widget.files[index], fit: BoxFit.cover),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
