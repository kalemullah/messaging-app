import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.onPressed,
      this.text,
      this.height,
      this.width,
      this.isloading = false,
      this.color});

  final onPressed;
  final text;
  final height;
  final width;
  final color;
  final isloading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: isloading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  text ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
