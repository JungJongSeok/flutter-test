import 'dart:ffi';

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
}

class Profile {
  final String id;
  final String? name;
  final String? thumbnail;
  final String? job;
  final String? location;
  final bool? isFollow;

  const Profile(
      {required this.id,
      this.name,
      this.thumbnail,
      this.job,
      this.location,
      this.isFollow});
}

class ImageType extends FeedType {
  final String url;

  const ImageType({
    required this.url,
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isBookmark,
    required super.timestamp,
  });
}

class VideoType extends TextType {
  final String url;

  const VideoType({
    required this.url,
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isBookmark,
    required super.timestamp,
  });
}

class TextType extends FeedType {

  const TextType({
    required super.text,
    required super.like,
    required super.comment,
    required super.share,
    required super.isBookmark,
    required super.timestamp,
  });
}

class FeedType {
  final String text;
  final int like;
  final int comment;
  final int share;
  final bool isBookmark;
  final int timestamp;

  const FeedType({
    required this.text,
    required this.like,
    required this.comment,
    required this.share,
    required this.isBookmark,
    required this.timestamp,
  });
}