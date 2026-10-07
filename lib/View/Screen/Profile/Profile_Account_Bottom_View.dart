import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Utills/App_Routes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Controller/Login_Controller.dart';
import '../../../Controller/Profile_Controller.dart';
import '../../Common/Get_storage_data.dart';

class ProfileAccountBottomView extends StatelessWidget {
  ProfileAccountBottomView({super.key});

  final LoginController loginController = Get.find<LoginController>();

  static const Color _tanBg = Color(0xFFE8DCC8);
  static const Color _borderTan = Color(0xFFE8DCC8);
  static const Color _logoutRed = Color(0xFFE53935);

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'A';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: Get.find<UserProfileController>(),
      builder: (UserProfileController userProfileController) {
        final name = userProfileController.user?.name?.trim().isNotEmpty == true
            ? userProfileController.user!.name!.trim()
            : 'Admin';
        final role = GetStorageData.readString(GetStorageData.userType) ==
                'employee'
            ? (userProfileController.user?.employeeRole ?? 'Employee')
            : (userProfileController.user?.accountRole ?? 'Admin');

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bgCream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const Gap(10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCFC5B9),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 18,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textColor,
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _borderTan, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _tanBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.floatingBtnColor,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              _initials(name),
                              style: TextStyle(
                                fontFamily: FontFamily.hanKenBold,
                                fontSize: 20,
                                color: AppColors.floatingBtnColor,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.toNamed(AppRoutes.userProfileScreen);
                              },
                              child: Container(
                                height: 22,
                                width: 22,
                                decoration: BoxDecoration(
                                  color: AppColors.floatingBtnColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontFamily.hanKenBold,
                                fontSize: 17,
                                color: AppColors.textColor,
                              ),
                            ),
                            const Gap(6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _tanBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                role.toString().toUpperCase(),
                                style: TextStyle(
                                  fontFamily: FontFamily.hanKenBold,
                                  fontSize: 11,
                                  letterSpacing: 0.4,
                                  color: AppColors.floatingBtnColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Account',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.userProfileScreen);
                      },
                    ),
                    _MenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Privacy',
                    ),
                    _MenuItem(
                      icon: Icons.language_rounded,
                      title: 'Language',
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help',
                    ),
                    _MenuItem(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Invite a Friend',
                    ),
                    const Gap(8),
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      isDestructive: true,
                      onTap: () {
                        Navigator.pop(context);
                        showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: _logoutRed.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _logoutRed,
                    size: 28,
                  ),
                ),
                const Gap(16),
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily.hanKenBold,
                    color: AppColors.textColor,
                  ),
                ),
                const Gap(10),
                Text(
                  'Are you sure you want to log out of your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontFamily.hanKenRegular,
                    color: AppColors.textColor.withValues(alpha: 0.7),
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFCFC5B9)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontFamily: FontFamily.hanKenMedium,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
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
                                  backgroundColor: _logoutRed,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  loginController.isLogoutLoading.value
                                      ? 'Logging out...'
                                      : 'Yes, Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.hanKenBold,
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
                                      backgroundColor: _logoutRed,
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });

  static const Color _tanBg = Color(0xFFE8DCC8);
  static const Color _logoutRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isDestructive ? _logoutRed : AppColors.floatingBtnColor;
    final iconBg = isDestructive
        ? _logoutRed.withValues(alpha: 0.12)
        : _tanBg;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDestructive
                    ? _logoutRed.withValues(alpha: 0.25)
                    : const Color(0xFFE8DCC8),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: accentColor),
                ),
                const Gap(14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenMedium,
                      fontSize: 15,
                      color: isDestructive ? _logoutRed : AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: isDestructive
                      ? _logoutRed.withValues(alpha: 0.6)
                      : AppColors.textColor.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void openProfileAccountBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    clipBehavior: Clip.antiAlias,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SizedBox(
          height: Get.height * 0.62,
          child: ProfileAccountBottomView(),
        ),
      );
    },
  );
}

