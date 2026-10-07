import 'package:clothlyn/View/Widget/Custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/Add_product_Controller.dart';
import '../../Model/Product_Model.dart';
import '../Common/Toast.dart';
import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';
import '../Utills/Global.dart';

class AddProductDialog extends StatelessWidget {
  bool isEdit;
  final ProductItem? item;
   AddProductDialog({super.key,    this.isEdit = false,this.item}){
     if (!isEdit) {
       controller.selected.value = null;
       controller.dateController.clear();
       controller.dNoController.clear();
       controller.lotNoController.clear();
       controller.colorController.clear();
       controller.sizeController.clear();
       controller.layerController.clear();
       controller.masterController.clear();
       controller.picController.clear();
     }

     if (isEdit && item != null) {
       controller.dateController.text = item!.date.toString();
       controller.dNoController.text = item!.dNo ?? '';
       controller.lotNoController.text = item!.lotNo ?? '';
       controller.colorController.text = item!.colour ?? '';
       controller.sizeController.text = item!.size ?? '';
       controller.layerController.text = item!.layer.toString() ?? '';
       controller.masterController.text = item!.master ?? '';
       controller.picController.text = item!.pic ?? '';
       controller.selected.value;
     }
   }

   final AddProductController controller =
   Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              "Add New Product",
              style: TextStyle(
                  fontFamily: FontFamily.jostBold,
                  color: AppColors.accentBrown,
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
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _row(
                        left: _dateField("Date",context,controller.dateController),
                        right: CommonTextField(isTitle: true,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "LOTNo is required.";
                            }
                            return null;
                          },
                          title: "Lot No",hintText:  "Enter lot number", controller: controller.lotNoController,),
                      ),
                      const SizedBox(height: 20),
                      _row(
                        left: CommonTextField(
                          isTitle: true,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          title:"D. No",
                           hintText: "Enter D number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "DNo is required.";
                            }
                            return null;
                          },
                            controller: controller.dNoController,),
                        right: CommonTextField(
                          isTitle: true,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                            title: "Color",
                             hintText: "Enter color",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Color is required.";
                            }
                            return null;
                          },
                              controller: controller.colorController,),
                      ),
                      const SizedBox(height: 20),
                      _row(
                        left: CommonTextField(isTitle: true,title: "Size",hintText:  "Enter size",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Size is required.";
                            }
                            return null;
                          },
                          controller: controller.sizeController,),
                        right: CommonTextField(isTitle: true,title: "Layer",hintText:  "Enter layer",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Layer is required.";
                            }
                            return null;
                          },
                          controller: controller.layerController,),
                      ),
                      const SizedBox(height: 20),
                      _row(
                        left: CommonTextField(isTitle: true,title:"Master",hintText:  "Enter master",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Master is required.";
                            }
                            return null;
                          },
                          controller: controller.masterController,),
                        right: CommonTextField(isTitle: true,title: "Pic",hintText:  "Enter pic",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Pic is required.";
                            }
                            return null;
                          },
                          controller: controller.picController,),
                      ),
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
                          fontFamily: FontFamily.hanKenMedium,
                          fontSize: 15,
                          color: Colors.black,
                        ),),
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
                                if (controller.formKey.currentState!.validate()) {
                                  bool success;

                                  if (isEdit) {
                                    success = await controller.updateProduct(
                                        id: item?.id ?? '',
                                        date: controller.dateController.text,
                                        lotNo: controller.lotNoController.text,
                                        dNo: controller.dNoController.text,
                                        color: controller.colorController.text,
                                        size: controller.sizeController.text,
                                        layer: controller.layerController.text,
                                        master: controller.masterController.text,
                                        pic: controller.picController.text
                                    );
                                  }else{
                                    success = await Get.find<AddProductController>().addProduct(
                                    );
                                  }
                                  if(success){
                                    Get.back();
                                    ToastWidget.showToastCustom(
                                      isEdit ? "Product Updated Successfully" :"Product Added Successfully",
                                      color: Colors.green,
                                    );
                                    print('success---${success}');
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
                                    : (isEdit ? "Update Product" : "Add Product"),
                                style: TextStyle(
                                  fontFamily: FontFamily.hanKenBold,
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
                      // Obx(()
                      //   => ElevatedButton(
                      //     onPressed: controller.isLoading.value
                      //         ? null
                      //         : controller.addProduct,
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors.appColor,
                      //       padding:
                      //       const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)),
                      //     ),
                      //     child: controller.isLoading.value
                      //         ? LoadingAnimationWidget.threeRotatingDots(
                      //       color: Colors.white,
                      //       size: 18,
                      //     ):
                      //     Text("Add Product",style: TextStyle(
                      //       fontFamily: FontFamily.jostMedium,
                      //       fontSize: 16,
                      //       color: Colors.white,
                      //     ),),
                      //   ),
                      // ),
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

  static Widget _row({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 20),
        Expanded(child: right),
      ],
    );
  }

  static Widget _dateField(String label,BuildContext context,  TextEditingController controller,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
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
              color: AppColors.hintTextColor,
              fontSize: 16,
              fontFamily: FontFamily.hanKenMedium,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:AppColors.floatingBtnColor, width: 1.5),
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

  static Widget _label(String text) {
    return RichText(
      text: TextSpan(
        text: text,
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
    );
  }
}
