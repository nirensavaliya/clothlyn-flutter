import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Controller/Admin_Salary_Master_Controller.dart';
import '../../../../Model/Salary_Master_Model.dart';
import '../../../../Model/Salary_Master_View_Model.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_DatePicker.dart';
import '../../../Widget/Custom_Spin_Loader.dart';

class AdminSalaryMasterScreen extends StatelessWidget {
   AdminSalaryMasterScreen({super.key});

  final AdminSalaryMasterController controller = Get.put(AdminSalaryMasterController());


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
              title: "Salary Master",
              showBack: true,
              actions: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:  Icon(Icons.filter_list, color: AppColors.iconColor),
                    onPressed: () {
                      salaryMasterFilterDialog(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: AppColors.iconColor),
                    onPressed: () {
                      controller.downloadSalaryMasterExcel();
                    },
                  ),
                ],
              )

          ),
          body: Column(
            children: [
              Gap(10),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return  Center(child: const CustomSpinLoader());
                  }
                  final list = controller.salaryMaster;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        "No account details available",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: FontFamily.hanKenBold,
                          fontWeight: FontWeight.w500,
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
                      shrinkWrap: true,
                      itemCount: list.length + (controller.hasMore.value ? 1 : 0),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: controller.isMoreLoading.value
                                  ?  SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CustomSpinLoader(size: 50, boxed: false)
                              )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }
                        final item = list[index];
                        return _SalaryMasterCard(
                          item: item,
                          onView: () async {
                            Get.dialog(
                              Center(
                                child: const CustomSpinLoader(),
                              ),
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.35),
                            );
                            await controller.getSalaryMasterView(item.employeeId);
                            Get.back();

                            if (controller.salaryViewData.value != null) {
                              salaryMasterViewDialog(
                                context,
                                controller.salaryViewData.value!,
                              );
                            }
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
      ],
    );
  }

   void salaryMasterViewDialog(BuildContext context,EmployeeSalaryData employeeSalaryData){
     showDialog(
         context: context,
         barrierDismissible: false,
         useSafeArea: true,
         builder: (context){
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
                       "Employee Details",
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
                 width: 500,
                 child: Padding(padding: EdgeInsets.all(20),
                   child:
                   Column(
                     children: [
                       Container(
                         padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                             border: Border.all(
                                 color: AppColors.floatingBtnColor,
                                 width: 1
                             )
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Employee Code:",
                                     value: employeeSalaryData.employee.employeeName,
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "First Name:",
                                     value: employeeSalaryData.employee.firstName,
                                   ),
                                 ),
                               ],
                             ),

                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Last Name:",
                                     value: employeeSalaryData.employee.lastName,
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Nickname:",
                                     value: employeeSalaryData.employee.nickname,
                                   ),
                                 ),
                               ],
                             ),
                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Joined Date:",
                                     value: apiToUiDate(employeeSalaryData.joinedAt.toString()),
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Mobile Number:",
                                     value: employeeSalaryData.employee.mobileNumber,
                                   ),
                                 ),
                               ],
                             ),
                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Reference Name:",
                                     value: employeeSalaryData.employee.referenceName,
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Reference Mobile:",
                                     value: employeeSalaryData.employee.referenceMobileNumber,
                                   ),
                                 ),
                               ],
                             ),
                             const Gap(10),
                             infoItem(
                               title: "Email",
                               value: employeeSalaryData.employee.email,
                             ),
                             const Gap(10),
                             infoItem(
                               title: "Process Name:",
                               value: employeeSalaryData.salarySummaryMaster.processNames.join(','),
                             ),
                             const Gap(10),
                             infoItem(
                               title: "Employee Role:",
                               value: employeeSalaryData.employee.employeeRole.join(','),
                             ),

                             const Gap(6),
                           ],
                         ),
                       ),
                       const Gap(12),
                       Container(
                         padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                             border: Border.all(
                                 color: AppColors.floatingBtnColor,
                                 width: 1
                             )
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               "Bank Details",
                               style: TextStyle(
                                   fontFamily: FontFamily.hanKenBold,
                                   fontSize: 18),
                             ),
                             const Gap(15),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Account holder:",
                                     value: employeeSalaryData.employee.accountHolderName,
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Account number:",
                                     value: employeeSalaryData.employee.accountNumber,
                                   ),
                                 ),
                               ],
                             ),

                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "IFSC:",
                                     value: employeeSalaryData.employee.ifscCode,
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Bank:",
                                     value: employeeSalaryData.employee.bankName,
                                   ),
                                 ),
                               ],
                             ),

                             const Gap(10),
                             infoItem(
                               title: "Branch name:",
                               value: employeeSalaryData.employee.bankBranchName,
                             ),
                           ],
                         ),
                       ),
                       const Gap(12),
                       Container(
                         padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                             border: Border.all(
                                 color: AppColors.floatingBtnColor,
                                 width: 1
                             )
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               "Salary Summary",
                               style: TextStyle(
                                   fontFamily: FontFamily.hanKenBold,
                                   fontSize: 18),
                             ),
                             const Gap(15),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Total Remaining:",
                                     value: employeeSalaryData.salarySummaryMaster.totalRemainingAmount.toStringAsFixed(2),
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Current Period:",
                                     value: employeeSalaryData.salarySummaryMaster.currentPeriodSalary.toStringAsFixed(2),
                                   ),
                                 ),
                               ],
                             ),

                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Last Period:",
                                     value: employeeSalaryData.salarySummaryMaster.lastPeriodSalary.toStringAsFixed(2),
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Upad:",
                                     value: employeeSalaryData.salarySummaryMaster.upadPaid.toStringAsFixed(2),
                                   ),
                                 ),
                               ],
                             ),

                             const Gap(10),
                             infoItem(
                               title: "Pay Salary:",
                               value: employeeSalaryData.salarySummaryMaster.paySalary.toStringAsFixed(2),
                             ),
                             const Gap(10),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Expanded(
                                   child: infoItem(
                                     title: "Lifetime earned:",
                                     value: employeeSalaryData.totals.lifetimeEarnedFromSalaryReports.toStringAsFixed(2),
                                   ),
                                 ),
                                 SizedBox(width: 20,),
                                 Expanded(
                                   child: infoItem(
                                     title: "Lifetime paid:",
                                     value: employeeSalaryData.totals.lifetimeTotalPaid.toStringAsFixed(2),
                                   ),
                                 ),
                               ],
                             ),
                             const Gap(10),
                             infoItem(
                               title: "Outstanding (approx):",
                               value: employeeSalaryData.totals.approximateNetOutstanding.toStringAsFixed(2),
                             ),

                           ],
                         ),
                       ),

                     ],
                   ),
                 ),
               )
           );
         });
   }


   void salaryMasterFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text:  TextSpan(
                text: "Employee Code",
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:AppColors.accentBrown,
                ),
              ),
            ),
            Gap(8),
            Obx(()
              => DropdownMenu<String>(
                width: double.infinity,
                hintText: "Select employee code",
                initialSelection: controller.salaryMasterEmployeeSelected.value,
                onSelected: (value) {
                  controller.salaryMasterEmployeeSelected.value = value;
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
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color:
                    controller.salaryMasterEmployeeSelected.value != null
                        ? AppColors.floatingBtnColor
                        : Colors.grey,
                        width: 1.5),
                  ),
                ),
                dropdownMenuEntries: controller.salaryMaster.map((e) {
                  final isSelected = e.employeeName == controller.salaryMasterEmployeeSelected.value;

                  return DropdownMenuEntry<String>(
                    value: '${e.employeeName}' ?? '',
                    label: '${e.employeeName}- ${e.nickname}' ?? '',

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
            ),
            Gap(15),
            RichText(
              text:  TextSpan(
                text: "Nick Name",
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            Gap(8),
            Obx(()
              => DropdownMenu<String>(
                width: double.infinity,
                hintText: "Select nick name",
                initialSelection: controller.salaryMasterNickNameSelected.value,
                onSelected: (value) {
                  controller.salaryMasterNickNameSelected.value = value;
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
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color:
                    controller.salaryMasterNickNameSelected.value != null
                        ? AppColors.floatingBtnColor
                        : Colors.grey,
                        width: 1.5),
                  ),
                ),
                dropdownMenuEntries: controller.salaryMaster.map((e) {
                  final isSelected = e.nickname == controller.salaryMasterNickNameSelected.value;

                  return DropdownMenuEntry<String>(
                    value: e.nickname ?? '',
                    label: e.nickname ?? '',

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
            ),
            Gap(15),
            RichText(
              text:  TextSpan(
                text: "Date Range",
                style: TextStyle(
                  fontFamily: FontFamily.hanKenMedium,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDatePicker(label: "Start Date", controller: controller.dateController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDatePicker(label: "End Date",controller:controller.endDateController),
                ),
              ],
            ),

          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              controller.salaryMasterEmployeeSelected.value = '';
              controller.salaryMasterNickNameSelected.value = '';
              controller.dateController.text = '';
              controller.endDateController.text = '';
              controller.loadFirstPage();
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
              "Clear",
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 14,
                color: Colors.black
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              controller.loadFirstPage();
              Get.back();
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
              "Apply",
              style: TextStyle(
                fontFamily: FontFamily.hanKenBold,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          )

        ],
      ),
    );
  }

}

class _SalaryMasterCard extends StatelessWidget {
  final SalaryData item;
  final VoidCallback onView;

  const _SalaryMasterCard({
    required this.item,
    required this.onView,
  });

  static const Color _netPayGreen = Color(0xFF1B7A3D);
  static const Color _statBg = Color(0xFFF7F4F0);

  String _dash(String? v) {
    final t = (v ?? '').trim();
    return t.isEmpty ? '-' : t;
  }

  String _money(num? v) {
    if (v == null) return '0';
    final d = v.toDouble();
    if (d % 1 == 0) return d.toStringAsFixed(0);
    return d.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _dash(item.nickname);
    final code = _dash(item.employeeName);
    final account = _dash(item.employee.accountNumber);
    final ifsc = _dash(item.employee.ifscCode);
    final bank = _dash(item.employee.bankName);
    final branch = _dash(item.employee.bankBranchName);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
        padding: const EdgeInsets.fromLTRB(14, 14, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: nickname,
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        TextSpan(
                          text: '  ·  $code',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Text(
                //   '₹${_money(item.netSalary)}',
                //   style: TextStyle(
                //     fontFamily: FontFamily.hanKenBold,
                //     fontSize: 16,
                //     color: _netPayGreen,
                //   ),
                // ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: PopupMenuButton<String>(

                    clipBehavior: Clip.none,
                    elevation: 0,
                    borderRadius: BorderRadius.zero,
                    color: Colors.white,
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textColor,
                      size: 22,
                    ),
                    onSelected: (value) {
                      if (value == 'view') onView();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            const Icon(Icons.visibility_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'View',
                              style: TextStyle(
                                fontFamily: FontFamily.hanKenMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(5),
            Text(
              '$bank  ·  $branch',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.hanKenRegular,
                fontSize: 13,
                color: AppColors.hintTextColor,
              ),
            ),
            const Gap(4),
            Text(
              'A/C $account  ·  $ifsc',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 13,
                color: AppColors.textColor,
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: _statChip(
                    label: 'Total Remaining',
                    value: '₹${_money(item.totalRemainingAmount)}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'Current Period',
                    value: '₹${_money(item.currentPeriodSalary)}',
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: _statChip(
                    label: 'Last Period',
                    value: '₹${_money(item.lastPeriodSalary)}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'Upad',
                    value: '₹${_money(item.upadPaid)}',
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _statChip(
                    label: 'Pay Salary',
                    value: '₹${_money(item.paySalary)}',
                  ),
                ),
              ],
            ),
            const Gap(8),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Total Remaining  ·  ₹${_money(item.totalRemainingAmount)}',
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
    );
  }

  Widget _statChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: _statBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.hanKenRegular,
              fontSize: 11,
              color: AppColors.hintTextColor,
            ),
          ),
          const Gap(2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.hanKenSemiBold,
              fontSize: 12,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/*class ProductionRow {
  final String nickName;
  final String employeeCode;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String branchName;
  final String totalSalary;
  final String totalUpad;
  final String paidSalary;
  final String netSalary;

  ProductionRow({
    required this.nickName,
    required this.employeeCode,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.branchName,
    required this.totalSalary,
    required this.totalUpad,
    required this.paidSalary,
    required this.netSalary,
  });
}*/
