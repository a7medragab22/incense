import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceWidget extends StatelessWidget {
  final num price;
  final TextStyle? style;
  final double? iconSize;

  const PriceWidget({
    super.key,
    required this.price,
    this.style,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style ?? TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'Cairo',
          color: const Color(0xFFD4A056),
        ),
        children: [
          TextSpan(text: "$price "),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(
              'assets/images/rial_coin.png',
              width: iconSize ?? (style?.fontSize ?? 16.sp),
              height: iconSize ?? (style?.fontSize ?? 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
