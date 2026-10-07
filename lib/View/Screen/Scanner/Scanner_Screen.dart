import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Widget/Custom_Appbar.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../Controller/Scanner_Controller.dart';
import '../../../Model/Scann_Model.dart';
import '../../Constant/App_Font.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_Scanner.dart';
import '../../Widget/Custom_Scanner_Mask.dart';

Widget _scanShimmerBone({
  double height = 14,
  double? width,
  BorderRadius? borderRadius,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: borderRadius ?? BorderRadius.circular(6),
    ),
  );
}

/// Skeleton process cards while Scan list loads — same size as real cards.
Widget _scanListShimmer({int count = 10}) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: count,
    itemBuilder: (_, __) {
      return Shimmer(
        duration: const Duration(milliseconds: 1400),
        interval: Duration.zero,
        color: Colors.white,
        colorOpacity: 0.45,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                color: Color(0xff6A5C44),
                width: 1.7,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xff6A5C44), width: 1.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Matches processName Text (fontSize 16)
                  _scanShimmerBone(height: 19, width: 130),
                  Row(
                    children: [
                      // Matches "Click to scan" (fontSize 15)
                      _scanShimmerBone(height: 18, width: 95),
                      const SizedBox(width: 6),
                      // Matches arrow icon size 15
                      _scanShimmerBone(
                        height: 15,
                        width: 15,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Full route page — Scaffold + AppBar for [Get.toNamed].
class ScannerScreen extends StatelessWidget {
  ScannerScreen({super.key});

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
          appBar: commonAppBar(title: 'Scan'),
          body: ScannerBody(),
        ),
      ],
    );
  }
}

/// Scanner content only — no Scaffold. Used inside AdminHomeScreen tab body.
class ScannerBody extends StatefulWidget {
  const ScannerBody({super.key});

  @override
  State<ScannerBody> createState() => _ScannerBodyState();
}

class _ScannerBodyState extends State<ScannerBody> {
  final controller = Get.put(ScanUserController());

  // @override
  // void initState() {
  //   super.initState();
  //   controller.scannerController = MobileScannerController(
  //     autoStart: true,
  //     facing: CameraFacing.back,
  //     detectionSpeed: DetectionSpeed.normal,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final scanWindow = Rect.fromCenter(
    //     center: MediaQuery.sizeOf(context).center(Offset.zero),
    //     width: 200,
    //     height: 200);
    return  Stack(
      children: [
        Column(
          children: [
            Obx(()
            => Expanded(
              child: controller.isLoading.value
                  ? Stack(
                      children: [
                        _scanListShimmer(),
                        const CustomSpinLoader(),
                      ],
                    )
                  : controller.scanData.isEmpty
                  ?  Center(child: Text("No Product Found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: FontFamily.hanKenBold,
                  color: Colors.grey,
                ),))

                  : Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 14),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.scanData.length,
                  itemBuilder: (context, index) {
                    return _buildCard(controller.scanData[index]);
                  },
                ),
              ),
            ),
            ),

            // Expanded(
            //   child: Stack(
            //     children:[
            //
            //       MobileScanner(
            //         controller: controller.scannerController,
            //         tapToFocus: true,
            //         fit: BoxFit.cover,
            //         // scanWindow: scanWindow,
            //         errorBuilder: (context, error){
            //           return Text(
            //             'error---${error.errorCode.toString()} ${error.errorDetails?.message}',
            //             style: TextStyle(
            //               color: Colors.black
            //             ),
            //           );
            //         },
            //         onDetect: (capture) async {
            //           final barcode = capture.barcodes.first;
            //           final String? code = barcode.rawValue;
            //
            //           if (code != null) {
            //             controller.scannerController?.stop();
            //             await controller.loadUserFromScan(code);
            //             // await scannerController.start();
            //           }
            //         },
            //       ),
            //       /*Positioned.fill(
            //         child: ImageFiltered(
            //           imageFilter: ImageFilter.blur(
            //             sigmaX: 6,
            //             sigmaY: 6,
            //           ),
            //           child: Container(
            //             color: Colors.black.withOpacity(0.7),
            //           ),
            //         ),
            //       ),*/
            //       const ScannerMask(),
            //       Center(
            //         child: ScannerOverlay(),
            //       ),
            //     ]
            //   ),
            // ),
          ],
        ),
        // Shown after scan camera closes while lot/employees APIs run
        Obx(() {
          if (!controller.isFetchingDetails.value) {
            return const SizedBox.shrink();
          }
          return Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomSpinLoader(),
                  const SizedBox(height: 12),
                  Text(
                    "Loading item details...",
                    style: TextStyle(
                      fontFamily: FontFamily.hanKenMedium,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
    // return  Scaffold(
    //   backgroundColor: Colors.grey.shade100,
    //   appBar: commonAppBar(title: "Scan"),
    //   body: Stack(
    //     children: [
    //       Column(
    //         children: [
    //               Obx(()
    //                 => Expanded(
    //                   child: controller.isLoading.value
    //                       ?  Center(child: LoadingAnimationWidget.threeArchedCircle(
    //                     color: AppColors.appColor,
    //                     size: 50,
    //                   ))
    //                       : controller.scanData.isEmpty
    //                       ?  Center(child: Text("No Product Found",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                       fontFamily: FontFamily.jostBold,
    //                       color: Colors.grey,
    //                     ),))
    //
    //                  : Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 14),
    //                   child: ListView.builder(
    //                     shrinkWrap: true,
    //                     itemCount: controller.scanData.length,
    //                     itemBuilder: (context, index) {
    //                       return _buildCard(controller.scanData[index]);
    //                     },
    //                   ),
    //                               ),
    //                 ),
    //               ),
    //
    //           // Expanded(
    //           //   child: Stack(
    //           //     children:[
    //           //
    //           //       MobileScanner(
    //           //         controller: controller.scannerController,
    //           //         tapToFocus: true,
    //           //         fit: BoxFit.cover,
    //           //         // scanWindow: scanWindow,
    //           //         errorBuilder: (context, error){
    //           //           return Text(
    //           //             'error---${error.errorCode.toString()} ${error.errorDetails?.message}',
    //           //             style: TextStyle(
    //           //               color: Colors.black
    //           //             ),
    //           //           );
    //           //         },
    //           //         onDetect: (capture) async {
    //           //           final barcode = capture.barcodes.first;
    //           //           final String? code = barcode.rawValue;
    //           //
    //           //           if (code != null) {
    //           //             controller.scannerController?.stop();
    //           //             await controller.loadUserFromScan(code);
    //           //             // await scannerController.start();
    //           //           }
    //           //         },
    //           //       ),
    //           //       /*Positioned.fill(
    //           //         child: ImageFiltered(
    //           //           imageFilter: ImageFilter.blur(
    //           //             sigmaX: 6,
    //           //             sigmaY: 6,
    //           //           ),
    //           //           child: Container(
    //           //             color: Colors.black.withOpacity(0.7),
    //           //           ),
    //           //         ),
    //           //       ),*/
    //           //       const ScannerMask(),
    //           //       Center(
    //           //         child: ScannerOverlay(),
    //           //       ),
    //           //     ]
    //           //   ),
    //           // ),
    //         ],
    //       ),
    //       // Shown after scan camera closes while lot/employees APIs run
    //       Obx(() {
    //         if (!controller.isFetchingDetails.value) {
    //           return const SizedBox.shrink();
    //         }
    //         return Positioned.fill(
    //           child: Container(
    //             color: Colors.black.withOpacity(0.35),
    //             child: Center(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   LoadingAnimationWidget.threeArchedCircle(
    //                     color: AppColors.appColor,
    //                     size: 50,
    //                   ),
    //                   const SizedBox(height: 12),
    //                   Text(
    //                     "Loading item details...",
    //                     style: TextStyle(
    //                       fontFamily: FontFamily.jostMedium,
    //                       fontSize: 15,
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         );
    //       }),
    //     ],
    //   ),
    // );
  }

  Future<void> _openScanDialog() async {
    await controller.initScanner();
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (scanContext) => _FullScreenScannerPage(controller: controller),
      ),
    );
    await controller.clearAndCloseScanner();
    await controller.disposeScannerSafely();
  }

  Widget _buildCard(ScannData item) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: const Color(0xff6A5C44),
            width: 1.7,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            controller.setSelectedProcess(item);
            await _openScanDialog();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xff6A5C44),width: 1.7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left Text
                Text(
                  item.processName,
                  style:  TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontFamily: FontFamily.hanKenBold,
                  ),
                ),

                /// Right Side
                Row(
                  children:  [
                    Text(
                      "Click to scan",
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenMedium,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenScannerPage extends StatelessWidget {
  final ScanUserController controller;
  const _FullScreenScannerPage({required this.controller});

  Future<void> _onPickFromGallery(BuildContext context) async {
    final scannerController = controller.scannerController;
    if (scannerController == null) return;

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    final BarcodeCapture? capture = await scannerController.analyzeImage(
      xFile.path,
    );
    final code = capture?.barcodes.first.rawValue;
    if (code == null || controller.isScanned) return;

    await controller.stopScanner();
    if (context.mounted) Navigator.of(context).pop();
    await controller.loadUserFromScan(code);
  }

  Widget _roundAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scannerController = controller.scannerController;
    if (scannerController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Scanner not ready")),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final double boxSize = (size.width * 0.72).clamp(220.0, 320.0);
    final double topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: scannerController,
            fit: BoxFit.cover,
            onDetect: (capture) async {
              final barcode = capture.barcodes.first;
              final code = barcode.rawValue;
              if (code == null || controller.isScanned) return;

              await controller.stopScanner();
              if (context.mounted) Navigator.of(context).pop();
              await controller.loadUserFromScan(code);
            },
          ),

          ScannerMask(boxSize: boxSize),

          Center(
            child: ScannerOverlay(boxSize: boxSize),
          ),

          Positioned(
            top: topPad + 12,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _roundAction(
                  icon: Icons.photo_library_outlined,
                  onTap: () async => _onPickFromGallery(context),
                ),
                _roundAction(
                  icon: Icons.flash_on_outlined,
                  onTap: () async {
                    try {
                      await scannerController.toggleTorch();
                    } catch (_) {}
                  },
                ),
                _roundAction(
                  icon: Icons.cameraswitch_outlined,
                  onTap: () async {
                    try {
                      await scannerController.switchCamera();
                    } catch (_) {}
                  },
                ),
                _roundAction(
                  icon: Icons.close_rounded,
                  onTap: () async {
                    await controller.stopScanner();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
