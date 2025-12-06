import 'package:flutter/material.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_chip_widget.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class InterestPicker extends StatefulWidget {
  final List<String> allInterests;
  final Function(List<String>)? onChanged;

  const InterestPicker({super.key, required this.allInterests, this.onChanged});

  @override
  State<InterestPicker> createState() => _InterestPickerState();
}

class _InterestPickerState extends State<InterestPicker> {
  final TextEditingController _controller = TextEditingController();

  List<String> selected = [];
  List<String> filtered = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final query = _controller.text.toLowerCase();

      setState(() {
        filtered = widget.allInterests
            .where(
              (item) =>
                  item.toLowerCase().contains(query) &&
                  !selected.contains(item),
            )
            .toList();

        showDropdown = filtered.isNotEmpty && query.isNotEmpty;
      });
    });
  }

  void addInterest(String interest) {
    if (selected.length >= 3) return;

    setState(() {
      selected.add(interest);
      _controller.clear();
      showDropdown = false;
    });

    widget.onChanged?.call(selected);
  }

  void removeInterest(String interest) {
    setState(() {
      selected.remove(interest);
    });

    widget.onChanged?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Interests", style: Theme.of(context).textTheme.labelMedium),
        Text("Choose upto 3", style: Theme.of(context).textTheme.labelSmall),
        SizedBox(height: 4),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'What are you looking for?',
            hintStyle: Theme.of(context).textTheme.labelSmall,
            suffixIcon: const Icon(Icons.search_rounded, size: 20),
          ),
          enabled: selected.length < 3,
        ),
        // Dropdown Suggestions
        if (showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.iconColor,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              children: filtered
                  .map(
                    (item) => ListTile(
                      title: Text(
                        item,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      dense: true,
                      onTap: () => addInterest(item),
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: selected
              .map(
                (item) => InterestChip(
                  label: item,
                  onRemove: () => removeInterest(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
