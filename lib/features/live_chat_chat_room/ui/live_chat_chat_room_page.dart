import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_event.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_state.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/chat_header.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/chat_message_list.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/message_input_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final String _liveChatRoomId;




@override
void initState() {
  super.initState();

  _liveChatRoomId = widget.roomId!;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    final bloc = context.read<ChatRoomBloc>();
    bloc.add(ChatRoomStarted(_liveChatRoomId));
  });
}



  @override
  void dispose() {
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }




  Future<void> _openLink(String rawUrl) async {
    final String url = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {

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
                liveChatRoomId: _liveChatRoomId,
                title: widget.title,
                imageUrl: widget.imageUrl,
                isAdmin: widget.isAdmin,
              ),

              Expanded(
  child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
    builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.error != null) {
        return Center(child: Text(state.error!));
      }

      return ChatMessageList(
        messages: state.messages,
        scrollController: _scrollController,
        onOpenLink: _openLink,
      );
    },
  ),
),


            ],
            
          ),
        ),
        
      ),
      
      bottomNavigationBar: BlocBuilder<ChatRoomBloc, ChatRoomState>(
  buildWhen: (p, c) =>
      p.isTyping != c.isTyping || p.pendingImage != c.pendingImage,
  builder: (context, state) {
    return ChatInputBar(
      picker: picker,
      messageController: messageController,
      showSend: state.isTyping || state.pendingImage != null,
      onSend: () {
        final text = messageController.text.trim();
        if (text.isEmpty && state.pendingImage == null) return;

        context.read<ChatRoomBloc>().add(ChatMessageSendRequested(text));
        messageController.clear();
      },
    );
  },
),




    );
  }
}
