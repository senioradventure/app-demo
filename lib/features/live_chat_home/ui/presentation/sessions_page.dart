import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/main_bottom_nav.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: 60,
          color: const Color(0xFFF9F9F7),  // full grey background
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 27),
                child: Text(
                  'Sessions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

     bottomNavigationBar: Theme(
  data: Theme.of(context).copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),
  ),
  child: const MainBottomNavBar(currentIndex: 2), 
),
    );
  }
}
