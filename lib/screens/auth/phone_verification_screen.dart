// ignore_for_file: use_build_context_synchronously

import 'package:darboda/loading_screen.dart';
import 'package:darboda/models/user_model.dart';
import 'package:darboda/providers/auth_provider.dart';
import 'package:darboda/widgets/primary_button.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen(
      {Key? key, required this.user, this.isSignUp = false})
      : super(
          key: key,
        );
  final UserModel user;
  final bool isSignUp;

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {});
  }

  bool isResend = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FirebasePhoneAuthHandler(
          phoneNumber: widget.user.phoneNumber!,
          builder: (context, controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 104.h,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        'Enter your verification code',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.workSans().fontFamily,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Enter the 6-digit code we have sent to',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: GoogleFonts.workSans().fontFamily,
                        ),
                      ),
                      Text(
                        widget.user.phoneNumber!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: GoogleFonts.workSans().fontFamily,
                        ),
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      Pinput(
                        onCompleted: (pin) async {
                          setState(() {
                            isLoading = true;
                          });
                          final isCorrect = await controller.verifyOtp(pin);
                          if (isCorrect) {
                            if (widget.isSignUp) {
                              try {
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .signUp(widget.user);
                                Get.offAll(() => const InitialLoadingScreen());
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              }
                            } else {
                              Get.offAll(() => const InitialLoadingScreen());
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                'Invalid Code',
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        listenForMultipleSmsOnAndroid: true,
                        length: 6,
                      ),
                      SizedBox(height: 41.h),
                      Text(
                        'Didn’t receive the code?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.workSans().fontFamily,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Resend code in '),
                          Text(controller.autoRetrievalTimeLeft.inSeconds
                              .toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PrimaryButton(
                      text: 'Resend Code',
                      isLoading: isLoading,
                      onTap: () async {
                        controller.autoRetrievalTimeLeft.inSeconds < 1
                            ? controller.sendOTP()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please wait for the code to be sent')));
                      }),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            );
          }),
    );
  }
}
