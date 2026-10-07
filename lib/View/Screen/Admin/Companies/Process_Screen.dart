import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Controller/Process_Controller.dart';
import '../../../Common/Get_storage_data.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';
import '../../../Widget/Custom_Spin_Loader.dart';

class ProcessScreen extends StatelessWidget {
   ProcessScreen({super.key});

   final ProcessController controller = Get.put(ProcessController());


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
            title: "Process",
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
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
                      final userId =
                          GetStorageData.readString(GetStorageData.userId);
                      showAddProcessDialog(context, userId);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(
                      'Add Process',
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

                    final data = controller.process.value;
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          'No process found',
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                      itemCount: data.length + (showLoader ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= data.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CustomSpinLoader(size: 40, boxed: false),
                          );
                        }
                        final item = data[index];
                        final date = item.createdAt == null
                            ? '-'
                            : formatDate(item.createdAt.toString());

                        return _ProcessCard(
                          processName: item.processName ?? '-',
                          date: date,
                          onEdit: () {
                            controller.selectedProcessId = item.userId;
                            controller.processNameController.text =
                                item.processName ?? '';
                            showAddProcessDialog(
                              context,
                              controller.selectedProcessId ?? '',
                              isEdit: true,
                            );
                          },
                          onDelete: () {
                            showDeleteDialog(context, item.userId ?? '');
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

  void showAddProcessDialog(
    BuildContext context,
    String userId, {
    bool isEdit = false,
  }) {
     final _formKey = GlobalKey<FormState>();

     if (!isEdit) {
       controller.processNameController.clear();
     }

     Get.dialog(
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
                   "Add New Process",
                   style: TextStyle(
                     color: AppColors.accentBrown,
                       fontFamily: FontFamily.hanKenBold,
                       fontSize: 18),
                 ),
                 const Spacer(),
                 InkWell(
                   onTap: () => Navigator.pop(context),
                   child: const Icon(Icons.close),
                 )
               ],
             ),
           ),
           content: SizedBox(
             width: 900,
             child: Form(
               key: _formKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 children: [

                   /// DESIGN NUMBER
                   RichText(
                     text:  TextSpan(
                       text: "Process Name",
                       style: TextStyle(
                         fontFamily: FontFamily.hanKenMedium,
                         fontSize: 16,
                         fontWeight: FontWeight.w500,
                         color: Color(0xFF616161),
                       ),
                       children: [
                         TextSpan(text: " *", style: TextStyle(color: Colors.red))
                       ],
                     ),
                   ),
                   Gap(8),
                   CommonTextField(
                     isTitle: false,
                     textInputType: TextInputType.name,
                     textInputAction: TextInputAction.done,
                     hintText: "Enter process name",
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return "Process name is required.";
                       }
                       return null;
                     },
                     controller: controller.processNameController,),
                   const SizedBox(height: 20),
                 ],
               ),
             ),
           ),
           actions: [
             ElevatedButton(
               onPressed: (){
                 Get.back();
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.transparent,
                 foregroundColor: Colors.transparent,
                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                 shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.grey),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 elevation: 0,
               ),
               child:  Text(
                 "Cancel",
                 style: TextStyle(
                     fontFamily: FontFamily.hanKenMedium,
                     fontSize: 14,
                     color: Colors.black
                 ),
               ),
             ),

             const SizedBox(width: 12),
             // ElevatedButton(
             //   onPressed: (){
             //     if (_formKey.currentState!.validate()) {
             //       /// SUBMIT DATA
             //       Navigator.pop(context);
             //     }
             //   },
             //   style: ElevatedButton.styleFrom(
             //     backgroundColor: AppColors.appColor,
             //     foregroundColor: Colors.white,
             //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
             //     shape: RoundedRectangleBorder(
             //       borderRadius: BorderRadius.circular(12),
             //     ),
             //     elevation: 3,
             //   ),
             //   child:  Text(
             //     "Add New Process",
             //     style: TextStyle(
             //       fontFamily: FontFamily.jostBold,
             //       fontWeight: FontWeight.bold,
             //       fontSize: 15,
             //     ),
             //   ),
             // ),

             Obx(() {
               final isLoading = isEdit
                   ? controller.isUpdatingProcess.value
                   : controller.isAddingProcess.value;
               return  Stack(
                 clipBehavior: Clip.none,
                 alignment: Alignment.center,
                 children: [
                   ElevatedButton(
                     onPressed: isLoading
                         ? null
                         : () async{
                       disposeKeyboard(context);
                       if (_formKey.currentState!.validate()) {
                         bool success;

                         if (isEdit) {
                           success = await controller.updateProcess(
                               processName: '${controller.processNameController.text.trim()}',
                               userId: '$userId'
                           );
                         }else{
                           success = await Get.find<ProcessController>().addProcess(
                               processName: '${controller.processNameController.text.trim()}',
                               userId: '$userId'

                           );
                         }
                         if (success) {
                           Get.back();
                           ToastWidget.showToastCustom(
                               isEdit
                                   ? 'Process updated successfully'
                                   : 'Process added successfully',
                               color: AppColors.greenColor
                           );
                         } else {
                           ToastWidget.showToastCustom(
                               'Failed to add Process',
                               color: Colors.red
                           );
                         }

                       }
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppColors.floatingBtnColor,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                       elevation: 3,
                     ),
                     child:  Text(
                       isLoading
                           ? (isEdit ? "Updating..." : "Adding...")
                           : (isEdit ? "Update Admin" : "Add Admin"),
                       // controller.isAddingAdmin.value? "Adding...": "Add Admin",
                       style: TextStyle(
                         fontFamily: FontFamily.hanKenBold,
                         fontWeight: FontWeight.bold,
                         fontSize: 15,
                       ),
                     ),
                   ),

                   isLoading
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
                       : const SizedBox(),
                 ],
               );
             }

             ),

           ],
         )
     );

   }

   void showDeleteDialog(BuildContext context, String id) {
     Get.dialog(
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
           child: Text("Delete Process",  style: TextStyle(
               fontFamily: FontFamily.hanKenBold,
               fontSize: 18)),
         ),
         content: Text("Are you sure you want to delete this process?"),
         actions: [
           ElevatedButton(
             onPressed: (){
               Get.back();
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.transparent,
               foregroundColor: Colors.transparent,
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
               shape: RoundedRectangleBorder(
                 side: BorderSide(color: Colors.grey),
                 borderRadius: BorderRadius.circular(12),
               ),
               elevation: 0,
             ),
             child:  Text(
               "Cancel",
               style: TextStyle(
                   fontFamily: FontFamily.hanKenMedium,
                   fontSize: 14,
                   color: Colors.black
               ),
             ),
           ),
           const SizedBox(width: 12),

           Obx(() => ElevatedButton(
             style: ElevatedButton.styleFrom(
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
               elevation: 3,
               backgroundColor: AppColors.floatingBtnColor,
             ),
             onPressed: controller.isDeletingProcess.value
                 ? null
                 : () async {
               final success = await controller.deleteProcess(id);

               if (success) {
                 Get.back();
                 ToastWidget.showToastCustom(
                   "Process deleted successfully",
                   color: AppColors.greenColor,
                 );
               } else {
                 ToastWidget.showToastCustom(
                   "Failed to delete process",
                   color: Colors.red,
                 );
               }
             },
             child: controller.isDeletingProcess.value
                 ? SizedBox(
               height: 18,
               width: 18,
               child: LinearProgressIndicator(
                 minHeight: 3,
                 backgroundColor: AppColors.accentBrown,
                 valueColor:
                 AlwaysStoppedAnimation<Color>(Colors.white),
               ),
             )
                 : Text("Delete",style: TextStyle(
               fontFamily: FontFamily.hanKenBold,
               fontWeight: FontWeight.bold,
               fontSize: 15,
             ),),
           )),
         ],
       ),
     );
   }
}

class _ProcessCard extends StatelessWidget {
  final String processName;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProcessCard({
    required this.processName,
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
                Icons.settings_input_component_outlined,
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
                    processName,
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

void showAddProcessDialog(BuildContext context,String userId,{bool isEdit = false,}) {
  ProcessController controller = Get.put(ProcessController());
  final _formKey = GlobalKey<FormState>();

  Get.dialog(
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
                "Add New Process",
                style: TextStyle(
                    color: AppColors.accentBrown,
                    fontFamily: FontFamily.hanKenBold,
                    fontSize: 18),
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              )
            ],
          ),
        ),
        content: SizedBox(
          width: 900,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                /// DESIGN NUMBER
                RichText(
                  text:  TextSpan(
                    text: "Process Name",
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenMedium,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF616161),
                    ),
                    children: [
                      TextSpan(text: " *", style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
                Gap(8),
                CommonTextField(
                  isTitle: false,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  hintText: "Enter process name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Process name is required.";
                    }
                    return null;
                  },
                  controller: controller.processNameController,),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child:  Text(
              "Cancel",
              style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 14,
                  color: Colors.black
              ),
            ),
          ),

          const SizedBox(width: 12),

          Obx(() {
            final isLoading = isEdit
                ? controller.isUpdatingProcess.value
                : controller.isAddingProcess.value;
            return  Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async{
                    disposeKeyboard(context);
                    if (_formKey.currentState!.validate()) {
                      bool success;

                      if (isEdit) {
                        success = await controller.updateProcess(
                            processName: '${controller.processNameController.text.trim()}',
                            userId: '$userId'
                        );
                      }else{
                        success = await Get.find<ProcessController>().addProcess(
                            processName: '${controller.processNameController.text.trim()}',
                            userId: '$userId'

                        );
                      }
                      if (success) {
                        Get.back();
                        ToastWidget.showToastCustom(
                            isEdit
                                ? 'Process updated successfully'
                                : 'Process added successfully',
                            color: AppColors.greenColor
                        );
                      } else {
                        ToastWidget.showToastCustom(
                            'Failed to add Process',
                            color: Colors.red
                        );
                      }

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.floatingBtnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child:  Text(
                    isLoading
                        ? (isEdit ? "Updating..." : "Adding...")
                        : (isEdit ? "Update Admin" : "Add Admin"),
                    // controller.isAddingAdmin.value? "Adding...": "Add Admin",
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                isLoading
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
                    : const SizedBox(),
              ],
            );
          }

          ),

        ],
      )
  );

}




class Process {
  final String date;
  final String processName;

  Process({
    required this.date,
    required this.processName,
  });
}
