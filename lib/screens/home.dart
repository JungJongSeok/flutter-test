import 'dart:developer' as Logger;

import 'package:flutter/material.dart';
import 'package:testing_app/screens/discover.dart';
import 'package:testing_app/screens/feed.dart';
import 'package:testing_app/screens/video_editor.dart';

enum TabPage { FEED, DISCOVER, SEARCH, PROFILE }

extension TabPageExtension on TabPage {
  static const icons = [
    Icon(Icons.home_outlined),
    Icon(Icons.ad_units_outlined),
    Icon(Icons.search_outlined),
    Icon(Icons.account_box_outlined),
  ];

  Widget get icon => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icons[this.index],
          Text(
            this.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
        ],
      );
}

class HomeArguments {
  final String city;

  HomeArguments({required this.city});
}

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController = TabController(
    length: TabPage.values.length,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
        ),
      ),
      bottomNavigationBar: TabBar(
        tabs: List.of(
          TabPage.values.map(
            (value) => Container(
              height: 56,
              alignment: Alignment.center,
              child: value.icon,
            ),
          ),
        ),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            //배경 그라데이션 적용
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.blueAccent,
              Colors.pinkAccent,
            ],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        controller: _tabController,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          FeedPage(_tabController),
          DiscoverPage(),
          FeedPage(_tabController),
          VideoPickerPage(),
        ],
      ),
    );
  }
}
