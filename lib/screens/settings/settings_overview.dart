import 'package:darboda/constants.dart';
import 'package:darboda/screens/history/my_rides_screen.dart';
import 'package:darboda/screens/settings/notifications_screen.dart';

import 'package:darboda/screens/settings/privacy_settings.dart';
import 'package:darboda/screens/settings/support_widget.dart';
import 'package:darboda/screens/settings/widgets/profile_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class SettingsOverview extends StatelessWidget {
  const SettingsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const ProfileIcon(),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            ...List.generate(settings.length,
                (index) => settingTile(settings[index], context)),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Become a driver',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text('Earn money on your schedule',
                      style: TextStyle(color: Colors.grey[200])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget settingTile(Map<String, dynamic> data, BuildContext context) {
    return ListTile(
      leading: Icon(
        data['icon'],
        size: 24,
      ),
      title: Text(
        data['title'],
      ),
      onTap: () {
        if (data['title'] == 'Support') {
          Get.bottomSheet(const SupportWidget(),
              isDismissible: true,
              backgroundColor: Colors.white,
              isScrollControlled: true);
        } else {
          data['onTap']();
        }
      },
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 16,
      ),
    );
  }
}

List<Map<String, dynamic>> settings = [
  {
    'title': 'Promotions',
    'icon': Icons.sell_outlined,
    'onTap': () {
      Get.to(() => const NotificationsScreen());
    },
  },
  {
    'title': 'My Rides',
    'icon': Icons.motorcycle,
    'onTap': () {
      Get.to(() => const MyRidesScreen());
    },
  },
  {
    'title': 'Security',
    'icon': Iconsax.security,
    'onTap': () {
      Get.to(() => const PrivacySettings());
    },
  },
  {
    'title': 'Support',
    'icon': Iconsax.info_circle,
    'onTap': () {},
  },
  {
    'title': 'Logout',
    'icon': Iconsax.logout,
    'onTap': () {
      FirebaseAuth.instance.signOut().then(
            (value) => Get.offAllNamed('/'),
          );
    },
  },
];
