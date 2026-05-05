import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuSectionHeader extends StatelessWidget {
  final String title;
  final double? fontSize;
  final VoidCallback? onTap;

  const MenuSectionHeader({
    super.key,
    required this.title,
    this.fontSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 16.sp,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
