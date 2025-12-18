import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

final List<GroupMessage> groupMessages = [
  GroupMessage(
    id: '1',
    senderId: 'Alice-id',
    senderName: 'Alice',
    avatar: 'https://i.pravatar.cc/150?img=1',
    text: 'Hello everyone!',
    time: '10:00 AM',
    replies: [
    ],
    reactions: [Reaction('👍', 3), Reaction('❤️', 2)],
  ),
  GroupMessage(
    id: '2',
    senderId: 'me-id',
    senderName: 'You',
    avatar: 'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
    text: 'Hi Alice!',
    time: '10:02 AM',
    reactions: [Reaction('😊', 1)],
  ),
  GroupMessage(
    id: '3',
    senderId: 'santra-id',
    senderName: 'santra',
    avatar: 'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
    text: 'Good morning!',
    time: '10:05 AM',
  ),
];