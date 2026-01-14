import 'package:get_it/get_it.dart';
import 'package:senior_circle/core/database/app_database.dart';
import 'package:senior_circle/core/database/daos/circle_messages_dao.dart';
import 'package:senior_circle/features/circle_chat/repositories/circle_chat_messages_repository.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Database
  final db = AppDatabase.instance;
  getIt.registerSingleton<AppDatabase>(db);
  
  // DAOs
  getIt.registerLazySingleton<CircleMessagesDao>(
    () => CircleMessagesDao(getIt<AppDatabase>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<CircleChatMessagesRepository>(
    () => CircleChatMessagesRepository(
      messagesDao: getIt<CircleMessagesDao>(),
    ),
  );
}
