import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Notification'
      ),
    );
  }
}