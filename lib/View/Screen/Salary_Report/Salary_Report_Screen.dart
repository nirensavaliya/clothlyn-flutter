import 'package:clothlyn/Controller/Salary_Report_Controller.dart';
import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../Model/Salary_Report_Model.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_Add_Salary_Paid_Dialog.dart';

class SalaryReportScreen extends StatelessWidget {
  SalaryReportScreen({super.key});

  final SalaryReportController salaryReportController =
      Get.put(SalaryReportController());

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
            title: 'Salary Report',
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _compactActionIcon(
                  icon: Icons.filter_list_rounded,
                  tooltip: 'Filter',
                  onTap: () => salaryMasterFilterDialog(context),
                ),
                _compactActionIcon(
                  icon: Icons.picture_as_pdf_outlined,
                  tooltip: 'Download PDF',
                  onTap: salaryReportController.downloadSalaryReport,
                ),
                _compactActionIcon(
                  icon: Icons.table_chart_outlined,
                  tooltip: 'Download Excel',
                  onTap: salaryReportController.downloadSalaryReportExcel,
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      if (salaryReportController.isLoading.value) {
                        return const _SummaryShimmerRow();
                      }

                      final data = salaryReportController.salaryResponse.value;
                      if (data?.totalsOverall == null) {
                        return const SizedBox.shrink();
                      }

                      final totals = data!.totalsOverall!;
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _SummaryCard(
                                label: 'Total Salary',
                                value:
                                    '₹${(totals.totalAllPrice ?? 0).toStringAsFixed(0)}',
                                color: AppColors.greenColor,
                                icon: Icons.trending_up_rounded,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: _SummaryCard(
                                label: 'Deductions',
                                value:
                                    '₹${(totals.totalDeductions ?? 0).toStringAsFixed(0)}',
                                color: const Color(0xFFC62828),
                                icon: Icons.remove_circle_outline_rounded,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: _SummaryCard(
                                label: 'Net Pay',
                                value:
                                    '₹${(totals.totalNetAmount ?? 0).toStringAsFixed(0)}',
                                color: AppColors.floatingBtnColor,
                                icon: Icons.account_balance_wallet_outlined,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Gap(14),
                    Text(
                      'Monthly Details',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Obx(() {
                        if (salaryReportController.isLoading.value) {
                          return Center(
                            child: const CustomSpinLoader(),
                          );
                        }

                        if (salaryReportController.salaryReport.isEmpty ||
                            salaryReportController
                                .filteredSalaryReport.isEmpty) {
                          return _EmptyState();
                        }

                        final list =
                            salaryReportController.filteredSalaryReport;

                        return RefreshIndicator(
                          color: AppColors.accentBrown,
                          onRefresh: salaryReportController.loadFirstPage,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: list.length +
                                (salaryReportController.hasMore.value ? 1 : 0),
                            itemBuilder: (_, index) {
                              if (index >= list.length) {
                                salaryReportController.loadNextPage();
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: CustomSpinLoader(
                                      size: 28,
                                      boxed: false,
                                    ),
                                  ),
                                );
                              }
                              return _EmployeeSalaryCard(item: list[index]);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (!salaryReportController.isDownloading.value) {
                  return const SizedBox.shrink();
                }
                return Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: const CustomSpinLoader(size: 60),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void salaryMasterFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter Report',
          style: TextStyle(
            fontFamily: FontFamily.hanKenBold,
            fontSize: 18,
            color: AppColors.textColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterLabel('Employee'),
              const Gap(8),
              Obx(() {
                return DropdownMenu<String>(
                  width: double.infinity,
                  hintText: 'Select employee',
                  initialSelection:
                      salaryReportController.employeeSelected.value,
                  onSelected: (value) {
                    salaryReportController.employeeSelected.value = value;
                  },
                  textStyle: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.white),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.floatingBtnColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: salaryReportController
                                    .employeeSelected.value !=
                                null
                            ? AppColors.floatingBtnColor
                            : Colors.grey,
                        width: 1.5,
                      ),
                    ),
                  ),
                  dropdownMenuEntries:
                      salaryReportController.salaryReport.map((e) {
                    final isSelected = e.user?.firstName ==
                        salaryReportController.employeeSelected.value;
                    return DropdownMenuEntry<String>(
                      value: '${e.id}',
                      label:
                          '${e.user?.firstName ?? ''} ${e.user?.lastName ?? ''}',
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => isSelected
                              ? AppColors.floatingBtnColor
                              : Colors.transparent,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              const Gap(14),
              _filterLabel('Lot No.'),
              const Gap(8),
              Obx(
                () => DropdownMenu<String>(
                  width: double.infinity,
                  hintText: 'Select Lot No',
                  initialSelection: salaryReportController.selectLotNo.value,
                  onSelected: (value) {
                    salaryReportController.selectLotNo.value = value;
                  },
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.floatingBtnColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  dropdownMenuEntries:
                      salaryReportController.salaryReport.map((e) {
                    final isSelected =
                        e.lotNo == salaryReportController.selectLotNo.value;
                    return DropdownMenuEntry<String>(
                      value: '${e.lotNo}',
                      label: '${e.lotNo}',
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => isSelected
                              ? AppColors.floatingBtnColor
                              : Colors.transparent,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Gap(14),
              _filterLabel('D.No.'),
              const Gap(8),
              Obx(
                () => DropdownMenu<String>(
                  width: double.infinity,
                  hintText: 'Select D.No',
                  initialSelection: salaryReportController.selectDNo.value,
                  onSelected: (value) {
                    salaryReportController.selectDNo.value = value;
                  },
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.floatingBtnColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  dropdownMenuEntries:
                      salaryReportController.salaryReport.map((e) {
                    final isSelected =
                        e.dNo == salaryReportController.selectDNo.value;
                    return DropdownMenuEntry<String>(
                      value: '${e.dNo}',
                      label: '${e.dNo}',
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => isSelected
                              ? AppColors.floatingBtnColor
                              : Colors.transparent,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Gap(14),
              _filterLabel('Pic'),
              const Gap(8),
              Obx(
                () => DropdownMenu<String>(
                  width: double.infinity,
                  hintText: 'Select Pic',
                  initialSelection: salaryReportController.selectPic.value,
                  onSelected: (value) {
                    salaryReportController.selectPic.value = value;
                  },
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.floatingBtnColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  dropdownMenuEntries:
                      salaryReportController.salaryReport.map((e) {
                    final isSelected =
                        '${e.pic}' == salaryReportController.selectPic.value;
                    return DropdownMenuEntry<String>(
                      value: '${e.pic}',
                      label: '${e.pic}',
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => isSelected
                              ? AppColors.floatingBtnColor
                              : Colors.transparent,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (states) =>
                              isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: dateField(
                      'Start Date',
                      context,
                      salaryReportController.startDateController,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: dateField(
                      'End Date',
                      context,
                      salaryReportController.endDateController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              salaryReportController.employeeSelected.value = '';
              salaryReportController.selectDNo.value = '';
              salaryReportController.selectLotNo.value = '';
              salaryReportController.endDateController.text = '';
              salaryReportController.startDateController.text = '';
              salaryReportController.selectPic.value = '';
              salaryReportController.filteredSalaryReport.clear();
              await salaryReportController.loadFirstPage();
              Get.back();
            },
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
          Obx(() {
            final isLoading = salaryReportController.isFilterLoading.value;
            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await salaryReportController.applyFilterApi();
                      Get.back();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.floatingBtnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLoading ? 'Applying...' : 'Apply',
                style: TextStyle(fontFamily: FontFamily.hanKenBold),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _filterLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: FontFamily.hanKenMedium,
        fontSize: 14,
        color: AppColors.textColor.withValues(alpha: 0.7),
      ),
    );
  }

  /// Default IconButton = 48×48 tap area. Compact = 32×32 per icon (20px + 6px padding).
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
          child: Icon(
            icon,
            size: 20,
            color: AppColors.floatingBtnColor,
          ),
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
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

class _SummaryShimmerRow extends StatelessWidget {
  const _SummaryShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (_) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.white,
              colorOpacity: 0.3,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
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
              Icons.receipt_long_outlined,
              size: 28,
              color: AppColors.floatingBtnColor,
            ),
          ),
          const Gap(12),
          Text(
            'Salary Report Not Found',
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontSize: 15,
              color: AppColors.textColor,
            ),
          ),
          const Gap(4),
          Text(
            'Try adjusting filters or check back later',
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

class _EmployeeSalaryCard extends StatelessWidget {
  final SalaryData item;

  const _EmployeeSalaryCard({required this.item});

  static const Color _pillBg = Color(0xFFEEE8DF);
  static const Color _statBg = Color(0xFFF7F4F0);
  static const Color _netGreen = Color(0xFF1B7A3D);

  String get _role => (item.processId?.processName ?? '-').trim();

  String get _code => (item.user?.employeeName ?? '-').trim();

  @override
  Widget build(BuildContext context) {
    final dNo = (item.dNo ?? '-').toString();
    final lotNo = (item.lotNo ?? '-').toString();
    final price = item.singlePrice ?? 0;
    final netPay = item.netAmount ?? 0;
    final pic = '${item.pic ?? '-'}';

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
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'D.$dNo  ·  Lot $lotNo',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 14,
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
                    _role.isEmpty ? '-' : _role,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 10,
                      color: AppColors.ringOuterColor,
                    ),
                  ),
                ),
              ],
            ),
            if (_code.isNotEmpty && _code != '-') ...[
              const Gap(6),
              Text(
                'Code: $_code',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenRegular,
                  fontSize: 12,
                  color: AppColors.textColor.withValues(alpha: 0.65),
                ),
              ),
            ],
            const Gap(10),
            const Divider(height: 1, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _statChip(
                    label: 'Price',
                    value: '₹$price',
                  ),
                ),
                const Gap(6),
                Expanded(
                  child: _statChip(
                    label: 'Net Pay',
                    value: '₹$netPay',
                    valueColor: _netGreen,
                  ),
                ),
                const Gap(6),
                Expanded(
                  child: _statChip(
                    label: 'PIC',
                    value: pic,
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
