import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';
import 'package:senior_circle/features/chat/ui/room_details_admin.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/main_bottom_nav.dart';
import 'package:senior_circle/features/tab/tab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messeges.dart';

class Chatroom extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final ValueNotifier<String?> pendingImage = ValueNotifier(null);

  final ValueNotifier<bool> isRequestSent = ValueNotifier<bool>(false);

  final ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);
  final TextEditingController messageController = TextEditingController();
  final ValueNotifier<String?> tappedLink = ValueNotifier(null);
  final String? title; // or final Contact? contact;
  final bool isAdmin;
  final bool isNewRoom;
  final File? imageFile;
  Chatroom({
    super.key,
    this.title,
    this.isAdmin = true,
    this.isNewRoom = false,
    this.imageFile,
  });
  void _initMessages() {
    if (isNewRoom) {
      chatMessages.value = [];
    } else {
      chatMessages.value = List.from(defaultChatMessages);
    }
  }

  void _showProfileSheet(BuildContext context, ChatMessage msg) {
    isRequestSent.value = false;

    final ImageProvider avatarImage =
        (msg.profileAsset != null && msg.profileAsset!.isNotEmpty)
        ? AssetImage(msg.profileAsset!)
        : const AssetImage('assets/images/chat_profile.png');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true, // ✅ REQUIRED
      enableDrag: true, // ✅ REQUIRED
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.pop(context); // ✅ tap outside closes sheet
          },
          child: Stack(
            children: [
              // Full-screen invisible layer to catch outside taps
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {}, // ✅ block tap inside container
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              top: 20,
                              right: 24,
                              bottom: 15,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: avatarImage,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  msg.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Text(
                                    "From Malappuram",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (msg.isFriend)
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF9F9F7),
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xFFE3E3E3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/user-minus.png',
                                            height: 18,
                                            width: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'REMOVE FRIEND',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    color: const Color(0xFFE3E3E3),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/message-circle.png',
                                            height: 18,
                                            width: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'MESSAGE',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ValueListenableBuilder<bool>(
                              valueListenable: isRequestSent,
                              builder: (context, sent, _) {
                                return InkWell(
                                  onTap: () {
                                    if (!sent) {
                                      isRequestSent.value = true;
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF9F9F7),
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFFE3E3E3),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        sent
                                            ? Image.asset(
                                                'assets/icons/clock.png',
                                                height: 24,
                                                width: 24,
                                              )
                                            : Image.asset(
                                                'assets/icons/user.png',
                                                height: 24,
                                                width: 24,
                                              ),
                                        const SizedBox(width: 10),
                                        Text(
                                          sent
                                              ? "WAITING FOR APPROVAL"
                                              : "ADD FRIEND",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: sent
                                                ? Colors.black
                                                : Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openLink(String rawUrl) async {
    final String url = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';

    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildMessageText(BuildContext context, ChatMessage msg) {
    final text = msg.text;
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    final regex = RegExp(
      r'(\+?\d[\d\s\-]{6,}\d)|((https?:\/\/|www\.)[^\s]+|[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\/\S*)?)',
    );

    return ValueListenableBuilder<String?>(
      valueListenable: tappedLink,
      builder: (context, active, _) {
        final spans = <TextSpan>[];
        int currentIndex = 0;

        for (final match in regex.allMatches(text)) {
          if (match.start > currentIndex) {
            spans.add(
              TextSpan(text: text.substring(currentIndex, match.start)),
            );
          }

          final matched = text.substring(match.start, match.end);

          final bool isPhone = RegExp(r'^[\d\s\-\+]+$').hasMatch(matched);
          final bool isActive = active == matched;

          spans.add(
            TextSpan(
              text: matched,
              style: TextStyle(
                color: isActive
                    ? const Color.fromARGB(255, 2, 100, 181)
                    : Colors.blue,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTapDown = (_) {
                  tappedLink.value = matched;
                }
                ..onTapUp = (_) {
                  Future.delayed(const Duration(milliseconds: 120), () {
                    tappedLink.value = null;
                  });

                  if (isPhone) {
                    _showProfileSheet(
                      context,
                      msg.copyWith(name: matched.trim()),
                    );
                  } else {
                    _openLink(matched);
                  }
                }
                ..onTapCancel = () {
                  tappedLink.value = null;
                },
            ),
          );

          currentIndex = match.end;
        }

        if (currentIndex < text.length) {
          spans.add(TextSpan(text: text.substring(currentIndex)));
        }

        return RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            children: spans,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _initMessages();
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

              InkWell(
                onTap: () {
                  // only navigate if NOT admin
                  if (!isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatDetailsScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatDetailsScreenadmin(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            currentPageIndex.value = 0; // Live Chat tab

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TabSelectorWidget(),
                              ),
                              (route) => false,
                            );
                          },
                        ),

                        CircleAvatar(
                          radius: 18,
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!)
                              : const AssetImage(
                                      'assets/images/chat_profile.png',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          (title != null && title!.length > 14)
                              ? '${title!.substring(0, 14)}...'
                              : (title ?? 'Chai Talks'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),
                        const Text(
                          '10 Active',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color(0xFF5C5C5C),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ValueListenableBuilder<List<ChatMessage>>(
                  valueListenable: chatMessages,
                  builder: (context, list, _) {
                    if (list.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 250),
                                  child: const Text(
                                    'No messages in chat',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icons/bell.png',
                                          height: 22,
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Chat Room has been created. Type a message to start the discussion.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final msg = list[index];

                        if (msg.isSender) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4, right: 4),

                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      (msg.imageAsset != null ||
                                          msg.imageFile != null)
                                      ? MediaQuery.of(context).size.width * 0.66
                                      : MediaQuery.of(context).size.width *
                                            0.635,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD6E6FF),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // ✅ IMAGE FOR SENDER (THIS WAS MISSING)
                                    if (msg.imageAsset != null ||
                                        msg.imageFile != null)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          3,
                                          3,
                                          3,
                                          0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.66,
                                              maxHeight:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.45, // ✅ dynamic
                                            ),
                                            child: msg.imageFile != null
                                                ? Image.file(
                                                    File(msg.imageFile!),
                                                    fit: BoxFit
                                                        .contain, // ✅ keeps full vertical image
                                                  )
                                                : Image.asset(
                                                    msg.imageAsset!,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),

                                    if (msg.text.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      _buildMessageText(context, msg),
                                    ],

                                    const SizedBox(height: 4),
                                    Text(
                                      msg.time,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (msg.profileAsset != null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        _showProfileSheet(context, msg);
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage: AssetImage(
                                          msg.profileAsset!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],

                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (msg.name != null) ...[
                                          Text(
                                            msg.name!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6A6A6A),
                                            ),
                                          ),
                                          const SizedBox(height: 9),
                                        ],

                                        GestureDetector(
                                          onLongPress: () {
                                            // Only on long press, not normal tap
                                            FocusScope.of(context).unfocus();
                                            isRequestSent.value = false;
                                            isRequestSent.value = false;
                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black26,
                                              builder: (context) {
                                                return Center(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.7,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/icons/star.png',
                                                                  ),
                                                                  SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Text(
                                                                    'STAR',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color(
                                                                        0xFF5C5C5C,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            thickness: 0.6,
                                                            color: Color(
                                                              0xFFE3E3E3,
                                                            ),
                                                          ),

                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/icons/flag.png',
                                                                  ),
                                                                  SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Text(
                                                                    'REPORT',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color(
                                                                        0xFF5C5C5C,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            thickness: 0.6,
                                                            color: Color(
                                                              0xFFE3E3E3,
                                                            ),
                                                          ),

                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'SHARE',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                        0xFF5C5C5C,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            thickness: 0.6,
                                                            color: Color(
                                                              0xFFE3E3E3,
                                                            ),
                                                          ),

                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'DELETE FOR ME',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                        0xFF5C5C5C,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            thickness: 0.6,
                                                            color: Color(
                                                              0xFFE3E3E3,
                                                            ),
                                                          ),

                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'DELETE FOR EVERYONE',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                        0xFF5C5C5C,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: msg.imageAsset != null
                                                  ? MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.66
                                                  : MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.635,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (msg.imageAsset != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                          3,
                                                          3,
                                                          3,
                                                          0,
                                                        ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.asset(
                                                        msg.imageAsset!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _buildMessageText(
                                                        context,
                                                        msg,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        msg.time,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Color(
                                                            0xFF777777,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 IMAGE PREVIEW (THIS WAS MISSING)
              ValueListenableBuilder<String?>(
                valueListenable: pendingImage,
                builder: (context, path, _) {
                  if (path == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => pendingImage.value = null,
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 🔹 INPUT ROW (YOUR EXISTING CODE)
              Container(
                height: 75,
                color: const Color(0xFFF9F9F7),
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 8,
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/icons/Vector.png'),
                      onPressed: () async {
                        final XFile? picked = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked == null) return;
                        pendingImage.value = picked.path;
                      },
                    ),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFDDDDDD)),
                        ),
                        child: TextField(
                          controller: messageController,
                          onChanged: (v) =>
                              isTyping.value = v.trim().isNotEmpty,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {
                        if (!isTyping.value && pendingImage.value == null)
                          return;

                        final now = TimeOfDay.now();
                        final formatted =
                            "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} "
                            "${now.period == DayPeriod.am ? 'AM' : 'PM'}";

                        chatMessages.value = [
                          ...chatMessages.value,
                          ChatMessage(
                            isSender: true,
                            text: messageController.text,
                            time: formatted,
                            imageFile: pendingImage.value,
                          ),
                        ];

                        messageController.clear();
                        pendingImage.value = null;
                        isTyping.value = false;
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isTyping,
                        builder: (context, typing, _) {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                              typing || pendingImage.value != null
                                  ? 'assets/icons/fab2.png'
                                  : 'assets/icons/fab.png',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
