import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/features/auth/bloc/auth_bloc.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';

class LocationPickerCreateUser extends StatefulWidget {
  final Function(LocationModel?)? onChanged;

  const LocationPickerCreateUser({super.key, this.onChanged, String? initialLocationId});

  @override
  State<LocationPickerCreateUser> createState() =>
      _LocationPickerCreateUserState();
}

class _LocationPickerCreateUserState extends State<LocationPickerCreateUser> {
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        /// 🔴 VERY IMPORTANT: guard
        if (state is! CreateUserState) {
          return const SizedBox();
        }

        // Now it's safe to read location fields
        final locationQuery = state.locationQuery;
        final filteredLocation = state.filteredLocation;
        final selectedLocation = state.selectedLocation;
        final showDropdown = state.showLocationDropdown;

        // Sync controller text
        if (_controller.text != locationQuery) {
          _controller.text = locationQuery;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onChanged?.call(selectedLocation);
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
              enabled: selectedLocation == null,
              decoration: InputDecoration(
                hintText: 'Search location',
                suffixIcon: const Icon(Icons.location_on_outlined, size: 20),
              ),
              onChanged: (val) {
                context.read<AuthBloc>().add(AuthLocationQueryChanged(val));
              },
            ),

            /// 🔹 DROPDOWN
            if (showDropdown && filteredLocation.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
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
                  itemCount: filteredLocation.length,
                  itemBuilder: (_, index) {
                    final location = filteredLocation[index];

                    return ListTile(
                      dense: true,
                      title: Text(location.name),
                      onTap: () {
                        context.read<AuthBloc>().add(
                          AuthLocationSelected(location),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            /// 🔹 SELECTED LOCATION CHIP
            if (selectedLocation != null)
              Wrap(
                children: [
                  InterestChip(
                    label: selectedLocation.name,
                    onRemove: () {
                      context.read<AuthBloc>().add(AuthLocationRemoved());
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
