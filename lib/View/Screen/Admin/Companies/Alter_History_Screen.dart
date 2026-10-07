import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../Controller/Alter_Hisotry_Controller.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';
import '../../../Widget/Custom_Spin_Loader.dart';

class AlterHistoryScreen extends StatelessWidget {
  AlterHistoryScreen({super.key});

  final AlterHistoryController controller = Get.put(AlterHistoryController());

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
          appBar: commonAppBar(title: 'Alter History'),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(() {
                  return AnimatedSwitcher(
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: controller.isSearching.value
                        ? _searchWidget()
                        : _normalWidget(),
                  );
                }),
                const Gap(14),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: const CustomSpinLoader(),
                      );
                    }

                    final data = controller.filteredList;
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          'No alter found',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontFamily.hanKenMedium,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    final showLoader = controller.hasMore.value;

                    return ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: data.length + (showLoader ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= data.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CustomSpinLoader(size: 40, boxed: false),
                          );
                        }
                        final item = data[index];
                        return _AlterHistoryCard(
                          lotNo: item.lotNo ?? '-',
                          processName: item.processName ?? '-',
                          alterPic: item.alterPic ?? 0,
                          doneDate: salaryFormatDate(item.alterDoneDate),
                          dNo: item.dNo,
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

  Widget _searchWidget() {
    return Row(
      key: const ValueKey('search'),
      children: [
        Expanded(
          child: CommonTextField(
            controller: controller.searchHistoryController,
            hintText: 'Search Alter History...',
            prefix: GestureDetector(
              onTap: () {
                controller.searchHistoryController.clear();
                controller.onSearch('');
                controller.isSearching.value = false;
              },
              child: const Icon(Icons.close),
            ),
            onChanged: (value) {
              controller.onSearch(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _normalWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        key: const ValueKey('normal'),
        children: [
          Expanded(
            child: Text(
              'Alter Pic Counting: ${controller.totalCount.value}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.hanKenBold,
                fontSize: 18,
                color: AppColors.textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.isSearching.value = true;
            },
            child: Icon(
              Icons.search_rounded,
              color: AppColors.iconColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlterHistoryCard extends StatelessWidget {
  final String lotNo;
  final String processName;
  final int alterPic;
  final String doneDate;
  final String? dNo;

  const _AlterHistoryCard({
    required this.lotNo,
    required this.processName,
    required this.alterPic,
    required this.doneDate,
    this.dNo,
  });

  static const Color _pillBg = Color(0xFFEEE8DF);
  static const Color _countBg = Color(0xFFF7F4F0);

  @override
  Widget build(BuildContext context) {
    final design = (dNo ?? '').trim();

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
                          text: lotNo,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        if (design.isNotEmpty)
                          TextSpan(
                            text: '  ·  $design',
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _pillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    processName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: AppColors.ringOuterColor,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _countBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alter Pic',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenRegular,
                            fontSize: 11,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '$alterPic',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _countBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Done Date',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenRegular,
                            fontSize: 11,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          doneDate,
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
                  ),
                ),
              ],
            ),
            const Gap(10),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Status · $processName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 13,
                      color: AppColors.textColor,
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
