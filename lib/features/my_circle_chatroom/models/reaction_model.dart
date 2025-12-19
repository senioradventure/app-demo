class Reaction {
  final String name; 
  final int count;
  
  Reaction({required this.name, required this.count});

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      name: map['name'] ?? '',
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
