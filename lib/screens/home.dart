import 'dart:async';
import 'dart:developer' as Logger;

import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/feeds.dart';
import 'package:testing_app/screens/favorites.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FeedData> feedList = [
      FeedData<ImageType>(
          id: "1",
          profile: Profile(id: "1"),
          model: ImageType(
            url: "http://clipart-library.com/images/BTaropdpc.gif",
            text: "text",
            like: 0,
            comment: 0,
            share: 0,
            isBookmark: false,
            timestamp: 0,
          )),
      FeedData<VideoType>(
          id: "2",
          profile: Profile(id: "2"),
          model: VideoType(
            url:
                "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
            text: "text",
            like: 0,
            comment: 0,
            share: 0,
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
            isBookmark: false,
            timestamp: 0,
          )),
      FeedData<VideoType>(
          id: "5",
          profile: Profile(id: "5"),
          model: VideoType(
            url:
                "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
            text: "text",
            like: 0,
            comment: 0,
            share: 0,
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
            isBookmark: false,
            timestamp: 0,
          )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Sample'),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, FavoritesPage.routeName);
            },
            icon: const Icon(Icons.favorite_border),
            label: const Text('Favorites'),
          ),
        ],
      ),
      body: InViewNotifierList(
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
            return ItemTile(feedList[index], isInView);
          },
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final FeedData feed;
  final bool isInView;

  const ItemTile(this.feed, this.isInView, {super.key});

  @override
  Widget build(BuildContext context) {
    final feedList = context.watch<Feeds>();

    if (feed.model is TextType) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Colors.primaries[feed.id.hashCode % Colors.primaries.length],
          ),
          title: Text(
            (feed.model as TextType).text,
            key: Key('text_$feed'),
          ),
          trailing: IconButton(
            key: Key('icon_$feed'),
            icon: feedList.items.contains(feed)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            onPressed: () {
              !feedList.items.contains(feed)
                  ? feedList.add(feed)
                  : feedList.remove(feed);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(feedList.items.contains(feed)
                      ? 'Added to favorites.'
                      : 'Removed from favorites.'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      );
    } else if (feed.model is ImageType) {
      return Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(18.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Column(
          children: [
            ProfileWidget(profile: feed.profile ?? Profile(id: "id")),
            GestureDetector(
              onTap: () {
                !feedList.items.contains(feed)
                    ? feedList.add(feed)
                    : feedList.remove(feed);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(feedList.items.contains(feed)
                        ? 'Added to favorites.'
                        : 'Removed from favorites.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: ImageWidget(
                url: (feed.model as ImageType).url,
              ),
            ),
            FeedContentWidget(feedType: feed.model)
          ],
        ),
      );
    } else if (feed.model is VideoType) {
      return Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(18.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Column(
          children: [
            ProfileWidget(profile: feed.profile ?? Profile(id: "id")),
            GestureDetector(
              onTap: () {
                !feedList.items.contains(feed)
                    ? feedList.add(feed)
                    : feedList.remove(feed);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(feedList.items.contains(feed)
                        ? 'Added to favorites.'
                        : 'Removed from favorites.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: VideoWidget(
                url: (feed.model as VideoType).url,
                play: isInView,
              ),
            ),
            FeedContentWidget(feedType: feed.model)
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class ImageWidget extends StatefulWidget {
  final String url;

  const ImageWidget({super.key, required this.url});

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
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

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const VideoWidget({super.key, required this.url, required this.play});

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
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
        fit: BoxFit.cover,
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

class ProfileWidget extends StatefulWidget {
  final Profile? profile;

  const ProfileWidget({this.profile});

  @override
  ProfileWidgetState createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: [
              Image.network(
                width: 32,
                height: 32,
                widget.profile?.thumbnail ??
                    "https://github.com/flutter/plugins/blob/main/packages/video_player/video_player/doc/demo_ipod.gif?raw=true",
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.profile?.name ?? "이름"),
                  Text(widget.profile?.job ?? "직업직업직업"),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.profile?.setFollow(!(widget.profile?.isFollow ?? false));
            });
          },
          child: Container(
            margin: EdgeInsets.all(16),
            child:
                Text(widget.profile?.isFollow == true ? "FOLLOWING" : "FOLLOW"),
          ),
        ),
      ],
    );
  }
}

class FeedContentWidget extends StatefulWidget {
  final FeedType? feedType;

  const FeedContentWidget({super.key, this.feedType});

  @override
  FeedContentWidgetState createState() => FeedContentWidgetState();
}

class FeedContentWidgetState extends State<FeedContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.favorite_border_outlined),
              Text(widget.feedType?.like.toString() ?? ""),
              const Icon(Icons.mode_comment_outlined),
              Text(widget.feedType?.comment.toString() ?? ""),
              const Icon(Icons.share_outlined),
              Text(widget.feedType?.share.toString() ?? ""),
            ]),
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
                    ? const Icon(Icons.bookmark)
                    : const Icon(Icons.bookmark_border_outlined),
              ),
            ),
          ],
        )
      ],
    );
  }
}
