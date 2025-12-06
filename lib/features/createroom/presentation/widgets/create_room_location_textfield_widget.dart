import 'package:flutter/material.dart';

class LocationTextField extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onDropdownPressed;

  const LocationTextField({super.key, this.controller, this.onDropdownPressed});

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose if we created the controller internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            "Location",
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),

        // TextField with dropdown arrow
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Tell us where are you from",
            hintStyle: Theme.of(context).textTheme.labelSmall,
            counterText: '',
            suffixIcon: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: widget.onDropdownPressed ?? () {},
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
