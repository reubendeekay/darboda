// ignore_for_file: library_private_types_in_public_api

import 'package:darboda/constants.dart';
import 'package:darboda/models/message_model.dart';
import 'package:darboda/providers/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';

class AddMessage extends StatefulWidget {
  final String userId;
  final String chatRoom;
  const AddMessage({Key? key, required this.userId, required this.chatRoom})
      : super(key: key);

  @override
  _AddMessageState createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  final TextEditingController messageController = TextEditingController();
  List<Media> mediaList = [];

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.grey[300]),
              child: TextField(
                controller: messageController,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    border: InputBorder.none,
                    prefixIcon: GestureDetector(
                        onTap: () => openImagePicker(context),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.camera_alt_rounded,
                              color: kPrimaryColor),
                        )),
                    hintText: 'Message',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: kPrimaryColor,
            child: IconButton(
              splashRadius: 25,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                if (messageController.text.isEmpty) {
                  return;
                }
                Provider.of<ChatProvider>(context, listen: false).sendMessage(
                    widget.userId,
                    MessageModel(
                      mediaFiles: [],
                      mediaType: '',
                      message: messageController.text,
                      senderId: FirebaseAuth.instance.currentUser!.uid,
                      receiverId: widget.userId,
                    ),
                    widget.chatRoom);
                messageController.clear();
              },
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }

  void openImagePicker(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);
                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeText: 'Change',
                      ),
                    )),
              ));
        }).then((_) async {
      if (mediaList.isNotEmpty) {
        double mediaSize =
            mediaList.first.file!.readAsBytesSync().lengthInBytes /
                (1024 * 1024);

        if (mediaSize < 1.0001) {
          for (var element in mediaList) {
            Provider.of<ChatProvider>(context, listen: false).sendMessage(
                widget.userId,
                MessageModel(
                  message: '',
                  mediaFiles: [element.file!],
                  mediaType:
                      element.mediaType == MediaType.image ? 'image' : 'video',
                  senderId: FirebaseAuth.instance.currentUser!.uid,
                  receiverId: widget.userId,
                ),
                widget.chatRoom);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image should be less than 1 MB')));
        }
      }
    });
  }
}
