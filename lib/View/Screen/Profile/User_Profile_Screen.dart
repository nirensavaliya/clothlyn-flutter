import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Controller/Profile_Controller.dart';
import '../../../Model/User_Model.dart';
import '../../Common/Get_storage_data.dart';
import '../../Constant/App_Colors.dart';
import '../../Constant/App_Font.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_TextField.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final UserProfileController controller = Get.put(UserProfileController());

  static const Color _tanBg = Color(0xFFE8DCC8);

  String _displayRole() {
    final userType = GetStorageData.readString(GetStorageData.userType);
    if (userType == 'employee') {
      return controller.user?.employeeRole.trim().isNotEmpty == true
          ? controller.user!.employeeRole
          : 'Employee';
    }
    return controller.user?.accountRole.trim().isNotEmpty == true
        ? controller.user!.accountRole
        : 'Admin';
  }

  String _displayPhone() {
    final phone = controller.user?.phoneNumber ?? controller.phoneCtrl.text;
    return phone.replaceAll('+91', '').trim().isNotEmpty
        ? phone.replaceAll('+91', '').trim()
        : '—';
  }

  bool get _isEmployee =>
      GetStorageData.readString(GetStorageData.userType) == 'employee';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        const ColoredBox(color: AppColors.bgCream),
        const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(title: 'User Profile'),
          body: GetBuilder<UserProfileController>(
            init: controller,
            builder: (_) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeader(),
                  const Gap(20),
                  Text(
                    'Account Details',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Gap(10),
                  if (controller.isEditing.value) ...[
                    _buildEditField(
                      title: 'Name',
                      child: CommonTextField(
                        controller: controller.nameCtrl,
                        isTitle: false,
                        hintText: 'Enter name',
                      ),
                    ),
                    const Gap(10),
                    _buildEditField(
                      title: 'Email',
                      child: CommonTextField(
                        controller: controller.emailCtrl,
                        isTitle: false,
                        hintText: 'Enter email',
                        textInputType: TextInputType.emailAddress,
                      ),
                    ),
                    const Gap(10),
                    _buildEditField(
                      title: 'Phone',
                      child: CommonTextField(
                        controller: controller.phoneCtrl,
                        isTitle: false,
                        readOnly: true,
                        showCursor: false,
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '+91',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: FontFamily.hanKenBold,
                            ),
                          ),
                        ),
                        hintText: 'Phone number',
                      ),
                    ),
                    const Gap(10),
                    _buildEditField(
                      title: 'Date of Birth',
                      child: CommonTextField(
                        controller: controller.dobCtrl,
                        isTitle: false,
                        readOnly: true,
                        showCursor: false,
                        hintText: 'Date of birth',
                      ),
                    ),
                  ] else ...[
                    _ProfileInfoTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Name',
                      value: controller.user?.name.trim().isNotEmpty == true
                          ? controller.user!.name
                          : '—',
                    ),
                    const Gap(10),
                    if (controller.user?.email.trim().isNotEmpty == true)
                      _ProfileInfoTile(
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        value: controller.user!.email,
                      ),
                    if (controller.user?.email.trim().isNotEmpty == true)
                      const Gap(10),
                    _ProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: _displayPhone(),
                    ),
                    const Gap(10),
                    _ProfileInfoTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date of Birth',
                      value: controller.dobCtrl.text.trim().isNotEmpty
                          ? controller.dobCtrl.text
                          : '—',
                    ),
                    const Gap(10),
                    _ProfileInfoTile(
                      icon: Icons.badge_outlined,
                      label: 'Role',
                      value: _displayRole(),
                    ),
                    if (controller.user?.company.trim().isNotEmpty == true) ...[
                      const Gap(10),
                      _ProfileInfoTile(
                        icon: Icons.apartment_outlined,
                        label: 'Company',
                        value: controller.user!.company,
                      ),
                    ],
                  ],
                ],
              ),
            ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    final user = controller.user ??
        User(
          name: '',
          accountRole: '',
          company: '',
          id: '',
          phoneNumber: '',
          email: '',
          employeeRole: '',
        );
    final name = user.name.trim().isNotEmpty ? user.name : 'Admin';
    final role = _displayRole();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!_isEmployee)
            Align(
              alignment: Alignment.centerRight,
              child: controller.isEditing.value
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: controller.onCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            side: const BorderSide(color: Color(0xFFCFC5B9)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: controller.onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.floatingBtnColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenBold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : TextButton.icon(
                      onPressed: controller.onEditProfile,
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: AppColors.floatingBtnColor,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 14,
                          color: AppColors.floatingBtnColor,
                        ),
                      ),
                    ),
            ),
          const Gap(8),
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _tanBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.ringOuterColor, width: 1.5),
            ),
            child: Text(
              getInitials(user),
              style: TextStyle(
                fontFamily: FontFamily.hanKenBold,
                fontSize: 28,
                color: AppColors.floatingBtnColor,
              ),
            ),
          ),
          const Gap(12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 20,
              color: AppColors.textColor,
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _tanBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toUpperCase(),
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
    );
  }

  Widget _buildEditField({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.hanKenMedium,
              fontSize: 13,
              color: AppColors.textColor.withValues(alpha: 0.65),
            ),
          ),
          const Gap(8),
          child,
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color _tanBg = Color(0xFFE8DCC8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.5),
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
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _tanBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.floatingBtnColor,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 12,
                    color: AppColors.textColor.withValues(alpha: 0.55),
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 15,
                    color: AppColors.textColor,
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
