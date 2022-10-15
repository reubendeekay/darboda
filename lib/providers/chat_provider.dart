import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darboda/models/message_model.dart';
import 'package:darboda/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ChatTileModel {
  final UserModel? user;
  String? latestMessage;
  Timestamp? time;
  final String? latestMessageSenderId;
  final String? chatRoomId;

  ChatTileModel({
    this.user,
    this.latestMessage,
    this.time,
    this.chatRoomId,
    this.latestMessageSenderId,
  });
}

class ChatProvider with ChangeNotifier {
  /////////////////SEND MESSAGE////////////////////////
  Future<void> sendMessage(
      String userId, MessageModel message, String chatRoomId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String url = '';
    print('starting');

    if (message.mediaFiles!.isNotEmpty) {
      await Future.forEach(message.mediaFiles!, (File element) async {
        final fileData = await FirebaseStorage.instance
            .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
            .putFile(element);
        url = await fileData.ref.getDownloadURL();
      }).then((_) async {
        final chat =
            FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

        chat.get().then((value) => {
              if (value.exists)
                {
                  chat.update({
                    'latestMessage':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sentAt': FieldValue.serverTimestamp(),
                    'sentBy': uid,
                  }),
                  chat.collection('messages').doc().set({
                    'message':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sender': uid,
                    'to': userId,
                    'media': url,
                    'mediaType': message.mediaType,
                    'isRead': false,
                    'sentAt': FieldValue.serverTimestamp()
                  })
                }
              else
                {
                  chat.set({
                    'initiator': uid,
                    'receiver': userId,
                    'startedAt': FieldValue.serverTimestamp(),
                    'latestMessage':
                        message.message!.isNotEmpty ? message.message : '',
                    'sentAt': FieldValue.serverTimestamp(),
                    'sentBy': uid,
                  }),
                  chat.collection('messages').doc().set({
                    'message':
                        message.message!.isNotEmpty ? message.message : '',
                    'sender': uid,
                    'to': userId,
                    'media': url,
                    'mediaType': message.mediaType,
                    'isRead': false,
                    'sentAt': FieldValue.serverTimestamp()
                  })
                }
            });
      });
    } else {
      final chat =
          FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

      chat.get().then((value) => {
            if (value.exists)
              {
                chat.update({
                  'latestMessage': message.message ?? 'photo',
                  'sentAt': FieldValue.serverTimestamp(),
                  'sentBy': uid,
                }),
                chat.collection('messages').doc().set({
                  'message': message.message ?? '',
                  'sender': uid,
                  'to': userId,
                  'media': url,
                  'mediaType': message.mediaType,
                  'isRead': false,
                  'sentAt': FieldValue.serverTimestamp()
                })
              }
            else
              {
                chat.set({
                  'initiator': uid,
                  'receiver': userId,
                  'startedAt': FieldValue.serverTimestamp(),
                  'latestMessage':
                      message.message!.isNotEmpty ? message.message : '',
                  'sentAt': FieldValue.serverTimestamp(),
                  'sentBy': uid,
                }),
                chat.collection('messages').doc().set({
                  'message': message.message!.isNotEmpty ? message.message : '',
                  'sender': uid,
                  'to': userId,
                  'media': url,
                  'mediaType': message.mediaType,
                  'isRead': false,
                  'sentAt': FieldValue.serverTimestamp()
                })
              }
          });
    }
  }
}
