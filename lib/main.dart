import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live-chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/live-chat_home_page.dart';
import 'package:senior_circle/features/details/bloc/chatroomdetails_bloc.dart';
import 'package:senior_circle/features/login_page/login_page.dart';
//import 'package:senior_circle/features/details/presentation/details_screen.dart';
//import 'package:senior_circle/features/preview/presentation/preview_screen.dart';
import 'package:senior_circle/theme/apptheme/app_theme.dart';


void main() {
  runApp(const SeniorCircleApp());
}

class SeniorCircleApp extends StatelessWidget {
  const SeniorCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateroomBloc>(create: (context) => CreateroomBloc()),
        BlocProvider<ChatroomdetailsBloc>(
          create: (context) => ChatroomdetailsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Senior Circle',
        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
        debugShowCheckedModeBanner: false,
        home: LiveChatLoginPage(),
      ),
    );
  }
}
