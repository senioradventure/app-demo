import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  runApp(
    const MaterialApp(
      home: CircleCreationScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class CircleCreationScreen extends StatelessWidget {
  const CircleCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            /*Go back to the previous screen*/
            ;
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Create Circle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              /*More details*/
              ;
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}
