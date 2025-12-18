import 'package:flutter/material.dart';


class MyCirclePagedefault extends StatelessWidget {
  const MyCirclePagedefault({super.key});

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
                  'My Circle',
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

    );
  }
}
