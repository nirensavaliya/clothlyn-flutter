import 'package:clothlyn/Controller/Design_Controller.dart';
import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../../Model/Design_Model.dart';
import '../../../Common/Get_storage_data.dart';
import '../../../Common/Toast.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Appbar.dart';
import '../../../Widget/Custom_TextField.dart';

class DesignScreen extends StatelessWidget {
   DesignScreen({super.key});

   final DesignController controller = Get.put(DesignController());


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
            title: "Design",
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
                      showAddDesignDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(
                      'Add Design',
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
                    final list = controller.design;
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'No available design',
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
                          return _DesignCard(
                            item: item,
                            onRateChange: () {
                              showUpdateRatesDialog(context, item);
                            },
                            onEdit: () {
                              controller.selectedDesignId = item.id;
                              showAddDesignDialog(
                                context,
                                isEdit: true,
                                designData: item,
                              );
                            },
                            onDelete: () {
                              showDeleteDialog(
                                context,
                                item.designNumber ?? '',
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

   // void showAddDesignDialog(BuildContext context) {
   //   final designController = TextEditingController();
   //   final List<ProcessItem> processList = [ProcessItem()];
   //   final _formKey = GlobalKey<FormState>();
   //
   //   final MultiSelectController<String> _machineController =
   //   MultiSelectController();
   //
   //   final List<DropdownItem<String>> machineItems = [
   //     DropdownItem(label: 'Single', value: 'Single'),
   //     DropdownItem(label: 'Fat Lock', value: 'Fat Lock'),
   //     DropdownItem(label: 'Over Lock', value: 'Over Lock'),
   //   ];
   //
   //
   //   Get.dialog(
   //     AlertDialog(
   //       backgroundColor: Colors.white,
   //       titlePadding: EdgeInsets.zero,
   //       scrollable: true,
   //       shape: RoundedRectangleBorder(
   //         borderRadius: BorderRadius.circular(12),
   //       ),
   //       title: Padding(
   //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
   //         child: Row(
   //           children: [
   //              Text(
   //               "Add New Design",
   //               style: TextStyle(
   //                   fontFamily: FontFamily.jostBold,
   //                   fontSize: 18),
   //             ),
   //             const Spacer(),
   //             IconButton(
   //               icon: const Icon(Icons.close),
   //               onPressed: () => Get.back(),
   //             )
   //           ],
   //         ),
   //       ),
   //       contentPadding: EdgeInsets.zero,
   //       content: SizedBox(
   //         width: 900,
   //         child: Form(
   //           key: _formKey,
   //           child: SingleChildScrollView(
   //             child: StatefulBuilder(
   //               builder: (context, setState) {
   //                 return Padding(
   //                   padding: const EdgeInsets.all(24),
   //                   child: Column(
   //                     mainAxisSize: MainAxisSize.min,
   //                     crossAxisAlignment: CrossAxisAlignment.start,
   //                     children: [
   //                       /// DESIGN NUMBER
   //                       RichText(
   //                         text:  TextSpan(
   //                           text: "Design Number",
   //                           style: TextStyle(
   //                             fontFamily: FontFamily.jostMedium,
   //                             fontSize: 16,
   //                             fontWeight: FontWeight.w500,
   //                             color: Color(0xFF616161),
   //                           ),
   //                           children: [
   //                             TextSpan(text: " *", style: TextStyle(color: Colors.red))
   //                           ],
   //                         ),
   //                       ),
   //                       Gap(8),
   //                       CommonTextField(
   //                         isTitle: false,
   //                         textInputType: TextInputType.number,
   //                         textInputAction: TextInputAction.next,
   //                         hintText: "Enter Design Number",
   //                         validator: (value) {
   //                           if (value == null || value.isEmpty) {
   //                             return "D.No is required.";
   //                           }
   //                           return null;
   //                         },
   //                         controller: designController,),
   //
   //                       const SizedBox(height: 24),
   //
   //                       /// PROCESS LIST
   //                       ...List.generate(processList.length, (index) {
   //                         final item = processList[index];
   //
   //                         return Column(
   //                           crossAxisAlignment: CrossAxisAlignment.start,
   //                           children: [
   //                             Row(
   //                               children: [
   //                                 /// PROCESS
   //                                 Expanded(
   //                                   flex: 3,
   //                                   child: Column(
   //                                     crossAxisAlignment: CrossAxisAlignment.start,
   //                                     children: [
   //                                       RichText(
   //                                         text:  TextSpan(
   //                                           text: "Process",
   //                                           style: TextStyle(
   //                                             fontFamily: FontFamily.jostMedium,
   //                                             fontSize: 16,
   //                                             fontWeight: FontWeight.w500,
   //                                             color: Color(0xFF616161),
   //                                           ),
   //                                           children: [
   //                                             TextSpan(text: " *", style: TextStyle(color: Colors.red))
   //                                           ],
   //                                         ),
   //                                       ),
   //                                       Gap(8),
   //                                       DropdownButtonFormField<String>(
   //                                         value: item.process,
   //                                         style: TextStyle(
   //                                           fontFamily: FontFamily.jostMedium,
   //                                           fontSize: 15,
   //                                           color: Colors.black
   //                                         ),
   //                                         hint: Text(
   //                                           'Select Process',
   //                                           style: TextStyle(
   //                                             color: Color(0xFF616161),
   //                                             fontSize: 16,
   //                                             fontFamily: FontFamily.jostMedium,
   //                                             fontWeight: FontWeight.w400,
   //                                           ),
   //                                         ),
   //                                         decoration:  InputDecoration(
   //                                           border: OutlineInputBorder(
   //                                             borderRadius: BorderRadius.circular(8),
   //                                             borderSide: BorderSide(color: Colors.grey, width: 1.5),
   //                                           ),
   //                                         ),
   //                                         items:  [
   //                                           DropdownMenuItem(
   //                                               value: "Cutting",
   //                                               child: Text("Cutting",style: TextStyle(
   //                                                 fontFamily: FontFamily.jostMedium,
   //                                                 fontSize: 15,
   //                                               ),)),
   //                                           DropdownMenuItem(
   //                                               value: "Stitching",
   //                                               child: Text("Stitching")),
   //                                           DropdownMenuItem(
   //                                               value: "Packing",
   //                                               child: Text("Packing")),
   //                                           DropdownMenuItem(
   //                                               value: "rc", child: Text("rc")),
   //                                         ],
   //                                         onChanged: (val) {
   //                                           setState(() {
   //                                             item.process = val;
   //
   //                                             /// reset on change
   //                                             if (val != "rc") {
   //                                               item.machines.clear();
   //                                             }
   //                                           });
   //                                         },
   //                                         validator: (v) =>
   //                                         v == null ? "Required" : null,
   //                                       ),
   //                                     ],
   //                                   ),
   //                                 ),
   //
   //                                 const SizedBox(width: 12),
   //
   //                                 /// RATE (HIDDEN FOR RC)
   //                                 if (item.process != "rc")
   //                                   Expanded(
   //                                     flex: 2,
   //                                     child: Column(
   //                                       crossAxisAlignment: CrossAxisAlignment.start,
   //                                       children: [
   //                                         const Text("Rate *"),
   //                                         const SizedBox(height: 6),
   //                                         TextFormField(
   //                                           controller: item.rateController,
   //                                           decoration: const InputDecoration(
   //                                             hintText: "Enter Rate",
   //                                             border: OutlineInputBorder(),
   //                                           ),
   //                                           validator: (v) =>
   //                                           v == null || v.isEmpty
   //                                               ? "Required"
   //                                               : null,
   //                                         ),
   //                                       ],
   //                                     ),
   //                                   ),
   //                               ],
   //                             ),
   //
   //                             /// SELECT MACHINE (ONLY RC)
   //                             if (item.process == "rc") ...[
   //                               const SizedBox(height: 16),
   //                               const Text("Select Machine *"),
   //                               const SizedBox(height: 6),
   //
   //                               MultiDropdown<String>(
   //                                 controller: _machineController,
   //                                 dropdownDecoration: DropdownDecoration(
   //                                    elevation: 3,
   //                                   backgroundColor: Colors.white
   //                                 ),
   //                                 items: machineItems,
   //                                 enabled: true,
   //                                 searchEnabled: false,
   //                                 closeOnBackButton: true,
   //                                 chipDecoration: ChipDecoration(
   //                                   backgroundColor: AppColors.appColor,
   //                                   wrap: true,
   //                                   runSpacing: 6,
   //                                   spacing: 6,
   //                                 ),
   //                                 fieldDecoration: FieldDecoration(
   //                                   border: OutlineInputBorder(
   //                                     borderRadius: BorderRadius.circular(6),
   //                                   ),
   //                                 ),
   //                                 onSelectionChange: (values) {
   //                                   setState(() {
   //                                     /// Remove unselected machines
   //                                     item.machines.removeWhere(
   //                                           (m) => !values.contains(m.machineName),
   //                                     );
   //
   //                                     /// Add newly selected machines
   //                                     for (final v in values) {
   //                                       if (!item.machines.any((m) => m.machineName == v)) {
   //                                         item.machines.add(MachineRateItem(v));
   //                                       }
   //                                     }
   //                                   });
   //                                   _machineController.closeDropdown();
   //                                 },
   //                               ),
   //
   //
   //                               // MultiSelectDialogField<String>(
   //                               //   items:  [
   //                               //     MultiSelectItem("Single", "Single"),
   //                               //     MultiSelectItem("Fat Lock", "Fat Lock"),
   //                               //     MultiSelectItem("Over Lock", "Over Lock"),
   //                               //   ],
   //                               //   listType: MultiSelectListType.CHIP,
   //                               //   onConfirm: (values) {
   //                               //     setState(() {
   //                               //       /// remove unselected
   //                               //       item.machines.removeWhere(
   //                               //             (m) =>
   //                               //         !values.contains(m.machineName),
   //                               //       );
   //                               //
   //                               //       /// add new
   //                               //       for (final v in values) {
   //                               //         if (!item.machines.any(
   //                               //                 (m) => m.machineName == v)) {
   //                               //           item.machines
   //                               //               .add(MachineRateItem(v));
   //                               //         }
   //                               //       }
   //                               //     });
   //                               //   },
   //                               // ),
   //
   //                               /// MACHINE RATE LIST
   //                               const SizedBox(height: 12),
   //                               ...item.machines.map((machine) {
   //                                 return Padding(
   //                                   padding:
   //                                   const EdgeInsets.symmetric(vertical: 6),
   //                                   child: Row(
   //                                     children: [
   //                                       /// MACHINE NAME (DISABLED)
   //                                       Expanded(
   //                                         child: TextFormField(
   //                                           initialValue: machine.machineName,
   //                                           enabled: false,
   //                                           decoration: const InputDecoration(
   //                                             labelText: "Machine Name",
   //                                             border: OutlineInputBorder(),
   //                                           ),
   //                                         ),
   //                                       ),
   //
   //                                       const SizedBox(width: 12),
   //
   //                                       /// BASE RATE
   //                                       Expanded(
   //                                         child: TextFormField(
   //                                           controller:
   //                                           machine.baseRateController,
   //                                           decoration: const InputDecoration(
   //                                             labelText: "Base Rate",
   //                                             border: OutlineInputBorder(),
   //                                           ),
   //                                           validator: (v) =>
   //                                           v == null || v.isEmpty
   //                                               ? "Required"
   //                                               : null,
   //                                         ),
   //                                       ),
   //
   //                                       const SizedBox(width: 8),
   //                                       IconButton(
   //                                         icon: const Icon(Icons.delete),
   //                                         onPressed: () {
   //                                           setState(() {
   //                                             item.machines.remove(machine);
   //                                           });
   //                                         },
   //                                       )
   //                                     ],
   //                                   ),
   //                                 );
   //                               }),
   //                             ],
   //
   //                             const Divider(height: 32),
   //                           ],
   //                         );
   //                       }),
   //
   //                       /// ADD PROCESS
   //                       TextButton.icon(
   //                         onPressed: () {
   //                           setState(() {
   //                             processList.add(ProcessItem());
   //                           });
   //                         },
   //                         icon: const Icon(Icons.add),
   //                         label: const Text("Add New Process"),
   //                       ),
   //                     ],
   //                   ),
   //                 );
   //               },
   //             ),
   //           ),
   //         ),
   //       ),
   //       actions: [
   //         TextButton(
   //           onPressed: () => Get.back(),
   //           child: const Text("Cancel"),
   //         ),
   //         ElevatedButton(
   //           onPressed: () {
   //             if (_formKey.currentState!.validate()) {
   //               /// FINAL DATA READY HERE
   //               Get.back();
   //             }
   //           },
   //           child: const Text("Add Design"),
   //         ),
   //       ],
   //     ),
   //   );
   // }


  void showAddDesignDialog(BuildContext context, {bool isEdit = false,DesignModel? designData }) {
    final designController = TextEditingController(text: designData?.designNumber);

    // final List<ProcessItem> processList = [ProcessItem()];
    final List<ProcessItem> processList =
    designData?.processes?.isNotEmpty == true
        ? []
        : [ProcessItem()];
    /// convert API process → UI process
    for (var p in designData?.processes ?? []) {

      /// NORMAL PROCESS
      if (p.processName == "Cutting" ||
          p.processName == "Stitching" ||
          p.processName == "Packing") {

        final item = ProcessItem();

        item.process = p.processName;
        item.rateController.text = p.price.toString();

        processList.add(item);
      }

      /// MACHINE PROCESS
      else {

        /// check existing RC item
        ProcessItem? rcItem;

        try {
          rcItem = processList.firstWhere((e) => e.process == "rc");
        } catch (_) {}

        rcItem ??= ProcessItem()..process = "rc";

        final machine = MachineRateItem(p.processName);
        machine.baseRateController.text = p.price.toString();

        rcItem.machines.add(machine);

        if (!processList.contains(rcItem)) {
          processList.add(rcItem);
        }
      }
    }
    final _formKey = GlobalKey<FormState>();
    final _processKey = GlobalKey<FormState>();

    final MultiSelectController<String> _machineController = MultiSelectController();

      final List<DropdownItem<String>> machineItems = [
        DropdownItem(label: 'Single', value: 'Single'),
        DropdownItem(label: 'Fat Lock', value: 'Fat Lock'),
        DropdownItem(label: 'Over Lock', value: 'Over Lock'),
      ];

    if (isEdit) {
      final selectedMachines = <String>[];

      for (var process in processList) {
        if (process.process == "rc") {
          for (var m in process.machines) {
            selectedMachines.add(m.machineName);
          }
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _machineController.setItems(machineItems);

        for (final machine in selectedMachines) {
          _machineController.selectWhere((item) => item.value == machine);
        }
      });
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
                     isEdit ? "Update Design" : "Add New Design",
                     style: TextStyle(
                         fontFamily: FontFamily.hanKenBold,
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
            content: SizedBox(
              width: 900,
              child: Form(
                key: _formKey,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// DESIGN NUMBER
                        RichText(
                          text:  TextSpan(
                            text: "Design Number",
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
                          hintText: "Enter Design Number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "D.No is required.";
                            }
                            return null;
                          },
                          controller: designController,),
                        const SizedBox(height: 20),

                        /// PROCESS LIST
                        Form(
                            key: _processKey,
                            child: Column(
                              children: List.generate(processList.length, (index) {
                                final item = processList[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          /// PROCESS DROPDOWN
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: "Process",
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.hanKenMedium,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFF616161),
                                                    ),
                                                    children: const [
                                                      TextSpan(text: " *", style: TextStyle(color: Colors.red))
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                DropdownButtonFormField<String>(
                                                  isExpanded: true,
                                                  value: item.process,
                                                  decoration: InputDecoration(
                                                    hintText: "Select process",
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
                                                    DropdownMenuItem(value: "Cutting", child: Text("Cutting")),
                                                    DropdownMenuItem(value: "Stitching", child: Text("Stitching")),
                                                    DropdownMenuItem(value: "Packing", child: Text("Packing")),
                                                    DropdownMenuItem(value: "rc", child: Text("rc")),
                                                  ],
                                                  onChanged: (val) {
                                                    setState(() {
                                                    item.process = val;

                                                    /// reset when switching process
                                                    if (val != "rc") {
                                                      item.machines.clear();
                                                    }
                                                    });
                                                  },
                                                  validator: (v) =>
                                                  v == null ? "Process required" : null,
                                                ),
                                              ],
                                            ),
                                          ),



                                          const SizedBox(width: 8),

                                          /// RATE
                                          if (item.process != "rc")
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "Rate",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.hanKenMedium,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xFF616161),
                                                      ),
                                                      children: const [
                                                        TextSpan(text: " *", style: TextStyle(color: Colors.red))
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  CommonTextField(
                                                    isTitle: false,
                                                    hintText: "Enter Rate",
                                                    controller: item.rateController,
                                                    textInputType: TextInputType.number,
                                                     textInputAction: TextInputAction.done,
                                                    validator: (v) =>
                                                    v == null || v.isEmpty ? "Rate is required" : null,
                                                  ),
                                                ],
                                              ),
                                            ),

                                          /// REMOVE
                                          if (processList.length > 1)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8, top: 22),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                  processList.removeAt(index);
                                                  });
                                                },
                                                child: Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.hanKenBold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),

                                        ],
                                      ),

                                      if (item.process == "rc") ...[
                                        const SizedBox(height: 16),
                                         Text("Select Machine", style: TextStyle(
                                          fontFamily: FontFamily.hanKenMedium,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF616161),
                                        ),),
                                        const SizedBox(height: 6),

                                        MultiDropdown<String>(
                                          controller: _machineController,
                                          dropdownDecoration: DropdownDecoration(
                                              elevation: 3,
                                              backgroundColor: Colors.white
                                          ),
                                          items: machineItems,
                                          enabled: true,
                                          searchEnabled: false,
                                          closeOnBackButton: true,
                                          chipDecoration: ChipDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: FontFamily.hanKenMedium,
                                              fontSize: 14
                                            ),
                                            backgroundColor: Colors.grey.shade200,
                                            wrap: true,
                                            runSpacing: 6,
                                            spacing: 6,
                                          ),
                                          fieldDecoration: FieldDecoration(

                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
                                            ),

                                          ),
                                          onSelectionChange: (values) {
                                            setState(() {
                                              /// Remove unselected machines
                                              item.machines.removeWhere(
                                                    (m) => !values.contains(m.machineName),
                                              );

                                              /// Add newly selected machines
                                              for (final v in values) {
                                                if (!item.machines.any((m) => m.machineName == v)) {
                                                  item.machines.add(MachineRateItem(v));
                                                }
                                              }
                                            });
                                            _machineController.closeDropdown();
                                          },
                                        ),


                                        // MultiSelectDialogField<String>(
                                        //   items:  [
                                        //     MultiSelectItem("Single", "Single"),
                                        //     MultiSelectItem("Fat Lock", "Fat Lock"),
                                        //     MultiSelectItem("Over Lock", "Over Lock"),
                                        //   ],
                                        //   listType: MultiSelectListType.CHIP,
                                        //   onConfirm: (values) {
                                        //     setState(() {
                                        //       /// remove unselected
                                        //       item.machines.removeWhere(
                                        //             (m) =>
                                        //         !values.contains(m.machineName),
                                        //       );
                                        //
                                        //       /// add new
                                        //       for (final v in values) {
                                        //         if (!item.machines.any(
                                        //                 (m) => m.machineName == v)) {
                                        //           item.machines
                                        //               .add(MachineRateItem(v));
                                        //         }
                                        //       }
                                        //     });
                                        //   },
                                        // ),

                                        /// MACHINE RATE LIST
                                        const SizedBox(height: 12),
                                        ...item.machines.map((machine) {
                                          return Padding(
                                            key: ValueKey(machine.machineName),
                                            padding:
                                            const EdgeInsets.symmetric(vertical: 6),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                /// MACHINE NAME (DISABLED)
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Machine Name',
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.hanKenMedium,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xFF616161),
                                                        ),
                                                      ),
                                                      Gap(8),
                                                      TextFormField(
                                                        initialValue: machine.machineName,
                                                        enabled: false,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:  16,
                                                          fontFamily: FontFamily.hanKenBold,
                                                        ),

                                                        decoration:  InputDecoration(
                                                          hintStyle: TextStyle(
                                                            color: Color(0xFF616161),
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.hanKenMedium,
                                                            fontWeight: FontWeight.w400,
                                                          ),
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
                                                          errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                            borderSide: BorderSide(color: Colors.red, width: 1.5),
                                                          ),                                                    ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                /// BASE RATE
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Base Rate",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.hanKenMedium,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF616161),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      CommonTextField(
                                                        isTitle: false,
                                                        hintText: "Enter Rate",
                                                        controller: machine.baseRateController,
                                                         textInputType: TextInputType.number,
                                                        textInputAction: TextInputAction.done,
                                                        validator: (v) =>
                                                        v == null || v.isEmpty ? "Rate is required" : null,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(width: 8),
                                                IconButton(
                                                  icon: const Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      final deleteName = machine.machineName;

                                                      print('deleteName-----${deleteName}');
                                                      final remainingSelected =
                                                      _machineController.selectedItems
                                                          .where((e) => e.value != deleteName)
                                                          .toList();

                                                      item.machines.removeWhere(
                                                            (m) =>
                                                        m.machineName == machine.machineName,
                                                      );
                                                      // item.machines.remove(machine);

                                                      _machineController.setItems(machineItems);

                                                      for (final sel in remainingSelected) {
                                                        _machineController.selectWhere(
                                                              (item) => item.value == sel.value,
                                                        );
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                            )

                        ),

                        /// ADD NEW PROCESS
                        TextButton.icon(
                          icon: const Icon(Icons.add,color: AppColors.accentBrown),
                          label:  Text("Add New Process",style: TextStyle(
                              color: AppColors.accentBrown,
                              fontFamily: FontFamily.hanKenBold,
                              fontSize: 17
                          ),),
                          onPressed: () {
                            final last = processList.last;


                            if (last.process == null ||
                                last.rateController.text.isEmpty) {
                              if (_processKey.currentState!.validate()) {
                                return;
                              }
                              return;
                            }

                            setState(() {
                            processList.add(ProcessItem());
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    );
                  },
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
                    ? controller.isUpdatingDesign.value
                    : controller.isAddingDesign.value;

                return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                  children:[
                    ElevatedButton(

                      onPressed: isLoading
                          ? null
                          : () async {

                        if (!_formKey.currentState!.validate()) return;

                        List<Map<String, dynamic>> processes = [];

                        for (final process in processList) {

                          /// NORMAL PROCESS
                          if (process.process != "rc") {

                            processes.add({
                              "processName": process.process,
                              "price": double.tryParse(process.rateController.text) ?? 0,
                              "startDate": DateTime.now().toUtc().toIso8601String(),
                              "endDate": DateTime.now()
                                  .add(const Duration(days: 365))
                                  .toUtc()
                                  .toIso8601String(),
                            });

                          }

                          /// MACHINE PROCESS
                          else {

                            for (final machine in process.machines) {

                              processes.add({
                                "processName": machine.machineName,
                                "price": double.tryParse(machine.baseRateController.text) ?? 0,
                                "startDate": DateTime.now().toUtc().toIso8601String(),
                                "endDate": DateTime.now()
                                    .add(const Duration(days: 365))
                                    .toUtc()
                                    .toIso8601String(),
                              });

                            }

                          }

                        }

                        bool success;
                        final loggedInUserId =
                            GetStorageData.readString(GetStorageData.userId)?.toString().trim() ?? '';

                        if (loggedInUserId.isEmpty) {
                          ToastWidget.showToastCustom(
                            'User ID is required. Please login again.',
                            color: Colors.red,
                          );
                          return;
                        }

                        /// UPDATE DESIGN
                        if (isEdit) {

                          success = await controller.updateDesign(
                            designId: controller.selectedDesignId!,
                            designNumber: designController.text,
                            userId: loggedInUserId,
                            description: "Summer collection design",
                            processes: processes,
                          );

                        }

                        /// ADD DESIGN
                        else {
                          success = await controller.addDesign(
                            designNumber: designController.text,
                            userId: loggedInUserId,
                            description: "Summer collection design",
                            processes: processes,
                          );

                        }

                        if (success) {

                          Get.back();

                          ToastWidget.showToastCustom(
                            isEdit
                                ? "Design updated successfully"
                                : "Design added successfully",
                            color: Colors.green,
                          );

                        } else {

                          ToastWidget.showToastCustom(
                            "Operation failed",
                            color: Colors.red,
                          );

                        }

                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.floatingBtnColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        isLoading
                            ? (isEdit ? "Updating..." : "Adding...")
                            : (isEdit ? "Update Design" : "Add Design"),
                        style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white
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
                  ]

                );

              }),

              // ElevatedButton(
              //   onPressed: () async{
              //     if (!_formKey.currentState!.validate()) return;
              //     List<Map<String, dynamic>> processes = [];
              //
              //     for (final process in processList) {
              //
              //       /// NORMAL PROCESS
              //       if (process.process != "rc") {
              //
              //         processes.add({
              //           "processName": process.process,
              //           "price": double.tryParse(process.rateController.text) ?? 0,
              //           "startDate": DateTime.now().toUtc().toIso8601String(),
              //           "endDate": DateTime.now()
              //               .add(Duration(days: 365))
              //               .toUtc()
              //               .toIso8601String(),
              //         });
              //
              //       }
              //
              //       /// MACHINE PROCESS
              //       else {
              //
              //         for (final machine in process.machines) {
              //
              //           processes.add({
              //             "processName": machine.machineName,
              //             "price":
              //             double.tryParse(machine.baseRateController.text) ?? 0,
              //             "startDate": DateTime.now().toUtc().toIso8601String(),
              //             "endDate": DateTime.now()
              //                 .add(Duration(days: 365))
              //                 .toUtc()
              //                 .toIso8601String(),
              //           });
              //
              //         }
              //
              //       }
              //
              //     }
              //
              //     await controller.addDesign(
              //       designNumber: designController.text,
              //       userId: "693fba19c5f9bd62bc3a269e",
              //       description: "Summer collection design",
              //       processes: processes,
              //     );
              //     Get.back();
              //
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
              //     "Add Design",
              //     style: TextStyle(
              //       fontFamily: FontFamily.jostBold,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 15,
              //     ),
              //   ),
              // )

            ],
          )
        );

  }

   void showUpdateRatesDialog(BuildContext context,DesignModel design) {
     Map<String, TextEditingController> rateControllers = {};
     Map<String, TextEditingController> dateControllers = {};
     // final _formKey = GlobalKey<FormState>();
     for (var p in design.processes!) {
       rateControllers[p.id!] =
           TextEditingController(text: p.price.toString());
       dateControllers[p.id!] = TextEditingController(
         text: DateFormat('dd/MM/yyyy')
             .format(DateTime.parse(p.startDate!)),
       );
     }
     Get.dialog(
       AlertDialog(
         backgroundColor: AppColors.bgCream,
         insetPadding: const EdgeInsets.all(24),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(12),
         ),

         titlePadding: EdgeInsets.zero,

         title: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
           child: Row(
             children: [
                Text(
                 "Update Rates for Design",
                 style: TextStyle(
                   fontSize: 18,
                   fontFamily: FontFamily.hanKenBold,
                 ),
               ),
               const Spacer(),
               InkWell(
                 onTap: () => Get.back(),
                 child: const Icon(Icons.close),
               )
             ],
           ),
         ),

         content: SizedBox(
           width: 700,
           child: SingleChildScrollView(
             child: Column(
               children: [

                 /// DESIGN NUMBER
                  Text(
                   "Design: ${design.designNumber}",
                   style: TextStyle(
                     fontSize: 18,
                     fontFamily: FontFamily.hanKenBold,
                   ),
                 ),

                 const SizedBox(height: 20),


                 ...design.processes!.map((process) {

                   final formattedDate = DateFormat('dd/MM/yyyy')
                       .format(DateTime.parse(process.startDate!));

                   return design.processes == null || design.processes!.isEmpty
                  ?  Center(
                     child: Padding(
                       padding: EdgeInsets.symmetric(vertical: 20),
                       child: Text(
                         "No Processes Found",
                         style: TextStyle(
                           fontSize: 16,
                           fontFamily: FontFamily.hanKenMedium,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   )
                   : Column(
                     children: [

                       processCard(
                         processName: process.processName ?? "",
                         rateController: rateControllers[process.id!]!,
                         dateController: dateControllers[process.id!]!,
                       ),

                       const SizedBox(height: 20),

                     ],
                   );

                 }).toList(),


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

           /// UPDATE BUTTON
           Obx((){
             final isLoading = controller.isUpdateRatesLoading.value;
             return Stack(
               children: [
                 ElevatedButton(
                   onPressed: isLoading
                       ? null
                       : () async {
                     List<Map<String, dynamic>> processes = [];

                     design.processes!.forEach((p) {

                       final rate =
                           double.tryParse(rateControllers[p.id!]!.text) ?? 0;

                       processes.add({
                         "processId": p.id,
                         "rate": rate,
                         "startDate": DateTime.now().toUtc().toIso8601String(),
                         "endDate": DateTime.now()
                             .add(Duration(days: 365))
                             .toUtc()
                             .toIso8601String(),
                       });

                     });

                     bool success = await controller.updateProcessRates(
                       designId: design.id!,
                       processes: processes,
                     );

                     if (success) {

                       Get.back();

                       ToastWidget.showToastCustom(
                         "Rates updated successfully",
                         color: AppColors.greenColor,
                       );

                     } else {

                       ToastWidget.showToastCustom(
                         "Failed to update rates",
                         color: Colors.red,
                       );

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
                   child:  Text(isLoading ? "Updating..." :"Update Rates",
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
               ]
             );
     }
           )
         ],
       ),
     );
   }

   void showDeleteDialog(BuildContext context,String designNumber,String designId) {
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
                   'Are you sure you want to design ${designNumber}?',
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
                                 bool success = await controller.deleteDesign(designId);

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
                                 controller.isDeleteDesignLoading.value
                                     ? "Deleting Design..."
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


   Widget processCard({
     required String processName,
     required TextEditingController rateController,
     required TextEditingController dateController,
   }) {

     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8),
         border: Border.all(color: AppColors.floatingBtnColor),
       ),

       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

           Text(
             "Process: $processName",
             style:  TextStyle(
               fontFamily: FontFamily.hanKenBold,
               fontWeight: FontWeight.bold,
               fontSize: 16,
             ),
           ),

           const SizedBox(height: 16),

           Row(
             children: [

               /// RATE FIELD
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     CommonTextField(
                       isTitle: true,
                       title: "Rate",
                       textInputType: TextInputType.number,
                       textInputAction: TextInputAction.next,
                       hintText: "Enter Rate",
                       controller: rateController,),
                   ],
                 ),
               ),

               const SizedBox(width: 20),

               /// DATE FIELD
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     CommonTextField(
                       isTitle: true,
                       title: "StartDate",
                       textInputType: TextInputType.number,
                       textInputAction: TextInputAction.done,
                       suffix: Icon(Icons.calendar_today),
                       hintText: "Enter Rate",
                       controller: dateController,),
                   ],
                 ),
               ),
             ],
           )
         ],
       ),
     );
   }

}

class _DesignCard extends StatelessWidget {
  final DesignModel item;
  final VoidCallback onRateChange;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DesignCard({
    required this.item,
    required this.onRateChange,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color _statBg = Color(0xFFF7F4F0);
  static const Color _pillBg = Color(0xFFEEE8DF);

  String _formatPrice(num? price) {
    if (price == null) return '0';
    final d = price.toDouble();
    if (d % 1 == 0) return d.toStringAsFixed(0);
    return d.toStringAsFixed(2);
  }

  String get _date {
    final processes = item.processes ?? [];
    if (processes.isEmpty) return '-';
    final created = processes.first.createdAt;
    return formatDate(created);
  }

  @override
  Widget build(BuildContext context) {
    final designNo = (item.designNumber ?? '-').toString();
    final processes = item.processes ?? [];

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
                          text: '#$designNo',
                          style: TextStyle(
                            fontFamily: FontFamily.hanKenBold,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                        ),
                        TextSpan(
                          text: '  ·  $_date',
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
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _pillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${processes.length} Process',
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenBold,
                      fontSize: 12,
                      color: AppColors.ringOuterColor,
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
                    if (value == 'rate change') {
                      onRateChange();
                    } else if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'rate change',
                      child: Row(
                        children: [
                          const Icon(Icons.currency_rupee, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Rate Change',
                            style: TextStyle(
                              fontFamily: FontFamily.hanKenMedium,
                            ),
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
            if (processes.isNotEmpty) ...[
              const Gap(12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: processes.map((p) {
                  final name = (p.processName ?? '-').toString();
                  final price = _formatPrice(p.price);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _statBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$name  ·  ₹$price',
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenMedium,
                        fontSize: 12,
                        color: AppColors.textColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const Gap(10),
            const Divider(height: 2, color: Color(0xFFF1EEEA)),
            const Gap(8),
            Row(
              children: [
                Icon(
                  Icons.design_services_outlined,
                  size: 14,
                  color: AppColors.textColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    processes.isEmpty
                        ? 'No processes'
                        : '${processes.length} processes configured',
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
}


class ProcessItem {
  String? process;
  TextEditingController rateController = TextEditingController();
  List<MachineRateItem> machines = [];

  ProcessItem({this.process});
}

class MachineRateItem {
  final String machineName;
  final TextEditingController baseRateController = TextEditingController();

  MachineRateItem(this.machineName);
}


class Design {
  final String date;
  final String designNumber;
  final String processName;

  Design({
    required this.date,
    required this.designNumber,
    required this.processName,
  });
}

