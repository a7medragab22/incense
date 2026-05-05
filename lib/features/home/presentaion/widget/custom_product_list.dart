import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insins/core/widgets/price_widget.dart';

class VerticalProductCard extends StatefulWidget {
  final dynamic product;
  final Function(int quantity) onAdd;
  final VoidCallback onTap;

  const VerticalProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onTap,
  });

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}

class _VerticalProductCardState extends State<VerticalProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. الصورة
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: AspectRatio(
                aspectRatio: 1.1,
                child: Image.network(
                  "https://incense-sa.com/${widget.product.imageUrl ?? ''}",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 50.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 2. الاسم
                  Text(
                    widget.product.nameAr ?? 'اسم غير متوفر',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: const Color(0xFF4A1D1D),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // 3. السعر
                  PriceWidget(
                    price: widget.product.price ?? 0,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                      color: const Color(0xFFD4A056),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Availability Status

                  // ─── متحكم الكمية ───
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQtyBtn(Icons.add, () {
                          if (widget.product.isAvailable ?? true) {
                            setState(() => quantity++);
                          }
                        }),
                        SizedBox(width: 10.w),
                        Text(
                          "$quantity",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _buildQtyBtn(Icons.remove, () {
                          if (quantity > 1 &&
                              (widget.product.isAvailable ?? true)) {
                            setState(() => quantity--);
                          }
                        }),
                        const Spacer(),
                        Text(
                          (widget.product.isAvailable ?? true)
                              ? 'متوفر'
                              : 'غير متوفر',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: (widget.product.isAvailable ?? true)
                                ? const Color(0xFF2DBB54)
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // 4. زر الإضافة
                  SizedBox(
                    width: double.infinity,
                    height: 45.h,
                    child: ElevatedButton.icon(
                      onPressed: (widget.product.isAvailable ?? true)
                          ? () => widget.onAdd(quantity)
                          : null,
                      icon: Icon(Icons.add_shopping_cart,
                          color: Colors.white, size: 18.sp),
                      label: Text(
                        (widget.product.isAvailable ?? true)
                            ? "إضافة للسلة"
                            : "غير متوفر حالياً",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (widget.product.isAvailable ?? true)
                            ? const Color(0xFF2DBB54)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Icon(icon, size: 20.sp, color: const Color(0xFF4A1D1D)),
      ),
    );
  }
}
