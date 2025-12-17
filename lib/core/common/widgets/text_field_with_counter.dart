import 'package:flutter/material.dart';

class TextFieldWithCounter extends StatelessWidget {
  final int count;
  final int maxLength;
  final String? hintText;
  final TextEditingController? controller;
  final String? label;
  final Function(String)? onChanged;

  const TextFieldWithCounter({
    super.key,
    required this.count,
    required this.maxLength,
    this.hintText,
    this.controller,
    this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with dynamic counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label ?? '', style: Theme.of(context).textTheme.labelMedium),
            Text(
              '$count/$maxLength',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),

        const SizedBox(height: 4),

        // TextField
        TextField(
          controller: controller,

          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            counterText: '', // Hide the default counter
          ),

          onChanged: onChanged,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
