import 'package:flutter/material.dart';
import 'package:senior_circle/debug/debug_menu.dart';
import 'package:senior_circle/features/live_chat_home/presentation/live_chat_home_page.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/main_bottom_nav.dart';

import 'package:senior_circle/features/my_circle_home/presentation/page/my_circle_home_page.dart';
import 'package:senior_circle/features/tab/dummy_page.dart';

class TabSelectorWidget extends StatelessWidget {
  TabSelectorWidget({super.key});

  final screens = [
    LiveChatPage(),
    MyCircleHomePage(),
    DummyPage(),
    DummyPage(),
    DebugMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: currentPageIndex,
        builder: (context, value, child) {
          return screens[value];
        },
      ),
      bottomNavigationBar: MainBottomNavBar(),
    );
  }
}
