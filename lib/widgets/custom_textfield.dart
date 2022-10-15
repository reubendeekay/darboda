import 'package:darboda/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.errorText,
      this.labelText,
      required this.hintText})
      : super(key: key);
  final TextEditingController controller;
  final String? errorText;
  final String hintText;
  final String? labelText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        if (val!.isEmpty) {
          return widget.errorText ?? 'Field cannot be empty';
        }

        return null;
      },
      style: const TextStyle(color: Colors.black, fontSize: 14),
      maxLength: null,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        labelText: widget.labelText ?? widget.hintText,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF1A1A1A).withOpacity(0.2494),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF1A1A1A).withOpacity(0.2494),
        ),
        focusedBorder: focusedBorder,
        border: outlineBorder,
        errorBorder: errorBorder,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
          borderSide: BorderSide(
            color: const Color(0xFF1A1A1A).withOpacity(0.1),
            width: 1.sp,
          ),
        ),
      ),
    );
  }
}
