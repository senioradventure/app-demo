import 'package:flutter/material.dart';

class MessageActionDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionItem(
                    context,
                    icon: 'assets/icons/star.png',
                    label: 'STAR',
                    fontWeight: FontWeight.w600,
                  ),
                  _divider(),
                  _actionItem(
                    context,
                    icon: 'assets/icons/flag.png',
                    label: 'REPORT',
                    fontWeight: FontWeight.w600,
                  ),
                  _divider(),
                  _textOnlyItem(context, 'SHARE'),
                  _divider(),
                  _textOnlyItem(context, 'DELETE FOR ME'),
                  _divider(),
                  _textOnlyItem(
                    context,
                    'DELETE FOR EVERYONE',
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.6,
      color: Color(0xFFE3E3E3),
    );
  }

  static Widget _actionItem(
    BuildContext context, {
    required String icon,
    required String label,
    required FontWeight fontWeight,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _textOnlyItem(
    BuildContext context,
    String label, {
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
