import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';

class ProfileLocationDropdown extends StatelessWidget {
  final Function(LocationModel?)? onChanged;

  const ProfileLocationDropdown({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileLoaded) {
          return const SizedBox.shrink();
        }

        final locations = state.allLocations;
        final selected = state.selectedLocation;
        print('Locations count: ${locations.length}');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 6),

            DropdownButtonFormField<LocationModel>(
              value: selected,
              hint: Text(
                'Choose your location',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              items: locations
                  .map(
                    (location) => DropdownMenuItem<LocationModel>(
                      value: location,
                      child: Text(
                        location.name,
                        style:
                            Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (location) {
                context.read<ProfileBloc>().add(
                      ProfileLocationSelected(location),
                    );
                onChanged?.call(location);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a location';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
