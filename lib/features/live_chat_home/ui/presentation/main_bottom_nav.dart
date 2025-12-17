import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/live-chat_home_page.dart';
import 'package:senior_circle/features/my_circle_home/presentation/page/my_circle_home_page.dart';

ValueNotifier<int> currentPageIndex = ValueNotifier<int>(0);

class MainBottomNavBar extends StatelessWidget {
  MainBottomNavBar({super.key});


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageIndex,
      builder: (context, value, child) {
        return SizedBox(
          height: 75,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPageIndex.value,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (index) {
              currentPageIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey, // 👈 Force inactive icon to grey
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/icons/message-circle.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                activeIcon: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(80, 24, 145, 244),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    'assets/icons/message-circle.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label: 'Live Chat',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/users.png',
                  width: 24,
                  height: 24,
                  filterQuality: FilterQuality.high,
                ),
                activeIcon: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(80, 24, 145, 244),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    'assets/icons/users.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label: 'My Circle',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/calendar.png',
                  width: 24,
                  height: 24,
                  filterQuality: FilterQuality.high,
                ),
                activeIcon: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(80, 24, 145, 244),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    // make sure this file name matches the normal one
                    'assets/icons/calendar.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/compass.png',
                  width: 24,
                  height: 24,
                  filterQuality: FilterQuality.high,
                ),
                activeIcon: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(80, 24, 145, 244),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    'assets/icons/compass.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label: 'Trips',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/tv.png',
                  width: 24,
                  height: 24,
                  filterQuality: FilterQuality.high,
                ),
                activeIcon: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(80, 24, 145, 244),
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Image.asset(
                    'assets/icons/tv.png',
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                label: 'Live TV',
              ),
            ],
          ),
        );
      },
    );
  }
}
