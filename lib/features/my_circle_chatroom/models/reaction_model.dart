class Reaction {
  final String emoji;
  final int count;

  Reaction({
    required this.emoji,
    required this.count,
  });

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      emoji: map['emoji'],
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'count': count,
    };
  }
}
