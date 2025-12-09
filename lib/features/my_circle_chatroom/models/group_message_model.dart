
class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final String text;
  final String time;
  final List<Reaction> reactions;
  final List<GroupMessage> replies;
   bool isThreadOpen;
  
 

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
   this.avatar,
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
