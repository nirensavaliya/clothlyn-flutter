import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Controller/Add_product_Controller.dart';
import '../../Model/Product_Model.dart';
import '../Common/Toast.dart';
import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';
import '../Utills/Global.dart';

class BarcodeDialog extends StatelessWidget {
  final ProductItem item;

  const BarcodeDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(24),
      // scrollable: true,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Text(
              "Product Details:- ${item.lotNo}",
              style: TextStyle(
                  fontFamily: FontFamily.jostBold,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _row("Lot No", item.lotNo),
                  _row("D No", item.dNo),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _row("Size", item.size),
                  _row("Color", item.colour),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _row("Pic", item.pic.toString()),
                ],
              ),
              _row("Last Scan Date", apiToUiDate(item.lastScanDate.toString())),

              const SizedBox(height: 20),

              /// QR Code
              QrImageView(
                data: item.lotNo ?? "N/A",
                version: QrVersions.auto,
                size: 150,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child:  Text("Close",style: TextStyle(
            fontFamily: FontFamily.jostBold,
            fontSize: 15,
            color: Colors.black,
          ),),
        ),
        const SizedBox(width: 12),
        Obx(() {
          final controller = Get.find<AddProductController>();
          final isLoading = controller.isBarcodePdfDownloading.value;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        controller.isBarcodePdfDownloading.value = true;
                        try {
                          await _downloadBarcodePdf(context, item);
                        } finally {
                          controller.isBarcodePdfDownloading.value = false;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  isLoading ? "Downloading..." : "Print",
                  style: TextStyle(
                    fontFamily: FontFamily.jostBold,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isLoading)
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: AppColors.appColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ",
              style:  TextStyle(
                fontFamily: FontFamily.hanKenMedium,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF616161),
              )),
          Text(value ?? "-",style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: FontFamily.hanKenBold,
          ),),
        ],
      ),
    );
  }

  Future<void> _downloadBarcodePdf(BuildContext context, ProductItem item) async {
    try {
      const mm = PdfPageFormat.mm;
      final labelFormat = PdfPageFormat(
        70 * mm,
        45 * mm,
        marginAll: 2 * mm,
      );

      final mediumFont =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Jost-Medium.ttf'));
      final boldFont =
          pw.Font.ttf(await rootBundle.load('assets/fonts/Jost-Bold.ttf'));

      final pdf = pw.Document(
        theme: pw.ThemeData.withFont(
          base: mediumFont,
          bold: boldFont,
        ),
      );

      pdf.addPage(
        pw.Page(
          pageFormat: labelFormat,
          build: (context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(color: PdfColors.black, width: 0.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _pdfRow("Lot No", item.lotNo),
                            _pdfRow("D No", item.dNo),
                            _pdfRow("Size", item.size),
                            _pdfRow("Color", item.colour),
                            _pdfRow("Pic", item.pic),
                            _pdfRow(
                              "Last Scan Date",
                              apiToUiDate(item.lastScanDate.toString()),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 3),
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: item.lotNo ?? "N/A",
                        width: 48,
                        height: 48,
                        color: PdfColors.black,
                        drawText: false,
                      ),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Center(
                    child: pw.Text(
                      item.lotNo ?? "-",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final lotNoSafe = (item.lotNo ?? DateTime.now().millisecondsSinceEpoch.toString())
          .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final fileName = "barcode-$lotNoSafe.pdf";

      final tempDir = await getTemporaryDirectory();
      final tempFile = File("${tempDir.path}/$fileName");
      await tempFile.writeAsBytes(bytes, flush: true);

      final result = await MediaStore().saveFile(
        tempFilePath: tempFile.path,
        relativePath: "Download",
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (result == null || result.toString().isEmpty) {
        throw Exception("Unable to save file in Downloads");
      }

      ToastWidget.showToastCustom(
        "PDF downloaded in Downloads/SitaramClothing",
        color: Colors.green,
      );
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      ToastWidget.showToastCustom(
        "PDF download failed",
        color: Colors.red,
      );
    }
  }

  pw.Widget _pdfRow(String title, String? value) {
    final safeValue = ((value ?? "-").trim().isEmpty) ? "-" : value!;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1.5),
      child: pw.Text(
        "$title: $safeValue",
        style: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 6.5,
        ),
        maxLines: 1,
      ),
    );
  }
}