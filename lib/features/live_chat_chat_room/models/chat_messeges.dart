import 'package:flutter/material.dart';
final List<ChatMessage> defaultChatMessages = [
  ChatMessage(
    isSender: false,
    profileAsset: 'assets/images/Ellipse 1.png',
    name: 'Large name of the sender',
    text: "Good Morning everyone! Isn’t it a lovely day for a chat",
    time: '9:01 AM',
  ),
  ChatMessage(
    isSender: true,
    text: "Welcome to the chat",
    time: "9:03 AM",
  ),
  ChatMessage(
    isSender: true,
    text: "Great to meet you all.",
    time: "9:03 AM",
  ),
  ChatMessage(
    isSender: false,
    profileAsset: 'assets/images/Ellipse 3.png',
    name: 'Large name of the sender',
    text: "How is this",
    time: '9:03 AM',
    imageAsset: 'assets/images/Frame 32.png',
    isFriend: true,
  ),
];

final ValueNotifier<List<ChatMessage>> chatMessages =
    ValueNotifier<List<ChatMessage>>([
      

  
  ChatMessage(
    isSender: false,
    profileAsset: 'assets/images/Ellipse 1.png',
    name: 'Large name of the sender',
    text: "Good Morning everyone! Isn’t it  a lovely day for a chat",
    time: '9:01 AM',
  ),
 

  
  ChatMessage(
    isSender: true,
    text: "Welcome to the chat",
    time: "9:03 AM",
  ),
  ChatMessage(
    isSender: true,
    text: "Great to meet you all.",
    time: "9:03 AM",
  ),

  
  ChatMessage(
    isSender: false,
    profileAsset: 'assets/images/Ellipse 1.png',
    name: 'Large name of the sender', 
    text: "Good Morning everyone! Isn’t it a lovely day for a chat", 
    time: '9:02 AM',
  ),
  ChatMessage(
    isSender: false,
    profileAsset: 'assets/images/Ellipse 3.png',
    name: 'Large name of the sender',
    text: "How is this",
    time: '9:03 AM',
    imageAsset: 'assets/images/Frame 32.png',
    isFriend: true,
  ),

 
  ChatMessage(
    isSender: true,
    text: "Hi how are you",
    time: "9:04 AM",
  ),
]);

class ChatMessage {
  final bool isSender;
  final String? profileAsset;
  final String? name;
  final String text;
  final String time;
  final String? imageAsset;
  final String? imageFile;
  final bool isFriend;

  ChatMessage({
    required this.isSender,
    this.profileAsset,
    this.name,
    required this.text,
    required this.time,
    this.imageAsset,
    this.imageFile,
    this.isFriend = false,
  });


 ChatMessage copyWith({
  bool? isSender,
  String? profileAsset,
  String? name,
  String? text,
  String? time,
  String? imageAsset,
  String? imageFile, 
  bool? isFriend,
}) {
  return ChatMessage(
    isSender: isSender ?? this.isSender,
    profileAsset: profileAsset ?? this.profileAsset,
    name: name ?? this.name,
    text: text ?? this.text,
    time: time ?? this.time,
    imageAsset: imageAsset ?? this.imageAsset,
    imageFile: imageFile ?? this.imageFile, 
    isFriend: isFriend ?? this.isFriend,
  );
}
}

