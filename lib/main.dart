import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/details/bloc/chatroomdetails_bloc.dart';
import 'package:senior_circle/features/details/presentation/details_screen.dart';
import 'package:senior_circle/features/login_page/login_page.dart';
//import 'package:senior_circle/features/details/presentation/details_screen.dart';
//import 'package:senior_circle/features/preview/presentation/preview_screen.dart';
import 'package:senior_circle/core/theme/apptheme/app_theme.dart';
import 'package:senior_circle/features/preview/presentation/preview_screen.dart';

void main() {
  runApp(const SeniorCircleApp());
}

class SeniorCircleApp extends StatelessWidget {
  const SeniorCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatroomdetailsBloc>(
          create: (context) => ChatroomdetailsBloc(),
        ),
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
