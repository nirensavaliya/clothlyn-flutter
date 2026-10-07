import 'package:clothlyn/Controller/Non_Moving_Controller.dart';
import 'package:clothlyn/Model/Non_Moving_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';

class NonMovingItemScreen extends StatelessWidget {
  NonMovingItemScreen({super.key});

  final NonMovingController nonMovingController =
      Get.put(NonMovingController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.bgCream),
        const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(
            title: "Non Moving Item",
            actions: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    nonMovingController.downloadNonMovePdf();
                  },
                  icon: Icon(Icons.picture_as_pdf, color: AppColors.iconColor),
                ),
                IconButton(
                  icon: const Icon(Icons.insert_drive_file,
                      color: AppColors.iconColor),
                  onPressed: () {
                    nonMovingController.downloadNonMoveExcel();
                  },
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Obx(() {
                  if (nonMovingController.isLoading.value) {
                    return const CustomSpinLoader();
                  }

                  if (nonMovingController.nonMoving.isEmpty) {
                    return Center(
                      child: Text(
                        "No non-moving items found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: FontFamily.hanKenMedium,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    );
                  }

                  final list = nonMovingController.nonMoving;
                  final showLoader = nonMovingController.hasMore.value;
                  return ListView.builder(
                    controller: nonMovingController.scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: list.length + (showLoader ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index >= list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CustomSpinLoader(size: 40, boxed: false),
                        );
                      }
                      final item = list[index];
                      return _NonMovingCard(
                        item: item,
                        onView: () => _openViewDialog(context, item),
                      );
                    },
                  );
                }),
              ),
              Obx(() {
                if (!nonMovingController.isDownloading.value) {
                  return const SizedBox();
                }

                return Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const CustomSpinLoader(size: 40),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void _openViewDialog(BuildContext context, NonMovingModel item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgCream,
          insetPadding: const EdgeInsets.all(24),
          scrollable: true,
          titlePadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  "Non Moving Details",
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 18,
                    color: AppColors.titleColor,
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: "Date",
                          value: item.date?.toString() ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: "D.No.",
                          value: item.designNumber?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: "Lot No.",
                          value: item.lotNo?.toString() ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: "PIC",
                          value: item.pic?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: "Master",
                          value: item.master?.toString() ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: "Layer",
                          value: item.layer?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: "Color",
                          value: item.color?.toString() ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: "Size",
                          value: item.size?.toString() ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: _infoItem(
                          title: "Status",
                          value: item.status?.toString() ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _infoItem(
                          title: "Days Since Change",
                          value: '${item.daysSinceLastChange ?? '-'}',
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
            fontFamily: FontFamily.hanKenMedium,
            fontSize: 13,
            color: AppColors.hintTextColor,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 15,
            fontFamily: FontFamily.hanKenBold,
          ),
        ),
      ],
    );
  }
}

class _NonMovingCard extends StatelessWidget {
  final NonMovingModel item;
  final VoidCallback onView;

  const _NonMovingCard({
    required this.item,
    required this.onView,
  });

  String get _dNo => item.designNumber?.toString().trim().isNotEmpty == true
      ? item.designNumber!.toString()
      : '—';

  String get _lot => item.lotNo?.toString().trim().isNotEmpty == true
      ? item.lotNo!.toString()
      : '—';

  String get _color => item.color?.toString().trim().isNotEmpty == true
      ? item.color!.toString()
      : '—';

  String get _size => item.size?.toString().trim().isNotEmpty == true
      ? item.size!.toString()
      : '—';

  String get _status => item.status?.toString().trim().isNotEmpty == true
      ? item.status!.toString()
      : '—';

  String get _days => '${item.daysSinceLastChange ?? 0}';

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
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
                        _dNo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 16,
                          color: AppColors.titleColor,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Lot  ·  $_lot',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 13,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgBeige,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_days d',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 12,
                      color: AppColors.accentBrown,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textColor,
                      size: 22,
                    ),
                    onSelected: (value) {
                      if (value == 'view') onView();
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
                    ],
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _chip(label: 'Color', value: _color),
                ),
                const Gap(8),
                Expanded(
                  child: _chip(label: 'Size', value: _size),
                ),
                const Gap(8),
                Expanded(
                  child: _chip(label: 'Status', value: _status),
                ),
              ],
            ),
            const Gap(10),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(10),
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Master  ·  ${item.master?.toString().isNotEmpty == true ? item.master : '—'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      fontSize: 13,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Text(
                  item.date?.toString() ?? '',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 12,
                    color: AppColors.hintTextColor,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
              fontFamily: FontFamily.hanKenBold,
              fontSize: 13,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
