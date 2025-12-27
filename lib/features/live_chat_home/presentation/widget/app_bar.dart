import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final double topPadding;
  final double leftPadding;

  const PageHeader({
    super.key,
    required this.title,
    this.topPadding = 15,
    this.leftPadding = 27,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
