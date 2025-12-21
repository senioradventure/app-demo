import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithCounter extends StatelessWidget {
  final int count;
  final int maxLength;
  final String? hintText;
  final TextEditingController? controller;
  final String? label;
  final ValueChanged<String>? onChanged;

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

        TextField(
          controller: controller,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            counterText: '',
          ),
          onChanged: onChanged,
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
