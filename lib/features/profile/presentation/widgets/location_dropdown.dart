import 'package:flutter/material.dart';

class LocationDropdown extends StatelessWidget {
  final String? value;
  final List<String> locations;
  final ValueChanged<String?> onChanged;
  final String label;
  final String hintText;

  const LocationDropdown({
    super.key,
    required this.value,
    required this.locations,
    required this.onChanged,
    this.label = 'Location',
    this.hintText = 'Tell us where you are from',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue:locations.contains(value) ? value : null, 
          hint: Text(hintText,style: Theme.of(context).textTheme.labelSmall),
          items: locations
              .map(
                (location) => DropdownMenuItem<String>(
                  value: location,
                  child: Text(location,style: Theme.of(context).textTheme.labelMedium),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a location';
            }
            return null;
          },
        ),
      ],
    );
  }
}
