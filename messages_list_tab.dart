import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';

class MessagesListTab extends StatelessWidget {
  const MessagesListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Please sign in to view messages.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isAdmin = userSnapshot.data?.get('isAdmin') ?? false;

        if (isAdmin) {
          return _buildAdminView(currentUser.uid);
        } else {
          return _buildUserView(currentUser.uid);
        }
      },
    );
  }

  Widget _buildAdminView(String adminId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').where('users', arrayContains: adminId).snapshots(),
      builder: (context, chatSnapshot) {
        if (!chatSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chatDocs = chatSnapshot.data!.docs;

        return ListView.builder(
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            final chatDoc = chatDocs[index];
            final List<String> userIds = List<String>.from(chatDoc['users']);
            final otherUserId = userIds.firstWhere((id) => id != adminId);

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
              builder: (context, otherUserSnapshot) {
                if (!otherUserSnapshot.hasData) {
                  return const ListTile(title: Text('Loading...'));
                }

                final otherUser = otherUserSnapshot.data!;
                final lastMessage = (chatDoc['lastMessage'] as Map<String, dynamic>?) ?? {};

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(otherUser['phoneNumber'] ?? 'User'),
                  subtitle: Text(lastMessage['text'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatId: chatDoc.id,
                          otherUserId: otherUserId,
                          otherUserName: otherUser['phoneNumber'] ?? 'User',
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUserView(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('isAdmin', isEqualTo: true).snapshots(),
      builder: (context, adminSnapshot) {
        if (!adminSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final adminDocs = adminSnapshot.data!.docs;

        return ListView.builder(
          itemCount: adminDocs.length,
          itemBuilder: (context, index) {
            final admin = adminDocs[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(admin['phoneNumber'] ?? 'Admin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      chatId: _getChatId(userId, admin.id),
                      otherUserId: admin.id,
                      otherUserName: admin['phoneNumber'] ?? 'Admin',
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode ? '${userId1}_$userId2' : '${userId2}_$userId1';
  }
}
