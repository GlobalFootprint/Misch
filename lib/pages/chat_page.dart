import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:misch/api/translation_api.dart';
import 'package:misch/components/chat_bubble.dart';
import 'package:misch/components/my_text_field.dart';
import 'package:misch/components/translation_title_widget.dart';
import 'package:misch/components/translation_widget.dart';
import 'package:misch/services/chat/chat_service.dart';
import 'package:misch/utils/translations.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String language1 = Translations.languages.first;
  String language2 = Translations.languages.first;

  void sendMessage() async {
    // only send the message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
        widget.receiverUserID,
        _messageController.text
      );
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.receiverUserEmail), backgroundColor: Colors.grey,),
      body: Column(
        children: [
          // translation widget
          TranslationTitleWidget(
              language1: language1,
              language2: language2,
              onChangedLanguage1: (newLanguage) => setState(() {
                language1 = newLanguage!;
              }),
              onChangedLanguage2: (newLanguage) => setState(() {
                language2 = newLanguage!;
              }),
          ),

          SizedBox(height: 15,),
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),

          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID,
          _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },

    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user, otherwise to the left
    var isMe = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          crossAxisAlignment:
            (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
          mainAxisAlignment:
            (data['senderId'] == _firebaseAuth.currentUser!.uid)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            TranslationWidget(
                message: data['message'],
                fromLanguage: language1,
                toLanguage: language2,
                builder: (translatedMessage) => ChatBubble(
                    message: data['message'],
                    translatedMessage: translatedMessage,
                    isMe: isMe
                )
            )
          ],
        ),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter message',
                obscureText: false
            ),
          ),

          // send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                size: 40,
              )
          ),
        ],
      ),
    );
  }
}