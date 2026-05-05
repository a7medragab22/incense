import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insins/core/animation/slide_reveal_animation.dart';
import 'package:insins/core/di/injection.dart';
import 'package:insins/core/widgets/custom_menu.dart';
import 'package:insins/core/widgets/drawer_item_widget.dart';
import 'package:insins/core/widgets/language_selector_widget.dart';
import 'package:insins/features/home/logic/categories_cubit/cubit/categories_cubit.dart';
import 'package:insins/features/home/logic/cubit/homecubit_cubit.dart';
import 'package:insins/features/home/presentaion/widget/custom_contact_button.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onHomeTap;
  final VoidCallback? onShopTap;
  final VoidCallback? onAboutTap;

  final GlobalKey<SlideRevealAnimationState> _animationKey = GlobalKey();

  CustomDrawer({
    super.key,
    required this.onClose,
    this.onHomeTap,
    this.onShopTap,
    this.onAboutTap,
  });

  Future<void> _handleClose() async {
    await _animationKey.currentState?.reverse();
    await Future.delayed(const Duration(milliseconds: 30));
    onClose();
  }

  Future<void> _navigate(VoidCallback? action) async {
    await _animationKey.currentState?.reverse();
    await Future.delayed(const Duration(milliseconds: 30));
    onClose();
    if (action != null) action();
  }

  @override
  Widget build(BuildContext context) {
    return SlideRevealAnimation(
      key: _animationKey,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // --- Header ---
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close,
                              color: Colors.white70, size: 28.sp),
                          onPressed: _handleClose,
                        ),
                        // Logo Placeholder or actual logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/ins.jpeg',
                            height: 60.h,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(width: 60),
                          ),
                        ),
                        const SizedBox(
                            width: 48), // Spacer to balance the close button
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // --- Menu Items ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          DrawerItemWidget(
                            title: 'الرئيسية',
                            onTap: () => _navigate(onHomeTap),
                          ),
                          DrawerItemWidget(
                            title: 'من نحن',
                            onTap: () => _navigate(onAboutTap),
                          ),
                          DrawerItemWidget(
                            title: 'قسم العطور',
                            hasArrow: true,
                            onTap: () {
                              final categoriesCubit =
                                  context.read<CategorieCubit>();
                              final productsCubit = sl<ProductsCubit>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                          value: categoriesCubit),
                                      BlocProvider.value(value: productsCubit),
                                    ],
                                    child: CategoryMenuWidget(
                                      filterCategoryName: 'العطور',
                                      onCategorySelected:
                                          (categoryId, categoryName) {
                                        productsCubit
                                            .filterByCategory(categoryName);
                                        _navigate(onShopTap);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          DrawerItemWidget(
                            title: 'التجميل من انسيسنس',
                            hasArrow: true,
                            onTap: () {
                              final categoriesCubit =
                                  context.read<CategorieCubit>();
                              final productsCubit = sl<ProductsCubit>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                          value: categoriesCubit),
                                      BlocProvider.value(value: productsCubit),
                                    ],
                                    child: CategoryMenuWidget(
                                      filterCategoryName: 'التجميل',
                                      onCategorySelected:
                                          (categoryId, categoryName) {
                                        productsCubit
                                            .filterByCategory(categoryName);
                                        _navigate(onShopTap);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          DrawerItemWidget(
                            title: 'العود من انسينس',
                            hasArrow: true,
                            onTap: () {
                              final categoriesCubit =
                                  context.read<CategorieCubit>();
                              final productsCubit = sl<ProductsCubit>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                          value: categoriesCubit),
                                      BlocProvider.value(value: productsCubit),
                                    ],
                                    child: CategoryMenuWidget(
                                      filterCategoryName: 'العود',
                                      onCategorySelected:
                                          (categoryId, categoryName) {
                                        productsCubit
                                            .filterByCategory(categoryName);
                                        _navigate(onShopTap);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          DrawerItemWidget(
                            title: 'المتجر',
                            onTap: () {
                              sl<ProductsCubit>().clearFilter();
                              _navigate(onShopTap);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Footer ---
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                    child: Column(
                      children: [
                        const LanguageSelectorWidget(),
                        SizedBox(height: 100.h), // Room for contact buttons
                      ],
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: 20,
                right: 20,
                child: QuickContactButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
