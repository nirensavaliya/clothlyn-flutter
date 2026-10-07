import 'package:clothlyn/Controller/Machine_Controller.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Common/Get_storage_data.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';

class MachineScreen extends StatelessWidget {
   MachineScreen({super.key});

   final MachineController controller = Get.put(MachineController());


   @override
  Widget build(BuildContext context) {
    return  Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
      children: [
        const ColoredBox(color: AppColors.bgCream),
        const FigmaBackgroundBlur(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: commonAppBar(
            title: "Machine",
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CommonTextField(
                  controller: controller.searchController,
                  hintText: 'Search Machine...',
                  prefix: GestureDetector(
                    onTap: () {
                      controller.searchController.clear();
                      controller.onSearch('');
                    },
                    child: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    controller.onSearch(value);
                  },
                ),
                const Gap(12),
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
                      showAddMachineDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(
                      'Add Machine',
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
                    final list = controller.machine;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'No available machine',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontFamily.hanKenMedium,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.accentBrown,
                      onRefresh: () => controller.loadFirstPage(),
                      child: ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                        itemCount:
                            list.length + (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == list.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: controller.isMoreLoading.value
                                    ? CustomSpinLoader(size: 28, boxed: false)
                                    : const SizedBox.shrink(),
                              ),
                            );
                          }

                          final item = list[index];
                          return _MachineCard(
                            machineName: item.machineName ?? '-',
                            date: formatDate(item.createdAt.toString()),
                            onEdit: () {
                              controller.selectedMachineId = item.id;
                              controller.machineNameController.text =
                                  item.machineName ?? '';
                              showAddMachineDialog(
                                context,
                                isEdit: true,
                                machineId: item.id,
                              );
                            },
                            onDelete: () {
                              showDeleteDialog(
                                context,
                                item.machineName ?? '',
                                item.id ?? '',
                              );
                            },
                          );
                        },
                      ),
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

   void showDeleteDialog(BuildContext context,String machineName,String machineId) {
     showDialog(
       context: context,
       barrierDismissible: false,
       useSafeArea: true,
       builder: (context) {
         return Dialog(
           backgroundColor: AppColors.bgCream,
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
                     fontFamily: FontFamily.hanKenBold,
                     fontWeight: FontWeight.bold,
                   ),
                 ),

                 const SizedBox(height: 10),

                 /// Message
                 RichText(
                   textAlign: TextAlign.center,
                   text: TextSpan(
                     style:  TextStyle(
                       fontSize: 14,
                       color: Colors.black54,
                       fontFamily: FontFamily.hanKenMedium,
                     ),
                     children: [
                       const TextSpan(text: 'Are you sure you want to design '),
                       TextSpan(
                         text: machineName,
                         style:  TextStyle(fontSize: 15,fontFamily: FontFamily.hanKenBold,color: Colors.black),
                       ),
                       const TextSpan(text: '?'),
                     ],
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
                               onPressed: controller.isDeleteMachine.value
                                   ? null
                                   : () async {
                                 bool success = await controller.deleteMachine(machineId);

                                 if (success) {
                                   Get.back();
                                   ToastWidget.showToastCustom(
                                     "Design deleted successfully",
                                     color: Colors.green,
                                   );
                                 } else {
                                   ToastWidget.showToastCustom(
                                     "Failed to delete design",
                                     color: Colors.red,
                                   );
                                 }
                               },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.floatingBtnColor,
                                 padding: const EdgeInsets.symmetric(vertical: 14),
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 elevation: 2,
                               ),
                               child: Text(
                                 controller.isDeleteMachine.value
                                     ? "Deleting..."
                                     : "Yes, Delete",
                                 style:  TextStyle(
                                   color: Colors.white,
                                   fontFamily: FontFamily.hanKenBold,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ),
                           )),

                           /// ⚡ Bottom Linear Loader
                           Obx(() => controller.isDeleteMachine.value
                               ? const Positioned(
                             bottom: 0,
                             left: 0,
                             right: 0,
                             child: LinearProgressIndicator(
                               minHeight: 3,
                               backgroundColor: AppColors.accentBrown,
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

class _MachineCard extends StatelessWidget {
  final String machineName;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MachineCard({
    required this.machineName,
    required this.date,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color _iconBg = Color(0xFFE8DCC8);

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
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.precision_manufacturing_outlined,
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
                    machineName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
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
                    ],
                  ),
                ],
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
      ),
    );
  }
}

void showAddMachineDialog(
  BuildContext context, {
  bool isEdit = false,
  String? machineId,
}) {
  final MachineController controller = Get.put(MachineController());
  final formKey = GlobalKey<FormState>();
  if (!isEdit) {
    controller.machineNameController.clear();
  }

  Get.dialog(
    useSafeArea: true,
    AlertDialog(
      backgroundColor: AppColors.bgCream,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(
              isEdit ? 'Edit Machine' : 'Add New Machine',
              style: TextStyle(
                color: AppColors.accentBrown,
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
      content: SizedBox(
        width: 900,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Machine Name',
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF616161),
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              CommonTextField(
                isTitle: false,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                hintText: 'Enter Machine Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Machine name is required.';
                  }
                  return null;
                },
                controller: controller.machineNameController,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: FontFamily.hanKenMedium,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Obx(() {
          final isLoading = isEdit
              ? controller.isUpdateMachine.value
              : controller.isAddMachine.value;
          return Stack(
            children: [
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        disposeKeyboard(context);
                        if (formKey.currentState!.validate()) {
                          final userId = GetStorageData.readString(
                            GetStorageData.userId,
                          );
                          final bool success;
                          if (isEdit) {
                            success = await Get.find<MachineController>()
                                .editMachine(
                              machineName:
                                  controller.machineNameController.text.trim(),
                              machineId: machineId ?? '',
                              userId: userId,
                            );
                          } else {
                            success =
                                await Get.find<MachineController>().addMachine(
                              machineName:
                                  controller.machineNameController.text.trim(),
                              userId: userId,
                            );
                          }

                          if (success) {
                            Get.back();
                            ToastWidget.showToastCustom(
                              isEdit
                                  ? 'Machine updated successfully'
                                  : 'Machine added successfully',
                              color: AppColors.greenColor,
                            );
                          } else {
                            ToastWidget.showToastCustom(
                              isEdit
                                  ? 'Failed to update machine'
                                  : 'Failed to add machine',
                              color: Colors.red,
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.floatingBtnColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  isLoading
                      ? (isEdit ? 'Updating...' : 'Adding...')
                      : (isEdit ? 'Update Machine' : 'Add Machine'),
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenBold,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isLoading)
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: AppColors.accentBrown,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          );
        }),
      ],
    ),
  );
}

class Machine {
  final String date;
  final String machineName;

  Machine({
    required this.date,
    required this.machineName,
  });
}

