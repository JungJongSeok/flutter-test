import 'dart:async';
import 'dart:developer' as Logger;

import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:testing_app/models/feeds.dart';
import 'package:testing_app/screens/city.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';

import '../swipe_cards/draggable_card.dart';
import '../swipe_cards/swipe_cards.dart';
import 'home.dart';

class FeedPage extends StatefulWidget {
  final TabController tabController;

  FeedPage(this.tabController, {super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  late MatchEngine matchEngine;

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)?.settings.arguments as HomeArguments?;

    final List<FeedData> feedList = [
      FeedData<ImageType>(
          id: "1",
          profile: Profile(id: "1"),
          model: ImageType(
            url:
                "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
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
            url:
                "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
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

    matchEngine = MatchEngine(
      swipeItems: List.of(
        feedList.map(
          (value) => SwipeItem(
            content: value,
            rightAction: () {
              Logger.log("rightAction");
            },
            leftAction: () {
              matchEngine.rewindMatch();
            },
            topAction: () {
              Logger.log("topAction");
            },
            bottomAction: () {
              Logger.log("bottomAction");
            },
            onSlideUpdate: (SlideRegion? region) async {
// Logger.log("Region $region");
            },
          ),
        ),
      ),
    );

    int currentIndex = -1;

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          InViewNotifierList(
            itemCount: feedList.length,
            controller: ScrollController(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            initialInViewIds: const ["0", "1", "2", "3", "4"],
            // 초기화 강제 뷰갱신
            isInViewPortCondition: (deltaTop, deltaBottom, viewPortDimension) {
              return deltaTop < (0.5 * viewPortDimension) &&
                  deltaBottom > (0.5 * viewPortDimension);
            },
            builder: (context, index) => InViewNotifierWidget(
              id: "$index",
              builder: (context, isInView, child) {
                return ItemTile(
                    feedList[index], isInView, widget.tabController);
              },
            ),
          ),
          SwipeCards(
            matchEngine: matchEngine,
            itemBuilder: (BuildContext context, int index) {
              return ItemTile(
                  feedList[index], currentIndex == index, widget.tabController);
            },
            onStackFinished: () {
              Logger.log("finish");
            },
            itemChanged: (SwipeItem item, int index) {
              Logger.log("item: ${item}, index: $index");
              currentIndex = index;
            },
            upSwipeAllowed: true,
            fillSpace: true,
          ),
          Card(
            color: Color(0xFFFFFFFF),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            child: InkWell(
              onTap: (() {
                Navigator.pushNamed(context, CityPage.routeName);
              }),
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  argument?.city ?? "Millan",
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends StatefulWidget {
  final FeedData feed;
  final bool isInView;
  final TabController tabController;

  const ItemTile(this.feed, this.isInView, this.tabController, {super.key});

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemTile>
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
              widget.feed.model,
              widget.tabController,
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
              widget.feed.model,
              widget.tabController,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class FeedImageWidget extends StatefulWidget {
  final String url;

  const FeedImageWidget(this.url, {super.key});

  @override
  FeedImageWidgetState createState() => FeedImageWidgetState();
}

class FeedImageWidgetState extends State<FeedImageWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Image.network(
      height: size.width,
      width: size.width,
      widget.url,
      fit: BoxFit.cover,
    );
  }
}

class FeedVideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const FeedVideoWidget(this.url, this.play, {super.key});

  @override
  FeedVideoWidgetState createState() => FeedVideoWidgetState();
}

class FeedVideoWidgetState extends State<FeedVideoWidget> {
  late final VideoPlayerController _controller = VideoPlayerController.network(
    widget.url,
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  );

  final Completer<void> _connectedCompleter = Completer<void>();
  bool isSupported = true;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    Future<void> initController(VideoPlayerController controller) async {
      await controller.initialize().then((value) {
        controller.setLooping(true);
        controller.play();
        _connectedCompleter.future;
      });
      if (mounted) {
        setState(() {});
      }
    }

    initController(_controller);
  }

  @override
  void dispose() {
    isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.play ? _controller.play() : _controller.pause();

    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.width,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: Container(
          width: size.width,
          height: size.width / _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

class FeedProfileWidget extends StatefulWidget {
  final Profile? profile;

  const FeedProfileWidget({this.profile});

  @override
  FeedProfileWidgetState createState() => FeedProfileWidgetState();
}

class FeedProfileWidgetState extends State<FeedProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: [
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                child: Image.network(
                  width: 32,
                  height: 32,
                  widget.profile?.thumbnail ??
                      "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profile?.name ?? "이름",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  Text(
                    widget.profile?.job ?? "직업직업직업",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(
          color: Color(0xFF000000),
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xFFFFFFFF),
              ),
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          child: InkWell(
            onTap: () {
              setState(() {
                widget.profile?.setFollow(!(widget.profile?.isFollow ?? false));
              });
            },
            child: Container(
              margin: EdgeInsets.all(16),
              child: Text(
                widget.profile?.isFollow == true ? "FOLLOWING" : "FOLLOW",
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FeedButtonWidget extends StatefulWidget {
  final FeedType? feedType;

  const FeedButtonWidget(this.feedType, {super.key});

  @override
  FeedButtonWidgetState createState() => FeedButtonWidgetState();
}

class FeedButtonWidgetState extends State<FeedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.all(16),
                child: Row(children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.feedType
                              ?.setLike(!(widget.feedType?.isLike ?? false));
                        });
                      },
                      child: widget.feedType?.isLike == false
                          ? const Icon(
                              Icons.favorite_border_outlined,
                              color: Color(0xFFFFFFFF),
                            )
                          : const Icon(
                              Icons.favorite_outlined,
                              color: Color(0xFFFFFFFF),
                            )),
                  Text(
                    widget.feedType?.like.toString() ?? "",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const Icon(
                    Icons.mode_comment_outlined,
                    color: Color(0xFFFFFFFF),
                  ),
                  Text(
                    widget.feedType?.comment.toString() ?? "",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const Icon(
                    Icons.share_outlined,
                    color: Color(0xFFFFFFFF),
                  ),
                  Text(
                    widget.feedType?.share.toString() ?? "",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ])),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.feedType
                      ?.setBookmark(!(widget.feedType?.isBookmark ?? false));
                });
              },
              child: Container(
                margin: EdgeInsets.all(16),
                child: widget.feedType?.isBookmark == true
                    ? const Icon(
                        Icons.bookmark,
                        color: Color(0xFFFFFFFF),
                      )
                    : const Icon(
                        Icons.bookmark_border_outlined,
                        color: Color(0xFFFFFFFF),
                      ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class FeedTextWidget extends StatefulWidget {
  final FeedType? feedType;
  final TabController? tabController;

  const FeedTextWidget(this.feedType, this.tabController, {super.key});

  @override
  FeedTextWidgetState createState() => FeedTextWidgetState();
}

class FeedTextWidgetState extends State<FeedTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 01234567890123456789 ",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.0,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.tabController?.index = 1;
            });
          },
          child: Container(
            margin: EdgeInsets.all(16),
            child: Text(
              "VIEW ALL",
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xFFAFAFAF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
