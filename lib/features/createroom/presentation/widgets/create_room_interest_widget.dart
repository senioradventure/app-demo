import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';

class InterestPicker extends StatelessWidget {
  final List<String> allInterests;
  final Function(List<String>)? onChanged;

  const InterestPicker({super.key, required this.allInterests, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateroomBloc, CreateroomState>(
      buildWhen: (prev, curr) =>
          prev.query != curr.query ||
          prev.selected != curr.selected ||
          prev.filtered != curr.filtered ||
          prev.showDropdown != curr.showDropdown,
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onChanged?.call(state.selected);
        });

        final controller = TextEditingController.fromValue(
          TextEditingValue(
            text: state.query,
            selection: TextSelection.collapsed(offset: state.query.length),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Interests", style: Theme.of(context).textTheme.labelMedium),
            Text(
              "Choose up to 3",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),

            /// Search Field
            TextField(
              controller: controller,
              enabled: state.selected.length < 3,
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                hintStyle: Theme.of(context).textTheme.labelSmall,
                suffixIcon: const Icon(Icons.search_rounded, size: 20),
              ),
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
    );
  }
}
