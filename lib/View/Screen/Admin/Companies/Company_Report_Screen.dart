import 'package:clothlyn/Controller/Company_Report_Controller.dart';
import 'package:clothlyn/Model/Challan_Model.dart';
import 'package:clothlyn/Model/View_Bill_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';

class CompanyReportScreen extends StatelessWidget {
   CompanyReportScreen({super.key});
  final CompanyReportController controller = Get.put(CompanyReportController());

  @override
  Widget build(BuildContext context) {
    return  Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.bgCream),
          const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(
            title: "Company Reports",
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Obx(()
            =>
                SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      Row(
                        children: [

                          Expanded(
                            child: Obx(() => DropdownMenu<String>(
                              // key: ValueKey(controller.selectedCompany.value),
                              width: double.infinity,
                              hintText: controller.isLoading.value ? "Loading Companies..." :"Select Company",
                              initialSelection: controller.selectedCompany.value,
                              onSelected: (value) {
                                controller.selectedCompany.value = value;
                                controller.selectCompany(controller.selectedCompany.value ?? '');
                                // controller.selectedDno.value = null;
                              },
                              textStyle: TextStyle(
                                fontFamily: FontFamily.hanKenMedium,
                                fontSize: 15,
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                minimumSize: MaterialStateProperty.all(
                                  const Size(500, 0),
                                ),
                                maximumSize: MaterialStateProperty.all(
                                  const Size(175, 400),
                                ),
                              ),
                              inputDecorationTheme:  InputDecorationTheme(
                                constraints: BoxConstraints(
                                  maxHeight: 50,
                                  minHeight: 50,
                                ),
                                isDense: true,
                                border:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color:
                                  controller.selectedCompany.value != null
                                      ? AppColors.floatingBtnColor
                                      : Colors.grey,
                                      width: 1.5),
                                ),
                              ),
                              dropdownMenuEntries: controller.company.map((e) {
                                final isSelected = e.id == controller.selectedCompany.value;

                                return DropdownMenuEntry<String>(
                                  value: e.id ?? '',
                                  label: e.name ?? '',
                                );
                              }
                              )
                                  .toList(),
                            )),
                          ),
                          const SizedBox(width: 8),
                          ///----------- D.No Dropdown -----------
                          /*
                      Expanded(
                        child: Obx(() => DropdownMenu<String>(
                          width: 170,
                          hintText: "Select D.No",
                          enabled: controller.selectedCompany.value != null,
                          initialSelection: controller.selectedDno.value,
                          onSelected: controller.selectedCompany.value == null
                              ? null
                              : (value) {
                            controller.selectedDno.value = value;
                          },
                          textStyle: TextStyle(
                            fontFamily: FontFamily.jostMedium,
                            fontSize: 15,
                            color: controller.selectedCompany.value == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            minimumSize: MaterialStateProperty.all(
                              const Size(500, 0),
                            ),
                            maximumSize: MaterialStateProperty.all(
                              const Size(175, 400),
                            ),
                          ),
                          inputDecorationTheme:  InputDecorationTheme(
                            constraints: BoxConstraints(
                              maxHeight: 50,
                              minHeight: 50,
                            ),
                            isDense: true,
                            border:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color:
                              controller.selectedCompany.value != null
                                  ? AppColors.appColor
                                  : Colors.grey,
                                  width: 1.5),
                            ),
                          ),
                          dropdownMenuEntries: controller.dnos
                              .map(
                                (e) => DropdownMenuEntry<String>(
                              value: e,
                              label: e,
                            ),
                          )
                              .toList(),
                        )),
                      ),
                  */

                          // const SizedBox(width: 4),
                          // TextButton(
                          //   onPressed: () {
                          //     controller.clearFilters();
                          //   },
                          //   child: Text(
                          //     "Clear",
                          //     style: TextStyle(
                          //       color: Colors.red,
                          //       fontSize: 14,
                          //       fontFamily: FontFamily.jostMedium,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Gap(16),
                      if (controller.isBillLoading.value)
                        Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Center(
                            child: const CustomSpinLoader(),
                          ),
                        )
                      else if (controller.billingDates.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Center(
                            child: Text(
                              'No billing data available for selected company.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.hanKenMedium,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ...controller.billingDates.map(
                          (item) => _BillingDateCard(
                            date: item.date.toString(),
                            onViewBill: () {
                              showDialog(
                                context: context,
                                builder: (context) => ViewBillReportDialog(
                                  controller: controller,
                                  date: item.date.toString(),
                                ),
                              );
                            },
                            onViewChallan: () {
                              showDialog(
                                context: context,
                                builder: (context) => ChallanReportDialog(
                                  controller: controller,
                                  date: item.date.toString(),
                                ),
                              );
                            },
                            onDownloadBill: () {
                              controller.downloadBill(item.date.toString());
                            },
                            onDownloadChallan: () {
                              controller.downloadChallan(item.date.toString());
                            },
                            onDelete: () {
                              // salaryData.remove(item);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BillingDateCard extends StatelessWidget {
  final String date;
  final VoidCallback onViewBill;
  final VoidCallback onViewChallan;
  final VoidCallback onDownloadBill;
  final VoidCallback onDownloadChallan;
  final VoidCallback onDelete;

  const _BillingDateCard({
    required this.date,
    required this.onViewBill,
    required this.onViewChallan,
    required this.onDownloadBill,
    required this.onDownloadChallan,
    required this.onDelete,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //   tooltip: 'Delete',
                //   onPressed: onDelete,
                //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                // ),
              ],
            ),
            const Gap(4),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _ActionTile(
                    icon: Icons.remove_red_eye_outlined,
                    label: 'View Bill',
                    onTap: onViewBill,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _ActionTile(
                    icon: Icons.file_present_outlined,
                    label: 'Challan',
                    onTap: onViewChallan,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _DownloadButton(
                    label: 'Download Bill',
                    onTap: onDownloadBill,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _DownloadButton(
                    label: 'Download Challan',
                    onTap: onDownloadChallan,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F4F0),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.textColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 13,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DownloadButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.download_outlined, color: Colors.white, size: 18),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.floatingBtnColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: FontFamily.hanKenMedium,
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ViewBillReportDialog extends StatefulWidget {
  final CompanyReportController controller;
  final String date;
  const ViewBillReportDialog({super.key,required this.controller,required this.date});

  @override
  State<ViewBillReportDialog> createState() => _ViewBillReportDialogState();
}

class _ViewBillReportDialogState extends State<ViewBillReportDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller.getViewByDate(widget.date);
  }

  // static const Color _borderBrown = Color(0xFF6A5C44);
  static const Color _tanBg = Color(0xFFE8DCC8);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCream,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: Get.height * 0.78),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tanBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    size: 20,
                    color: AppColors.floatingBtnColor,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Report',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 17,
                          color: AppColors.textColor,
                        ),
                      ),
                      const Gap(4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.ringOuterColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          widget.date,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 12,
                            color: AppColors.floatingBtnColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: Get.back,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textColor,
                    size: 22,
                  ),
                ),
              ],
            ),

            const Gap(14),
            const Divider(height: 1, color: Color(0xFFE8DCC8)),
            const Gap(12),

            /// BILL CARDS
            Flexible(
              child: Obx(() {
                if (widget.controller.isViewBillLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: const CustomSpinLoader(),
                    ),
                  );
                }

                final list = widget.controller.viewBill;
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 36,
                          color: AppColors.textColor.withValues(alpha: 0.35),
                        ),
                        const Gap(8),
                        Text(
                          'No bill items found',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14,
                            color: AppColors.textColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return _BillItemCard(item: list[index]);
                  },
                );
              }),
            ),

            const Gap(14),

            /// TOTAL SUMMARY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.ringOuterColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: Color(0xFF1B7A3D),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'Total Amount',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenMedium,
                        fontSize: 13,
                        color: AppColors.textColor.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      '₹${widget.controller.grandTotal.value}',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 16,
                        color: const Color(0xFF1B7A3D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(14),

            /// ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Get.back,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFFCFC5B9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                ),
                const Gap(10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: Get.back,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.floatingBtnColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BillItemCard extends StatelessWidget {
  final ChallanReport item;

  const _BillItemCard({required this.item});

  static const Color _tanBg = Color(0xFFE8DCC8);
  static const Color _statBg = Color(0xFFF7F4F0);
  static const Color _netGreen = Color(0xFF1B7A3D);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _tanBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.no ?? '-'}',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 12,
                    color: AppColors.ringOuterColor,
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  item.dNo?.toString() ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 15,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Text(
                '₹${item.totalAmount ?? 0}',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenBold,
                  fontSize: 15,
                  color: _netGreen,
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(height: 1, color: Color(0xFFF1EEEA)),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: _statChip('Alter', '${item.alter ?? 0}'),
              ),
              const Gap(6),
              Expanded(
                child: _statChip('Reject', '${item.reject ?? 0}'),
              ),
              const Gap(6),
              Expanded(
                child: _statChip('Pic', '${item.totalPic ?? 0}'),
              ),
            ],
          ),
          const Gap(6),
          Row(
            children: [
              Expanded(
                child: _statChip('Lots', '${item.totalLots ?? 0}'),
              ),
              const Gap(6),
              Expanded(
                child: _statChip('Amount', '₹${item.price ?? 0}'),
              ),
              const Gap(6),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) {
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
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ChallanReportDialog extends StatefulWidget {
  final CompanyReportController controller;
  final String date;
  const ChallanReportDialog({super.key,required this.controller,required this.date});

  @override
  State<ChallanReportDialog> createState() => _ChallanReportDialogState();
}

class _ChallanReportDialogState extends State<ChallanReportDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller.getChallanByDate(widget.date);
  }

  // static const Color _borderBrown = Color(0xFF6A5C44);
  static const Color _tanBg = Color(0xFFE8DCC8);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgCream,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: Get.height * 0.78),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tanBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: AppColors.floatingBtnColor,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challan Report',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 17,
                          color: AppColors.textColor,
                        ),
                      ),
                      const Gap(4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.ringOuterColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          widget.date,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 12,
                            color: AppColors.floatingBtnColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: Get.back,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textColor,
                    size: 22,
                  ),
                ),
              ],
            ),

            const Gap(14),
            const Divider(height: 1, color: Color(0xFFE8DCC8)),
            const Gap(12),

            /// CHALLAN CARDS
            Flexible(
              child: Obx(() {
                if (widget.controller.isChallanLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: const CustomSpinLoader(),
                    ),
                  );
                }

                final list = widget.controller.challan;
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 36,
                          color: AppColors.textColor.withValues(alpha: 0.35),
                        ),
                        const Gap(8),
                        Text(
                          'No challan found',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14,
                            color: AppColors.textColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return _ChallanItemCard(item: list[index]);
                  },
                );
              }),
            ),

            const Gap(14),

            /// TOTAL SUMMARY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.ringOuterColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: Color(0xFF1B7A3D),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'Total Amount',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenMedium,
                        fontSize: 13,
                        color: AppColors.textColor.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      final num total = widget.controller.challan.fold<num>(
                        0,
                        (sum, e) => sum + (e.totalAmount ?? 0),
                      );
                      return Text(
                        '₹${total % 1 == 0 ? total.toStringAsFixed(0) : total.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 16,
                          color: const Color(0xFF1B7A3D),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Gap(14),

            /// ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: Get.back,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFFCFC5B9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                ),
                const Gap(10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: Get.back,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.floatingBtnColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallanItemCard extends StatelessWidget {
  final ChallanData item;

  const _ChallanItemCard({required this.item});

  static const Color _tanBg = Color(0xFFE8DCC8);
  static const Color _statBg = Color(0xFFF7F4F0);
  static const Color _netGreen = Color(0xFF1B7A3D);

  String _dash(String? v) {
    final t = (v ?? '').trim();
    return t.isEmpty ? '-' : t;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ringOuterColor, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _tanBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.no ?? '-'}',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 12,
                    color: AppColors.ringOuterColor,
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dash(item.dNo),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 15,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      'Lot ${_dash(item.lotNo)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenMedium,
                        fontSize: 12,
                        color: AppColors.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${item.totalAmount ?? 0}',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenBold,
                  fontSize: 15,
                  color: _netGreen,
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(height: 1, color: Color(0xFFF1EEEA)),
          const Gap(8),
          Row(
            children: [
              Expanded(child: _statChip('Color', _dash(item.color))),
              const Gap(6),
              Expanded(child: _statChip('Size', _dash(item.size))),
              const Gap(6),
              Expanded(child: _statChip('Pic', '${item.pic ?? 0}')),
            ],
          ),
          const Gap(6),
          Row(
            children: [
              Expanded(child: _statChip('Alter', '${item.alter ?? 0}')),
              const Gap(6),
              Expanded(child: _statChip('Reject', '${item.reject ?? 0}')),
              const Gap(6),
              Expanded(
                child: _statChip('Deduction', '${item.totalDeduction ?? 0}'),
              ),
            ],
          ),
          const Gap(6),
          Row(
            children: [
              Expanded(child: _statChip('Amount', '₹${item.amount ?? 0}')),
              const Gap(6),
              const Expanded(child: SizedBox()),
              const Gap(6),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) {
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
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}