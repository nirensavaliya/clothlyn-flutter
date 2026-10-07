import 'package:clothlyn/Controller/Companies_Controller.dart';
import 'package:clothlyn/Model/Companies_Model.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_Companies_Dialog.dart';
import '../../../Widget/Custom_TextField.dart';

class CompaniesScreen extends StatelessWidget {
   CompaniesScreen({super.key});
  final CompaniesController controller = Get.put(CompaniesController());


  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children:[
        const ColoredBox(color: AppColors.bgCream),
        const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(
            title: "Companies",
            // IconButton(
            //   icon: const Icon(Icons.filter_list, color: Colors.white),
            //   onPressed: () {
            //     openFilterDialog();
            //   },
            // ),


          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                CommonTextField(
                  controller: controller.searchController,
                  hintText: "Search Companies...",
                  prefix: GestureDetector(
                      onTap: (){
                        controller.searchController.clear();
                        controller.onSearch("");
                      },
                      child: Icon(Icons.search)),
                  onChanged: (value) {
                    controller.onSearch(value);
                  },
                ),
                Gap(10),
                Obx(() {
                  if (controller.isLoading.value) {
                    return  Expanded(
                      child: Center(child: const CustomSpinLoader()),
                    );
                  }

                  final data = controller.company;
                  if (data.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "No company found",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: FontFamily.hanKenBold,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(top: 6, bottom: 88),
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
                        return _CompanyCard(
                          item: item,
                          onEdit: () {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              barrierDismissible: false,
                              builder: (_) => CustomCompaniesDialog(
                                controller: controller,
                                isEdit: true,
                                item: item,
                              ),
                            );
                          },
                          onDelete: () {
                            showDeleteDialog(
                              context,
                              item.id ?? '',
                              '${item.name}',
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                useSafeArea: true,
                barrierDismissible: false,
                builder: (_) => CustomCompaniesDialog(controller: controller),
              );
            },
            backgroundColor: AppColors.floatingBtnColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tooltip: 'Create Company',
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  void openFilterDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter by Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontFamily.hanKenBold,
          ),
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu<String>(
                hintText: 'Filter by Status',
                initialSelection: controller.selected.value,
                onSelected: (value) {
                  controller.selected.value = value;
                },
                textStyle: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 15,
                  color: Colors.black,
                ),
                menuStyle: MenuStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(
                    const Size(500, 0),
                  ),
                  maximumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 400),
                  ),
                ),
                dropdownMenuEntries: controller.filter.map((e) {
                  final isSelected = e == controller.selected.value;

                  return DropdownMenuEntry<String>(
                    value: e,
                    label: e,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.floatingBtnColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String id, String cName) {
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
                        text: 'Are you sure you want to delete company ',
                      ),
                      TextSpan(
                        text: cName,
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
                                onPressed: controller.isDeleteCompany.value
                                    ? null
                                    : () async {
                                        bool success =
                                            await controller.deleteCompany(id);

                                        if (success) {
                                          Get.back();
                                          ToastWidget.showToastCustom(
                                            'Company deleted successfully',
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
                                  controller.isDeleteCompany.value
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
                            () => controller.isDeleteCompany.value
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

class _CompanyCard extends StatelessWidget {
  final CompanyModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CompanyCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color _activeGreen = Color(0xFF2E7D32);
  static const Color _activeGreenBg = Color(0xFFE8F5E9);
  static const Color _inactiveBg = Color(0xFFEEE8DF);

  @override
  Widget build(BuildContext context) {
    final isActive = item.isActive == true;
    final name = (item.name ?? '-').toString();
    final description = (item.description ?? '').toString().trim();
    final date = formatDate(item.createdAt.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? _activeGreen : AppColors.ringOuterColor,
          width: 1.7,
        ),
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
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? _activeGreenBg : _inactiveBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 12,
                      letterSpacing: 0.3,
                      color: isActive ? _activeGreen : AppColors.ringOuterColor,
                    ),
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
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
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
            if (description.isNotEmpty) ...[
              const Gap(8),
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: FontFamily.hanKenRegular,
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
            ],
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
                    date,
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
                  Icons.apartment_outlined,
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
