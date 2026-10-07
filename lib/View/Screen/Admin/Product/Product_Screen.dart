import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../Controller/Add_product_Controller.dart';
import '../../../../Model/Product_Model.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Widget/Custom_Add_Product_Dialog.dart';
import '../../../Widget/Custom_Bar_Code _Dailog.dart';
import '../../../Widget/Custom_Spin_Loader.dart';

Widget _productShimmerBone({
  double height = 14,
  double? width,
  BorderRadius? borderRadius,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: borderRadius ?? BorderRadius.circular(6),
    ),
  );
}

/// Skeleton cards while Product list loads.
Widget _productListShimmer({int count = 6}) {
  return ListView.builder(
    padding: const EdgeInsets.only(bottom: 140),
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: count,
    itemBuilder: (_, __) {
      return Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: Duration.zero,
        color: Colors.white,
        colorOpacity: 0.45,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.ringOuterColor, width: 1.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _productShimmerBone(height: 16, width: 160),
                        const Gap(8),
                        _productShimmerBone(height: 12, width: 100),
                      ],
                    ),
                  ),
                  _productShimmerBone(
                    height: 26,
                    width: 72,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(child: _productShimmerBone(height: 14)),
                  const Gap(12),
                  _productShimmerBone(height: 14, width: 48),
                ],
              ),
              const Gap(10),
              const Divider(height: 2, color: Color(0xFFF1EEEA)),
              const Gap(10),
              Row(
                children: [
                  _productShimmerBone(
                    height: 14,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const Gap(8),
                  Expanded(child: _productShimmerBone(height: 12)),
                  const Gap(8),
                  _productShimmerBone(
                    height: 22,
                    width: 22,
                    borderRadius: BorderRadius.circular(6),
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
String _formatProcessScanDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '-';
  final dt = DateTime.tryParse(raw.trim());
  if (dt != null) {
    return DateFormat('dd-MM-yyyy/HH:mm').format(dt);
  }
  return raw.trim();
}

String _scannedByDisplay(ProcessEmployee pe) {
  final by = pe.scanBy?.trim();
  if (by != null && by.isNotEmpty) return by;
  final name = pe.employeeName?.trim();
  if (name != null && name.isNotEmpty) return name;
  final code = pe.employeeCode?.trim();
  if (code != null && code.isNotEmpty) return code;
  return '-';
}

void showProductStatusFilterDialog(
  BuildContext context,
  AddProductController controller,
) {
  const selectedBg = Color(0xFFE8DCC8);
  const selectedInk = Color(0xFF6A5C44);
  const titleNavy = Color(0xFF1A2B4A);

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        title: Row(
          children: [
            Text(
              'Filter by Status',
              style: TextStyle(
                fontFamily: FontFamily.hanKenBold,
                fontSize: 18,
                color: titleNavy,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.pop(ctx),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 22, color: AppColors.textColor),
              ),
            ),
          ],
        ),
        content: Obx(() {
          final options = controller.statusOptions;
          if (options.isEmpty) {
            return SizedBox(
              height: 120,
              child: Center(
                child: CustomSpinLoader(size: 32),
              ),
            );
          }

          return SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: options.length + 1,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (_, index) {
                final isAll = index == 0;
                final label = isAll ? 'All' : options[index - 1].key;
                final value = isAll ? null : options[index - 1].value;
                final selected = isAll
                    ? (controller.selectedStatus.value == null ||
                        controller.selectedStatus.value!.isEmpty)
                    : controller.selectedStatus.value == value;

                return ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selected: selected,
                  selectedTileColor: selectedBg,
                  leading: Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: selected ? selectedInk : Colors.grey.shade400,
                    size: 20,
                  ),
                  title: Text(
                    label,
                    style: TextStyle(
                      fontFamily: selected
                          ? FontFamily.hanKenSemiBold
                          : FontFamily.hanKenMedium,
                      fontSize: 15,
                      color: selected ? selectedInk : AppColors.textColor,
                    ),
                  ),
                  onTap: () {
                    controller.selectedStatus.value = value;
                    Navigator.pop(ctx);
                    controller.loadFirstPage();
                  },
                );
              },
            ),
          );
        }),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () {
              controller.selectedStatus.value = null;
              Navigator.pop(ctx);
              controller.loadFirstPage();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textColor,
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFCFC5B9), width: 1.4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 14,
                color: AppColors.textColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: selectedInk,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'Close',
              style: TextStyle(
                fontFamily: FontFamily.hanKenSemiBold,
                fontSize: 14,
                color: selectedInk,
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Product list UI (no Scaffold) — used by ProductScreen & AdminHomeScreen.
class ProductListBody extends StatelessWidget {
  final AddProductController controller;
  final bool decorateBackground;
  const ProductListBody({
    super.key,
    required this.controller,
    this.decorateBackground = true,
  });

  static const Color _bgTop = Color(0xFFF8F9FF);
  static const Color _bgBottom = Color(0xFFF4E0C1);
  static const Color _navy = Color(0xFF1A2B4A);
  static const Color _muted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Products',
              //   style: TextStyle(
              //     fontFamily: FontFamily.hanKenBold,
              //     fontSize: 28,
              //     color: _navy,
              //   ),
              // ),
              // Text(
              //   'Manage and track your daily production lots.',
              //   style: TextStyle(
              //     fontFamily: FontFamily.hanKenRegular,
              //     fontSize: 14,
              //     color: AppColors.textColor,
              //   ),
              // ),
              const Gap(5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCFC5B9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearch,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: _navy,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search Lot ID or Product...',
                    hintStyle: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.hintTextColor,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xffA5A39E),
                        width: 1.7,
                      )
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xffA5A39E),
                          width: 1.7,
                        )
                    ),
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xffA5A39E),
                          width: 1.7,
                        )
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const Gap(15),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Stack(
                      children: [
                        _productListShimmer(),
                        const CustomSpinLoader(),
                      ],
                    );
                  }
                  final list = controller.productReport;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'No available product',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontFamily.hanKenMedium,
                          fontWeight: FontWeight.w500,
                          color: _muted,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => controller.loadFirstPage(),
                    color: AppColors.accentBrown,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: controller.scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 140),
                      itemCount:
                          list.length + (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index >= list.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: CustomSpinLoader(size: 40, boxed: false),
                          );
                        }

                        final product = list[index];

                        return ProductCard(
                          item: product,
                          controller: controller,
                          index: index,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.isDownloading.value) {
            return const SizedBox();
          }

          return Container(
            color: Colors.black.withOpacity(0.3),
            child: CustomSpinLoader(size: 40),
          );
        }),
      ],
    );

    if (!decorateBackground) {
      return content;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bgTop, _bgBottom],
        ),
      ),
      child: content,
    );
  }
}

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F9FF), Color(0xFFF4E0C1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xFF1A2B4A)),
          title: Text(
            'Products',
            style: TextStyle(
              fontFamily: FontFamily.hanKenBold,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A2B4A),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showProductStatusFilterDialog(context, controller);
              },
              icon: const Icon(Icons.filter_alt_outlined),
            ),
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () {
                controller.downloadProductExcel();
              },
            ),
          ],
        ),
        body: ProductListBody(controller: controller),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  ProductItem item;
  AddProductController controller;
  int index;
  ProductCard({
    super.key,
    required this.item,
    required this.controller,
    this.index = 0,
  });

  static const Color _statusGreen = Color(0xFF2E7D32);
  static const Color _statusGreenBg = Color(0xFFE8F5E9);

  bool get _isComplete {
    final s = (item.currentStatus ?? '').trim().toLowerCase();
    return s == 'complete' || s == 'completed';
  }

  String _cardDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMM yyyy').format(dt);
  }

  String get _detailLine {
    final parts = <String>[
      if ((item.dNo ?? '').trim().isNotEmpty) item.dNo!.trim(),
      if ((item.colour ?? '').trim().isNotEmpty) item.colour!.trim(),
      if ((item.size ?? '').trim().isNotEmpty) item.size!.trim(),
    ];
    return parts.isEmpty ? '-' : parts.join('   ');
  }

  String get _picValue {
    final pic = (item.pic ?? '').trim();
    return pic.isEmpty ? '-' : pic;
  }

  Widget _picCountLabel() {
    final pic = _picValue;
    if (pic == '-') {
      return Text(
        '-',
        style: TextStyle(
          fontFamily: FontFamily.hanKenMedium,
          fontSize: 14,
          color: AppColors.textColor,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: FontFamily.hanKenMedium,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF7DD3E8),
          decorationThickness: 1.5,
        ),
        children: [
          TextSpan(
            text: pic,
            style: const TextStyle(color: Color(0xFF1A1A1A)),
          ),
          const TextSpan(
            text: ' / ',
            style: TextStyle(color: Color(0xFF1A1A1A)),
          ),
          TextSpan(
            text: pic,
            style: const TextStyle(color: Color(0xFF1B7A3D)),
          ),
        ],
      ),
    );
  }

  String get _employeeLabel {
    ProcessEmployee? pe;
    if (item.processEmployees.isNotEmpty) {
      pe = item.processEmployees.last;
    }
    final name = pe?.employeeName?.trim();
    final code = pe?.employeeCode?.trim();
    if ((name == null || name.isEmpty) && (code == null || code.isEmpty)) {
      return '';
    }
    if (name != null && name.isNotEmpty && code != null && code.isNotEmpty) {
      return '$name ($code)';
    }
    return name?.isNotEmpty == true ? name! : '($code)';
  }

  @override
  Widget build(BuildContext context) {
    final statusText =
        (item.currentStatus ?? item.status ?? '-').trim().toUpperCase();
    final lotDate = _cardDate(item.date);
    final scanDate = _cardDate(item.lastScanDate ?? item.date);
    final employee = _employeeLabel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isComplete ? _statusGreen :Color(0xff6A5C44),
          width: 1.7
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '#${item.lotNo ?? '-'}',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            // fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        TextSpan(
                          text: '  · $lotDate',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            // fontWeight: FontWeight.w400,
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isComplete
                        ? _statusGreenBg
                        : const Color(0xFFEEE8DF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      // fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.3,
                      color: _isComplete ? _statusGreen : Color(0xff6A5C44),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _detailLine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenMedium,
                      // fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                _picCountLabel(),
              ],
            ),
            const Gap(5),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(5),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.textColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    employee.isEmpty ? scanDate : '$scanDate  ·  $employee',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      // fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      useSafeArea: true,
                      barrierDismissible: false,
                      builder: (_) => BarcodeDialog(item: item),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.qr_code_scanner,
                        size: 22, color: AppColors.textColor),
                  ),
                ),
                PopupMenuButton<String>(
                  clipBehavior: Clip.none,
                  elevation: 0,
                  color: Colors.white,
                  position: PopupMenuPosition.under,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.chevron_right_rounded,
                      size: 26, color: AppColors.textColor),
                  onSelected: (value) {
                    if (value == 'view') {
                      productViewDialog(
                        context,
                        lotNo: '${item.lotNo}',
                        designNo: '${item.dNo}',
                        color: '${item.colour}',
                        size: '${item.size}',
                        pic: '${item.pic}',
                        master: '${item.master}',
                        status: '${item.status}',
                        processEmployees: item.processEmployees,
                        rcPic: '${item.rcPic == null ? 0 : item.rcPic}',
                        alter: '${item.alter == null ? 0 : item.alter}',
                        reject: '${item.reject == null ? 0 : item.reject}',
                      );
                    } else if (value == 'edit') {
                      showDialog(
                        context: context,
                        useSafeArea: true,
                        barrierDismissible: false,
                        builder: (_) =>
                            AddProductDialog(isEdit: true, item: item),
                      );
                    } else if (value == 'delete') {
                      showDeleteDialog(
                          context, item.dNo ?? '', item.id ?? '', controller);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'View',
                            style: TextStyle(fontFamily: FontFamily.hanKenMedium),
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
                            style: TextStyle(fontFamily: FontFamily.hanKenMedium),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 1),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete,
                              color: Colors.red, size: 18),
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
          ],
        ),
      ),
    );
  }

  void productViewDialog(
    BuildContext context, {
    required String lotNo,
    required String designNo,
    required String color,
    required String size,
    required String pic,
    required String master,
    required String status,
    required String rcPic,
    required String alter,
    required String reject,
    required List<ProcessEmployee> processEmployees,
  }) {
    final expanded = <bool>[true];
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                insetPadding: const EdgeInsets.all(24),
                scrollable: true,
                titlePadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Product Details:- $lotNo",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            fontFamily: FontFamily.jostBold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(dialogContext),
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFFedeef3),
                                width: 3,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  "Product Information",
                                  style: TextStyle(
                                    fontFamily: FontFamily.jostBold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        title: "Lot No. :-",
                                        value: lotNo,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "Design No. :-",
                                        value: designNo,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        title: "Color :-",
                                        value: color.isEmpty ? "-" : color,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "Size :-",
                                        value: size.isEmpty ? "-" : size,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        title: "Pic :-",
                                        value: pic.isEmpty ? "-" : pic,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "Master :-",
                                        value: master.isEmpty ? "-" : master,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "Status :-",
                                        value: status.isEmpty ? "-" : status,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        title: "RC PIC :-",
                                        value: rcPic.isEmpty ? "-" : rcPic,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "ALTER :-",
                                        value: alter.isEmpty ? "-" : alter,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        title: "REJECT :-",
                                        value: reject.isEmpty ? "-" : reject,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color(0xFFedeef3),
                                width: 3,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InkWell(
                                  onTap: () => setState(
                                    () => expanded[0] = !expanded[0],
                                  ),
                                  child: Row(
                                    children: [
                                       Expanded(
                                        child: Text(
                                          "User/Employee Details",
                                          style: TextStyle(
                                            fontFamily: FontFamily.jostBold,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        expanded[0]
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                    ],
                                  ),
                                ),
                                if (expanded[0]) ...[
                                  const Divider(
                                    color: Colors.black26,
                                    height: 20,
                                  ),
                                  if (processEmployees.isEmpty)
                                    Text(
                                      "No process records",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontFamily: FontFamily.hanKenMedium,
                                        fontSize: 15,
                                      ),
                                    )
                                  else
                                    ...List<Widget>.generate(
                                      processEmployees.length,
                                      (i) {
                                        final pe = processEmployees[i];
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: i == 0 ? 0 : 16,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _infoItem(
                                                  title: "Process Name :-",
                                                  value: pe.processName
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? pe.processName!
                                                      : "-",
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _infoItem(
                                                  title: "Scan Date:-",
                                                  value: _formatProcessScanDate(
                                                      pe.scanDate),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: _infoItem(
                                                  title: "Scanned By:-",
                                                  value: _scannedByDisplay(pe),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
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
            fontFamily: FontFamily.jostBold,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:  const Color(0xFF616161),
          ),
        ),
        const Gap(4),
        Text(
          value,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color:  Colors.black,
            fontSize: 16,
            fontFamily: FontFamily.hanKenMedium,
          ),
        ),
      ],
    );
  }

  void showDeleteDialog(BuildContext context,String name,String id,AddProductController controller) {
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
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_sharp,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  'Confirm Delete',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: FontFamily.jostBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// Message
                Text(
                  'Are you sure you want to delete item${name}?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontFamily.hanKenMedium,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                /// Buttons
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
                        child:  Text(
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

                          Obx(() => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.isDeleteDesignLoading.value
                                  ? null
                                  : () async {
                                bool success = await controller.deleteProduct(id);

                                if (success) {
                                  Get.back();
                                  ToastWidget.showToastCustom(
                                    "Product deleted successfully",
                                    color: Colors.green,
                                  );
                                } else {
                                  ToastWidget.showToastCustom(
                                    "Failed to delete Product",
                                    color: Colors.red,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.appColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                controller.isDeleteDesignLoading.value
                                    ? "Deleting..."
                                    : "Yes, Product",
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontFamily.jostBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )),

                          /// ⚡ Bottom Linear Loader
                          Obx(() => controller.isDeleteDesignLoading.value
                              ? const Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              minHeight: 3,
                              backgroundColor: AppColors.appColor,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const SizedBox()),
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

