import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';

class SalaryPaidController extends GetxController{
  final List<Map<String, dynamic>> salaryPaidData = [
    {
      "employeeName": "John Doe",
      "month": "January",
      "paidAmount": 45000,
      "createdAt": "12 Jan 2025",
    },
    {
      "employeeName": "Jane Smith",
      "month": "February",
      "paidAmount": 54000,
      "createdAt": "10 Feb 2025",
    },
    {
      "employeeName": "Robert Brown",
      "month": "March",
      "paidAmount": 36000,
      "createdAt": "08 Mar 2025",
    },
  ];

  Future<void> downloadSalaryPaidPdf(List<Map<String, dynamic>> salaryPaidData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Salary Paid Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Text(
            'Generated on: ${DateTime.now().toString().substring(0, 10)}',
            style: const pw.TextStyle(fontSize: 10),
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            border: pw.TableBorder.all(width: 0.5),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            cellAlignment: pw.Alignment.centerLeft,
            headers: const [
              "Employee Name",
              "Month",
              "Paid Amount",
              "Paid Date",
            ],
            data: salaryPaidData.map((item) {
              return [
                item["employeeName"],
                item["month"],
                "₹${item["paidAmount"]}",
                item["createdAt"],
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/salary_paid_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      usePrinterSettings: false,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );

    Get.snackbar("Success", "Salary Paid PDF downloaded successfully");
  }

  RxList<Map<String, dynamic>> filteredList =
      <Map<String, dynamic>>[].obs;

  final nameCtrl = TextEditingController();

  @override
  void onInit() {
    filteredList.assignAll(salaryPaidData);
    super.onInit();
  }

  void applyFilter() {
    filteredList.assignAll(
      salaryPaidData.where((item) {
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
    filteredList.assignAll(salaryPaidData);
    Get.back();
  }


}