import 'package:darboda/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.text,
      this.onTap,
      this.color = kPrimaryColor,
      this.isLoading = false})
      : super(key: key);

  final String text;
  final Function? onTap;
  final Color? color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null && !isLoading) {
          onTap!();
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(5.w),
        child: Container(
          height: 49.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 25.h,
                    width: 25.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
