import 'package:darboda/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    backgroundColor: Colors.grey[50],
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        titleTextStyle: GoogleFonts.ibmPlexSans(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        iconTheme: const IconThemeData(color: Colors.black)),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: kPrimaryColor, selectionColor: kPrimaryColor),
    textTheme: Typography.englishLike2021.apply(
        fontSizeFactor: 1,
        bodyColor: Colors.black,
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily),
    primaryColor: kPrimaryColor,
  );
}
