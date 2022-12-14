// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/feeds.dart';
import 'package:testing_app/screens/city.dart';
import 'package:testing_app/screens/home.dart';
import 'package:testing_app/screens/video_editor.dart';

void main() {
  runApp(const TestingApp());
}

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Feeds>(
      create: (context) => Feeds(),
      child: MaterialApp(
        title: 'Testing Sample',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: const CardTheme(
            clipBehavior: Clip.antiAlias,
          ),
        ),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          CityPage.routeName: (context) => const CityPage(),
          VideoPickerPage.routeName: (context) => const VideoPickerPage(),
        },
        initialRoute: HomePage.routeName,
      ),
    );
  }
}