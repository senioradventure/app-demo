import 'package:flutter/material.dart';

class TextFieldWithCounter extends StatefulWidget {
  final int maxLength;
  final String? hintText;
  final TextEditingController? controller;
  final String? label;

  const TextFieldWithCounter({
    super.key,
    required this.maxLength,
    this.hintText,
    this.controller,
    this.label,
  });

  @override
  State<TextFieldWithCounter> createState() => _TextFieldWithCounterState();
}

class _TextFieldWithCounterState extends State<TextFieldWithCounter> {
  late TextEditingController _controller;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _controller = widget.controller ?? TextEditingController();
    _currentLength = _controller.text.length;

    // Listen to controller changes
    _controller.addListener(_updateLength);
  }

  @override
  void dispose() {
    // Only dispose if we created the controller internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      _currentLength = _controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with dynamic counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label ?? '',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '$_currentLength/${widget.maxLength}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),

        const SizedBox(height: 4),

        // TextField
        TextField(
          controller: _controller,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            counterText: '', // Hide the default counter
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
