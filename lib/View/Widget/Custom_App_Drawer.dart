import 'dart:convert';

import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Utills/App_Routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/Admin_Home_Controller.dart';
import '../../Controller/Login_Controller.dart';
import '../Common/Get_storage_data.dart';
import '../Screen/Profile/Profile_Account_Bottom_View.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final AdminHomeController controller = Get.put(AdminHomeController());
  final LoginController loginController = Get.find<LoginController>();

  static const Color _drawerBg = Color(0xFFF9FAFF);
  static const Color _selectedBg = Color(0xFFD6C7B9);
  static const Color _logoutRed = Color(0xFFE53935);

  String _displayName() {
    final loginDataString =
        GetStorageData.readString(GetStorageData.loginData);
    if (loginDataString == null || loginDataString.isEmpty) return 'Admin';

    final jsonData = jsonDecode(loginDataString) as Map<String, dynamic>;
    final username = jsonData['username']?.toString() ?? '';
    if (username.isNotEmpty) return username;

    final firstName = jsonData['firstName']?.toString() ?? '';
    final lastName = jsonData['lastName']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isNotEmpty ? fullName : 'Admin';
  }

  String _displayRole() {
    final loginDataString =
        GetStorageData.readString(GetStorageData.loginData);
    if (loginDataString == null || loginDataString.isEmpty) return 'Admin';

    final jsonData = jsonDecode(loginDataString) as Map<String, dynamic>;
    final role = jsonData['accountRole']?.toString() ?? '';
    return role.isNotEmpty ? role : 'Admin';
  }

  @override
  Widget build(BuildContext context) {
    final userType = GetStorageData.readString(GetStorageData.userType);
    final isAdmin = userType?.toString().toLowerCase() == 'admin';
    return Drawer(
      backgroundColor: _drawerBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sitaram Cloth',
                        style: TextStyle(
                          color: AppColors.accentBrown,
                          fontSize: 20,
                          fontFamily: FontFamily.hanKenBold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                      color: AppColors.accentBrown,
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _selectedBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayName(),
                              style: TextStyle(
                                color: AppColors.titleColor,
                                fontSize: 16,
                                fontFamily: FontFamily.hanKenBold,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _displayRole(),
                              style: TextStyle(
                                color: AppColors.hintTextColor,
                                fontSize: 13,
                                fontFamily: FontFamily.hanKenRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [

                    _drawerItem(
                      icon: Icons.widgets_outlined,
                      title: 'Non Moving Item',
                      onTap: () {
                        controller.changeIndex(2);
                        Get.toNamed(AppRoutes.nonMovingItemScreen);
                      },
                      isSelected: controller.selectedIndex.value == 2,
                    ),
                    // _drawerItem(
                    //   icon: Icons.bar_chart_outlined,
                    //   title: 'Salary Report',
                    //   isSelected: controller.selectedIndex.value == 3,
                    //   onTap: () {
                    //     controller.changeIndex(3);
                    //     Get.toNamed(AppRoutes.adminSalaryReportScreen);
                    //   },
                    // ),
                    _drawerItem(
                      icon: Icons.description_outlined,
                      title: 'Product Report',
                      onTap: () {
                        controller.changeIndex(4);
                        Get.toNamed(AppRoutes.productReportScreen);
                      },
                      isSelected: controller.selectedIndex.value == 4,
                    ),
                    _drawerItem(
                      icon: Icons.apartment_outlined,
                      title: 'Companies',
                      onTap: () {
                        controller.changeIndex(5);
                        Get.toNamed(AppRoutes.companiesScreen);
                      },
                      isSelected: controller.selectedIndex.value == 5,
                    ),
                    _drawerItem(
                      icon: Icons.article_outlined,
                      title: 'Company Reports',
                      onTap: () {
                        controller.changeIndex(6);
                        Get.toNamed(AppRoutes.companyReportScreen);
                      },
                      isSelected: controller.selectedIndex.value == 6,
                    ),
                    _drawerItem(
                      icon: Icons.attach_money_outlined,
                      title: 'Salary Paid',
                      onTap: () {
                        controller.changeIndex(7);
                        Get.toNamed(AppRoutes.adminSalaryPaidScreen);
                      },
                      isSelected: controller.selectedIndex.value == 7,
                    ),
                    _drawerItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Salary Master',
                      onTap: () {
                        controller.changeIndex(8);
                        Get.toNamed(AppRoutes.adminSalaryMasterScreen);
                      },
                      isSelected: controller.selectedIndex.value == 8,
                    ),
                    if (!isAdmin) ...[
                      _drawerItem(
                        icon: Icons.design_services_outlined,
                        title: 'Design',
                        onTap: () {
                          controller.changeIndex(9);
                          Get.toNamed(AppRoutes.designScreen);
                        },
                        isSelected: controller.selectedIndex.value == 9,
                      ),
                      _drawerItem(
                        icon: Icons.precision_manufacturing_outlined,
                        title: 'Machine',
                        onTap: () {
                          controller.changeIndex(10);
                          Get.toNamed(AppRoutes.machineScreen);
                        },
                        isSelected: controller.selectedIndex.value == 10,
                      ),
                      _drawerItem(
                        icon: Icons.settings_input_component_outlined,
                        title: 'Process',
                        onTap: () {
                          controller.changeIndex(11);
                          Get.toNamed(AppRoutes.processScreen);
                        },
                        isSelected: controller.selectedIndex.value == 11,
                      ),
                    ],

                  /*  _drawerItem(
                      icon: Icons.qr_code_scanner_outlined,
                      title: 'Scan',
                      onTap: () {
                        controller.changeIndex(12);
                        Get.toNamed(AppRoutes.scannerScreen);
                      },
                      isSelected: controller.selectedIndex.value == 12,
                    ),*/
                    _drawerItem(
                      icon: Icons.content_cut_outlined,
                      trailing: controller.isAlterExpanded.value == true
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      title: 'Alter',
                      onTap: () {
                        controller.changeIndex(13);
                        controller.toggleAlter();
                      },
                      isSelected: controller.selectedIndex.value == 13,
                    ),
                    if (controller.isAlterExpanded.value == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          children: [
                            _drawerItem(
                              icon: Icons.content_cut_outlined,
                              title: 'Alter',
                              onTap: () {
                                controller.changeIndex(14);
                                Get.toNamed(AppRoutes.alterScreen);
                              },
                              isSelected: controller.selectedIndex.value == 14,
                            ),
                            _drawerItem(
                              icon: Icons.history,
                              title: 'Alter History',
                              onTap: () {
                                controller.changeIndex(15);
                                Get.toNamed(AppRoutes.alterHistoryScreen);
                              },
                              isSelected: controller.selectedIndex.value == 15,
                            ),
                            _drawerItem(
                              icon: Icons.receipt_long_outlined,
                              title: 'Reject',
                              onTap: () {
                                controller.changeIndex(16);
                                Get.toNamed(AppRoutes.rejectScreen);
                              },
                              isSelected: controller.selectedIndex.value == 16,
                            ),
                          ],
                        ),
                      ),
                    _drawerItem(
                      icon: Icons.group_outlined,
                      title: 'Member',
                      trailing: controller.isMemberExpanded.value == true
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      onTap: () {
                        controller.changeIndex(17);
                        controller.toggleMember();
                      },
                      isSelected: controller.selectedIndex.value == 17,
                    ),
                    if (controller.isMemberExpanded.value == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Column(
                          children: [
                            _drawerItem(
                              icon: Icons.person_add_alt_1_outlined,
                              title: 'Employee',
                              onTap: () {
                                controller.changeIndex(18);
                                Get.toNamed(AppRoutes.employeeScreen);
                              },
                              isSelected: controller.selectedIndex.value == 18,
                            ),
                            _drawerItem(
                              icon: Icons.person,
                              title: 'Admin',
                              onTap: () {
                                controller.changeIndex(19);
                                Get.toNamed(AppRoutes.adminScreen);
                              },
                              isSelected: controller.selectedIndex.value == 19,
                            ),
                          ],
                        ),
                      ),
                    _drawerItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Profile',
                      onTap: () {
                        Get.back();
                        openProfileAccountBottomSheet(context);
                      },
                      isSelected: controller.selectedIndex.value == 20,
                    ),
                    // _drawerItem(
                    //   icon: Icons.qr_code,
                    //   title: 'Select barcode label',
                    //   onTap: () {
                    //     controller.changeIndex(20);
                    //   },
                    //   isSelected: controller.selectedIndex.value == 20,
                    // ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFE5E7EB),
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: InkWell(
                  onTap: () => showLogoutDialog(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout_rounded,
                          color: _logoutRed,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: _logoutRed,
                            fontSize: 15,
                            fontFamily: FontFamily.hanKenMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    IconData? trailing,
    required void Function() onTap,
  }) {
    final Color itemColor =
        isSelected ? AppColors.titleColor : AppColors.textColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? _selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: itemColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 15,
                      fontFamily: isSelected
                          ? FontFamily.hanKenSemiBold
                          : FontFamily.hanKenRegular,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (trailing != null)
                  Icon(trailing, color: itemColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepOrange,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.priority_high,
                      color: Colors.deepOrange,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily.hanKenBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to log out of your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontFamily.hanKenMedium,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: FontFamily.hanKenMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loginController.isLogoutLoading.value
                                    ? null
                                    : () async {
                                        await loginController.logout();
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  loginController.isLogoutLoading.value
                                      ? 'Logging out...'
                                      : 'Yes, Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.hanKenBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => loginController.isLogoutLoading.value
                                ? const Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: Colors.deepOrange,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
