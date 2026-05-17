import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insins/features/checkout/data/models/checkout_model.dart';
import 'package:insins/features/checkout/data/models/order_model.dart';

class PaymentDetailsView extends StatefulWidget {
  final String method;
  final String customerName;
  final String customerPhone;
  final String city;
  final String address;
  final List<OrderItem> items;
  final Function(CheckoutRequest) onConfirm;

  const PaymentDetailsView({
    super.key,
    required this.method,
    required this.customerName,
    required this.customerPhone,
    required this.city,
    required this.address,
    required this.items,
    required this.onConfirm,
  });

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getTitle(),
          style: TextStyle(
            color: const Color(0xFF1D1D1D),
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1D1D1D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.method == "Visa") _buildCardMockup(),
            if (widget.method == "ApplePay") _buildApplePayView(),
            if (widget.method == "Tamara") _buildTamaraView(),
            SizedBox(height: 30.h),
            if (widget.method == "Visa") _buildCreditCardForm(),
            SizedBox(height: 40.h),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.method) {
      case "Visa":
        return "بيانات البطاقة";
      case "ApplePay":
        return "Apple Pay";
      case "Tamara":
        return "تقسيط تمارا";
      default:
        return "إتمام الدفع";
    }
  }

  Widget _buildCardMockup() {
    return Container(
      height: 200.h,
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(FontAwesomeIcons.solidCreditCard,
                  color: Colors.white.withValues(alpha: 0.8), size: 30.sp),
              Text(
                "Mastercard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            cardNumberController.text.isEmpty
                ? "**** **** **** ****"
                : cardNumberController.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CARD HOLDER",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10.sp)),
                  Text(
                    cardHolderController.text.isEmpty
                        ? "FULL NAME"
                        : cardHolderController.text.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("EXPIRES",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10.sp)),
                  Text(
                    expiryController.text.isEmpty
                        ? "MM/YY"
                        : expiryController.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Column(
      children: [
        _buildTextField(
            "اسم صاحب البطاقة", cardHolderController, Icons.person_outline),
        SizedBox(height: 16.h),
        _buildTextField("رقم البطاقة", cardNumberController, Icons.credit_card,
            keyboardType: TextInputType.number),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
                child: _buildTextField("CVV", cvvController, Icons.lock_outline,
                    keyboardType: TextInputType.number)),
            SizedBox(width: 16.w),
            Expanded(
                child: _buildTextField("تاريخ الانتهاء", expiryController,
                    Icons.calendar_today_outlined,
                    hint: "MM/YY")),
          ],
        ),
      ],
    );
  }

  Widget _buildApplePayView() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(FontAwesomeIcons.applePay, size: 100.sp, color: Colors.black),
          SizedBox(height: 20.h),
          Text(
            "سيتم إتمام الدفع عبر Apple Pay بأمان",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildTamaraView() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFFE47C25).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFE47C25)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.payment, color: Color(0xFFE47C25)),
              const Spacer(),
              Text(
                "قسّمها مع تمارا",
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _tamaraRow("دفعة اليوم", "33%"),
          _tamaraRow("بعد شهر", "33%"),
          _tamaraRow("بعد شهرين", "34%"),
          SizedBox(height: 20.h),
          const Divider(),
          SizedBox(height: 20.h),
          _buildTextField("رقم الجوال المسجل في تمارا", cardHolderController,
              Icons.phone_android_outlined,
              keyboardType: TextInputType.phone),
        ],
      ),
    );
  }

  Widget _tamaraRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 13.sp, color: Colors.grey[600])),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          onChanged: (v) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF2DBB54), size: 20.sp),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          final request = CheckoutRequest(
            customerName: widget.customerName,
            customerPhone: widget.customerPhone,
            city: widget.city,
            address: widget.address,
            paymentMethod: widget.method,
            items: widget.items,
          );

          if (widget.method == "Tamara") {
            // Tamara case (fallback if not handled in checkout screen)
            widget.onConfirm(request);
            Navigator.pop(context);
          } else {
            widget.onConfirm(request);
            Navigator.pop(context); // العودة بعد التأكيد
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D1D1D),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          elevation: 0,
        ),
        child: Text(
          "تأكيد الدفع",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }
}
