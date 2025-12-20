class ReactionList {
  static const Map<String, String> _nameToEmoji = {
    'heart': '❤️',
    'haha': '😂',
    'wow': '😮',
    'sad': '😢',
    'fire': '🔥',
  };

  static bool isSvg(String name) => name == 'like';

  static String getEmoji(String name) {
    return _nameToEmoji[name.toLowerCase()] ?? '';
  }
}
