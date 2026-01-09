import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/chat_header.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/chat_message_list.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/message_input_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Chatroom extends StatefulWidget {
  final String? title;
  final bool isAdmin;
  final String? imageUrl;
  final bool isNewRoom;
  final File? imageFile;
  final String? roomId;

  const Chatroom({
    super.key,
    this.title,
    this.imageUrl,
    this.isAdmin = true,
    this.isNewRoom = false,
    this.imageFile,
    this.roomId,
  });

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final ImagePicker picker = ImagePicker();
  final ValueNotifier<String?> pendingImage = ValueNotifier(null);
  final ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);
  final ValueNotifier<int> fabRebuild = ValueNotifier<int>(0);
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _liveChatRoomId;
  late final Stream<List<Map<String, dynamic>>> _messagesStream;
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();
  final List<ChatMessage> messages = [];

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour > 12
        ? localTime.hour - 12
        : (localTime.hour == 0 ? 12 : localTime.hour);
    final period = localTime.hour >= 12 ? 'PM' : 'AM';
    final minute = localTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  void initState() {
    super.initState();

    assert(widget.roomId != null, 'Chatroom opened without roomId');
    _liveChatRoomId = widget.roomId!;

    _messagesStream = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('live_chat_room_id', _liveChatRoomId)
        .order('created_at', ascending: true);

    pendingImage.addListener(() => fabRebuild.value++);
    isTyping.addListener(() => fabRebuild.value++);
  }

  @override
  void dispose() {
    pendingImage.dispose();
    isTyping.dispose();
    fabRebuild.dispose();
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    final imagePath = pendingImage.value;

    if (text.isEmpty && imagePath == null) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final tempId = _uuid.v4();
      final now = DateTime.now();
      final tempMsg = ChatMessage(
        id: tempId,
        isSender: true,
        text: text,
        time: _formatTime(now),
        imageFile: imagePath,
        name: 'You',
        profileAsset: null,
      );

      setState(() {
        messages.add(tempMsg);
        messageController.clear();
        pendingImage.value = null;
        isTyping.value = false;
      });

      String? mediaUrl;
      String mediaType = 'text';

      if (imagePath != null) {
        final file = File(imagePath);
        final fileExt = imagePath.split('.').last;
        final fileName = 'messages/${_uuid.v4()}.$fileExt';

        await _supabase.storage
            .from('media')
            .upload(
              fileName,
              file,
              fileOptions: const FileOptions(upsert: false),
            );

        mediaUrl = _supabase.storage.from('media').getPublicUrl(fileName);
        mediaType = 'image';
      }

      await _supabase.from('messages').insert({
        'live_chat_room_id': _liveChatRoomId,
        'id': tempId,
        'conversation_id': null,
        'circle_id': null,
        'sender_id': user.id,
        'content': text,
        'media_type': mediaType,
        'media_url': mediaUrl,
      });
    } catch (e) {
      setState(() {
        if (messages.isNotEmpty) messages.removeLast();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
    }
  }

  Future<void> _openLink(String rawUrl) async {
    final String url = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('CHATROOM USING ROOM ID = $_liveChatRoomId');

    final currentUserId = _supabase.auth.currentUser?.id ?? '';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F2E8), Color(0xFFFFE9BC)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: Colors.white,
              ),
              ChatHeaderWidget(
                title: widget.title,
                imageUrl: widget.imageUrl,
                isAdmin: widget.isAdmin,
                roomId: _liveChatRoomId,
              ),

              Expanded(
                child: ChatMessageList(
                  messagesStream: _messagesStream,
                  optimisticMessages: messages,
                  currentUserId: currentUserId,
                  scrollController: _scrollController,
                  onOpenLink: _openLink,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ChatInputBar(
        picker: picker,
        pendingImage: pendingImage,
        isTyping: isTyping,
        fabRebuild: fabRebuild,
        messageController: messageController,
        onSend: _sendMessage,
      ),
    );
  }
}
