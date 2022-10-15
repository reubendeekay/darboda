// ignore_for_file: library_private_types_in_public_api

import 'package:darboda/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.setVolume(0);
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller.value.size.height,
                width: _controller.value.size.width,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'DARBODA',
                  style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.black12,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Spacer(),
                Text(
                  'CONNECTING CUSTOMERS TO BODABODAS',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                      fontSize: 50,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.black12,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'giving you the convenience of booking a bodaboda from the comfort of your home',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                      fontSize: 16,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.black12,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const Spacer(),
                Hero(
                  tag: 'login-page',
                  transitionOnUserGestures: true,
                  child: SizedBox(
                    height: 48.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const AuthScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const AuthScreen());
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
