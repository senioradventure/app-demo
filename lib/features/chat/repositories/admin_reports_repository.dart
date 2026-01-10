import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/report_model.dart';

class AdminReportsRepository {
  final SupabaseClient _client;

  AdminReportsRepository(this._client);

  /// Fetch all reported messages for a specific live chat room
  /// Groups reports by message_id and counts them
  Future<List<ReportModel>> fetchReportedMessages({
    required String liveChatRoomId,
  }) async {
    debugPrint('🟦 [AdminReportsRepo] Fetching reports for liveChatRoomId: $liveChatRoomId');

    try {
      // Fetch reports with message and user details
      final reportRows = await _client
          .from('reports')
          .select('''
            id,
            reporter_id,
            reported_user_id,
            reported_message_id,
            reason,
            status,
            created_at,
            updated_at,
            messages!reports_reported_message_id_fkey (
              id,
              content,
              sender_id,
              live_chat_room_id,
              profiles!messages_sender_id_fkey (
                id,
                full_name,
                avatar_url
              )
            )
          ''')
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      debugPrint('🟩 [AdminReportsRepo] Reports fetched: ${reportRows.length}');

 
      final Map<String, List<Map<String, dynamic>>> groupedReports = {};
      
      for (final row in reportRows) {
        final messageData = row['messages'] as Map<String, dynamic>?;
        if (messageData == null) continue;
        
        final messageLiveChatRoomId = messageData['live_chat_room_id'] as String?;
        if (messageLiveChatRoomId != liveChatRoomId) continue;

        final messageId = row['reported_message_id'] as String;
        groupedReports.putIfAbsent(messageId, () => []);
        groupedReports[messageId]!.add(row);
      }

      final List<ReportModel> reports = [];
      
      for (final entry in groupedReports.entries) {
        final messageId = entry.key;
        final reportList = entry.value;
        
        if (reportList.isEmpty) continue;

        final firstReport = reportList.first;
        final messageData = firstReport['messages'] as Map<String, dynamic>;
        final profileData = messageData['profiles'] as Map<String, dynamic>?;
        
        
        final report = ReportModel(
          id: firstReport['id'] as String? ?? '',
          reporterId: firstReport['reporter_id'] as String? ?? '',
          reportedUserId: firstReport['reported_user_id'] as String? ?? '',
          reportedMessageId: messageId,
          reason: firstReport['reason'] as String? ?? '',
          status: firstReport['status'] as String? ?? 'pending',
          createdAt: DateTime.tryParse(firstReport['created_at'] as String? ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(firstReport['updated_at'] as String? ?? '') ?? DateTime.now(),
          reportedUserName: profileData?['full_name'] as String? ?? 'Unknown',
          reportedUserAvatar: profileData?['avatar_url'] as String?,
          messageContent: messageData['content'] as String? ?? '',
          reportCount: reportList.length,
        );
        
        
        reports.add(report);
      }

      debugPrint('🟩 [AdminReportsRepo] Processed reports: ${reports.length}');
      return reports;
    } catch (e, stack) {
      debugPrint('🟥 [AdminReportsRepo] ERROR: $e');
      debugPrint('🟥 [AdminReportsRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  /// Dismiss a report (soft delete by setting deleted_at)
  Future<void> dismissReport({
    required String reportedMessageId,
  }) async {
    debugPrint('🟦 [AdminReportsRepo] Dismissing reports for message: $reportedMessageId');

    try {
      await _client
          .from('reports')
          .update({
            'deleted_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('reported_message_id', reportedMessageId)
          .eq('status', 'pending');

      debugPrint('🟩 [AdminReportsRepo] Reports dismissed successfully');
    } catch (e, stack) {
      debugPrint('🟥 [AdminReportsRepo] dismissReport ERROR: $e');
      debugPrint('🟥 [AdminReportsRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  /// Delete a reported message (soft delete by setting deleted_at)
  Future<void> deleteReportedMessage({
    required String messageId,
  }) async {
    debugPrint('🟦 [AdminReportsRepo] Deleting message: $messageId');

    try {
      // Soft delete the message
      await _client
          .from('messages')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', messageId);

      // Soft delete the reports
      await _client
          .from('reports')
          .update({
            'deleted_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('reported_message_id', messageId)
          .eq('status', 'pending');

      debugPrint('🟩 [AdminReportsRepo] Message and reports deleted');
    } catch (e, stack) {
      debugPrint('🟥 [AdminReportsRepo] deleteReportedMessage ERROR: $e');
      debugPrint('🟥 [AdminReportsRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  /// Subscribe to real-time updates for reports
  RealtimeChannel subscribeToReports({
    required String liveChatRoomId,
    required Function(List<ReportModel>) onReportsUpdated,
  }) {
    debugPrint('🟦 [AdminReportsRepo] Subscribing to reports for live chat room: $liveChatRoomId');

    final channel = _client
        .channel('admin_reports_$liveChatRoomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'reports',
          callback: (payload) async {
            debugPrint('🟨 [AdminReportsRepo] Real-time update received');
            // Refetch reports when any change occurs
            final reports = await fetchReportedMessages(liveChatRoomId: liveChatRoomId);
            onReportsUpdated(reports);
          },
        )
        .subscribe();

    return channel;
  }
}
