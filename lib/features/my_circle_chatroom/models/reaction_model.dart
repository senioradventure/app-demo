class Reaction {
  final String name; // e.g., 'like', 'heart', 'fire'
  final int count;

  Reaction({required this.name, required this.count});

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      name: map['name'] ?? 'like',
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'count': count,
    };
  }
}
