import 'package:clothlyn/Controller/Admin_Salary_Paid_Controller.dart';
import 'package:clothlyn/Model/Admin_Salary_Paid_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../Controller/Employee_Controller.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Add_Salary_Paid_Dialog.dart';
import '../../../Widget/Custom_Appbar.dart';

class AdminSalaryPaidScreen extends StatelessWidget {
  AdminSalaryPaidScreen({super.key});

  final AdminSalaryPaidController controller =
      Get.put(AdminSalaryPaidController());
  final EmployeeController employeeController = Get.put(EmployeeController());

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
          appBar: commonAppBar(
            title: 'Salary Paid',
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => IconButton(
                  icon: controller.isImporting.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.iconColor,
                          ),
                        )
                      : const Icon(Icons.upload_file, color: AppColors.iconColor),
                  tooltip: 'Import Excel',
                  onPressed: controller.isImporting.value
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx', 'xls'],
                          );
                          final path = result?.files.single.path;
                          if (path == null || path.isEmpty) return;
                          await controller.importSalaryPaidExcel(path);
                        },
                )),
                IconButton(
                  icon: const Icon(Icons.download, color: AppColors.iconColor),
                  tooltip: 'Download import demo Excel',
                  onPressed: () {
                    controller.downloadImportDemoExcel();
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.floatingBtnColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        useSafeArea: true,
                        barrierDismissible: false,
                        builder: (_) => CustomAddSalaryPaidDialog(
                          adminSalaryPaidController: controller,
                          employeeController: employeeController,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(
                      'Add Salary Paid',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenSemiBold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: const CustomSpinLoader(),
                      );
                    }

                    final data = controller.salaryPaid;
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          'No salary paid entries available',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontFamily.hanKenMedium,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount:
                          data.length + (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index >= data.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CustomSpinLoader(size: 28, boxed: false),
                            ),
                          );
                        }

                        final item = data[index];
                        final employeeName =
                            '${item.employee.firstName} ${item.employee.lastName}'
                                .trim();

                        return _SalaryPaidCard(
                          item: item,
                          employeeName:
                              employeeName.isEmpty ? '-' : employeeName,
                          onView: () {
                            salaryPaidViewDialog(
                              context,
                              employeeName,
                              '₹${item.employee.totalSalary}',
                              '',
                              formatDate(item.employee.createdAt.toString()),
                            );
                          },
                          onEdit: () {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              barrierDismissible: false,
                              builder: (_) => CustomAddSalaryPaidDialog(
                                isEdit: true,
                                item: item,
                                adminSalaryPaidController: controller,
                                employeeController: employeeController,
                              ),
                            );
                          },
                          onDelete: () {
                            showDeleteDialog(
                              context,
                              item.employee.id,
                              employeeName,
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void salaryPaidViewDialog(
    BuildContext context,
    String employeeName,
    String amount,
    String month,
    String createdDate,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(24),
          scrollable: true,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Salary Paid Details',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: 'Employee Name',
                          value: employeeName,
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: 'Amount',
                          value: amount,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: 'Month',
                          value: month.isEmpty ? '-' : month,
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: 'Created Date',
                          value: createdDate,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoItem({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.hanKenSemiBold,
            fontSize: 14,
            color: const Color(0xFF616161),
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: FontFamily.hanKenMedium,
          ),
        ),
      ],
    );
  }

  void showDeleteDialog(
    BuildContext context,
    String id,
    String employeeName,
  ) {
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
                const Center(
                  child: Icon(
                    Icons.warning_amber_sharp,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Confirm Delete',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily.hanKenBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontFamily: FontFamily.hanKenMedium,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Are you sure you want to delete salary paid entry for ',
                      ),
                      TextSpan(
                        text: employeeName,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.hanKenBold,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(text: '?'),
                    ],
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
                                onPressed: controller.isDeleteSalary.value
                                    ? null
                                    : () async {
                                        bool success =
                                            await controller.deleteSalary(id);

                                        if (success) {
                                          Get.back();
                                          ToastWidget.showToastCustom(
                                            'Salary deleted successfully',
                                            color: Colors.green,
                                          );
                                        } else {
                                          ToastWidget.showToastCustom(
                                            'Failed to delete salary',
                                            color: Colors.red,
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.floatingBtnColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  controller.isDeleteSalary.value
                                      ? 'Deleting...'
                                      : 'Yes, Delete',
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
                            () => controller.isDeleteSalary.value
                                ? const Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: AppColors.accentBrown,
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

class _SalaryPaidCard extends StatelessWidget {
  final PaidSalaries item;
  final String employeeName;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SalaryPaidCard({
    required this.item,
    required this.employeeName,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color _netPayGreen = Color(0xFF1B7A3D);

  @override
  Widget build(BuildContext context) {
    final paidAmount = item.employee.totalPaid;
    final created = formatDate(item.employee.createdAt.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Type: ${item.paymentType.toUpperCase()}',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 12,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${paidAmount.toStringAsFixed(paidAmount % 1 == 0 ? 0 : 2)}',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 16,
                    color: _netPayGreen,
                  ),
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  position: PopupMenuPosition.under,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textColor,
                    size: 22,
                  ),
                  onSelected: (value) {
                    if (value == 'view') {
                      onView();
                    } else if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'View',
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 1),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_square, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 1),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: FontFamily.hanKenMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(10),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Created  ·  $created',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      fontSize: 13,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.payments_outlined,
                  size: 16,
                  color: AppColors.accentBrown,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
