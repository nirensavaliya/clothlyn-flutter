import 'dart:io';
import 'package:clothlyn/Controller/Employee_Controller.dart';
import 'package:clothlyn/Model/Employee_list_Model.dart';
import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:clothlyn/View/Widget/Custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Common/Toast.dart';
import '../../../Constant/Method_Constant.dart';
import '../../../Constant/Permission_Service.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeController controller = Get.put(EmployeeController());
  final ScrollController _scrollController = ScrollController();
  static const double _loadMoreThreshold = 200;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (max - current < _loadMoreThreshold) {
      controller.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<double> values = [10, 20, 30, 50];

  List<ChartData> chartData = [
    ChartData("MON", 10),
    ChartData("TUE", 12),
    ChartData("WED", 8),
    ChartData("THU", 14),
    ChartData("FRI", 11),
    ChartData("SAT", 15),
    ChartData("SUN", 13),
  ];

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
            title: "Employees",
            actions: GestureDetector(
              onTap: () => showAddAdminDialog(context, controller),
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                _topBar(),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.blue.shade200, style: BorderStyle.solid),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // 🔹 Left Side (Text + Icon)
                //       Row(
                //         children: [
                //           Container(
                //             padding: const EdgeInsets.all(8),
                //             decoration: BoxDecoration(
                //               color: Colors.blue.shade50,
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Icon(
                //               Icons.trending_up,
                //               color: Colors.blue,
                //             ),
                //           ),
                //           const SizedBox(width: 10),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: const [
                //               Text(
                //                 "+12.4% from last",
                //                 style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue,
                //                 ),
                //               ),
                //               Text(
                //                 "month",
                //                 style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: values.map((value) {
                //           return _bar(
                //             value,
                //             Colors.blue.withOpacity(value / 60),
                //           );
                //         }).toList(),
                //       )
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 250,
                //   child: SfCartesianChart(
                //     margin: EdgeInsets.zero,
                //     plotAreaBorderWidth: 0,
                //
                //     primaryXAxis: CategoryAxis(
                //       majorGridLines: MajorGridLines(width: 0),
                //       axisLine: AxisLine(width: 0),
                //     ),
                //     primaryYAxis: NumericAxis(isVisible: false),
                //
                //     series: <CartesianSeries>[
                //       ColumnSeries<ChartData, String>(
                //         dataSource: chartData,
                //         xValueMapper: (data, _) => data.day,
                //         yValueMapper: (data, _) => data.value,
                //
                //         borderRadius: BorderRadius.circular(6),
                //
                //         pointColorMapper: (data, index) {
                //           if (index == chartData.length - 1) {
                //             return Colors.blue.shade200;
                //           }
                //           return Colors.blue.shade700;
                //         },
                //
                //         width: 0.5,
                //         spacing: 0.0,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return  Center(child: const CustomSpinLoader());
                    }
                    final list = controller.filteredEmployees;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          "No available employee",
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

                    return RefreshIndicator(
                      color: AppColors.accentBrown,
                      onRefresh: () => controller.loadFirstPage(),
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 6, bottom: 88),
                        itemCount: list.length + (showLoader ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= list.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CustomSpinLoader(size: 40, boxed: false),
                            );
                          }
                          final employee = list[index];
                          return _EmployeeCard(employee: employee, controller: controller,);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _topBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonTextField(
          controller: controller.searchController,
          hintText: "Search employees...",
          prefix: GestureDetector(
            onTap: () {
              controller.searchController.clear();
              controller.onSearch("");
            },
            child: const Icon(Icons.search_outlined),
          ),
          onChanged: controller.onSearch,
        ),
        const Gap(10),
        Obx(
          () => Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEE8DF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _statusTab(
                    label: "Active",
                    selected: controller.showActive.value,
                    onTap: () => controller.toggle(0),
                  ),
                ),
                Expanded(
                  child: _statusTab(
                    label: "Deactive",
                    selected: !controller.showActive.value,
                    onTap: () => controller.toggle(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.floatingBtnColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.hanKenBold,
            fontSize: 14,
            color: selected ? Colors.white : AppColors.textColor,
          ),
        ),
      ),
    );
  }

}

class _EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final EmployeeController controller;

  const _EmployeeCard({required this.employee, required this.controller});

  // static const Color _borderBrown = Color(0xFF6A5C44);
  static const Color _activeGreen = Color(0xFF2E7D32);
  static const Color _activeGreenBg = Color(0xFFE8F5E9);
  static const Color _inactiveBg = Color(0xFFEEE8DF);

  String get _formattedDate {
    final d = employee.createdAt;
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  String get _displayName {
    final fullName =
        "${employee.firstName} ${employee.lastName}".trim();
    if (fullName.isNotEmpty) return fullName;
    return employee.employeeName;
  }

  String get _initials {
    final first = employee.firstName.trim();
    final last = employee.lastName.trim();
    if (first.isNotEmpty && last.isNotEmpty) {
      return "${first[0]}${last[0]}".toUpperCase();
    }
    if (employee.employeeName.isNotEmpty) {
      return employee.employeeName.substring(0, 1).toUpperCase();
    }
    return "E";
  }

  String get _shortId {
    if (employee.id.length <= 8) return employee.id;
    return employee.id.substring(0, 8);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final updatedEmployee = controller.employees
          .firstWhere((e) => e.id == employee.id, orElse: () => employee);
      final isActive = updatedEmployee.isActive;

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
                          _displayName,
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
                          "${employee.employeeName} · $_shortId",
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
                      color: isActive ? _activeGreenBg : _inactiveBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenBold,
                        fontSize: 11,
                        letterSpacing: 0.3,
                        color: isActive ? _activeGreen : AppColors.ringOuterColor,
                      ),
                    ),
                  ),
                  Switch(
                    value: isActive,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.floatingBtnColor,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    onChanged: (value) {
                      controller.toggleEmployeeStatus(
                        employee: updatedEmployee,
                        value: value,
                      );
                    },
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
                      if (value == 'view') {
                        employeeViewDialog(
                          context,
                          employeeCode: employee.employeeName,
                          firstN: employee.firstName,
                          lastN: employee.lastName,
                          nickN: employee.nickname,
                          joinDate: _formattedDate,
                          email: employee.email,
                          mobileN: employee.mobileNumber,
                          referenceN: employee.referenceName,
                          referenceM: employee.referenceMobileNumber,
                          processN: employee.processNames.join(", "),
                          employeeRole: employee.employeeRole!.join(", "),
                        );
                      } else if (value == 'edit') {
                        controller.employeeCodeController.text =
                            employee.employeeName;
                        controller.firstNameController.text =
                            employee.firstName;
                        controller.lastNameController.text =
                            employee.lastName;
                        controller.nickNameController.text =
                            employee.nickname;
                        final selectedNames = (employee.processNames ?? [])
                            .map((e) => e.toLowerCase().trim())
                            .toList();
                        final selectedIds = controller.process
                            .where((e) => selectedNames.contains(
                                  (e.processName ?? "").toLowerCase().trim(),
                                ))
                            .map((e) => e.userId.toString())
                            .toList();
                        controller.selectedRole.value =
                            employee.employeeRole == "employee"
                                ? "Employee"
                                : "User";
                        controller.emailController.text = employee.email;
                        controller.aadhaarNumberController.text =
                            employee.adharNumber;
                        controller.mobileNumberController.text =
                            employee.mobileNumber;
                        controller.referenceNameController.text =
                            employee.referenceName;
                        controller.referenceMobileNumberController.text =
                            employee.referenceMobileNumber;
                        controller.acNumberController.text =
                            employee.accountNumber;
                        controller.acHolderNameController.text =
                            employee.accountHolderName;
                        controller.ifscCodeController.text =
                            employee.ifscCode;
                        controller.bankNameController.text =
                            employee.bankName;
                        controller.bankBranchNameController.text =
                            employee.bankBranchName;

                        showAddAdminDialog(context, controller,
                            isEdit: true, id: employee.id);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          controller.machineController.clearAll();
                          controller.machineController.setItems(
                            controller.process.map((e) {
                              return DropdownItem<String>(
                                label: e.processName ?? "",
                                value: e.userId.toString(),
                                selected: selectedIds
                                    .contains(e.userId.toString()),
                              );
                            }).toList(),
                          );
                        });
                      } else if (value == 'delete') {
                        showDeleteDialog(
                          context,
                          '${employee.firstName} ${employee.lastName}',
                          employee.id,
                          controller,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "View",
                              style:
                                  TextStyle(fontFamily: FontFamily.hanKenMedium),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(height: 1),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_square, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Edit",
                              style:
                                  TextStyle(fontFamily: FontFamily.hanKenMedium),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(height: 1),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "Delete",
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
                      label: "Phone",
                      value: employee.mobileNumber.isNotEmpty
                          ? employee.mobileNumber
                          : "—",
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _infoTile(
                      icon: Icons.calendar_today_outlined,
                      label: "Joined",
                      value: _formattedDate,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              _infoTile(
                icon: Icons.email_outlined,
                label: "Email",
                value: employee.email.isNotEmpty ? employee.email : "—",
              ),
            ],
          ),
        ),
      );
    });
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

void showAddAdminDialog(BuildContext context,EmployeeController controller,{bool isEdit = false,String? id}) {
  final _formKey = GlobalKey<FormState>();
  if(!isEdit){
    controller.employeeCodeController.clear();
    controller.firstNameController.clear();
    controller.lastNameController.clear();
    controller.nickNameController.clear();
    controller.processNameController.clear();
    controller.emailController.clear();
    controller.aadhaarNumberController.clear();
    controller.mobileNumberController.clear();
    controller.referenceNameController.clear();
    controller.referenceMobileNumberController.clear();
    controller.acNumberController.clear();
    controller.acHolderNameController.clear();
    controller.ifscCodeController.clear();
    controller.bankNameController.clear();
    controller.bankBranchNameController.clear();
    controller.machineController.clearAll();
    controller.selectedRole.value = '';
    controller.aadhaarFrontImage.value = null;
    controller.aadhaarBackImage.value = null;
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
                isEdit ? "Update Employee" :"Add Employee",
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
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            hintText: "Enter employee code",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "employee code is required.";
                              }

                              if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                                return "Employee code must be exactly 4 digits.";
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
                              text: "First Name",
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
                            controller: controller.firstNameController,),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text:  TextSpan(
                              text: "Last Name",
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
                            hintText: "Enter last name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "last name is required.";
                              }
                              return null;
                            },
                            controller: controller.lastNameController,),
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
                              text: "Nick Name",
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
                            hintText: "Enter nick name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "nick name is required.";
                              }
                              return null;
                            },
                            controller: controller.nickNameController,),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(13),
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
                MultiDropdown<String>(
                      controller: controller.machineController,
                      dropdownDecoration: DropdownDecoration(
                          elevation: 3,
                          backgroundColor: Colors.white
                      ),
                  items: controller.process.map((e) {
                    return DropdownItem<String>(
                      label: e.processName ?? "",
                      value: e.userId.toString(),
                    );
                  }).toList(),
                  enabled: true,
                      searchEnabled: false,
                      closeOnBackButton: false,
                     validator: (values) {
                       if (values == null || values.isEmpty) {
                         return "Please select process.";
                       }
                       return null;
                     },
                     chipDecoration: ChipDecoration(
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: FontFamily.hanKenMedium,
                            fontSize: 14
                        ),
                        backgroundColor: Colors.grey.shade200,
                        wrap: true,
                        // runSpacing: 6,
                        // spacing: 6,
                      ),
                      fieldDecoration: FieldDecoration(

                        hintText: "Select Process",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                        ),

                      ),
                      onSelectionChange: (values) {
                        controller.machineController.closeDropdown();
                      },
                    ),
                Gap(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text:  TextSpan(
                              text: "Aadhaar Number",
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
                            maxLength: 12,
                            isTitle: false,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            hintText: "Enter aadhaar number",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "aadhaar number is required.";
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return "Aadhaar must contain only digits.";
                              }

                              // Check length
                              if (value.length != 12) {
                                return "Aadhaar must be 12 digits.";
                              }
                              return null;
                            },
                            controller: controller.aadhaarNumberController,),
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
                              text: "Email",
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
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            hintText: "Enter email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "email is required.";
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(value)) {
                                return "Enter a valid email address.";
                              }
                              return null;
                            },
                            controller: controller.emailController,),
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
                  textInputAction: TextInputAction.next,
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
                        fontFamily: FontFamily.hanKenBold,
                      ),
                    ),
                  ),
                  hintText: 'Enter mobile number',
                ),
                Gap(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Role',
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
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: ["Employee", "User"].contains(controller.selectedRole.value)
                                ? controller.selectedRole.value
                                : null,
                            decoration: InputDecoration(
                              hintText: "Select Role",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.floatingBtnColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                const BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            items: const [
                              DropdownMenuItem(value: "Employee", child: Text("Employee")),
                              DropdownMenuItem(value: "User", child: Text("User")),
                            ],
                            onChanged: (val) {
                              controller.selectedRole.value = val;
                            },
                            validator: (v) =>
                            v == null ? "Role required" : null,
                          ),

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
                              text: "Reference Name",
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
                            hintText: "Enter reference name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "reference name is required.";
                              }
                              return null;
                            },
                            controller: controller.referenceNameController,),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(13),
                Obx(() {
                  if (controller.selectedRole.value == "User") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        RichText(
                          text: TextSpan(
                            text: "Scan Permission",
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

                        MultiDropdown<String>(
                          controller: controller.scanPermissionController,
                          dropdownDecoration: DropdownDecoration(
                            elevation: 3,
                            backgroundColor: Colors.white,
                          ),
                          items: [],
                          enabled: true,
                          searchEnabled: false,
                          closeOnBackButton: false,
                          chipDecoration: ChipDecoration(
                            backgroundColor: Colors.grey.shade200,
                            wrap: true,
                          ),
                          fieldDecoration: FieldDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.floatingBtnColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onSelectionChange: (values) {
                            controller.scanPermissionController.closeDropdown();
                          },
                        ),

                        Gap(13),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),

                RichText(
                  text: TextSpan(
                    text: 'Reference Mobile Number ',
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
                  controller: controller.referenceMobileNumberController,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  borderRadius: 8,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Reference Mobile number is required';
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
                        fontFamily: FontFamily.hanKenBold,
                      ),
                    ),
                  ),
                  hintText: 'Enter reference mobile number',
                ),
                Gap(13),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Details",
                        style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text:  TextSpan(
                              text: "Account Number",
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
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            hintText: "Enter account number",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "account number is required.";
                              }

                            },
                            controller: controller.acNumberController,),
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
                              text: "Account Holder Name",
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
                            hintText: "Enter account holder name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "account holder name is required.";
                              }
                              return null;
                            },
                            controller: controller.acHolderNameController,),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text:  TextSpan(
                              text: "IFSC Code",
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
                            hintText: "Enter ifsc code",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "IFSC code is required.";
                              }
                              return null;
                            },
                            controller: controller.ifscCodeController,),
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
                              text: "Bank Name",
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
                            hintText: "Enter bank name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "bank name is required.";
                              }
                              return null;
                            },
                            controller: controller.bankNameController,),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(13),
                RichText(
                  text:  TextSpan(
                    text: "Bank Branch Name",
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
                  textInputAction: TextInputAction.done,
                  hintText: "Enter bank branch name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "bank branch name is required.";
                    }
                    return null;
                  },
                  controller: controller.bankBranchNameController,),
                Gap(13),
                Text(
                  "Upload Aadhaar Images *",
                  style: TextStyle(
                    fontFamily: FontFamily.hanKenMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF616161),
                  ),
                ),
                Gap(8),
                Row(
                  children: [

                    /// FRONT IMAGE
                    Expanded(
                      child: Obx(() => GestureDetector(
                        onTap: () => showImagePickerBottomSheet(context, true),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.floatingBtnColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: controller.aadhaarFrontImage.value == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload, size: 30),
                              SizedBox(height: 6),
                              Text("Upload Front"),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              controller.aadhaarFrontImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )),
                    ),

                    Gap(10),

                    /// BACK IMAGE
                    Expanded(
                      child: Obx(() => GestureDetector(
                        onTap: () => showImagePickerBottomSheet(context, false),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.floatingBtnColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: controller.aadhaarBackImage.value == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload, size: 30),
                              SizedBox(height: 6),
                              Text("Upload Back"),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              controller.aadhaarBackImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )),
                    ),
                  ],
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
                      if (controller.aadhaarFrontImage.value == null ||
                          controller.aadhaarBackImage.value == null) {

                        Get.snackbar(
                          "Error",
                          "Please upload both Aadhaar front and back images",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                        );

                        return;
                      }
                      bool success;

                      if (isEdit) {
                        success = await controller.updateEmployee(
                          id ?? ''
                        );
                      }else{
                        success = await Get.find<EmployeeController>().addEmployee(
                        );
                      }
                      if(success){
                        Get.back();
                        ToastWidget.showToastCustom(
                          isEdit ? "Employee Updated Successfully" :"Employee Added Successfully",
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

void employeeViewDialog(BuildContext context,
    {required String employeeCode, required String firstN,
      required String lastN,
      required String nickN,
      required String joinDate,
      required String email,
      required String mobileN,
      required String referenceN,
      required String referenceM,
      required String processN,
      required String employeeRole,
    }){
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
                child: Column(
                  children: [
                    Container(
                    padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xFFedeef3),
                          width: 3
                        )
                      ),
                      child: Column(
                        children: [
                          _infoItem(
                            title: "Employee Code:",
                            value: employeeCode,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "First Name:",
                            value: firstN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Last Name:",
                            value: lastN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Nickname:",
                            value: nickN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Joined Date:",
                            value: joinDate,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Email",
                            value: email,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Mobile Number:",
                            value: mobileN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Reference Name:",
                            value: referenceN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Reference Mobile:",
                            value: referenceM,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Process Name:",
                            value: processN,
                          ),
                          const Gap(6),
                          _infoItem(
                            title: "Employee Role:",
                            value: employeeRole,
                          ),
                          const Gap(6),
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

Widget _infoItem({
  required String title,
  required String value,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style:  TextStyle(
          fontFamily: FontFamily.hanKenBold,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF616161),
        ),
      ),
      const Gap(4),
      Text(
        value,
        style:  TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: FontFamily.hanKenMedium,
        ),
      ),
    ],
  );
}


void showDeleteDialog(BuildContext context,String name,String id,EmployeeController controller) {
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
              Text(
                'Are you sure you want to delete this employee ${name}?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontFamily.hanKenMedium,
                  color: Colors.black54,
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
                            onPressed: controller.isDeleteDesignLoading.value
                                ? null
                                : () async {
                              bool success = await controller.deleteEmployee(id);

                              if (success) {
                                Get.back();
                                ToastWidget.showToastCustom(
                                  "Employee deleted successfully",
                                  color: Colors.green,
                                );
                              } else {
                                ToastWidget.showToastCustom(
                                  "Failed to delete Employee",
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
                              controller.isDeleteDesignLoading.value
                                  ? "Deleting..."
                                  : "Yes, Employee",
                              style:  TextStyle(
                                color: Colors.white,
                                fontFamily: FontFamily.hanKenBold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )),

                        /// ⚡ Bottom Linear Loader
                        Obx(() => controller.isDeleteDesignLoading.value
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


void showImagePickerBottomSheet(BuildContext context, bool isFront) {
  final controller = Get.find<EmployeeController>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: AppColors.bgCream,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// TITLE
               Text(
                "Select Image",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.hanKenMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// CAMERA
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: ()async {
                  final parentContext = Get.context!;
                  Get.back();
                  bool permanentlyDenied = await PermissionHandlerService.isPermanentlyDenied(Permission.camera);
                  if(permanentlyDenied){
                    PermissionHandlerService.showCameraPermissionDialog(context);
                    return;
                  }
                  final hasPermission = await PermissionHandlerService.checkAndRequestPermission(
                      context,
                      Permission.camera,
                      'camera'
                  );
                  if(hasPermission){
                    final image = await MethodConstants.getImage(
                        imageSource: ImageSource.camera, context: parentContext);
                    if (image.isNotEmpty) {
                      if (isFront) {
                        controller.aadhaarFrontImage.value = File(image);
                      } else {
                        controller.aadhaarBackImage.value = File(image);
                      }
                      // controller.myImage.value = image;
                      // controller.validateCarPhotoForm();
                    }
                  }
                  // controller.pickImageFromSource(true, isFront);
                },
              ),

              /// GALLERY
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text("Gallery"),
                onTap: () async {
                  final parentContext = Get.context!;

                  Get.back();
                  bool permanentlyDenied = await PermissionHandlerService.isPermanentlyDenied(Permission.photos);
                  if(permanentlyDenied){
                    PermissionHandlerService.showGalleryPermissionDialog(context);
                    return;
                  }
                  // PermissionHandlerService();
                  final hasPermission = await PermissionHandlerService.checkAndRequestPermission(
                      context,
                      Permission.photos,
                      'photos'
                  );
                  if(hasPermission){
                    final image = await MethodConstants.getImage(
                        imageSource: ImageSource.gallery, context: parentContext);
                    if (image.isNotEmpty) {
                      if (isFront) {
                        controller.aadhaarFrontImage.value = File(image);
                      } else {
                        controller.aadhaarBackImage.value = File(image);
                      }
                    }
                  }
                  // controller.pickImageFromSource(false, isFront);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}



class ChartData {
  final String day;
  final double value;

  ChartData(this.day, this.value);
}