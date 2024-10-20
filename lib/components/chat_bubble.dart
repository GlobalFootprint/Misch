import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String translatedMessage;
  final bool isMe;
  const ChatBubble({
    super.key,
    required this.message,
    required this.translatedMessage,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isMe ? Colors.grey : Colors.blue,
      ),
      child: isMe ?
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),)
      : Column(
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 5),
            Text(
             translatedMessage,
             style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
    );
  }
}