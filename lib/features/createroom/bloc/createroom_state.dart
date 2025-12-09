part of 'createroom_bloc.dart';

@immutable
class CreateroomState {
  final File? imageFile;
  final int nameCount;
  final int descriptionCount;
  final List<String> selected;
  final List<String> filtered;
  final bool showDropdown;
  final String query;

  const CreateroomState({
    this.imageFile,
    this.nameCount = 0,
    this.descriptionCount = 0,
    this.selected = const [],
    this.filtered = const [],
    this.showDropdown = false,
    this.query = '',
  });

  CreateroomState copyWith({
    File? imageFile,
    int? nameCount,
    int? descriptionCount,
    List<String>? selected,
    List<String>? filtered,
    bool? showDropdown,
    String? query,
  }) {
    return CreateroomState(
      imageFile: imageFile ?? this.imageFile,
      nameCount: nameCount ?? this.nameCount,
      descriptionCount: descriptionCount ?? this.descriptionCount,
      selected: selected ?? this.selected,
      filtered: filtered ?? this.filtered,
      showDropdown: showDropdown ?? this.showDropdown,
      query: query ?? this.query,
    );
  }
}
