import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/utils/location_service/location_service.dart';
import 'package:senior_circle/features/auth/bloc/auth_bloc.dart';
import 'package:senior_circle/features/auth/presentation/splash_screen/splash_screen.dart';
import 'package:senior_circle/features/auth/repositories/auth_repository.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/details/bloc/chatroomdetails_bloc.dart';
import 'package:senior_circle/core/theme/apptheme/app_theme.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_repository.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/repository/live_chat_repository.dart';
import 'package:senior_circle/features/live_chat_home/presentation/bloc/live_chat_home_bloc.dart';
import 'package:senior_circle/features/live_chat_home/presentation/repository/live_chat_home_repo.dart';
import 'package:senior_circle/features/my_circle_home/bloc/my_circle_bloc.dart';
import 'package:senior_circle/features/my_circle_home/bloc/my_circle_event.dart';
import 'package:senior_circle/features/my_circle_home/repository/my_circle_repository.dart';
import 'package:senior_circle/features/createCircle/bloc/create_circle_bloc.dart';
import 'package:senior_circle/features/createCircle/repository/create_circle_repository.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/repository/profile_repository.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_bloc.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/repository/view_friends_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bnfozroolcequclltwjb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuZm96cm9vbGNlcXVjbGx0d2piIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1NzEzNzMsImV4cCI6MjA4MDE0NzM3M30.0MQAK_yOPZX8MxvmsmSnXkV2tcMPzKcGOOTpl2XdTlA',
  );

  runApp(const SeniorCircleApp());
}

class SeniorCircleApp extends StatelessWidget {
  const SeniorCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository(), LocationService()),
        ),
        BlocProvider(create: (_) => ChatroomdetailsBloc()),
        BlocProvider(
          create: (_) => ProfileBloc(
            ProfileRepository(Supabase.instance.client),
            LocationService(),
          )..add(LoadProfile()),
        ),
        BlocProvider(
          create: (_) =>
              ViewFriendsBloc(ViewFriendsRepository(Supabase.instance.client))
                ..add(LoadFriends()),
        ),
        BlocProvider(
          create: (_) => ChatRoomBloc(
            repository: ChatRoomRepository(supabase: Supabase.instance.client,),
          ),
        ),

        BlocProvider(
          create: (_) =>
              CreateroomBloc(locationService: LocationService())
                ..add(LoadLocationsEvent()),
        ),
        BlocProvider(
          create: (_) =>
              MyCircleBloc(repository: MyCircleRepository())
                ..add(LoadMyCircleChats()),
        ),
        BlocProvider(
          create: (context) => LiveChatHomeBloc(LiveChatHomeRepository())
            ..add(FetchLocationsEvent())
            ..add(FetchRoomsEvent()),
        ),
        BlocProvider(create: (context) => IndividualChatBloc(IndividualChatRepository())),
        BlocProvider(
          create: (_) => CreateCircleBloc(
            repository: CreateCircleRepository(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
        BlocProvider(
          create: (_) => IndividualChatBloc(IndividualChatRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Senior Circle',
        theme: AppTheme.lightMode,
        darkTheme: AppTheme.darkMode,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return SafeArea(top: false, bottom: true, child: child!);
        },
        //SplashScreen
        home: SplashPage(),
      ),
    );
  }
}
