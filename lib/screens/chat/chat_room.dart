// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/models/driver_model.dart';
import 'package:darboda/models/message_model.dart';
import 'package:darboda/models/user_model.dart';
import 'package:darboda/screens/chat/add_message.dart';
import 'package:darboda/screens/chat/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ChatRoom extends StatelessWidget {
  static const routeName = '/chat-room';
  final ScrollController _scrollController = ScrollController();

  ChatRoom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chatRoomData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final RiderModel user = chatRoomData['user'];
    final chatRoomId = chatRoomData['chatRoomId'];

    build(BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 25,
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: CachedNetworkImageProvider(user.profilePic!),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  Text(
                    user.phoneNumber!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            constraints: const BoxConstraints(maxHeight: 10, minHeight: 10),
            icon: const Icon(
              Icons.call,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () async {
              bool? res =
                  await FlutterPhoneDirectCaller.callNumber(user.phoneNumber!);

              if (res == false) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Oops could not make phone call'),
                ));
              }
            },
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatRoomId)
                    .collection('messages')
                    .orderBy('sentAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(child: Container());
                  }

                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs[index];

                        build(context);
                        return ChatBubble(MessageModel(
                          message: message['message'],
                          isRead: message['isRead'],
                          sentAt: message['sentAt'],
                          senderId: message['sender'],
                          mediaType: message['mediaType'],
                          mediaUrl: message['media'],
                        ));
                      },
                    ),
                  );
                }),
            AddMessage(
              userId: user.userId!,
              chatRoom: chatRoomId,
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget moreVert() {
    return PopupMenuButton(
        elevation: 1,
        itemBuilder: (xtx) => options
            .map((e) => PopupMenuItem(
                    child: Text(
                  e,
                  style: const TextStyle(fontSize: 15),
                )))
            .toList(),
        icon: const Icon(
          Icons.more_vert,
          color: Colors.grey,
        ));
  }

  List options = [
    'Search',
    'Mute notifications',
    'Clear chat',
    'Report',
    'Block'
  ];
}
