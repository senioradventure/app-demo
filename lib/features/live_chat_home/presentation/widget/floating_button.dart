import 'package:flutter/material.dart';

class AppFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final String symbol;
  final double symbolSize;

  const AppFAB({
    super.key,
    required this.onPressed,
    this.size = 50,
    this.backgroundColor = Colors.blueAccent,
    this.symbol = "+",
    this.symbolSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        onPressed: onPressed,
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: symbolSize,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}
