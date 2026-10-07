import 'package:clothlyn/Controller/Admin_Upad_Controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../Model/Upad_Model.dart';
import '../Common/Toast.dart';
import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';
import '../Utills/Global.dart';
import 'Custom_TextField.dart';

class CustomAddUpadDialog extends StatefulWidget {
  final AdminUpadController adminUpadController;
  final bool isEdit;
  UpadData? item;

   CustomAddUpadDialog({super.key,required this.adminUpadController,this.isEdit = false,this.item}){
     if (!isEdit) {
       adminUpadController.selected.value = null;
       adminUpadController.upadAmountController.clear();;
     }
     if (isEdit && item != null) {
       adminUpadController.upadAmountController.text = item!.upadAmount.toString();

       adminUpadController.selected.value = item!.employeeId?.id;
     }
   }

  @override
  State<CustomAddUpadDialog> createState() => _CustomAddUpadDialogState();
}

class _CustomAddUpadDialogState extends State<CustomAddUpadDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(24),
        scrollable: true,
        titlePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(
              "Add New UPAD",
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
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 900,
          child: SingleChildScrollView(
            child: Obx(()
              => Form(
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
                          RichText(
                            text:  TextSpan(
                              text: "Select Employee",
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
                         DropdownMenu<String>(
                           enabled: !widget.isEdit,
                           width: double.infinity,
                    hintText: "Select an employee",
                    initialSelection: widget.adminUpadController.selected.value,
                    onSelected: (value) {
                      widget.adminUpadController.selected.value = value;
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
                        borderSide: BorderSide(color: widget.adminUpadController.selected.value != null
                        ? AppColors.floatingBtnColor
                            : Colors.grey,
                            width: 1.5),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                      ),
                    ),
                    dropdownMenuEntries: widget.adminUpadController.employee.map((e) {
                      final isSelected = e.id == widget.adminUpadController.selected.value;

                      return DropdownMenuEntry<String>(
                        value: '${e.id}',
                        label: '${e.firstName} ${e.lastName} ${e.employeeName}',

                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                            isSelected ? AppColors.floatingBtnColor : Colors.transparent,
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                            isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                          const SizedBox(height: 20),
                          CommonTextField(
                            isTitle: true,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            title:"UPAD Amount",
                            hintText: "Enter UPAD Amount",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Upad amount is required.";
                              }
                              return null;
                            },
                            controller: widget.adminUpadController.upadAmountController,),
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
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
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
                            final isLoading = widget.isEdit
                                ? widget.adminUpadController.isUpdateUpad.value
                                : widget.adminUpadController.isAddUpad.value;
                            return Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        :   () async{
                                      disposeKeyboard(context);
                                      if (widget.adminUpadController.selected.value == null || widget.adminUpadController.selected.value!.isEmpty) {
                                        ToastWidget.showToastCustom(
                                          "Please select employee",
                                          color: Colors.red,
                                        );
                                        return;
                                      }

                                      if(_formKey.currentState!.validate()){
                                        bool success;
                                        if (widget.isEdit) {
                                          success = await widget.adminUpadController.editUPad(
                                              upadId: widget.adminUpadController.selected.value ?? '',
                                              uPadAmount: widget.adminUpadController.upadAmountController.text,
                                              id: widget.item?.id ?? ''
                                          );
                                        }else{
                                          success = await widget.adminUpadController.addUpad(
                                              uPadAmount: widget.adminUpadController.upadAmountController.text,
                                              uPadId: widget.adminUpadController.selected.value ?? ''

                                          );
                                        }
                                        if (success) {
                                          Get.back();
                                          ToastWidget.showToastCustom(
                                              widget.isEdit
                                                  ? 'Upad updated successfully'
                                                  : 'Upad added successfully',
                                              color: AppColors.greenColor
                                          );
                                        } else {
                                          ToastWidget.showToastCustom(
                                              widget.isEdit? 'Fails to update Upad' :'Failed to add upad',
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
                                    child: Text(
                                      isLoading
                                          ? (widget.isEdit ? "Updating..." : "Adding...")
                                          : (widget.isEdit ? "Update Upad" : "Add Upad"),                            style: TextStyle(
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
        ),
    );
  }
}
