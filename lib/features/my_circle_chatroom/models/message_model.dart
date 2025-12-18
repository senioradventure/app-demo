class Message {
  final String id;
  final String sender;
  final String text;
  final String time;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.sender,
  });

 factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id']?.toString() ?? '',
      text: map['text'] ?? '',
      time: map['time'] ?? '',
      sender: map['sender'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'time': time,
      'sender': sender,
    };
  }
}
