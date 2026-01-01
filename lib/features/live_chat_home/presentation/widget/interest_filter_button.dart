import 'package:flutter/material.dart';

class InterestFilterButton extends StatelessWidget {
  final List<String> interests;
  final String? selectedInterest;
  final Function(String?) onInterestSelected;

  InterestFilterButton({
    super.key,
    required this.interests,
    required this.selectedInterest,
    required this.onInterestSelected,
  });
  final GlobalKey _buttonKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: _buttonKey,
      onPressed: () async {
        final RenderBox btn =
            _buttonKey.currentContext!.findRenderObject() as RenderBox;

        final Offset pos = btn.localToGlobal(Offset.zero);
        final Size size = btn.size;

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

            ...interests.map(
              (i) => PopupMenuItem(
                value: i,
                child: Text(i, style: const TextStyle(color: Colors.black87)),
              ),
            ),
          ],
        );

        if (selected != null) {
          onInterestSelected(selected == "All" ? null : selected);
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
          const Icon(Icons.filter_alt, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 6),

          Text(
            selectedInterest == null || selectedInterest!.isEmpty
                ? "by interest"
                : selectedInterest!,
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
