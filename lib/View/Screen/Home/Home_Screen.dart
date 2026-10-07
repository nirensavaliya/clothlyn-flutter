import 'dart:convert';

import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Screen/Profile/Profile_Account_Bottom_View.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Common/Get_storage_data.dart';
import '../../Constant/App_Font.dart';
import '../../Utills/App_Routes.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_Appbar.dart';
import '../../Widget/Custom_Home_Card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String? _getUserName() {
    final loginDataString = GetStorageData.readString(GetStorageData.loginData);
    if (loginDataString == null || loginDataString.isEmpty) return null;

    final jsonData = jsonDecode(loginDataString) as Map<String, dynamic>;
    final firstName = jsonData['firstName'] ?? '';
    final lastName = jsonData['lastName'] ?? '';
    return "$firstName $lastName".trim();
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final today = DateFormat('d MMM yyyy').format(DateTime.now());

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        const ColoredBox(color: AppColors.bgCream),
        const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(
            showBack: false,
            title: 'Dashboard',
            actions: GestureDetector(
              onTap: () => openProfileBottomSheet(context),
              child: Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFCFC5B9)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.iconColor,
                  size: 18,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CompactWelcome(
                  userName: userName,
                  initials: _getInitials(userName),
                  date: today,
                ),
                const Gap(14),
                Text(
                  'Modules',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.18,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      HomeCard(
                        title: 'Salary Report',
                        subtitle: 'Employee salary details',
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.floatingBtnColor,
                        onTap: () => Get.toNamed(AppRoutes.salaryReportScreen),
                      ),
                      HomeCard(
                        title: 'Salary Paid',
                        subtitle: 'Paid salary records',
                        icon: Icons.payments_outlined,
                        color: AppColors.greenColor,
                        onTap: () => Get.toNamed(AppRoutes.salaryPaidScreen),
                      ),
                      HomeCard(
                        title: 'Upad Report',
                        subtitle: 'UPAD deductions',
                        icon: Icons.trending_down_rounded,
                        color: const Color(0xFFE65100),
                        onTap: () => Get.toNamed(AppRoutes.upadReportScreen),
                      ),
                      HomeCard(
                        title: 'Scanner',
                        subtitle: 'Scan & edit product',
                        icon: Icons.qr_code_scanner_rounded,
                        color: const Color(0xFF7B1FA2),
                        onTap: () => Get.toNamed(AppRoutes.scannerScreen,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void openProfileBottomSheet(BuildContext context) {
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
}

class _CompactWelcome extends StatelessWidget {
  final String? userName;
  final String initials;
  final String date;

  const _CompactWelcome({
    required this.userName,
    required this.initials,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final name = userName?.trim().isNotEmpty == true ? userName! : 'User';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ringOuterColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DCC8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: FontFamily.hanKenBold,
                fontSize: 15,
                color: AppColors.floatingBtnColor,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getGreeting()}, $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const Gap(2),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenRegular,
                    fontSize: 11,
                    color: AppColors.textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
