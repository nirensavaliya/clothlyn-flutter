import 'package:clothlyn/Controller/Reject_Controller.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';

class RejectScreen extends StatelessWidget {
  RejectScreen({super.key});

  final RejectController controller = Get.put(RejectController());

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
          appBar: commonAppBar(title: 'Reject'),
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
                          'No reject found',
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
                        return _RejectCard(
                          lotNo: item.lotNo ?? '-',
                          rejectPic: item.rejectPic ?? 0,
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
            controller: controller.searchController,
            hintText: 'Search Reject...',
            prefix: GestureDetector(
              onTap: () {
                controller.searchController.clear();
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

class _RejectCard extends StatelessWidget {
  final String lotNo;
  final int rejectPic;

  const _RejectCard({
    required this.lotNo,
    required this.rejectPic,
  });

  static const Color _countBg = Color(0xFFF7F4F0);
  static const Color _rejectRed = Color(0xFFC62828);
  static const Color _rejectRedBg = Color(0xFFFFEBEE);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _countBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.block_outlined,
                color: AppColors.accentBrown,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lotNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Lot number',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenRegular,
                      fontSize: 12,
                      color: AppColors.hintTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _rejectRedBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Reject $rejectPic',
                style: TextStyle(
                  fontFamily: FontFamily.hanKenBold,
                  fontSize: 13,
                  color: _rejectRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
