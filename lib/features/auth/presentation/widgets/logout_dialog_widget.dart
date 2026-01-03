import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout', style: Theme.of(context).textTheme.displayLarge),
      content: Text(
        'Are you sure you want to logout?',
        style: Theme.of(context).textTheme.displayMedium,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      actionsPadding: EdgeInsets.zero, // 🔹 remove default padding
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              // NO button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'No',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
              ),

              // YES button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
