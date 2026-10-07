import 'package:clothlyn/Controller/Admin_Upad_Controller.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../Constant/App_Colors.dart';
import '../../../Constant/App_Font.dart';
import '../../../Utills/Global.dart';
import '../../../Widget/Custom_Add_Upad_Dialog.dart';

class AdminUpadReportScreen extends StatelessWidget {
   AdminUpadReportScreen({super.key});

   AdminUpadController upadController = Get.put(AdminUpadController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: commonAppBar(
          title: "Upad Report",
        actions:
          // IconButton(
          //   onPressed: () {
          //   },
          //   icon: const Icon(Icons.filter_list, color: Colors.white),
          // ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: () {
              upadController.downloadSalaryExcel();
            },
          ),

      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: (){
                        showDialog(
                          context: context,
                          useSafeArea: true,
                          barrierDismissible: false,
                          builder: (_) =>  CustomAddUpadDialog(adminUpadController: upadController,),
                        );

                      },
                      child: Text(
                        "Add New UPAD",
                        style: TextStyle(
                          fontFamily: FontFamily.jostBold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(15),
                Obx(() {
                  return   upadController.isLoading.value
                      ?  Expanded(
                    child: Center(child: const CustomSpinLoader()),
                  )
                      : upadController.uPad.isEmpty
                      ?  Expanded(
                    child: Center(child: Text("No Upad Found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: FontFamily.jostBold,
                        color: Colors.grey,
                      ),)),
                  )

                      : Expanded(
                    child: SingleChildScrollView(
                      child:
                        Container(
                          color: Colors.grey.shade100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20,
                              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                              headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
                              columns: [
                                const DataColumn(
                                  label: Text(
                                    "Action",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Text("Upad Dates",textAlign: TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FontFamily.jostBold))),
                                DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Text("Employee Name",textAlign: TextAlign.center  ,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FontFamily.jostBold))),
                                DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Text("Salary", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FontFamily.jostBold))),
                                DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Text("Total UPAD", textAlign: TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FontFamily.jostBold))),
                                DataColumn(
                                    headingRowAlignment: MainAxisAlignment.center,
                                    label: Text("Final Total Salary", textAlign: TextAlign.center ,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FontFamily.jostBold))),
                              ],
                              rows: upadController.uPad
                                  .map(
                                    (item) => DataRow(
                                    cells: [
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: PopupMenuButton<String>(
                                            color: Colors.white,
                                            position: PopupMenuPosition.under,
                                            padding: const EdgeInsets.all(0),

                                            icon: const Icon(Icons.more_vert),
                                            onSelected: (value) {
                                              // if (value == 'view') {
                                              // } else
                                              if (value == 'edit') {
                                                showDialog(
                                                  context: context,
                                                  useSafeArea: true,
                                                  barrierDismissible: false,
                                                  builder: (_) =>  CustomAddUpadDialog(adminUpadController: upadController,isEdit: true,item: item),
                                                );
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              // const PopupMenuItem(
                                              //   value: 'view',
                                              //   child: Row(
                                              //     children: [
                                              //       Icon(Icons.visibility, size: 18),
                                              //       SizedBox(width: 8),
                                              //       Text("View"),
                                              //     ],
                                              //   ),
                                              // ),
                                              // const PopupMenuDivider(height: 1),
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit_square, size: 18),
                                                    SizedBox(width: 8),
                                                    Text("Edit",style: TextStyle(
                                                        fontFamily: FontFamily.hanKenMedium
                                                    ),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(child: Text(formatDate(item.createdAt.toString()),style: TextStyle(
                                          fontFamily: FontFamily.jostBold
                                      ),))),
                                      DataCell(Center(child: Text('${item.employeeId?.firstName ?? '-'} ${item.employeeId?.lastName ?? ''}',style: TextStyle(
                                          fontFamily: FontFamily.jostMedium
                                      ),))),
                                      DataCell(
                                          Center(child: Text("₹${item.totalSalary}",style: TextStyle(
                                              fontFamily: FontFamily.jostMedium
                                          ),))),
                                      DataCell(Center(child: Text("₹${item.upadAmount}",style: TextStyle(
                                          fontFamily: FontFamily.jostMedium
                                      ),))),
                                      DataCell(Center(child: Text("₹${item.availableAmount}",style: TextStyle(
                                          fontFamily: FontFamily.jostMedium
                                      ),))),
                                    ]),
                              )
                                  .toList(),
                            ),
                          ),
                        ),
                    ),
                  );
                }

                ),

              ],
            ),
          ),
          Obx(() {
            if(!upadController.isDownloading.value){
              return const SizedBox();
            }

            return Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: const CustomSpinLoader(size: 60),
              ),
            );
          })
        ]
      ),
    );
  }
}
