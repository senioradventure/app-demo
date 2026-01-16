import 'package:flutter/material.dart';

class DebugMenu extends StatelessWidget {
  const DebugMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Column(children: [
        ElevatedButton(onPressed: (){}, child: Text('Backup Room Chat')),
        ElevatedButton(onPressed: (){}, child: Text('Backup User Chat')),
      ],));
  }
}
