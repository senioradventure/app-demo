import 'package:flutter/material.dart';

class LocationFilterButton extends StatelessWidget {
  final List<Map<String, String>> locations;
  final String? selectedLocation;
  final Function(String?) onLocationSelected;

  LocationFilterButton({
    super.key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationSelected,
  });
  final GlobalKey _buttonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    String displayName = "by location";

    if (selectedLocation != null && selectedLocation!.isNotEmpty) {
      final match = locations.firstWhere(
        (loc) => loc["id"] == selectedLocation,
        orElse: () => {"name": "by location"},
      );
      displayName = match["name"]!;
    }

    return OutlinedButton(
      key: _buttonKey,
      onPressed: () async {
        final renderBox =
            _buttonKey.currentContext!.findRenderObject() as RenderBox;

        final Offset pos = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final selected = await showMenu<String>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFFE8EFF5),
          position: RelativeRect.fromLTRB(
            pos.dx,
            pos.dy + size.height + 6,
            pos.dx + size.width,
            0,
          ),
          items: [
            const PopupMenuItem(
              value: "All",
              child: Text("All", style: TextStyle(color: Colors.black)),
            ),

            ...locations.map((item) {
              final id = item["id"]!;
              final name = item["name"]!;

              return PopupMenuItem(
                value: id,
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.black87),
                ),
              );
            }),
          ],
        );

        if (selected != null) {
          onLocationSelected(selected == "All" ? null : selected);
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: const Color(0xFFE8EFF5),
        side: BorderSide.none,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_pin, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 6),

          Text(
            displayName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
