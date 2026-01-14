library;

List<T> filterByName<T>({
  required List<T> items,
  required String query,
  required String Function(T) nameExtractor,
}) {
  if (query.isEmpty) {
    return items;
  }

  final lowerQuery = query.toLowerCase();
  return items
      .where((item) => nameExtractor(item).toLowerCase().contains(lowerQuery))
      .toList();
}
