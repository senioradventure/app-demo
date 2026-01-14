import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_event.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_state.dart';
import 'package:senior_circle/features/live_chat_home/presentation/bloc/live_chat_home_bloc.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/search_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageActionDialog {
  static void show(
    BuildContext context, {
    required String messageId,
    required String currentUserId,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<ChatRoomBloc, ChatRoomState>(
                    builder: (context, state) {
                      final msg = state.messages
                          .cast<ChatMessage?>()
                          .firstWhere(
                            (m) => m?.id == messageId,
                            orElse: () => null,
                          );

                      if (msg == null) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _actionItem(
                            context,
                            icon: 'assets/icons/star.png',
                            label: msg.isStarred ? 'UNSTAR' : 'STAR',
                            fontWeight: FontWeight.w600,
                            onTap: () {
                              context.read<ChatRoomBloc>().add(
                                ChatMessageStarToggled(messageId: messageId),
                              );
                              Navigator.pop(context);
                            },
                          ),

                          _divider(),

                          _actionItem(
                            context,
                            icon: 'assets/icons/flag.png',
                            label: msg.isReported ? 'UNREPORT' : 'REPORT',
                            fontWeight: FontWeight.w600,
                            onTap: () async {
                              final bloc = context.read<ChatRoomBloc>();

                              Navigator.pop(context);

                              if (msg.isReported) {
                                bloc.add(
                                  ChatMessageReportToggled(
                                    messageId: messageId,
                                    reportedUserId: msg.senderId!,
                                  ),
                                );
                              } else {
                                final reason = await _askReportReason(
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).context,
                                );
                                if (reason == null) return;

                                bloc.add(
                                  ChatMessageReportToggled(
                                    messageId: messageId,
                                    reportedUserId: msg.senderId!,
                                    reason: reason,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  _divider(),
                  _textOnlyItem(
                    context,
                    'FORWARD',
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      final rootContext = Navigator.of(
                        context,
                        rootNavigator: true,
                      ).context;

                      Navigator.pop(context);

                      _showForwardBottomSheet(rootContext, messageId);
                    },
                  ),

                  _divider(),
                  _textOnlyItem(
                    context,
                    'SHARE',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _divider(),
                  _textOnlyItem(
                    context,
                    'DELETE FOR ME',
                    onTap: () {
                      context.read<ChatRoomBloc>().add(
                        ChatMessageDeleteForMeRequested(messageId: messageId),
                      );
                    },
                  ),
                  _divider(),
                  _textOnlyItem(
                    context,
                    'DELETE FOR EVERYONE',
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      context.read<ChatRoomBloc>().add(
                        ChatMessageDeleteRequested(messageId: messageId),
                      );

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void _showForwardBottomSheet(BuildContext context, String messageId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<LiveChatHomeBloc>(),
          child: _ForwardRoomSheet(messageId: messageId),
        );
      },
    );
  }

  static Future<String?> _askReportReason(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54, // ✅ dim background
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Report message',
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 20,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter 1-word reason',
              hintStyle: const TextStyle(color: Colors.grey),
              counterText: '',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // ✅ applies correctly now
              ),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty || text.contains(' ')) return;
                Navigator.pop(context, text);
              },
              child: const Text('REPORT'),
            ),
          ],
        );
      },
    );
  }

  static Widget _divider() {
    return const Divider(height: 1, thickness: 0.6, color: Color(0xFFE3E3E3));
  }

  static Widget _actionItem(
    BuildContext context, {
    required String icon,
    required String label,
    required FontWeight fontWeight,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _textOnlyItem(
    BuildContext context,
    String label, {
    FontWeight fontWeight = FontWeight.w500,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: fontWeight,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForwardRoomSheet extends StatefulWidget {
  final String messageId;

  const _ForwardRoomSheet({required this.messageId});

  @override
  State<_ForwardRoomSheet> createState() => _ForwardRoomSheetState();
}

class _ForwardRoomSheetState extends State<_ForwardRoomSheet> {
  final Set<String> _selectedRoomIds = {};
  late final LiveChatHomeBloc _homeBloc;
  @override
  void initState() {
    super.initState();
    _homeBloc = context.read<LiveChatHomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Forward',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchTextField(
              onChanged: (txt) {
                _homeBloc.add(UpdateSearchEvent(txt));
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: BlocBuilder<LiveChatHomeBloc, LiveChatHomeState>(
              bloc: _homeBloc,

              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: state.filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = state.filteredRooms[index];
                    final isSelected = _selectedRoomIds.contains(room.id);

                    return InkWell(
                      onTap: () => _toggle(room.id),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),

                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isSelected,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),

                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>((
                                        states,
                                      ) {
                                        if (states.contains(
                                          MaterialState.selected,
                                        )) {
                                          return Colors.blue;
                                        }
                                        return Colors.white;
                                      }),

                                  checkColor: Colors.transparent,

                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),

                                  onChanged: (_) => _toggle(room.id),
                                ),

                                const SizedBox(width: 6),

                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: room.image_url != null
                                      ? NetworkImage(room.image_url!)
                                      : null,
                                  backgroundColor: Colors.grey.shade300,
                                  child: room.image_url == null
                                      ? const Icon(
                                          Icons.group,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    room.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            _divider(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _selectedRoomIds.isEmpty
                      ? null
                      : () async {
                          for (final roomId in _selectedRoomIds) {
                            context.read<ChatRoomBloc>().add(
                              ChatMessageForwardRequested(
                                messageId: widget.messageId,
                                targetRoomId: roomId,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                  child: Text(
                    'FORWARD (${_selectedRoomIds.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggle(String roomId) {
    setState(() {
      if (_selectedRoomIds.contains(roomId)) {
        _selectedRoomIds.remove(roomId);
      } else {
        _selectedRoomIds.add(roomId);
      }
    });
  }

  static Widget _divider() {
    return const Divider(height: 1, thickness: 0.6, color: Color(0xFFE3E3E3));
  }
}
