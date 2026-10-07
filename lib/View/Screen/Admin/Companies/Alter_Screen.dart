import 'package:clothlyn/Controller/Alter_Controller.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_TextField.dart';

class AlterScreen extends StatelessWidget {
   AlterScreen({super.key});

  final AlterController controller = Get.put(AlterController());

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
          appBar: commonAppBar(title: "Alter"),
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
                Gap(15),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Expanded(
                      child: Center(
                        child: const CustomSpinLoader(),
                      ),
                    );
                  }

                  final data = controller.filteredList;
                  if (data.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'No alter found',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontFamily.hanKenMedium,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final showLoader = controller.hasMore.value;
                  return Expanded(
                    child: ListView.builder(
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
                        final isSelected =
                            controller.selectedLot.value == item.lotNo;

                        return _AlterCard(
                          lotNo: item.lotNo ?? '-',
                          alterCount: item.alterCount ?? 0,
                          isSelected: isSelected,
                          onTap: () async {
                            controller.selectedLot.value = item.lotNo ?? '';
                            controller.alterValueController.text =
                                item.alterCount.toString();
                            await controller
                                .getAlterEditLot(item.lotNo ?? '');
                            showAlterDialog(context, 0);
                          },
                        );
                      },
                    ),
                  );
                }),
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
            hintText: 'Search lot number...',
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

  void showAlterDialog(BuildContext context, int index) {
     showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           backgroundColor:  AppColors.bgCream,
           insetPadding: const EdgeInsets.all(24),
           scrollable: true,
           titlePadding: EdgeInsets.zero,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
           title: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
             child: Row(
               children: [
                 Text(
                   "Alter Details",
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
           content: Obx(() {
             if (controller.isEditLoading.value) {
               return Center(
                 child: const CustomSpinLoader(),
               );
             }

             if (controller.alterEdit.isEmpty) {
               return const SizedBox(
                 height: 200,
                 child: Center(child: Text("No Data Found")),
               );
             }
             return SizedBox(
               width: 900,
               child: SingleChildScrollView(
                 child: Column(
                   // mainAxisSize: MainAxisSize.min,
                   children: [

                     Container(
                       padding: const EdgeInsets.all(14),
                       decoration: BoxDecoration(
                         color: Colors.grey.shade100,
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Row(
                         children: [
                           CircleAvatar(
                             backgroundColor: AppColors.ringInnerColor,
                             child: const Icon(Icons.inventory, color: AppColors.floatingBtnColor),
                           ),
                           const SizedBox(width: 10),
                           Text(
                             "${controller.alterEdit[index].lotNo}",
                             style: TextStyle(
                               fontSize: 16,
                               fontFamily: FontFamily.hanKenBold,
                             ),
                           )
                         ],
                       ),
                     ),

                     const SizedBox(height: 16),

                     Padding(
                       padding: const EdgeInsets.all(11.0),
                       child: _cardContainer(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               "Lot Information",
                               style: TextStyle(
                                 fontFamily: FontFamily.hanKenBold,
                                 fontSize: 18,
                               ),
                             ),
                             const SizedBox(height: 12),
                             _infoRow("LOT NUMBER", "${controller.alterEdit[index].lotNo}"),
                             _infoRow("SIZE", "${controller.alterEdit[index].size}"),
                             _infoRow("PIC", "${controller.alterEdit[index].pic}"),
                             _infoRow("PRICE", "₹-"),
                             _infoRow("D NUMBER", "${controller.alterEdit[index].dNo}"),
                             _infoRow("COLOR", "${controller.alterEdit[index].color}"),
                             _infoRow("RC PIC", "${controller.alterEdit[index].rcPic}"),

                           ],
                         ),
                       ),
                     ),

                     const SizedBox(height: 16),

                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: _cardContainer(
                         child: Form(
                           key: controller.formKey,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 children: [
                                   Icon(Icons.edit_square, size: 25,color: AppColors.floatingBtnColor,),
                                   Gap(5),
                                   Text(
                                     "Alter Value",
                                     style: TextStyle(
                                       fontFamily: FontFamily.hanKenBold,
                                       fontSize: 18,
                                     ),
                                   ),
                                 ],
                               ),

                               const SizedBox(height: 10),
                               CommonTextField(
                                 isTitle: true,
                                 textInputType: TextInputType.text,
                                 textInputAction: TextInputAction.next,
                                 title:"Alter Value",
                                 hintText: "Enter alter value",
                                 validator: (value) {
                                   if (value == null || value.isEmpty) {
                                     return "Alter Value is required.";
                                   }
                                   return null;
                                 },
                                 controller: controller.alterValueController,),
                             ],
                           ),
                         ),
                       ),
                     ),

                     const SizedBox(height: 20),
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
                             final isLoading = controller.isUpdateLoading.value;
                             return Stack(
                                 clipBehavior: Clip.none,
                                 alignment: Alignment.center,
                                 children: [
                                   ElevatedButton(
                                     onPressed: isLoading
                                         ? null
                                         :   () async{
                                       disposeKeyboard(context);

                                       if(controller.formKey.currentState!.validate()){
                                         bool success = await controller.updateAlter(alter: controller.alterValueController.text, id: controller.alterEdit[index].lotNo ?? '');

                                         if (success) {
                                           Get.back();
                                           ToastWidget.showToastCustom(
                                              'Alter updated successfully',
                                               color: AppColors.greenColor
                                           );
                                         } else {
                                           ToastWidget.showToastCustom(
                                                'Fails to update Alter',
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
                                       isLoading ? "Updating..." :"Update",
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
             );
           }
           ),
         );
       },
     );
   }

   Widget _cardContainer({required Widget child}) {
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         color: Colors.white,
         border: Border.all(color: AppColors.floatingBtnColor,width: 0),
         borderRadius: BorderRadius.circular(10),
       ),
       child: child,
     );
   }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.hanKenMedium,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF616161),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontFamily: FontFamily.hanKenBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlterCard extends StatelessWidget {
  final String lotNo;
  final int alterCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _AlterCard({
    required this.lotNo,
    required this.alterCount,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _selectedBg = Color(0xFFE8DCC8);
  static const Color _countBg = Color(0xFFF7F4F0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              color: isSelected ? _selectedBg : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.ringOuterColor,
                width: isSelected ? 2 : 1.7,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.7)
                        : _countBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.content_cut_outlined,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : _countBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Alter $alterCount',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 13,
                      color: AppColors.ringOuterColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _AlterCard extends StatelessWidget {
//   final String lotNo;
//   final int alterCount;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _AlterCard({
//     required this.lotNo,
//     required this.alterCount,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   static const Color _borderBrown = Color(0xFF6A5C44);
//   static const Color _selectedBg = Color(0xFFE8DCC8);
//   static const Color _countBg = Color(0xFFF7F4F0);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(14),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
//             decoration: BoxDecoration(
//               color: isSelected ? _selectedBg : Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(
//                 color: isSelected ? _borderBrown : _borderBrown,
//                 width: isSelected ? 2 : 1.7,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? Colors.white.withValues(alpha: 0.7)
//                         : _countBg,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.content_cut_outlined,
//                     color: AppColors.accentBrown,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         lotNo,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontFamily: FontFamily.hanKenBold,
//                           fontSize: 16,
//                           color: AppColors.textColor,
//                         ),
//                       ),
//                       const Gap(4),
//                       Text(
//                         'Lot number',
//                         style: TextStyle(
//                           fontFamily: FontFamily.hanKenRegular,
//                           fontSize: 12,
//                           color: AppColors.hintTextColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isSelected ? Colors.white : _countBg,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'Alter $alterCount',
//                     style: TextStyle(
//                       fontFamily: FontFamily.hanKenBold,
//                       fontSize: 13,
//                       color: _borderBrown,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Icon(
//                   Icons.chevron_right_rounded,
//                   color: AppColors.textColor,
//                   size: 22,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
