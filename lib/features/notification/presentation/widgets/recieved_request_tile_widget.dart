import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/individual_profile_icon.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/notification/bloc/notification_bloc.dart';
import 'package:senior_circle/features/notification/bloc/notification_event.dart';
import 'package:senior_circle/features/notification/models/recieved_request_model.dart';
import 'package:senior_circle/features/notification/presentation/widgets/accept_reject_button_widget.dart';

final List<ReceivedRequestModel> receivedSampleData = [
  ReceivedRequestModel(
    
    name: 'Ramcy',
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    text: 'You: How are you today?',
    time: 'Yesterday', id: '1',
  ),
  ReceivedRequestModel(
    name: 'Anil Kumar',
    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    text: 'Sent you a friend request',
    time: '2d ago', id: '2',
  ),
  ReceivedRequestModel(
    name: 'Meera Nair',
    imageUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    text: 'Would like to connect with you',
    time: '3d ago', id: '3',
  ),
  ReceivedRequestModel(
    name: 'Suresh Rao',
    imageUrl: 'https://randomuser.me/api/portraits/men/71.jpg',
    text: 'You: Let’s stay in touch',
    time: '1w ago', id: '4',
  ),
];


class ReceivedRequestTile extends StatelessWidget {
  final String requestId;
  final String name;
  final String? imageUrl;
  final String? text;
  final String time;
  final ReceivedRequestModel item;

  const ReceivedRequestTile({
    super.key,
    required this.requestId,
    required this.name,
    this.imageUrl,
    this.text,
    required this.time,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    text!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  Buttons(
  onAccept: () {
    context.read<NotificationBloc>().add(
      AcceptRequest(
    requestId: item.id,
    userName: item.name,
    imageUrl: item.imageUrl ?? '',
  ),
    );
  },
  onReject: () {
    context.read<NotificationBloc>().add(
  RejectRequest(requestId: item.id),
);

  },
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
