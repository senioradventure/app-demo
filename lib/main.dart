import 'package:flutter/material.dart';
import 'package:senior_circle/features/livechat/ui/livechat_page.dart';

void main() {
  filteredContactList.value = List.from(masterContactList);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senior Circle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // show the page wid
      //get (do NOT use MyApp() here)
      
      home: const LiveChatPage(),
    );
  }
}
