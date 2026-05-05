import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insins/features/shipping/presentation/widgets/city_dropdown_field.dart';

class ShippingForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final GlobalKey<FormState>? formKey;
  final Key? nameKey;
  final Key? phoneKey;
  final Key? cityKey;
  final Key? addressKey;

  const ShippingForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    this.formKey,
    this.nameKey,
    this.phoneKey,
    this.cityKey,
    this.addressKey,
  });

  @override
  State<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          _buildTextField(
            fieldKey: widget.nameKey,
            label: "الاسم الكريم",
            hint: "الاسم الثنائي",
            icon: Icons.person_outline,
            controller: widget.nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "يرجى إدخال الاسم";
              }
              if (value.trim().split(" ").length < 2) {
                return "يرجى إدخال الاسم الثنائي";
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          _buildTextField(
            fieldKey: widget.phoneKey,
            label: "رقم الجوال",
            hint: "05xxxxxxxx",
            icon: Icons.phone_android_outlined,
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "يرجى إدخال رقم الجوال";
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          CityDropdownField(fieldKey: widget.cityKey),
          SizedBox(height: 15.h),
          _buildTextField(
            fieldKey: widget.addressKey,
            label: "العنوان التفصيلي",
            hint: "اسم الحي، الشارع، رقم المنزل...",
            icon: Icons.home_outlined,
            controller: widget.addressController,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "يرجى إدخال العنوان التفصيلي";
              }
              if (value.trim().length < 8) {
                return "العنوان قصير جداً";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "بيانات الشحن والدفع",
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo'),
        ),
        SizedBox(width: 8.w),
        Icon(Icons.local_shipping_outlined,
            size: 22.sp, color: Colors.grey[700]),
      ],
    );
  }

  Widget _buildTextField({
    Key? fieldKey,
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      key: fieldKey,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.sp, fontFamily: 'Cairo', color: Colors.grey[600])),
        SizedBox(height: 6.h),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                  fontFamily: 'Cairo'),
              prefixIcon: Icon(icon, size: 20.sp, color: Colors.grey[400]),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
            ),
          ),
        ),
      ],
    );
  }
}
