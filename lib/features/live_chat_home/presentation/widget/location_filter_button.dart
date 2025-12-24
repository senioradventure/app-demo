import 'package:flutter/material.dart';

class LocationFilterButton extends StatelessWidget {
  final List<Map<String, String>> locations;
  final String? selectedLocation;
  final Function(String?) onLocationSelected;

  const LocationFilterButton({
    super.key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

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

    return Builder(
      builder: (ctx) {
        return OutlinedButton(
          onPressed: () async {
            final RenderBox btn = ctx.findRenderObject() as RenderBox;
            final Offset pos = btn.localToGlobal(Offset.zero);
            final Size size = btn.size;

            final selected = await showMenu<String>(
              context: ctx,
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
                  value: "None",
                  child: Text("None", style: TextStyle(color: Colors.black)),
                ),

                ...locations.map((item) {
                  final id = item["id"].toString();
                  final name = item["name"].toString();

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
              if (selected == "None") {
                onLocationSelected(null);
              } else {
                onLocationSelected(selected);
              }
            }
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: const Color(0xFFE8EFF5),
            side: BorderSide.none,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_pin,
                size: 18,
                color: Colors.blueAccent,
              ),
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
      },
    );
  }
}
