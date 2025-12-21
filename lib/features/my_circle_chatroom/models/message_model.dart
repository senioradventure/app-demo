class Message {
  final String id;
  final String sender;
  final String text;
  final String time;

  final Map<String, int>? reactions;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.sender,
    this.reactions,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id']?.toString() ?? '',
      text: map['text'] ?? '',
      time: map['time'] ?? '',
      sender: map['sender'] ?? '',
      reactions: map['reactions'] != null
          ? Map<String, int>.from(map['reactions'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'time': time,
      'sender': sender,
      if (reactions != null) 'reactions': reactions,
    };
  }
}
