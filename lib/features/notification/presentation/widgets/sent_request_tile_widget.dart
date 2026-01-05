import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/individual_profile_icon.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/notification/models/sent_request_model.dart';

class SentRequestTile extends StatelessWidget {
  final String name;
  final RequestStatus status;
  final String time;
  final String? imageUrl;

  const SentRequestTile({
    super.key,
    required this.name,
    required this.status,
    required this.time,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAccepted = status == RequestStatus.accepted;
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Material(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            individualProfileIcon(hasImage, imageUrl),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isAccepted ? Icons.circle : Icons.access_time,
                        size: 10,
                        color: isAccepted ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isAccepted ? 'ACCEPTED' : 'WAITING FOR APPROVAL',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isAccepted
                              ? Colors.green
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
