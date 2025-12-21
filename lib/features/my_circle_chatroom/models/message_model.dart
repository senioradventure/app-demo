class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String? text;
  final String? imagePath;
  final String time;

  final Map<String, List<String>> reactions;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.text,
    this.imagePath,
    required this.time,
    this.reactions = const {},
  });

  bool get isImage => imagePath != null;
  bool get isText => text != null && text!.isNotEmpty;

  Message copyWith({Map<String, List<String>>? reactions}) {
    return Message(
      id: id,
      senderId: senderId,
      senderName: senderName,
      text: text,
      imagePath: imagePath,
      time: time,
      reactions: reactions ?? this.reactions,
    );
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['sender_id'],
      senderName: map['sender_name'],
      text: map['text'],
      imagePath: map['imagePath'],
      time: map['time'],
      reactions: map['reactions'] != null
          ? Map<String, List<String>>.from(
              (map['reactions'] as Map).map(
                (k, v) => MapEntry(k, List<String>.from(v)),
              ),
            )
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'text': text,
      'time': time,
      'reactions': reactions,
    };
  }
}
