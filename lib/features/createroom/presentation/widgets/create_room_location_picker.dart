import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';

class LocationPicker extends StatefulWidget {
  final Function(List<String>)? onChanged;

  const LocationPicker({super.key, this.onChanged});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
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
    return BlocBuilder<CreateroomBloc, CreateroomState>(
      buildWhen: (prev, curr) =>
          prev.locationQuery != curr.locationQuery ||
          prev.selectedLocation != curr.selectedLocation ||
          prev.filteredLocation != curr.filteredLocation ||
          prev.showLocationDropdown != curr.showLocationDropdown,
      builder: (context, state) {
        // Sync controller text ONLY when Bloc changes it
        if (_controller.text != state.locationQuery) {
          _controller.text = state.locationQuery;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onChanged?.call(state.selectedLocation);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location", style: Theme.of(context).textTheme.labelMedium),
            Text(
              "Choose your location",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),

            /// 🔹 SEARCH FIELD
            TextField(
              controller: _controller,
              enabled: state.selectedLocation.isEmpty,
              decoration: InputDecoration(
                hintText: 'Search location',
                hintStyle: Theme.of(context).textTheme.labelSmall,
                suffixIcon: const Icon(Icons.location_on_outlined, size: 20),
              ),
              onChanged: (val) {
                context.read<CreateroomBloc>().add(SearchLocationtEvent(val));
              },
            ),

            /// 🔹 DROPDOWN
            if (state.showLocationDropdown && state.filteredLocation.isNotEmpty)
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredLocation.length,
                  itemBuilder: (_, index) {
                    final item = state.filteredLocation[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        item,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      onTap: () {
                        context.read<CreateroomBloc>().add(
                          AddLocationEvent(item),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            /// 🔹 SELECTED LOCATION CHIP
            Wrap(
              spacing: 8,
              children: state.selectedLocation
                  .map(
                    (item) => InterestChip(
                      label: item,
                      onRemove: () {
                        context.read<CreateroomBloc>().add(
                          RemoveLocationEvent(item),
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
