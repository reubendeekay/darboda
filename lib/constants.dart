import 'package:flutter/material.dart';

const kPrimaryColor = Colors.black;
const kSecondaryColor = Colors.purple;

final kBorder = const Color(0xFF1A1A1A).withOpacity(0.1);
const kDark = Color(0xff264653);

OutlineInputBorder outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    color: const Color(0xFF1A1A1A).withOpacity(0.1),
    width: 1,
  ),
);
UnderlineInputBorder inputBorder = const UnderlineInputBorder(
  borderSide: BorderSide(
    color: kDark,
    width: 1,
  ),
);

OutlineInputBorder focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    color: kDark,
    width: 1,
  ),
);

OutlineInputBorder errorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    color: Colors.red,
    width: 1,
  ),
);

List<Map> onboardingTitles = [
  {
    'title': 'Welcome to Darboda',
    'description':
        'Darboda is a platform that connects you to the best bodas in your area. Enjoy the convenience of the most popular, fastest and preferred method of transport at the click of a button',
    'image': 'assets/images/onboarding1.jpeg'
  },
  {
    'title': 'A Boda for yourself or parcels',
    'description':
        'Get a boda in a few clicks. Choose your preferred boda and get a ride to your destination. The best part you can transport your goods faster and securely with no paperwork',
    'image': 'assets/images/onboarding2.webp',
  },
  {
    'title': 'Thank you for choosing us',
    'description':
        'Choosing us is choosing reliability, accountability and exceptional service. We welcome you to a large community of riders waiting to serve you. Again Karibu Sana!',
    'image': 'assets/images/onboarding3.jpeg',
  }
];
