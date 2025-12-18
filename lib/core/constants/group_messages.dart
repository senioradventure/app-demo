
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';


final List<GroupMessage> groupMessages = [
  GroupMessage(
    id: '1',
    senderId: 'Alice-id',
    senderName: 'Alice',
    avatar: 'https://i.pravatar.cc/150?img=1',
    text: 'Hello everyone!',
    time: '10:00 AM',
    replies: [],

    reactions: [
      Reaction(name: 'like', count: 3), 
      Reaction(name: 'heart', count: 2)
    ],
  ),
  GroupMessage(
    id: '2',
    senderId: 'me-id',
    senderName: 'You',
    avatar: '...',
    text: 'Hi Alice!',
    time: '10:02 AM',
    
    reactions: [
      Reaction(name: 'haha', count: 1)
    ],
  ),
  GroupMessage(
    id: '3',
    senderId: 'santra-id',
    senderName: 'santra',
    avatar: '...',
    text: 'Good morning!',
    time: '10:05 AM',
    reactions: [], 
  ),
];