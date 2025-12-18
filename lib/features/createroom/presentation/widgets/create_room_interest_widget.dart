import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';

class InterestPicker extends StatefulWidget {
  final List<String> allInterests;
  final Function(List<String>)? onChanged;

  const InterestPicker({super.key, required this.allInterests, this.onChanged});

  @override
  State<InterestPicker> createState() => _InterestPickerState();
}

class _InterestPickerState extends State<InterestPicker> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateroomBloc, CreateroomState>(
      listenWhen: (prev, curr) => prev.query != curr.query,
      listener: (context, state) {
        // Sync bloc → text field ONLY when needed
        if (_controller.text != state.query) {
          _controller.value = TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          );
        }
      },
      child: BlocBuilder<CreateroomBloc, CreateroomState>(
        buildWhen: (prev, curr) =>
            prev.selected != curr.selected ||
            prev.filtered != curr.filtered ||
            prev.showDropdown != curr.showDropdown,
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged?.call(state.selected);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Interests", style: Theme.of(context).textTheme.labelMedium),
              Text(
                "Choose upto 3",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),

              /// Search Field
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'What are you looking for?',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  suffixIcon: const Icon(Icons.search_rounded, size: 20),
                ),
                enabled: state.selected.length < 3,
                onChanged: (val) {
                  context.read<CreateroomBloc>().add(SearchInterestEvent(val));
                },
              ),

              /// Dropdown
              if (state.showDropdown)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.iconColor,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: state.filtered
                        .map(
                          (item) => ListTile(
                            dense: true,
                            title: Text(
                              item,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onTap: () {
                              context.read<CreateroomBloc>().add(
                                AddInterestEvent(item),
                              );
                              _controller.clear(); // UX improvement
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),

              const SizedBox(height: 12),

              /// Selected Chips
              Wrap(
                spacing: 8,
                children: state.selected
                    .map(
                      (item) => InterestChip(
                        label: item,
                        onRemove: () {
                          context.read<CreateroomBloc>().add(
                            RemoveInterestEvent(item),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
