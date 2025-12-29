import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/enum/profile_visibility.dart';

class VisibilityDropdown extends StatelessWidget {
  final ProfileVisibility value;
  final ValueChanged<ProfileVisibility> onChanged;

  const VisibilityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProfileVisibility>(
          value: value,
          isDense: true,
          icon: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: AppColors.textGray),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: ProfileVisibility.values.map((visibility) {
            return DropdownMenuItem(
              value: visibility,
              child: Text(visibility.label),
            );
          }).toList(),
        ),
      ),
    );
  }
}
