import 'package:senior_circle/features/notification/models/recieved_request_model.dart';
import 'package:senior_circle/features/notification/models/sent_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRepository {
  final SupabaseClient _client;

  NotificationRepository(this._client);

  Future<List<ReceivedRequestModel>> getReceivedRequests() async {
    try {
      print('getReceivedRequests called');
      final userId = _client.auth.currentUser!.id;
      print('Current user: $userId');
      final response = await _client
          .from('friend_requests')
          .select('''
  id,
  status,
  created_at,
  sender:profiles!friend_requests_sender_id_fkey (
    id,
    full_name,
    avatar_url
  )
''')
          .eq('receiver_id', userId)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false)
          .then((res) {
            print('Raw received response: $res');
            return res;
          });

      return response.map<ReceivedRequestModel>((json) {
        return ReceivedRequestModel(
          id: json['id'],
          name: json['sender']['full_name'],
          imageUrl: json['sender']['avatar_url'],
          text: 'Sent you a friend request',
          time: _formatTime(json['created_at']),
        );
      }).toList();
    } catch (e, s) {
      print('getReceivedRequests error: $e');
      print(s);
      rethrow;
    }
  }

  Future<List<SentRequestModel>> getSentRequests() async {
    final userId = _client.auth.currentUser!.id;

    final response = await _client
        .from('friend_requests')
        .select('''
  id,
  status,
  created_at,
  receiver:profiles!friend_requests_receiver_id_fkey (
    id,
    full_name,
    avatar_url
  )
''')
        .eq('sender_id', userId)
        .filter('deleted_at', 'is', null)
        .order('created_at', ascending: false);

    return response.map<SentRequestModel>((json) {
      return SentRequestModel(
        id: json['id'],
        name: json['receiver']['full_name'],
        imageUrl: json['receiver']['avatar_url'],
        status: _mapStatus(json['status']),
        time: _formatTime(json['created_at']),
      );
    }).toList();
  }


  Future<void> acceptRequest(String requestId) async {
    await _client
        .from('friend_requests')
        .update({
          'status': 'accepted',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  Future<void> rejectRequest(String requestId) async {
    await _client
        .from('friend_requests')
        .update({
          'status': 'rejected',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  RequestStatus _mapStatus(String status) {
    switch (status) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return RequestStatus.waiting;
    }
  }

  String _formatTime(String timestamp) {
    final date = DateTime.parse(timestamp).toLocal();
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }
}
