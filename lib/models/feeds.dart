import 'package:flutter/material.dart';

class Feeds extends ChangeNotifier {
  final List<FeedData> _feedItems = [];

  List<FeedData> get items => _feedItems;

  void add(FeedData feed) {
    _feedItems.add(feed);
    notifyListeners();
  }

  void remove(FeedData feed) {
    _feedItems.remove(feed);
    notifyListeners();
  }
 }

class FeedData<T extends FeedType> {
  final String id;
  final Profile? profile;
  final T? model;

  const FeedData({required this.id, this.profile, this.model});

  @override
  int get hashCode {
    return id.hashCode;
  }
}

class Profile {
  final String id;
  final String? name;
  final String? thumbnail;
  final String? job;
  final String? location;
  bool? isFollow;

  Profile(
      {required this.id,
      this.name,
      this.thumbnail,
      this.job,
      this.location,
      this.isFollow});

  void setFollow(bool isFollow) {
    this.isFollow = isFollow;
  }
}

class ImageType extends FeedType {
  final String url;

  ImageType({
    required this.url,
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isLike,
    required super.isBookmark,
    required super.timestamp,
  });
}

class VideoType extends FeedType {
  final String url;

  VideoType({
    required this.url,
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isLike,
    required super.isBookmark,
    required super.timestamp,
  });
}

class TextType extends FeedType {

  TextType({
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isLike,
    required super.isBookmark,
    required super.timestamp,
  });
}

class FeedType {
  final String text;
  int like;
  final int comment;
  final int share;
  bool isLike;
  bool isBookmark;
  final int timestamp;

  FeedType({
    required this.text,
    required this.like,
    required this.comment,
    required this.share,
    required this.isLike,
    required this.isBookmark,
    required this.timestamp,
  });

  void setBookmark(bool isBookmark) {
    this.isBookmark = isBookmark;
  }

  void setLike(bool isLike) {
    if (isLike) {
      increaseLike();
    } else {
      decreaseLike();
    }
    this.isLike = isLike;
  }

  void increaseLike() {
    this.like += 1;
  }

  void decreaseLike() {
    this.like -= 1;
  }
}