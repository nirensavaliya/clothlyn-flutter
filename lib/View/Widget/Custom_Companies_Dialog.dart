import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../Controller/Companies_Controller.dart';
import '../../Model/Companies_Model.dart';
import '../Common/Toast.dart';
import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';
import '../Utills/Global.dart';
import 'Custom_TextField.dart';

class CustomCompaniesDialog extends StatelessWidget {
  CompaniesController controller;
  bool isEdit;
  final CompanyModel? item;

  CustomCompaniesDialog({
    super.key,
    required this.controller,
    this.isEdit = false,
    this.item
  }) {
    if (!isEdit) {
      controller.selected.value = null;
      controller.cNameController.clear();
      controller.descriptionController.clear();
    }

    if (isEdit && item != null) {
      controller.cNameController.text = item!.name ?? '';
      controller.descriptionController.text = item!.description ?? '';
      controller.selected.value =
      item!.isActive == true ? "Active" : "Inactive";
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final activeCompany = controller.company.firstWhere(
          (e) => e.isActive == true,
      orElse: () => controller.company.first,
    );

    controller.selected.value =
    activeCompany != null
        ? (activeCompany.isActive == true ? "Active" : "Inactive")
        : "No Company";

    // if (isEdit && item != null) {
    //   controller.cNameController.text = item!.name ?? '';
    //   controller.descriptionController.text = item!.description ?? '';
    //
    //   // controller.selected.value = item!.employeeId?.id;
    // }
    return  AlertDialog(
      backgroundColor: AppColors.bgCream,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(
              "Create Company",
              style: TextStyle(
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
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 900,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextField(
                        isTitle: true,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        title:"Company Name",
                        hintText: "Enter company name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Company Name is required.";
                          }
                          return null;
                          },
                        controller: controller.cNameController,),
                      Gap(8),
                      const SizedBox(height: 20),
                      CommonTextField(
                        isTitle: true,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        title:"Description (Optional)",
                        hintText: "Enter description (Optional)",
                        validator: (value) {
                          return null;
                        },
                        controller: controller.descriptionController,),
                      if(isEdit == true)...[
                        SizedBox(height: 20,),
                        RichText(
                          text:  TextSpan(
                            text: "Employee",
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF616161),
                            ),
                            // children: [
                            //   TextSpan(text: " *", style: TextStyle(color: Colors.red))
                            // ],
                          ),
                        ),
                        Gap(8),
                        DropdownMenu<String>(
                          width: double.infinity,
                          hintText: "Select employee",
                          initialSelection: controller.selected.value,
                          onSelected: (value) {
                            controller.selected.value = value;
                          },
                          textStyle:  TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            minimumSize: MaterialStateProperty.all(
                              const Size(500, 0),
                            ),
                            maximumSize: MaterialStateProperty.all(
                              const Size(300, 400),
                            ),
                          ),
                          inputDecorationTheme:  InputDecorationTheme(
                            isDense: true,
                            border:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color:
                              controller.selected.value != null
                                  ? AppColors.floatingBtnColor
                                  : Colors.grey,
                                  width: 1.5),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                            ),
                          ),
                          dropdownMenuEntries: ["Active", "Inactive"].map((e) {
                            final isSelected = controller.selected.value == e;

                            return DropdownMenuEntry<String>(
                              value: '${e}' ?? '',
                              label: "${e}",

                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                    fontFamily: FontFamily.hanKenMedium,
                                    fontSize: 15,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.resolveWith(
                                      (states) =>
                                  isSelected ? AppColors.accentBrown : Colors.transparent,
                                ),
                                foregroundColor: MaterialStateProperty.resolveWith(
                                      (states) =>
                                  isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ]

                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child:  Text("Cancel",style: TextStyle(
                          fontFamily: FontFamily.hanKenBold,
                          fontSize: 15,
                          color: Colors.black,
                        ),),
                      ),
                      const SizedBox(width: 12),
                      Obx(() {
                        final isLoading = isEdit
                            ? controller.isUpdateCompany.value
                            : controller.isAddCompany.value;

                        return Stack(
                          children: [
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : ()async{
                                disposeKeyboard(context);
                                if (_formKey.currentState!.validate()) {
                                  bool success;

                                  if (isEdit) {
                                    success = await controller.updateCompany(
                                        description: controller.descriptionController.text,
                                        name: controller.cNameController.text,
                                        id: item?.id ?? ''
                                    );
                                  }else{
                                    success = await controller.addCompany(
                                        description: controller.descriptionController.text,
                                        name: controller.cNameController.text

                                    );
                                  }
                                  if (success) {
                                    Get.back();
                                    ToastWidget.showToastCustom(
                                        isEdit
                                            ? 'Company updated successfully'
                                            : 'Company added successfully',
                                        color: AppColors.greenColor
                                    );
                                  } else {
                                    ToastWidget.showToastCustom(
                                        isEdit? 'Failed to update admin' : 'Failed to add admin',
                                        color: Colors.red
                                    );
                                  }

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.floatingBtnColor,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child:
                              Text(
                                isLoading
                                    ? (isEdit ? "Updating..." : "Adding...")
                                    : (isEdit ? "Update Company" : "Add Company"),
                                style: TextStyle(
                                fontFamily: FontFamily.hanKenMedium,
                                fontSize: 16,
                                color: Colors.white,
                              ),),
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
                          ]
                        );
                      }
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
