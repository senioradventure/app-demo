import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class Buttons extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const Buttons({super.key, required this.onReject, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return 
      
    SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onReject,
                child: Container(
                  color: AppColors.lightGray,
                  alignment: Alignment.center,
                  child: Text(
                    'REJECT',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: InkWell(
                onTap: onAccept,
                child: Container(
                  color: AppColors.bottomButtonBlue,
                  alignment: Alignment.center,
                  child: Text(
                    'ACCEPT',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    
    );
  }
}
