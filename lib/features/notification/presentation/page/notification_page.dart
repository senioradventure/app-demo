import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/notification/bloc/notification_bloc.dart';
import 'package:senior_circle/features/notification/bloc/notification_state.dart';
import 'package:senior_circle/features/notification/models/recieved_request_model.dart';
import 'package:senior_circle/features/notification/models/sent_request_model.dart';
import 'package:senior_circle/features/notification/presentation/widgets/recieved_request_tile_widget.dart';
import 'package:senior_circle/features/notification/presentation/widgets/sent_request_tile_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: CommonAppBar(title: 'Notification'),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationLoaded) {
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: AppColors.white,
                    child: const TabBar(
                      labelColor: AppColors.buttonBlue,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorColor: AppColors.buttonBlue,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(text: 'RECEIVED'),
                        Tab(text: 'SENT'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ReceivedTab(data: state.received),
                        SentTab(data: state.sent),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ReceivedTab extends StatelessWidget {
  final List<ReceivedRequestModel> data;

  const ReceivedTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No requests'));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final item = data[index];
          return ReceivedRequestTile(
            requestId: item.id,
            name: item.name,
            imageUrl: item.imageUrl,
            text: item.text,
            time: item.time,
            item: item,
          );
        },
      ),
    );
  }
}

class SentTab extends StatelessWidget {
  final List<SentRequestModel> data;

  const SentTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No sent requests'));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final item = data[index];
          return SentRequestTile(
            name: item.name,
            status: item.status,
            time: item.time,
            imageUrl: item.imageUrl,
          );
        },
      ),
    );
  }
}
