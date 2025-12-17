import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';

part 'createroom_event.dart';
part 'createroom_state.dart';

class CreateroomBloc extends Bloc<CreateroomEvent, CreateroomState> {
  final ImagePicker _picker = ImagePicker();
  final List<String> allInterests = AppLists.interests;

  CreateroomBloc() : super(const CreateroomState()) {
    on<PickImageFromGalleryEvent>((event, emit) async {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        emit(state.copyWith(imageFile: File(pickedImage.path)));
      }
    });

    on<NameTextFieldCounterEvent>((event, emit) {
      emit(state.copyWith(nameCount: event.count));
    });

    on<DisDescriptionTextFieldCounterEvent>((event, emit) {
      emit(state.copyWith(descriptionCount: event.count));
    });

    on<SearchInterestEvent>((event, emit) {
      final query = event.query.toLowerCase();

      final filtered = allInterests
          .where(
            (item) =>
                item.toLowerCase().contains(query) &&
                !state.selected.contains(item),
          )
          .toList();

      emit(
        state.copyWith(
          query: event.query,
          filtered: filtered,
          showDropdown: filtered.isNotEmpty && query.isNotEmpty,
        ),
      );
    });

    on<AddInterestEvent>((event, emit) {
      if (state.selected.length >= 3) return;

      final updated = List<String>.from(state.selected)..add(event.interest);

      emit(
        state.copyWith(
          selected: updated,
          filtered: [],
          showDropdown: false,
          query: '',
        ),
      );
    });

    on<RemoveInterestEvent>((event, emit) {
      final updated = List<String>.from(state.selected)..remove(event.interest);

      emit(state.copyWith(selected: updated));
    });
  }
}
