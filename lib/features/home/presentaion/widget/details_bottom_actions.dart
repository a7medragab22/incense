import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsBottomActions extends StatefulWidget {
  final Function(int quantity) onAddToCart;
  final VoidCallback onWhatsApp;

  const DetailsBottomActions({
    super.key,
    required this.onAddToCart,
    required this.onWhatsApp,
  });

  @override
  State<DetailsBottomActions> createState() => _DetailsBottomActionsState();
}

class _DetailsBottomActionsState extends State<DetailsBottomActions> {
  int quantity = 1;

  Future<void> _launchWhatsApp() async {
    const String phoneNumber = "966503606971";
    const String message = "السلام عليكم، أريد الاستفسار عن هذا المنتج";

    final Uri whatsappUri = Uri.parse(
        "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");

    final Uri fallbackUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    try {
      bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );

      if (!launched) {
        await launchUrl(fallbackUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      await launchUrl(fallbackUri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          // زر الواتساب
          _buildIconButton(
            FontAwesomeIcons.whatsapp,
            const Color(0xFF25D366),
            () {
              _launchWhatsApp();
              widget.onWhatsApp();
            },
          ),

          SizedBox(width: 12.w),

          // ─── متحكم الكمية ───
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                _buildSmallActionBtn(Icons.add, () {
                  setState(() => quantity++);
                }),
                SizedBox(width: 12.w),
                Text(
                  "$quantity",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(width: 12.w),
                _buildSmallActionBtn(Icons.remove, () {
                  if (quantity > 1) {
                    setState(() => quantity--);
                  }
                }),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // زر إضافة للسلة
          Expanded(
            child: ElevatedButton(
              onPressed: () => widget.onAddToCart(quantity),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                "إضافة للسلة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 22.sp),
      ),
    );
  }

  Widget _buildSmallActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20.sp, color: Colors.grey[700]),
    );
  }
}
