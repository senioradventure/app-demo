import 'package:flutter/material.dart';

class SentTab extends StatelessWidget {
  const SentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 2, // later from Bloc state
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, index) {
       // return const SentRequestTile(name: '', status: c, time: '',);
      },
    );
  }
}


enum RequestStatus { waiting, accepted }

class SentRequestTile extends StatelessWidget {
  final String name;
  final RequestStatus status;
  final String time;

  const SentRequestTile({
    super.key,
    required this.name,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepted = status == RequestStatus.accepted;

    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/avatar.png'), // replace later
        ),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
    );
  }
}
