import 'dart:io';

import 'package:flutter/material.dart';

class MessageImage extends StatelessWidget {
  final String url;

  const MessageImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('/data/') || url.startsWith('file://')) {
      return Image.file(File(url), fit: BoxFit.cover);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}
