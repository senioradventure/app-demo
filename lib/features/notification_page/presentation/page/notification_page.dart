import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/notification_page/presentation/widgets/recieved_tab_widget.dart';
import 'package:senior_circle/features/notification_page/presentation/widgets/sent_tab_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text(
            'Notification',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,

          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
              onPressed: () {},
            ),
          ],

          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'RECEIVED'),
              Tab(text: 'SENT'),
            ],
          ),
        ),
        body: const TabBarView(children: [ReceivedTab(), SentTab()]),
      ),
    );
  }
}
