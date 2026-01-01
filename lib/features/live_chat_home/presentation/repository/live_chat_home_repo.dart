import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/core/constants/contact.dart';

class LiveChatHomeRepository {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, String>>> fetchLocations() async {
    final response = await supabase.from('locations').select('id, name');
    final locations=response.map<Map<String, String>>((row) {
      return {
        "id": row['id'] as String,
        "name": row['name'] as String,
      };
    }).toList();
    return locations;
  }


  Future<List<Contact>> fetchRooms() async {
    final response = await supabase.from('live_chat_rooms').select().order('id', ascending: false);
    final rooms= response
        .map<Contact>((json) => Contact.fromJson(json))
        .toList();
    return rooms;
  }
}
