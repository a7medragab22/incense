// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:insins/features/checkout/data/models/order_model.dart';
// import 'package:insins/features/checkout/logic/cubit/checkout_cubit.dart';
// import 'package:insins/features/checkout/logic/cubit/checkout_state.dart';
// import 'package:insins/features/checkout/data/models/checkout_model.dart';
// import 'package:insins/features/home/logic/cart_cubit/cubit/cart_cubit.dart';
// import 'package:insins/features/home/logic/cart_cubit/cubit/cart_state.dart';
// import 'package:insins/features/shipping/logic/shipping_cubit/cubit/shipping_cubit.dart';
// import 'package:insins/features/shipping/logic/shipping_cubit/cubit/shipping_state.dart';
// import 'package:insins/features/shipping/presentation/widgets/shippin_form.dart';
// import 'package:insins/features/shipping/presentation/widgets/payment_method.dart';
// import 'package:insins/features/shipping/presentation/widgets/custom_action_button.dart';

// // حولناها لـ StatefulWidget عشان نعرف نتحكم في الـ Controllers
// class CheckoutViewBody extends StatefulWidget {
//   final VoidCallback onBack;

//   const CheckoutViewBody({
//     super.key,
//     required this.onBack,
//   });

//   @override
//   State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
// }

// class _CheckoutViewBodyState extends State<CheckoutViewBody> {
//   // 1. تعريف الـ Controllers هنا عشان نسحب منهم القيم وقت الضغط على الزرار
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CheckoutCubit, CheckoutState>(
//       listener: (context, state) {
//         if (state is CheckoutSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text("تم تأكيد طلبك بنجاح!"),
//                 backgroundColor: Colors.green),
//           );
//           // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//         }

//         if (state is CheckoutFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 state.errMessage.contains("timeout")
//                     ? "عذراً، الاتصال بالخادم ضعيف حالياً"
//                     : state.errMessage,
//                 style: const TextStyle(fontFamily: 'Cairo'),
//               ),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return SingleChildScrollView(
//           // عشان الكيبورد لما يفتح
//           child: Column(
//             children: [
//               // 2. مرر الـ Controllers للـ ShippingForm (تأكد من تعديل الـ Constructor هناك ليقبلهم)
//               ShippingForm(
//                 nameController: nameController,
//                 phoneController: phoneController,
//                 addressController: addressController,
//               ),

//               SizedBox(height: 25.h),
//               const PaymentSection(),
//               SizedBox(height: 25.h),

//               CustomActionButton(
//                 text: "تأكيد الطلب",
//                 color: const Color(0xFF1D1D1D),
//                 icon: Icons.arrow_forward,
//                 isLoading: state is CheckoutLoading,
//                 onTap: () {
//                   final shippingState = context.read<ShippingCubit>().state;
//                   final cartState = context.read<CartCubit>().state;

//                   if (shippingState is ShippingSuccess &&
//                       cartState is CartLoaded) {
//                     final selectedCity = shippingState.selectedCity;

//                     if (selectedCity != null) {
//                       // 3. بناء الـ Request باستخدام الـ Controllers مباشرة
//                       final request = CheckoutRequest(
//                         customerName: nameController.text, // من الـ Controller
//                         customerPhone:
//                             phoneController.text, // من الـ Controller
//                         city: selectedCity.cityName ?? "",
//                         address: addressController.text, // من الـ Controller
//                         paymentMethod: "cash", // أو هاته من اختيار المستخدم

//                         items: cartState.items
//                             .map((item) => OrderItem(
//                                   productId: int.tryParse(item.id.toString()) ??
//                                       0, // حل مشكلة int
//                                   quantity: item.quantity,
//                                   price:
//                                       double.tryParse(item.price.toString()) ??
//                                           0.0,
//                                   productName: item.name,
//                                 ))
//                             .toList(),
//                       );

//                       // تنفيذ الطلب
//                       context.read<CheckoutCubit>().submitOrder(request);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text("برجاء اختيار المدينة أولاً")),
//                       );
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content:
//                               Text("تأكد من استكمال البيانات وجودة الإنترنت")),
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: 15.h),
//               TextButton(
//                 onPressed: widget.onBack,
//                 child: Text(
//                   "تعديل الطلب",
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     color: Colors.grey,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insins/features/checkout/data/models/order_model.dart';
import 'package:insins/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:insins/features/checkout/logic/cubit/checkout_state.dart';
import 'package:insins/features/checkout/data/models/checkout_model.dart';
import 'package:insins/features/home/logic/cart_cubit/cubit/cart_cubit.dart';
import 'package:insins/features/home/logic/cart_cubit/cubit/cart_state.dart';
import 'package:insins/features/shipping/logic/shipping_cubit/cubit/shipping_cubit.dart';
import 'package:insins/features/shipping/logic/shipping_cubit/cubit/shipping_state.dart';
import 'package:insins/features/shipping/presentation/widgets/shippin_form.dart';
import 'package:insins/features/shipping/presentation/widgets/payment_method.dart';
import 'package:insins/features/shipping/presentation/widgets/custom_action_button.dart';
import 'package:go_router/go_router.dart';
import 'package:insins/core/router/routes.dart';
import 'package:insins/features/shipping/presentation/payment_details_view.dart';
import 'package:insins/core/widgets/price_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutViewBody extends StatefulWidget {
  final VoidCallback onBack;
  const CheckoutViewBody({super.key, required this.onBack});

  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  // الكنترولرز بتوعنا عشان نسحب منهم الداتا للفورم
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isOrderCompleted = false;
  String selectedPaymentMethod = "COD";

  // مفاتيح للحقول عشان نعرف نعمل سكرول ليهم
  final GlobalKey nameKey = GlobalKey();
  final GlobalKey phoneKey = GlobalKey();
  final GlobalKey cityKey = GlobalKey();
  final GlobalKey addressKey = GlobalKey();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          setState(() {
            _isOrderCompleted = true;
          });
          // تنظيف السلة فور نجاح الطلب
          context.read<CartCubit>().clearCart();

          // التحقق إذا كان هناك رابط دفع (تمارا أو تابي)
          // بنجرب نسحب الداتا سواء كانت في الروت أو جوه أوبجيكت data
          final responseData = state.response['data'] ?? state.response;
          final paymentUrl = responseData['checkoutUrl'] ??
              responseData['payment_url'] ??
              responseData['link'] ??
              responseData['payment_type'];

          if (paymentUrl != null &&
              paymentUrl.toString().contains('http') &&
              selectedPaymentMethod == "Tamara") {
            _launchPaymentUrl(paymentUrl.toString());
          } else {
            // إظهار الديالوج الرائع للطلبات العادية
            _showSuccessDialog(context);
          }
        }
        if (state is CheckoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.errMessage), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        // بنستخدم context.watch عشان الـ UI يتحدث أول ما نختار مدينة أو السعر يتغير
        final cartState = context.watch<CartCubit>().state;
        final shippingState = context.watch<ShippingCubit>().state;

        // حساب الحسبة الحقيقية
        double subtotal =
            (cartState is CartLoaded) ? cartState.totalPrice : 0.0;
        double shipping = (shippingState is ShippingSuccess)
            ? (shippingState.selectedCity?.price ?? 0.0)
            : 0.0;
        double total = subtotal + shipping;

        return SingleChildScrollView(
          child: Column(
            children: [
              ShippingForm(
                nameController: nameController,
                phoneController: phoneController,
                addressController: addressController,
                formKey: _formKey,
                nameKey: nameKey,
                phoneKey: phoneKey,
                cityKey: cityKey,
                addressKey: addressKey,
              ),
              SizedBox(height: 20.h),
              PaymentSection(
                selectedMethod: selectedPaymentMethod,
                onMethodChanged: (method) {
                  setState(() {
                    selectedPaymentMethod = method;
                  });
                },
              ),
              SizedBox(height: 30.h),

              // --- الجزء اللي رجعناه: ملخص الطلب ---
              _buildOrderSummary(subtotal, shipping, total),

              SizedBox(height: 20.h),

              CustomActionButton(
                text: "تأكيد الطلب",
                color: const Color(0xFF1D1D1D),
                icon: Icons.arrow_forward,
                isLoading: state is CheckoutLoading,
                // منع الضغط مرة تانية لو الطلب تم بنجاح
                onTap: _isOrderCompleted
                    ? () {}
                    : () => _handleOrderSubmission(context),
              ),

              SizedBox(height: 10.h),
              TextButton(
                onPressed: widget.onBack,
                child: Text(
                  "تعديل الطلب",
                  style: TextStyle(
                      fontFamily: 'Cairo', color: Colors.grey, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ويدجت ملخص الطلب اللي في الصورة
  Widget _buildOrderSummary(double subtotal, double shipping, double total) {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "ملخص الطلب",
            style: TextStyle(
                fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Text(
            "راجع منتجاتك قبل التأكيد",
            style: TextStyle(
                fontFamily: 'Cairo', color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 15.h),
          _summaryRow("المجموع الفرعي", subtotal),
          SizedBox(height: 10.h),
          _summaryRow("الشحن", shipping),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(color: Colors.grey[200]),
          ),
          _summaryRow("الإجمالي", total, isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, num price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PriceWidget(
          price: price,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _handleOrderSubmission(BuildContext context) {
    final shippingState = context.read<ShippingCubit>().state;
    final cartState = context.read<CartCubit>().state;

    // تحقق من صحة جميع الحقول
    if (!(_formKey.currentState?.validate() ?? false)) {
      // البحث عن أول حقل به خطأ لسكرول إليه
      if (nameController.text.trim().split(" ").length < 2) {
        _scrollToField(nameKey);
      } else if (phoneController.text.trim().isEmpty) {
        _scrollToField(phoneKey);
      } else if (shippingState is ShippingSuccess &&
          shippingState.selectedCity == null) {
        _scrollToField(cityKey);
      } else if (addressController.text.trim().length < 8) {
        _scrollToField(addressKey);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى تعبئة جميع البيانات بشكل صحيح")),
      );
      return;
    }

    if (shippingState is ShippingSuccess && cartState is CartLoaded) {
      if (shippingState.selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("يرجى اختيار المدينة")),
        );
        return;
      }
      final request = CheckoutRequest(
        customerName: nameController.text,
        customerPhone: phoneController.text,
        city: shippingState.selectedCity?.cityName ?? "",
        address: addressController.text,
        paymentMethod: selectedPaymentMethod,
        items: cartState.items
            .map((e) => OrderItem(
                  productId: int.parse(e.id.toString()),
                  quantity: e.quantity,
                  price: e.price,
                  productName: e.name,
                ))
            .toList(),
      );

      if (selectedPaymentMethod == "COD" || selectedPaymentMethod == "Tamara") {
        // دفع عند الاستلام أو تمارا (تحويل مباشر)
        context.read<CheckoutCubit>().submitOrder(request);
      } else {
        final checkoutCubit = context.read<CheckoutCubit>();
        // الفيزا والوسائل الأخرى اللي محتاجة بيانات
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PaymentDetailsView(
              method: selectedPaymentMethod,
              customerName: request.customerName,
              customerPhone: request.customerPhone,
              city: request.city,
              address: request.address,
              items: request.items,
              onConfirm: (finalRequest) {
                checkoutCubit.submitOrder(finalRequest);
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("تأكد من استكمال البيانات وجودة الإنترنت")),
      );
    }
  }

  // دالة مساعدة لعمل السكرول للحقل المطلوب
  void _scrollToField(GlobalKey key) {
    // استراحة بسيطة عشان الحقول تاخد مكانها الجديد بعد ظهور رسالة الخطأ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  // ديالوج النجاح
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle,
                    color: const Color(0xFF2DBB54), size: 60.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                "تم تأكيد الطلب بنجاح",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "شكراً لتسوقك معنا، سيصلك رقم التتبع فور شحن الطلبية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("Success Dialog: Home button pressed");
                    // محاولة التوجيه باستخدام الطريقة الأكثر أماناً
                    try {
                      GoRouter.of(context).go(AppRoutes.homeScreen);
                    } catch (e) {
                      debugPrint("Navigation Error: $e");
                      // Fallback لو في مشكلة في GoRouter
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.homeScreen);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D1D1D),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    "العودة للرئيسية",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لفتح رابط الدفع
  Future<void> _launchPaymentUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("عذراً، لم نتمكن من فتح رابط الدفع")),
        );
      }
    }
  }
}
