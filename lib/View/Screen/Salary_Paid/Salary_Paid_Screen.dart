import 'package:clothlyn/Controller/Salary_Paid_Controller.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../Constant/App_Colors.dart';
import '../../Constant/App_Font.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_TextField.dart';

class SalaryPaidScreen extends StatelessWidget {
  SalaryPaidScreen({super.key});

  final SalaryPaidController salaryPaidController =
      Get.put(SalaryPaidController());

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
                _compactActionIcon(
                  icon: Icons.filter_list_rounded,
                  tooltip: 'Filter',
                  onTap: () => openFilterDialog(salaryPaidController),
                ),
                _compactActionIcon(
                  icon: Icons.picture_as_pdf_outlined,
                  tooltip: 'Download PDF',
                  onTap: () => salaryPaidController
                      .downloadSalaryPaidPdf(salaryPaidController.salaryPaidData),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final list = salaryPaidController.filteredList;
                  final uniqueEmployees = list
                      .map((e) => e['employeeName'].toString())
                      .toSet()
                      .length;
                  final totalPaid = list.fold<num>(
                    0,
                    (sum, item) => sum + (item['paidAmount'] as num? ?? 0),
                  );

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Employees',
                            value: '$uniqueEmployees',
                            color: AppColors.floatingBtnColor,
                            icon: Icons.people_outline_rounded,
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Records',
                            value: '${list.length}',
                            color: AppColors.greenColor,
                            icon: Icons.receipt_long_outlined,
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Total Paid',
                            value: '₹$totalPaid',
                            color: const Color(0xFF1B7A3D),
                            icon: Icons.payments_outlined,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Gap(14),
                Text(
                  'Payment Records',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 15,
                    color: AppColors.textColor,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Obx(() {
                    final list = salaryPaidController.filteredList;

                    if (list.isEmpty) {
                      return _EmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        return _SalaryPaidCard(
                          item: list[index],
                          onDelete: () {
                            // Delete action — wire to API when available
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

  Widget _compactActionIcon({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: AppColors.floatingBtnColor),
        ),
      ),
    );
  }

  void openFilterDialog(SalaryPaidController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgCream,
        scrollable: true,
        titlePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Filter Salary Paid',
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 18,
              color: AppColors.textColor,
            ),
          ),
        ),
        content: SizedBox(
          width: 600,
          child: CommonTextField(
            controller: controller.nameCtrl,
            isTitle: true,
            title: 'Employee Name',
            hintText: 'Search by name',
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: controller.clearFilter,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCFC5B9)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                color: AppColors.textColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: controller.applyFilter,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.floatingBtnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Apply',
              style: TextStyle(fontFamily: FontFamily.hanKenBold,color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const Gap(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenRegular,
                    fontSize: 10,
                    height: 1.1,
                    color: AppColors.textColor.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 12,
                    height: 1.1,
                    color: color,
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DCC8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.payments_outlined,
              size: 28,
              color: AppColors.floatingBtnColor,
            ),
          ),
          const Gap(12),
          Text(
            'No salary paid records',
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 15,
              color: AppColors.textColor,
            ),
          ),
          const Gap(4),
          Text(
            'Try adjusting your filter',
            style: TextStyle(
              fontFamily: FontFamily.hanKenRegular,
              fontSize: 12,
              color: AppColors.textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalaryPaidCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;

  const _SalaryPaidCard({
    required this.item,
    required this.onDelete,
  });

  static const Color _netGreen = Color(0xFF1B7A3D);
  static const Color _statBg = Color(0xFFF7F4F0);
  static const Color _pillBg = Color(0xFFEEE8DF);

  @override
  Widget build(BuildContext context) {
    final name = item['employeeName']?.toString() ?? '-';
    final month = item['month']?.toString() ?? '-';
    final amount = item['paidAmount']?.toString() ?? '0';
    final createdAt = item['createdAt']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 15,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _pillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 10,
                      color: AppColors.ringOuterColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFC62828), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Gap(5),
            const Divider(height: 1, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _statChip(
                    label: 'Paid Amount',
                    value: '₹$amount',
                    valueColor: _netGreen,
                  ),
                ),
                const Gap(6),
                Expanded(
                  child: _statChip(
                    label: 'Created',
                    value: createdAt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: _statBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.hanKenRegular,
              fontSize: 10,
              color: AppColors.textColor.withValues(alpha: 0.55),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 12,
              color: valueColor ?? AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
