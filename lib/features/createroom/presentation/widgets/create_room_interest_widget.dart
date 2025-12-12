import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class InterestPicker extends StatelessWidget {
  final List<String> allInterests;
  final Function(List<String>)? onChanged;

  const InterestPicker({super.key, required this.allInterests, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateroomBloc(),
      child: BlocBuilder<CreateroomBloc, CreateroomState>(
        builder: (context, state) {
          final controller = TextEditingController(text: state.query);

          void notifyParent() {
            onChanged?.call(state.selected);
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifyParent();
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
                controller: controller,
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
                    boxShadow: [
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
                            title: Text(
                              item,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            dense: true,
                            onTap: () {
                              context.read<CreateroomBloc>().add(
                                AddInterestEvent(item),
                              );
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
