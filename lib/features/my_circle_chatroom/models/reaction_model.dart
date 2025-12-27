class Reaction {
  final String emoji;
  final List<String> userIds;

  Reaction({
    required this.emoji,
    required this.userIds,
  });

  int get count => userIds.length;

  Reaction copyWith({
    String? emoji,
    List<String>? userIds,
  }) {
    return Reaction(
      emoji: emoji ?? this.emoji,
      userIds: userIds ?? this.userIds,
    );
  }

  factory Reaction.fromMap(String emoji, List<dynamic> users) {
    return Reaction(
      emoji: emoji,
      userIds: List<String>.from(users),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'userIds': userIds,
    };
  }
}
