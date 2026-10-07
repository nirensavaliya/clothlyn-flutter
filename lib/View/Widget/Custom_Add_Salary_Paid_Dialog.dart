import 'package:clothlyn/Controller/Admin_Salary_Paid_Controller.dart';
import 'package:clothlyn/Controller/Employee_Controller.dart';
import 'package:clothlyn/View/Utills/Global.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../Controller/Admin_Salary_Master_Controller.dart';
import '../../Model/Admin_Salary_Paid_Model.dart';
import '../Common/Toast.dart';
import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';
import 'Custom_TextField.dart';

class CustomAddSalaryPaidDialog extends StatelessWidget {
  final bool isEdit;
  final AdminSalaryPaidController adminSalaryPaidController;
  final PaidSalaries? item;
  final EmployeeController employeeController;

  CustomAddSalaryPaidDialog({super.key, this.isEdit = false,required this.adminSalaryPaidController,this.item,required this.employeeController}) {
    if (!isEdit) {
      controller.selected.value = null;
      dateController.clear();
      endDateController.clear();
      adminSalaryPaidController.paidController.clear();
      adminSalaryPaidController.isUpad.value = false;
      adminSalaryPaidController.paymentType.value = 'salary';
    }
    if (isEdit && item != null) {
      adminSalaryPaidController.paidController.text = item!.employee.totalPaid.toString();
      // dateController.text = apiToUiDate(item!.startDate ?? '');
      // endDateController.text = apiToUiDate(item!.endDate ?? '');
      adminSalaryPaidController.isUpad.value = item?.isUpad ?? false;
      adminSalaryPaidController.paymentType.value =
          (item?.paymentType.isNotEmpty == true)
              ? item!.paymentType
              : ((item?.isUpad ?? false) ? 'upad' : 'salary');

      controller.selected.value = item!.employee.id;
    }
  }

  final AdminSalaryMasterController controller = Get.put(AdminSalaryMasterController());
   final dateController = TextEditingController();
   final endDateController = TextEditingController();
     final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

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
              "Add Salary Paid",
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                        dropdownMenuEntries: employeeController.employees.map((e) {
                          final isSelected = e.id  == controller.selected.value;

                          return DropdownMenuEntry<String>(
                            value: '${e.id}' ?? '',
                            label: '${e.firstName} ${e.lastName} (${e.employeeName})' ?? '',

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
                      Gap(8),
                      const SizedBox(height: 20),
                      CommonTextField(
                        isTitle: true,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        title:"Paid Amount",
                        hintText: "Enter amount",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount is required.";
                          }
                          return null;
                          },
                        controller: adminSalaryPaidController.paidController,),
                      const SizedBox(height: 20),
                      Obx(
                        () {
                          final selectedType =
                              adminSalaryPaidController.paymentType.value;
                          const types = <MapEntry<String, String>>[
                            MapEntry('salary', 'Salary'),
                            MapEntry('upad', 'Upad'),
                            MapEntry('bonus', 'Bonus'),
                          ];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type",
                                style: TextStyle(
                                  fontFamily: FontFamily.hanKenMedium,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF616161),
                                ),
                              ),
                              Gap(8),
                              DropdownMenu<String>(
                                width: double.infinity,
                                hintText: "Select type",
                                initialSelection: selectedType,
                                onSelected: (value) {
                                  if (value == null) return;
                                  adminSalaryPaidController.paymentType.value =
                                      value;
                                  adminSalaryPaidController.isUpad.value =
                                      value == 'upad';
                                },
                                textStyle: TextStyle(
                                  fontFamily: FontFamily.hanKenMedium,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                menuStyle: MenuStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(500, 0),
                                  ),
                                  maximumSize: MaterialStateProperty.all(
                                    const Size(300, 400),
                                  ),
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.floatingBtnColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: AppColors.floatingBtnColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                dropdownMenuEntries: types.map((e) {
                                  final isSelected = e.key == selectedType;
                                  return DropdownMenuEntry<String>(
                                    value: e.key,
                                    label: e.value,
                                    style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                          fontFamily: FontFamily.hanKenMedium,
                                          fontSize: 15,
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => isSelected
                                            ? AppColors.accentBrown
                                            : Colors.transparent,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.resolveWith(
                                        (states) => isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        },
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: dateField("Start Date", context, dateController),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: dateField("End Date", context, endDateController),
                      //     ),
                      //   ],
                      // ),

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
                            ? adminSalaryPaidController.isUpdateSalary.value
                            : adminSalaryPaidController.isAddingSalary.value;
                        return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  :   () async{
                                disposeKeyboard(context);
                                if (controller.selected.value == null || controller.selected.value!.isEmpty) {
                                  ToastWidget.showToastCustom(
                                    "Please select employee",
                                    color: Colors.red,
                                  );
                                  return;
                                }

                                if(_formKey.currentState!.validate()){
                                  bool success;
                                  if (isEdit) {
                                    success = await adminSalaryPaidController.editSalary(
                                        employeeId: item?.employee.id.toString() ??'',
                                        paid: adminSalaryPaidController.paidController.text,
                                        // startDate: convertToApiDate(dateController.text),
                                        // endDate: convertToApiDate(endDateController.text),
                                        employeePassApiId: item?.id ?? '',
                                        isUpad: adminSalaryPaidController.paymentType.value == 'upad',
                                        paymentType: adminSalaryPaidController.paymentType.value,
                                    );
                                  }else{
                                    success = await adminSalaryPaidController.addSalaryPaid(
                                        employeeId: controller.selected.value ?? '',
                                        paid: adminSalaryPaidController.paidController.text,
                                        isUpad: adminSalaryPaidController.paymentType.value == 'upad',
                                        paymentType: adminSalaryPaidController.paymentType.value,
                                    );
                                  }
                                  if (success) {
                                    Get.back();
                                    ToastWidget.showToastCustom(
                                        isEdit
                                            ? 'Salary updated successfully'
                                            : 'Salary added successfully',
                                        color: AppColors.greenColor
                                    );
                                  } else {
                                    ToastWidget.showToastCustom(
                                        isEdit? 'Fails to update Salary' :'Failed to add salary',
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
                                    ? (isEdit ? "Updating..." : "Adding...")
                                    : (isEdit ? "Update Salary" : "Add Salary"),                            style: TextStyle(
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



Widget dateField(String label,BuildContext context,  TextEditingController controller,) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style:  TextStyle(
            fontFamily: FontFamily.hanKenMedium,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF616161),
          ),
          children: const [
            TextSpan(text: " *", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        readOnly: true,
        cursorColor: AppColors.accentBrown,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: FontFamily.hanKenBold,
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Date is Required";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "dd / mm / yyyy",
          hintStyle: TextStyle(
            color: Color(0xFF616161),
            fontSize: 16,
            fontFamily: FontFamily.hanKenMedium,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          border:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
          ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
          ),
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            controller.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/"
                "${pickedDate.month.toString().padLeft(2, '0')}/"
                "${pickedDate.year}";
          }
        },
      ),
    ],
  );
}
