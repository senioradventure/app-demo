import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class DetailsTagWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final List<String> interests;
  final String description;

  const DetailsTagWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.interests,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(height: 10),

          Text(
            name,
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),

          if (interests.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 10),
                Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: interests
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chipBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),

          if (description.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ),
        ],
      ),
    );
  }
}
