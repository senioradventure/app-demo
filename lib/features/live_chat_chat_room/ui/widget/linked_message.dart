import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

class LinkedMessageText extends StatefulWidget {
  final String text;
  final ChatMessage msg;
  final void Function(String phone, ChatMessage msg) onPhoneTap;
  final void Function(String link) onLinkTap;

  const LinkedMessageText({
    super.key,
    required this.text,
    required this.msg,
    required this.onPhoneTap,
    required this.onLinkTap,
  });

  @override
  State<LinkedMessageText> createState() => _LinkedMessageTextState();
}

class _LinkedMessageTextState extends State<LinkedMessageText> {
  String? _activeLink;

  @override
  Widget build(BuildContext context) {
    if (widget.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final regex = RegExp(
      r'(\+?\d[\d\s\-]{6,}\d)|((https?:\/\/|www\.)[^\s]+|[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\/\S*)?)',
    );

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in regex.allMatches(widget.text)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(text: widget.text.substring(currentIndex, match.start)),
        );
      }

      final matched = widget.text.substring(match.start, match.end);
      final isPhone = RegExp(r'^[\d\s\-\+]+$').hasMatch(matched);
      final isActive = _activeLink == matched;

      spans.add(
        TextSpan(
          text: matched,
          style: TextStyle(
            color: isActive
                ? const Color.fromARGB(255, 2, 100, 181)
                : Colors.blue,
            fontWeight: FontWeight.w500,
          ),
          recognizer: TapGestureRecognizer()
            ..onTapDown = (_) {
              setState(() => _activeLink = matched);
            }
            ..onTapUp = (_) {
              Future.delayed(const Duration(milliseconds: 120), () {
                if (mounted) setState(() => _activeLink = null);
              });

              if (isPhone) {
                widget.onPhoneTap(matched, widget.msg);
              } else {
                widget.onLinkTap(matched);
              }
            }
            ..onTapCancel = () {
              setState(() => _activeLink = null);
            },
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < widget.text.length) {
      spans.add(
        TextSpan(text: widget.text.substring(currentIndex)),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        children: spans,
      ),
    );
  }
}
