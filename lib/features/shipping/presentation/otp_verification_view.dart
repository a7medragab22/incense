import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/tamara_terms_text.dart';

class OtpVerificationView extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerify;

  const OtpVerificationView({
    super.key,
    required this.phoneNumber,
    required this.onVerify,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String _currentCode = "4823";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        // Generate a random 4-digit code
        _currentCode =
            (1000 + (DateTime.now().millisecond * 9) % 9000).toString();
      });
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إعادة إرسال رمز التحقق الجديد",
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Color(0xFFA143D3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  void _verifyCode() {
    String code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
      // Simulate verification delay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator(color: Colors.black)),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pop(context); // Close loading
        Navigator.pop(context); // Close OtpVerificationView
        widget.onVerify(); // Trigger confirm callback
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 30.h),
            Text(
              "تحقق من رقمك",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            _buildPhoneContainer(),
            SizedBox(height: 20.h),
            Text(
              "لقد أرسلنا للتو رمز التحقق عبر الرسائل القصيرة",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30.h),
            _buildOtpRow(),
            SizedBox(height: 40.h),
            _buildResendBadge(),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Code: $_currentCode",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 100.h),
            _buildFooter(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.all(8.w),
                ),
              ),
              SizedBox(width: 12.w),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              SizedBox(width: 12.w),
              Text(
                "English",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Text(
            "تمارا",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.phoneNumber.isEmpty
                    ? "966 50 8961928"
                    : widget.phoneNumber,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1,
                ),
                textDirection: TextDirection.ltr,
              ),
              SizedBox(width: 12.w),
              Icon(Icons.phone_iphone_outlined,
                  color: Colors.black, size: 24.sp),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "تبي تغير الرقم؟",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              color: const Color(0xFFA143D3), // Tamara Purple color
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 55.w,
          height: 65.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _onOtpChanged(value, index),
          ),
        ),
      ),
    );
  }

  void _showTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "شروط وأحكام",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "تم التحديث في: 18 يوليو 2023",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildSection(TamaraTerms.terms),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 55.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  "يوافق",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14.sp,
          color: Colors.black87,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildResendBadge() {
    String timerText = "00:${_secondsRemaining.toString().padLeft(2, '0')}";

    return Center(
      child: InkWell(
        onTap: _canResend ? _resendOtp : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _canResend
                ? const Color(0xFFA143D3).withValues(alpha: 0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(20.r),
            border: _canResend
                ? Border.all(
                    color: const Color(0xFFA143D3).withValues(alpha: 0.3))
                : null,
          ),
          child: Text(
            _canResend ? "إعادة إرسال الرمز" : "إعادة الإرسال في $timerText",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              color: _canResend ? const Color(0xFFA143D3) : Colors.grey[600],
              fontWeight: _canResend ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          children: [
            const TextSpan(text: "باختيارك للمتابعة، فأنت توافق على "),
            TextSpan(
              text: "شروط وأحكام",
              style: const TextStyle(
                color: Color(0xFFA143D3), // Tamara Purple color
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = _showTermsAndConditions,
            ),
            const TextSpan(text: " تمارا"),
          ],
        ),
      ),
    );
  }
}
