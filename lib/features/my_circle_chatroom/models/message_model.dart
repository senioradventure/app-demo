
class Message {
  final String id;
  final String sender;
  final String avatar;
  final String text;
  final String time;
  final List<Reaction> reactions;
  final List<Message> replies;
   bool isThreadOpen;
  
 

  Message({
    required this.id,
    required this.sender,
    required this.avatar,
    required this.text,
    required this.time,
    this.reactions = const [],
    this.replies = const [],
    this.isThreadOpen = false,
  });
}

class Reaction {
  final String reaction;
  final int count;
  Reaction(this.reaction, this.count);
}
