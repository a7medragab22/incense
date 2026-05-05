import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool hasArrow;

  const DrawerItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.hasArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white10,
      highlightColor: Colors.white10,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 30.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasArrow)
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white54,
                size: 16.sp,
              )
            else
              const SizedBox(),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
