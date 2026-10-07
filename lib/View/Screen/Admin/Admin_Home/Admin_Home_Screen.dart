import 'dart:ui';

import 'package:clothlyn/Controller/Add_product_Controller.dart';
import 'package:clothlyn/Controller/Admin_Home_Controller.dart';
import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Screen/Admin/Product/Product_Screen.dart';
import 'package:clothlyn/View/Widget/Custom_Add_Product_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_App_Drawer.dart';
import '../../Scanner/Scanner_Screen.dart';
import '../Admin_Salary_Report_Screen/Admin_Salary_Report_Screen.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  AdminHomeController adminHomeController = Get.put(AdminHomeController());
  final AddProductController productController = Get.put(AddProductController());


  List<Widget> get screens => [
    ProductListBody(
      controller: productController,
      decorateBackground: false,
    ),
    ScannerBody(),
    AdminSalaryReportScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(()
      => Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const ColoredBox(color: AppColors.bgCream),
          const FigmaBackgroundBlur(),

          Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            extendBodyBehindAppBar: false,
            drawer: AppDrawer(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                65 + MediaQuery.paddingOf(context).top,
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFCFC5B9),
                          width: 2,
                        ),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: SizedBox(
                        height: 65,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (context) => IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.menu_rounded,
                                    color: AppColors.iconColor,
                                    size: 26,
                                  ),
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                ),
                              ),
                                  Text(
                                     adminHomeController.getTitle(adminHomeController.selectedBottomIndex.value),
                                   style: TextStyle(
                                       fontWeight: FontWeight.w600,
                                       letterSpacing: 0.4,
                                       fontSize: 20,
                                       color: Colors.black
                                   ),
                                   ),
                              adminHomeController.selectedBottomIndex.value == 0
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      tooltip: 'Filter',
                                      icon: const Icon(
                                        Icons.filter_alt_outlined,
                                        color: AppColors.iconColor,
                                        size: 26,
                                      ),
                                      onPressed: () {
                                        showProductStatusFilterDialog(
                                          context,
                                          productController,
                                        );
                                      },
                                    )
                                  : const SizedBox(width: 36),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body:   screens[adminHomeController.selectedBottomIndex.value],
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: adminHomeController.selectedBottomIndex.value == 0
                       ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      barrierDismissible: false,
                      builder: (_) => AddProductDialog(isEdit: false),
                    );
                  },
                  backgroundColor: AppColors.floatingBtnColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ): SizedBox(),
            bottomNavigationBar:
                 Obx(()
                  => _AdminFloatingBottomNav(
                       selectedIndex: adminHomeController.selectedBottomIndex.value,
                       onTap: adminHomeController.changeTab,
                       ),
                 ),
          ),
        ],
      ),
    );
  }
}

class _AdminFloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const _AdminFloatingBottomNav({required this.selectedIndex,    required this.onTap,
  });

  static const Color _ink = Color(0xFF52452E);
  static const Color _activeBg = Color(0xFFE5D9C5);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(38, 0, 38, 10 + bottomInset),
      child: SizedBox(
        height: 73,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: _ink.withOpacity(0.50),
                        offset: const Offset(0, 8),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.55),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _navItem(
                          index: 0,
                          icon: Icons.inventory_2_outlined,
                          label: 'Product',
                          onTap: () => onTap(0),
                          currentIndex: selectedIndex,
                        ),
                        _navItem(
                          index: 1,
                          icon: Icons.qr_code_scanner,
                          label: 'Scan',
                          onTap: () => onTap(1),
                          currentIndex: selectedIndex,
                        ),
                        _navItem(
                          index: 2,
                          icon: Icons.person_outline_rounded,
                          label: 'Salary',
                          onTap: () => onTap(2),
                          currentIndex: selectedIndex,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final active = index == currentIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 65,
        height: 58,
        decoration: BoxDecoration(
          color: active ? _activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? _ink : _ink.withOpacity(0.70),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 11,
                height: 1,
                color: _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final void Function() onTap;
  final bool isLoading;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: FontFamily.hanKenMedium,
              ),
            ),
            const SizedBox(height: 6),
            isLoading
                ? Shimmer(
                    duration: const Duration(seconds: 2),
                    interval: const Duration(seconds: 0),
                    color: Colors.white,
                    colorOpacity: 0.3,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 28,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: FontFamily.jostBold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
