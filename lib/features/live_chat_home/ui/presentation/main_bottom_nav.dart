import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/live-chat_home_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/livetv_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/my_circle_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/sessions_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/trips_page.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == currentIndex) return; 

          Widget page;
          switch (index) {
            case 0:
              page = const LiveChatPage();
              break;
            case 1:
              page = const MyCirclePage();
              break;
            case 2:
              page = const SessionsPage();
              break;
            case 3:
              page = const TripsPage();
              break;
            case 4:
              page = const LivetvPage();
              break;
            default:
              page = const LiveChatPage();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: ColorFiltered(
    colorFilter: const ColorFilter.mode(
      Colors.grey,  // 👈 Force inactive icon to grey
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
  }
}
