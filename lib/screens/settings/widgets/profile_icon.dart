import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/screens/settings/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    return GestureDetector(
      onTap: () {
        Get.to(() => const EditProfileScreen());
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.profilePic!),
              backgroundColor: Colors.grey[50],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 2.5,
          ),
          Text(
            user.phoneNumber!,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
