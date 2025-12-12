import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';
import 'package:senior_circle/features/chat/ui/room_details_admin.dart';            
import 'package:url_launcher/url_launcher.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messeges.dart';
final ImagePicker picker = ImagePicker();

final ValueNotifier<bool> isRequestSent = ValueNotifier<bool>(false);

final ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);
final TextEditingController messageController = TextEditingController();
final ValueNotifier<String?> tappedLink = ValueNotifier(null);



class Chatroom extends StatelessWidget {
  final String? title; // or final Contact? contact;
  final bool isAdmin;
  const Chatroom({super.key, this.title,this.isAdmin = true});
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
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            color: const Color(0xFFE3E3E3),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                               
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                    color: sent ? Colors.black : Colors.blue,
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
        );
      },
    );
  }


  Future<void> _openLink(String rawUrl) async {
    final String url = rawUrl.startsWith('http')
        ? rawUrl
        : 'https://$rawUrl'; 

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

   
          final bool isPhone =
              RegExp(r'^[\d\s\-\+]+$').hasMatch(matched);
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
    msg.copyWith(
      name: matched.trim(),   
    ),
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
          spans.add(
            TextSpan(text: text.substring(currentIndex)),
          );
        }

        return RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: spans,
          ),
        );
      },
    );
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
      colors: [
        Color(0xFFF7F2E8),
        Color(0xFFFFE9BC), 
      ],
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
        MaterialPageRoute(builder: (context) => const ChatDetailsScreen()),
      );
    } else {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ChatDetailsScreenadmin()),
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
              Navigator.pop(context);
            },
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage:
                AssetImage('assets/images/chat_profile.png'),
          ),
          const SizedBox(width: 10),
          Text(
            title ?? 'Chai Talks',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
                      maxWidth: msg.imageAsset != null
                          ? MediaQuery.of(context).size.width * 0.66
                          : MediaQuery.of(context).size.width * 0.635,
                    ),
          decoration: BoxDecoration(
            color: const Color(0xFFD6E6FF), 
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                        _buildMessageText(context, msg),
              const SizedBox(height: 2),
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
      backgroundImage: AssetImage(msg.profileAsset!),
    ),
  ),
  const SizedBox(width: 8),
],


           Flexible(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       
                        InkWell(
                          onTap: () {
                           
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
  'assets/icons/star.png',  
  
),
                                SizedBox(width: 12),
                                Text(
                                  'STAR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5C5C5C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
  height: 1,
  thickness: 0.6,
  color: Color(0xFFE3E3E3),
),

                       
                        InkWell(
                          onTap: () {
                           
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                 Image.asset(
  'assets/icons/flag.png', 
  
),
                                SizedBox(width: 12),
                                Text(
                                  'REPORT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5C5C5C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
  height: 1,
  thickness: 0.6,
  color: Color(0xFFE3E3E3),
),

                       
                        InkWell(
                          onTap: () {
                          
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                
                                Text(
                                  'SHARE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5C5C5C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
  height: 1,
  thickness: 0.6,
  color: Color(0xFFE3E3E3),
),

                       
                        InkWell(
                          onTap: () {
                        
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                               
                                Text(
                                  'DELETE FOR ME',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5C5C5C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
  height: 1,
  thickness: 0.6,
  color: Color(0xFFE3E3E3),
),


                       
                        InkWell(
                          onTap: () {
                           
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                
                                Text(
                                  'DELETE FOR EVERYONE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5C5C5C),
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
                ? MediaQuery.of(context).size.width * 0.66
                : MediaQuery.of(context).size.width * 0.635,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.imageAsset != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      msg.imageAsset!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageText(context, msg),
                    const SizedBox(height: 2),
                    Text(
                      msg.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF777777),
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
    )
        
  ),

  
      ],
    ),
  ),
),


        
        bottomNavigationBar: Padding(
  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  child:SafeArea(
          
  child: Container(
    height: 75,
    color: const Color(0xFFF9F9F7),
    padding: const EdgeInsets.only(left: 0, right: 8, top: 6, bottom: 6),
    child: Row(
      children: [
       
        IconButton(
  icon: Image.asset('assets/icons/Vector.png'),
  onPressed: () async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final now = TimeOfDay.now();
      final formatted = "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}";

      chatMessages.value = [
        ...chatMessages.value,
        ChatMessage(
          isSender: true,
          text: "",         
          time: formatted,
          imageAsset: picked.path,  
        ),
      ];
    }
  },
  padding: EdgeInsets.zero,
),


      

     
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical:0),
            decoration: BoxDecoration(
              color:  Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: TextField(
              controller: messageController,
  onChanged: (value) {
    isTyping.value = value.trim().isNotEmpty;
  },
  enableInteractiveSelection: false,
  showCursor: true,

 
  cursorColor: Colors.black,
  cursorWidth: 2,
  cursorHeight: 18, 
  style: const TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  decoration: const InputDecoration(
    hintText: 'Type a message',
    hintStyle: TextStyle(
      color: Color(0xFF5C5C5C),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 9),
    border: InputBorder.none,
  ),
  minLines: 1,
  maxLines: 1,
),

          ),
        ),

        const SizedBox(width: 8),

   
       GestureDetector(
  onTap: () {
  if (isTyping.value) {
    final now = TimeOfDay.now();
    final formatted = "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}";

    chatMessages.value = [
      ...chatMessages.value,
      ChatMessage(
        isSender: true,
        text: messageController.text,
        time: formatted,
      ),
    ];

    messageController.clear();
    isTyping.value = false;
  } else {
    print("Mic tapped");
  }
},

  child: ValueListenableBuilder<bool>(
    valueListenable: isTyping,
    builder: (context, typing, _) {
      return SizedBox(
        width: 50,
        height: 50,
         child: typing
            ? Image.asset(
                'assets/icons/fab2.png', 
              )
            : Image.asset(
                'assets/icons/fab.png', 
              ),
      );
    },
  ),
),

      ],
    ),
  ),
),
    ),
    );
  }
}