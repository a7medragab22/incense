import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentSection extends StatefulWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "طريقة الدفع",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: const Color(0xFF1D1D1D),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _buildOption(
            "Paymob_Cards", "بطاقة ائتمان", null, const Color(0xFF1A1F71),
            imagePath: 'assets/images/mastercard.png'),
        _buildOption("Paymob_ApplePay", "Apple Pay", FontAwesomeIcons.applePay,
            Colors.black),
        _buildOption("Tamara", "قسّطها مع تمارا (تمارا)", Icons.credit_card,
            const Color(0xFFE47C25)),
        _buildOption("COD", "الدفع عند الاستلام (كاش)", Icons.money_outlined,
            const Color(0xFF2DBB54)),
      ],
    );
  }

  Widget _buildOption(
      String value, String title, IconData? icon, Color iconColor,
      {String? imagePath}) {
    bool isSelected = widget.selectedMethod == value;
    return GestureDetector(
      onTap: () => widget.onMethodChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[50],
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2DBB54) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF2DBB54) : Colors.grey[300]!,
                  width: 2,
                ),
                color:
                    isSelected ? const Color(0xFF2DBB54) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF1D1D1D) : Colors.grey[700],
              ),
            ),
            SizedBox(width: 14.w),
            imagePath != null
                ? Image.asset(imagePath,
                    height: 35.h, width: 50.w, fit: BoxFit.contain)
                : Icon(icon,
                    color: isSelected ? iconColor : Colors.grey[400],
                    size: 24.sp),
          ],
        ),
      ),
    );
  }
}
