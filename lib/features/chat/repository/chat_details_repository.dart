import 'package:supabase_flutter/supabase_flutter.dart';
import '../enum/chat_type.dart';

class ChatDetailsRepository {
  final SupabaseClient _supabase;

  ChatDetailsRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<({Map<String, dynamic> details, List<Map<String, dynamic>> members})>
  fetchDetails({required String id, required ChatType type}) async {
    if (type == ChatType.room) {
      // Fetch Room Details
      final roomResponse = await _supabase
          .from('live_chat_rooms')
          .select()
          .eq('id', id)
          .single();

      // Fetch Room Participants
      final participantsResponse = await _supabase
          .from('live_chat_participants')
          .select('*, profiles(*)')
          .eq('room_id', id)
          .limit(5); // Limit for preview

      return (
        details: roomResponse,
        members: List<Map<String, dynamic>>.from(participantsResponse),
      );
    } else {
      // Fetch Circle Details
      final circleResponse = await _supabase
          .from('circles')
          .select()
          .eq('id', id)
          .single();

      // Fetch Circle Members
      final membersResponse = await _supabase
          .from('circle_members')
          .select('*, profiles(*)')
          .eq('circle_id', id)
          .limit(5); // Limit for preview

      return (
        details: circleResponse,
        members: List<Map<String, dynamic>>.from(membersResponse),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllMembers({
    required String id,
    required ChatType type,
  }) async {
    if (type == ChatType.room) {
      final participantsResponse = await _supabase
          .from('live_chat_participants')
          .select('*, profiles(*)')
          .eq('room_id', id);
      return List<Map<String, dynamic>>.from(participantsResponse);
    } else {
      final membersResponse = await _supabase
          .from('circle_members')
          .select('*, profiles(*)')
          .eq('circle_id', id);
      return List<Map<String, dynamic>>.from(membersResponse);
    }
  }
}
