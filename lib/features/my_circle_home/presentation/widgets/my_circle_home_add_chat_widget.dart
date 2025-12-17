import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/ui/circle_creation_screen.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class AddChatWidget extends StatelessWidget {
  final Widget destinationPage; 

  const AddChatWidget({
    super.key,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *0.1, right: 24.0),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => destinationPage, // 👈 dynamic page
              ),
            );

            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Created circle: ${result['name']}'),
                ),
              );
            }
          },

          shape: const CircleBorder(),
          backgroundColor: AppColors.buttonBlue,
          elevation: 0,
          child: const Icon(Icons.add, color: AppColors.white, size: 40,),
        ),
      ),
    );
  }
}