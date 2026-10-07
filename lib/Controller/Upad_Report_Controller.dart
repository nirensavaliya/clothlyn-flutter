import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class UpadReportController extends GetxController {

  final List<Map<String, dynamic>> upadReportData = [
    {
      "dNo": 1,
      "employeeName": "Ravi Kumar",
      "upadDates": "01 Mar - 03 Mar",
      "salary": 30000,
      "totalUpad": 2500,
      "finalSalary": 27500,
    },
    {
      "dNo": 2,
      "employeeName": "Amit Sharma",
      "upadDates": "05 Mar - 06 Mar",
      "salary": 28000,
      "totalUpad": 1800,
      "finalSalary": 26200,
    },
    {
      "dNo": 3,
      "employeeName": "Neha Patel",
      "upadDates": "10 Mar - 12 Mar",
      "salary": 35000,
      "totalUpad": 3200,
      "finalSalary": 31800,
    },
    {
      "dNo": 4,
      "employeeName": "Suresh Mehta",
      "upadDates": "15 Mar - 16 Mar",
      "salary": 40000,
      "totalUpad": 4500,
      "finalSalary": 35500,
    },
    {
      "dNo": 5,
      "employeeName": "Pooja Verma",
      "upadDates": "18 Mar - 20 Mar",
      "salary": 26000,
      "totalUpad": 1500,
      "finalSalary": 24500,
    },
    {
      "dNo": 6,
      "employeeName": "Rahul Singh",
      "upadDates": "22 Mar - 25 Mar",
      "salary": 32000,
      "totalUpad": 2800,
      "finalSalary": 29200,
    },
    {
      "dNo": 7,
      "employeeName": "Anjali Desai",
      "upadDates": "26 Mar - 27 Mar",
      "salary": 29000,
      "totalUpad": 2100,
      "finalSalary": 26900,
    },
    {
      "dNo": 8,
      "employeeName": "Vikas Malhotra",
      "upadDates": "28 Mar - 30 Mar",
      "salary": 36000,
      "totalUpad": 3400,
      "finalSalary": 32600,
    },
  ];

  void deleteUpad(Map<String, dynamic> item) {
    upadReportData.remove(item);
    filteredList.remove(item);
    update();
  }

  Future<void> downloadUpadReportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'UPAD Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),

          pw.Text(
            'Generated on: ${DateTime.now().toString().substring(0, 10)}',
            style: const pw.TextStyle(fontSize: 10),
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            border: pw.TableBorder.all(width: 0.6),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const [
              "D.No",
              "Employee Name",
              "UPAD Dates",
              "Salary",
              "Total UPAD",
              "Final Salary",
            ],
            data: upadReportData.map((item) {
              return [
                item["dNo"].toString(),
                item["employeeName"],
                item["upadDates"],
                "₹${item["salary"]}",
                "₹${item["totalUpad"]}",
                "₹${item["finalSalary"]}",
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/upad_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      usePrinterSettings: false,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    Get.snackbar("Success", "UPAD Report PDF downloaded successfully");
  }


  RxList<Map<String, dynamic>> filteredList =
      <Map<String, dynamic>>[].obs;

  final nameCtrl = TextEditingController();

  @override
  void onInit() {
    filteredList.assignAll(upadReportData);
    super.onInit();
  }

  void applyFilter() {
    filteredList.assignAll(
      upadReportData.where((item) {
        final nameMatch = nameCtrl.text.isEmpty ||
            item["employeeName"]
                .toString()
                .toLowerCase()
                .contains(nameCtrl.text.toLowerCase());

        return  nameMatch;
      }).toList(),
    );

    Get.back();
  }

  void clearFilter() {
    nameCtrl.clear();
    filteredList.assignAll(upadReportData);
    Get.back();
  }

}


