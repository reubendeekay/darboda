import 'package:cached_network_image/cached_network_image.dart';
import 'package:darboda/constants.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/widgets/custom_textfield.dart';
import 'package:darboda/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user!;

    //Initialize the controllers with the current of user
    nameController.text = user.name!;

    phoneController.text = user.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          elevation: 0.4,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profilePic!),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: kPrimaryColor,
                              size: 14,
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                    child: Text('Change Profile Picture',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 3,
                ),
                const Center(
                    child: Text(
                  'Your profile picture is displayed to all riders on request',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  hintText: 'Full name',
                  labelText: 'Full name',
                  controller: nameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hintText: 'Phone number',
                  labelText: 'Phone number',
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
            Positioned(
                bottom: 15,
                right: 15,
                left: 15,
                child: PrimaryButton(
                  text: 'Save changes',
                  onTap: () {},
                ))
          ],
        ));
  }
}
