import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';

final List<Message> individualMessages = [
  Message(
    id: '1',
    sender: 'Alice',
    text: 'Good morning. How are you?',
    time: '10:00 AM',
    reactions: {
  "❤️": 1
}

  ),
  Message(
    id: '2',
    sender: 'You',
    text: 'Hi Alice! Welcome to the chat',
    time: '10:02 AM',
  ),
   Message(
    id: '3',
    sender: 'You',
    text: 'Have a great day!',
    time: '10:05 AM',
  ),
];

final List<Map<String, dynamic>> rawMessageData = [
  {
    'id': '1',
    'text': 'Good Morning everyone!',
    'time': '9:01 AM',
    'sender': 'Ramsy',
  },
  {
    'id': '2',
    'text': 'Good Morning! How are you?',
    'time': '9:05 AM',
    'sender': 'You',
  },
  {
    'id': '3',
    'text': 'I am doing great, thanks for asking!',
    'time': '9:10 AM',
    'sender': 'Ramsy',
  },
];