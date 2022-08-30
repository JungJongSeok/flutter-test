import 'dart:developer' as Logger;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testing_app/screens/home.dart';

import '../models/feeds.dart';
import 'feed.dart';

class DiscoverPage extends StatelessWidget {
  static const routeName = '/discover_page';

  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: DiscoverWidget(),
      ),
    );
  }
}

class DiscoverWidget extends StatefulWidget {
  const DiscoverWidget({super.key});

  @override
  State<DiscoverWidget> createState() => DiscoverWidgetState();
}

class DiscoverWidgetState extends State<DiscoverWidget>
    with SingleTickerProviderStateMixin {
  late final PageController controller = PageController(
    initialPage: currentPage,
  );

  late int currentPage = 0;

  final List<FeedData> feedList = [
    FeedData<ImageType>(
        id: "1",
        profile: Profile(id: "1"),
        model: ImageType(
          url: "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
    FeedData<VideoType>(
        id: "2",
        profile: Profile(id: "2"),
        model: VideoType(
          url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
    FeedData<TextType>(
        id: "3",
        profile: Profile(id: "3"),
        model: TextType(
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
    FeedData<ImageType>(
        id: "4",
        profile: Profile(id: "4"),
        model: ImageType(
          url: "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=trueg",
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
    FeedData<VideoType>(
        id: "5",
        profile: Profile(id: "5"),
        model: VideoType(
          url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
    FeedData<TextType>(
        id: "6",
        profile: Profile(id: "6"),
        model: TextType(
          text: "text",
          like: 0,
          comment: 0,
          share: 0,
          isLike: false,
          isBookmark: false,
          timestamp: 0,
        )),
  ];

  @override
  Widget build(context) {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: feedList.length,
      onPageChanged: (value) {
        setState(() {
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
      itemBuilder: (context, index) => GestureDetector(
          onTap: (() {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false,
                arguments: HomeArguments(
                  city: currentPage.toString(),
                ));
          }),
          child: DiscoverItemWidget(feedList[index], currentPage == index)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DiscoverItemWidget extends StatefulWidget {
  final FeedData feed;
  final bool isInView;

  const DiscoverItemWidget(this.feed, this.isInView, {super.key});

  @override
  DiscoverItemWidgetState createState() => DiscoverItemWidgetState();
}

class DiscoverItemWidgetState extends State<DiscoverItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  bool isStartLottie = false;

  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        lottieController.reset();
        finishLottie();
      }
    });
  }

  void startLottie() {
    isStartLottie = true;
    lottieController.forward();
  }

  void finishLottie() {
    isStartLottie = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.feed.model is TextType) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors
                .primaries[widget.feed.id.hashCode % Colors.primaries.length],
          ),
          title: Text(
            (widget.feed.model as TextType).text,
            key: Key('text_$widget.feed'),
          ),
          trailing: IconButton(
            key: Key('icon_$widget.feed'),
            icon: const Icon(Icons.favorite),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("TEXT"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      );
    } else if (widget.feed.model is ImageType) {
      return Card(
        elevation: 10.0,
        color: Color(0xFF000000),
        margin: const EdgeInsets.all(18.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Column(
          children: [
            FeedProfileWidget(
                profile: widget.feed.profile ?? Profile(id: "id")),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("TEXT"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onDoubleTap: () {
                setState(() {
                  startLottie();
                  if (widget.feed.model?.isLike == false) {
                    widget.feed.model
                        ?.setLike(!(widget.feed.model?.isLike ?? false));
                  }
                });
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  FeedImageWidget(
                    (widget.feed.model as ImageType).url,
                  ),
                  Lottie.network(
                    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                    repeat: false,
                    controller: lottieController,
                    onLoaded: (composition) {
                      lottieController.duration = composition.duration;
                      if (isStartLottie) {
                        lottieController.forward();
                      }
                    },
                  )
                ],
              ),
            ),
            FeedButtonWidget(widget.feed.model),
            FeedTextWidget(
              widget.feed.model, null
            ),
          ],
        ),
      );
    } else if (widget.feed.model is VideoType) {
      return Card(
        elevation: 10.0,
        color: Color(0xFF000000),
        margin: const EdgeInsets.all(18.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Column(
          children: [
            FeedProfileWidget(
                profile: widget.feed.profile ?? Profile(id: "id")),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("TEXT"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onDoubleTap: () {
                setState(() {
                  startLottie();
                  if (widget.feed.model?.isLike == false) {
                    widget.feed.model
                        ?.setLike(!(widget.feed.model?.isLike ?? false));
                  }
                });
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  FeedVideoWidget(
                    (widget.feed.model as VideoType).url,
                    widget.isInView,
                  ),
                  Lottie.network(
                    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                    repeat: false,
                    controller: lottieController,
                    onLoaded: (composition) {
                      lottieController.duration = composition.duration;
                      if (isStartLottie) {
                        lottieController.forward();
                      }
                    },
                  )
                ],
              ),
            ),
            FeedButtonWidget(widget.feed.model),
            FeedTextWidget(
              widget.feed.model, null
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
