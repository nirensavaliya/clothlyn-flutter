import 'package:clothlyn/Controller/Admin_Controller.dart';
import 'package:clothlyn/Model/Admin_User_List_Model.dart';
import 'package:clothlyn/View/Utills/Global.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  final AdminController controller = Get.put(AdminController());

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
            title: "Admin",
            actions: GestureDetector(
              onTap: () => showAddAdminDialog(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.floatingBtnColor,
                  size: 30,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: const CustomSpinLoader(),
                );
              }

              final data = controller.adminUsers;

              if (data.isEmpty) {
                return Center(
                  child: Text(
                    "No admin users found",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: FontFamily.hanKenBold,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              final showLoader = controller.hasMore.value;

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.only(top: 6, bottom: 88),
                itemCount: data.length + (showLoader ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= data.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomSpinLoader(size: 40, boxed: false),
                    );
                  }
                  final item = data[index];
                  return _AdminCard(
                    item: item,
                    onEdit: () {
                      controller.selectedAdminId = item.id;
                      controller.employeeCodeController.text =
                          item.clientCode ?? '';
                      controller.nameController.text = item.username ?? '';
                      controller.mobileNumberController.text =
                          item.phoneNumber.replaceAll("+91", "");
                      controller.companyController.text = item.company ?? '';
                      controller.emailController.text = item.email ?? '';
                      showAddAdminDialog(context, isEdit: true);
                    },
                    onDelete: () => showDeleteDialog(context, item.id),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

   void showAddAdminDialog(BuildContext context,{bool isEdit = false}) {
     final _formKey = GlobalKey<FormState>();
     if (!isEdit) {
       controller.employeeCodeController.clear();
       controller.nameController.clear();
       controller.mobileNumberController.clear();
       controller.passwordController.clear();
       controller.emailController.clear();
       controller.companyController.clear();
       controller.nicknameController.clear();
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
                   isEdit ? "Edit Admin" :"Add Admin",
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
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             RichText(
                               text:  TextSpan(
                                 text: "Employee Code",
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
                               textInputType: TextInputType.text,
                               textInputAction: TextInputAction.next,
                               hintText: "Enter employee code",
                               validator: (value) {
                                 if (value == null || value.isEmpty) {
                                   return "employee code is required.";
                                 }
                                 return null;
                               },
                               controller: controller.employeeCodeController,),
                           ],
                         ),
                       ),
                       Gap(10),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             RichText(
                               text:  TextSpan(
                                 text: "Name",
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
                               textInputType: TextInputType.text,
                               textInputAction: TextInputAction.next,
                               hintText: "Enter name",
                               validator: (value) {
                                 if (value == null || value.isEmpty) {
                                   return "name is required.";
                                 }
                                 return null;
                               },
                               controller: controller.nameController,),
                           ],
                         ),
                       ),
                     ],
                   ),
                   Gap(13),
                   RichText(
                     text: TextSpan(
                       text: 'Mobile Number ',
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 14,
                         fontFamily: FontFamily.hanKenBold,
                         fontWeight: FontWeight.w600,
                       ),
                       children: [
                         TextSpan(
                           text: '*',
                           style: TextStyle(color: Colors.red),
                         ),
                       ],
                     ),
                   ),
                   Gap(8),
                   CommonTextField(
                     isTitle: false,
                     controller: controller.mobileNumberController,
                     prefixIconConstraints: const BoxConstraints(
                       minWidth: 0,
                       minHeight: 0,
                     ),
                     borderRadius: 8,
                     textInputType: TextInputType.number,
                     textInputAction: TextInputAction.done,
                     maxLength: 10,
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Mobile number is required';
                       } else if (value.length != 10) {
                         return 'Mobile number must be 10 digits';
                       } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                         return 'Mobile number can contain only digits';
                       }
                       return null;
                     },
                     prefix: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 12),
                       child: Text(
                         '+91',
                         style: TextStyle(
                           color: Colors.black,
                           fontFamily: FontFamily.jostBold,
                         ),
                       ),
                     ),
                     hintText: 'Enter mobile number',
                   ),

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
                   ? controller.isUpdatingAdmin.value
                   : controller.isAddingAdmin.value;
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
                           success = await controller.updateAdmin(
                             id: controller.selectedAdminId!,
                             phoneNumber:
                             '${controller.mobileNumberController.text}',
                             username: controller.nameController.text,
                             password: controller.passwordController.text,
                             clientCode:
                             controller.employeeCodeController.text,
                             company: controller.companyController.text,
                             email: controller.emailController.text,
                             nickname: controller.nicknameController.text,
                           );
                         }else{
                            success = await Get.find<AdminController>().addAdmin(
                             phoneNumber: '+91${controller.mobileNumberController.text}',
                             username: controller.nameController.text,
                             password: controller.passwordController.text,
                             clientCode: controller.employeeCodeController.text,
                             company: controller.companyController.text,
                             email: controller.emailController.text,
                             nickname: controller.nicknameController.text,
                           );
                         }
                         if (success) {
                           Get.back();
                           ToastWidget.showToastCustom(
                               isEdit
                                   ? 'Admin updated successfully'
                                   : 'Admin added successfully',
                               color: AppColors.greenColor
                           );
                         } else {
                           ToastWidget.showToastCustom(
                               'Failed to add admin',
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
           child: Text("Delete Admin",  style: TextStyle(
               fontFamily: FontFamily.hanKenBold,
               fontSize: 18)),
         ),
         content: Text("Are you sure you want to delete this admin?"),
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
             onPressed: controller.isDeletingAdmin.value
                 ? null
                 : () async {
               final success = await controller.deleteAdmin(id);

               if (success) {
                 Get.back();
                 ToastWidget.showToastCustom(
                   "Admin deleted successfully",
                   color: AppColors.greenColor,
                 );
               } else {
                 ToastWidget.showToastCustom(
                   "Failed to delete admin",
                   color: Colors.red,
                 );
               }
             },
             child: controller.isDeletingAdmin.value
                 ? SizedBox(
               height: 18,
               width: 18,
               child: CircularProgressIndicator(
                 strokeWidth: 2,
                 color: Colors.white,
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

class _AdminCard extends StatelessWidget {
  final AdminUserModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  // static const Color _borderBrown = Color(0xFF6A5C44);
  static const Color _activeGreen = Color(0xFF2E7D32);
  static const Color _activeGreenBg = Color(0xFFE8F5E9);
  static const Color _inactiveBg = Color(0xFFEEE8DF);

  String get _initials {
    final name = item.username.trim();
    if (name.isEmpty) return "A";
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String get _displayPhone {
    final phone = item.phoneNumber.trim();
    if (phone.isEmpty) return "—";
    return phone.replaceAll("+91", "").trim();
  }

  bool get _isActive =>
      item.status.toLowerCase() == 'active' || item.status.isEmpty;

  @override
  Widget build(BuildContext context) {
    final username = item.username.trim().isNotEmpty ? item.username : "—";
    final clientCode =
        item.clientCode.trim().isNotEmpty ? item.clientCode : "—";
    final email = item.email.trim().isNotEmpty ? item.email : "—";
    final company = (item.company ?? '').trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isActive ? _activeGreen : AppColors.ringOuterColor,
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
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DCC8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _initials,
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 16,
                      color: AppColors.floatingBtnColor,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        "Code: $clientCode",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.hanKenRegular,
                          fontSize: 13,
                          color: AppColors.textColor.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isActive ? _activeGreenBg : _inactiveBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: _isActive ? _activeGreen : AppColors.ringOuterColor,
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
            const Gap(12),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.phone_outlined,
                    label: "Mobile",
                    value: _displayPhone,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _infoTile(
                    icon: Icons.badge_outlined,
                    label: "Client Code",
                    value: clientCode,
                  ),
                ),
              ],
            ),
            const Gap(8),
            _infoTile(
              icon: Icons.email_outlined,
              label: "Email",
              value: email,
            ),
            if (company.isNotEmpty) ...[
              const Gap(8),
              _infoTile(
                icon: Icons.apartment_outlined,
                label: "Company",
                value: company,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.floatingBtnColor),
          const Gap(6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 11,
                    color: AppColors.textColor.withValues(alpha: 0.55),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 13,
                    color: AppColors.textColor,
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

