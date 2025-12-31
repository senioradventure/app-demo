import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/individual_profile_icon.dart';
import 'package:senior_circle/features/notification_page/models/recieved_request_model.dart';


final List<ReceivedRequestModel> receivedSampleData = [
  ReceivedRequestModel(
    name: 'Ramcy',
    imageUrl:
        'https://randomuser.me/api/portraits/women/44.jpg',
    text: 'You: How are you today?',
    time: 'Yesterday',
  ),
  ReceivedRequestModel(
    name: 'Anil Kumar',
    imageUrl:
        'https://randomuser.me/api/portraits/men/32.jpg',
    text: 'Sent you a friend request',
    time: '2d ago',
  ),
  ReceivedRequestModel(
    name: 'Meera Nair',
    imageUrl:
        'https://randomuser.me/api/portraits/women/65.jpg',
    text: 'Would like to connect with you',
    time: '3d ago',
  ),
  ReceivedRequestModel(
    name: 'Suresh Rao',
    imageUrl:
        'https://randomuser.me/api/portraits/men/71.jpg',
    text: 'You: Let’s stay in touch',
    time: '1w ago',
  ),
];


class ReceivedTab extends StatelessWidget {
  const ReceivedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: receivedSampleData.length, 
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (_, index) {
        final item = receivedSampleData[index];
        return ReceivedRequestTile(
          name: item.name,
          imageUrl: item.imageUrl,
          text: item.text,
          time: item.time,
        );
      },
    );
  }
}

class ReceivedRequestTile extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? text;
  final String time;
   const ReceivedRequestTile({super.key,required this.name,this.imageUrl,this.text,required this.time});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              individualProfileIcon(hasImage, imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
               Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    
                  ),
                  onPressed: () {},
                  child: const Text('REJECT'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('ACCEPT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
