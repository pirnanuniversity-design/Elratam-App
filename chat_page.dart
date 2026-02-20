import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view messages.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message['sender'] == currentUser.uid;
                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Card(
                        elevation: 1.5,
                        color: isUserMessage ? Colors.green.shade100 : Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUserMessage ? const Radius.circular(16) : const Radius.circular(4),
                            bottomRight: isUserMessage ? const Radius.circular(4) : const Radius.circular(16),
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Text(message['text'] ?? ''),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(currentUser.uid),
        ],
      ),
    );
  }

  Widget _buildMessageComposer(String currentUserId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(currentUserId),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String currentUserId) {
    if (_textController.text.isEmpty) return;

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    chatRef.collection('messages').add({
      'sender': currentUserId,
      'text': _textController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    chatRef.set({
      'lastMessage': {
        'text': _textController.text,
        'timestamp': FieldValue.serverTimestamp(),
      },
      'users': [currentUserId, widget.otherUserId],
    }, SetOptions(merge: true));

    _textController.clear();
  }
}
