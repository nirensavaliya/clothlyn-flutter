import 'package:clothlyn/Controller/Product_Report_Controller.dart';
import 'package:clothlyn/Model/Product_List_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';

class ProductReportScreen extends StatelessWidget {
  ProductReportScreen({super.key});

  final ProductReportController productController =
      Get.put(ProductReportController());

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
            title: 'Product Report',
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Obx(
              () => Column(
                children: [
                  DropdownMenu<String>(
                    width: double.infinity,
                    hintText: productController.isLoading.value
                        ? 'Loading design...'
                        : 'Select design',
                    initialSelection: productController.selectedD.value,
                    onSelected: (value) {
                      productController.selectedD.value = value;
                      productController.getProductReport(value!);
                    },
                    textStyle: TextStyle(
                      fontFamily: FontFamily.hanKenMedium,
                      fontSize: 15,
                      color: AppColors.textColor,
                    ),
                    menuStyle: MenuStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize: MaterialStateProperty.all(
                        const Size(500, 0),
                      ),
                      maximumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 400),
                      ),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.floatingBtnColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: productController.selectedD.value != null
                              ? AppColors.floatingBtnColor
                              : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                    dropdownMenuEntries:
                        productController.productReport.map((e) {
                      final isSelected =
                          e.designNumber == productController.selectedD.value;
                      return DropdownMenuEntry<String>(
                        value: e.designNumber ?? '',
                        label: e.designNumber ?? '',
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => isSelected
                                ? AppColors.accentBrown
                                : Colors.transparent,
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                                isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Gap(14),
                  Expanded(
                    child: productController.isProduct.value
                        ? Center(
                            child: const CustomSpinLoader(),
                          )
                        : productController.product.isEmpty
                            ? Center(
                                child: Text(
                                  'No Product Found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontFamily.hanKenMedium,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 24),
                                itemCount: productController.product.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      productController.product[index];
                                  return _ProductReportCard(
                                    item: item,
                                    processColumns:
                                        productController.processColumns,
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductReportCard extends StatelessWidget {
  final Report item;
  final List<ProcessColumn> processColumns;

  const _ProductReportCard({
    required this.item,
    required this.processColumns,
  });

  static const Color _completeGreen = Color(0xFF1B7A3D);
  static const Color _completeGreenBg = Color(0xFFE8F5E9);
  static const Color _statBg = Color(0xFFF7F4F0);

  List<_ProcessStat> get _stats {
    if (processColumns.isNotEmpty) {
      return processColumns
          .map(
            (col) => _ProcessStat(
              label: (col.label ?? col.key ?? '-').toString(),
              value: item.cellValue(col.key),
            ),
          )
          .toList();
    }

    return [
      _ProcessStat(label: 'For-Thread', value: item.forThread ?? item.total),
      _ProcessStat(label: 'RC PIC', value: item.rcPic),
      _ProcessStat(label: 'Doracut', value: item.doraCut),
      _ProcessStat(label: 'Logo', value: item.logo),
      _ProcessStat(label: 'Checking', value: item.checking),
      _ProcessStat(label: 'Press', value: item.press),
      _ProcessStat(label: 'Packing', value: item.packing),
      _ProcessStat(label: 'Bill Scan', value: item.billScan),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final color = (item.color ?? '-').toString();
    final size = (item.size ?? '-').toString();
    final total = (item.total ?? '-').toString();
    final completed = (item.completed ?? '-').toString();
    final stats = _stats;

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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: color,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        TextSpan(
                          text: '  ·  Size $size',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: _completeGreenBg,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Text(
                //     'Done $completed',
                //     style: TextStyle(
                //       fontFamily: FontFamily.hanKenBold,
                //       fontSize: 12,
                //       color: _completeGreen,
                //     ),
                //   ),
                // ),
              ],
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.map((s) {
                return _statChip(
                  label: s.label,
                  value: (s.value ?? '-').toString(),
                );
              }).toList(),
            ),
            const Gap(12),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Total  ·  $total',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenSemiBold,
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Text(
                  'Completed  ·  $completed',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 13,
                    color: _completeGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({required String label, required String value}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: _statBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.hanKenRegular,
              fontSize: 11,
              color: AppColors.hintTextColor,
            ),
          ),
          const Gap(2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.hanKenSemiBold,
              fontSize: 13,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessStat {
  final String label;
  final String? value;

  _ProcessStat({required this.label, this.value});
}
