import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class AddChatWidget extends StatelessWidget {
  final Widget destinationPage;

  const AddChatWidget({super.key, required this.destinationPage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
          right: 16.0,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => destinationPage, 
              ),
            );

            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Created circle: ${result['name']}')),
              );
            }
          },

          shape: const CircleBorder(),
          backgroundColor: AppColors.buttonBlue,
          elevation: 0,
          child: const Icon(Icons.add, color: AppColors.white, size: 40),
        ),
      ),
    );
  }
}
