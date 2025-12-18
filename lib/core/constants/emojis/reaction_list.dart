class ReactionList {
  static const Map<String, String> _nameToEmoji = {
    'like': 'assets/icons/liked_icon.svg',
    'heart': '❤️',
    'haha': '😂',
    'wow': '😮',
    'sad': '😢',
    'fire': '🔥',
  };

  static String getEmoji(String name) => _nameToEmoji[name.toLowerCase()] ?? 'assets/icons/liked_icon.svg';
}