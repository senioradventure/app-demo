# senior_circle

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


for individual conversation first create friend request with status pending, use create_conversation rcp to initiate the conversation, use get_all_conversations to get the all conversation of a user using uid, and list in circle page 
Future<void> _fetchConversations() async {
  final client = Supabase.instance.client;
  final userId = client.auth.currentUser?.id;

  if (userId == null) {
    debugPrint('❌ No logged-in user');
    return;
  }

  try {
    // 🔹 STEP 1: Create conversation (if needed)
    final createResponse = await client.rpc(
      'create_conversation',
      params: {
        'p_other_user_id':
            "6e91deea-c703-4662-af46-8cf0384588c5", // <-- pass the other user's UUID
        'p_conversation_id': null, // or omit if DB generates it
      },
    );

    debugPrint('✅ Create conversation result:');
    debugPrint(createResponse.toString());

    // 🔹 STEP 2: Fetch all conversations
    final response = await client.rpc(
      'get_all_conversations',
      params: {'p_user_id': userId},
    );

    debugPrint('✅ Conversations result:');
    debugPrint(response.toString());
  } catch (e, stackTrace) {
    debugPrint('❌ Error fetching conversations: $e');
    debugPrint(stackTrace.toString());
  }
}
