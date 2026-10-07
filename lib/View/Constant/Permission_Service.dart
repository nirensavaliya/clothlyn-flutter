import 'dart:io';

import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';


class PermissionHandlerService {
  static Future<PermissionStatus> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isPermanentlyDenied) {
      await showCameraPermissionDialog(context);
    }

    return status;
  }

  /*Request photo library permission with custom dialog
  static Future<PermissionStatus> requestPhotoLibraryPermission(BuildContext context) async {
    final status = await Permission.photos.request();

    if (!status.isGranted) {
      await _showGalleryPermissionDialog(context);
    }

    return status;
  }*/

  static Future<bool> requestPhotoLibraryPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final status = await Permission.photos.request();
        if (status.isPermanentlyDenied) {
          // await _showGalleryPermissionDialog(context);
          return false;
        }
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        // if (status.isPermanentlyDenied) {
        //   await _showGalleryPermissionDialog(context);
        //   return false;
        // }
        return status.isGranted;
      }
    } else {
      final status = await Permission.photos.request();
      /*   if (status.isPermanentlyDenied) {
        await _showGalleryPermissionDialog(context);
        return false;
      }*/
      return status.isGranted || status.isLimited;
    }
  }


  /*static Future<PermissionStatus> requestPhotoLibraryPermission(BuildContext context) async {
    final status = await Permission.photos.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      await _showGalleryPermissionDialog(context);
    } else if (status.isLimited) {
      print("Limited photo library access granted");
    }

    return status;
  }*/


  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> isPhotoLibraryPermissionGranted() async {
    final status = await Permission.photos.status;
    return status.isGranted || status.isLimited;
  }

  static Future<Map<Permission, PermissionStatus>> requestAllMediaPermissions(BuildContext context) async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    final cameraStatus = statuses[Permission.camera];
    final photosStatus = statuses[Permission.photos];

    if ((cameraStatus?.isDenied ?? false) || (cameraStatus?.isPermanentlyDenied ?? false)) {
      await showCameraPermissionDialog(context);
    }

    if ((photosStatus?.isDenied ?? false) || (photosStatus?.isPermanentlyDenied ?? false)) {
      await showGalleryPermissionDialog(context);
    }

    return statuses;
  }

  static Future<bool> areAllMediaPermissionsGranted() async {
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;

    return cameraStatus.isGranted && (photosStatus.isGranted || photosStatus.isLimited);
  }

  static Future<void> showCameraPermissionDialog(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_outlined,size: 90,),
                const SizedBox(height: 16),

                 Text(
                  "Camera Access Needed",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.jostBold
                  ),
                ),

                const SizedBox(height: 8),

                 Text(
                  "We need access to your camera so you can take photos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.hanKenMedium,
                      color: Colors.black54
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEAF7F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      openAppSettings();
                    },
                    child: const Text(
                      "Open Settings",
                      style: TextStyle(
                        color: Color(0xFF04BCBC),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showGalleryPermissionDialog(BuildContext context) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_outlined,size: 100,),

                const SizedBox(height: 16),

                 Text(
                  "Photo Library Access Needed",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.jostBold
                  ),
                ),

                const SizedBox(height: 8),

                 Text(
                  "We need access to your photo library to select and save photos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.hanKenMedium,
                      color: Colors.black54
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEAF7F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      openAppSettings();
                    },
                    child: const Text(
                      "Open Settings",
                      style: TextStyle(
                        color: Color(0xFF04BCBC),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  static Future<bool> checkAndRequestMediaPermissions(BuildContext context) async {
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;

    if (cameraStatus.isGranted && (photosStatus.isGranted || photosStatus.isLimited)) {
      return true;
    }

    final statuses = await requestAllMediaPermissions(context);

    final newCameraStatus = statuses[Permission.camera];
    final newPhotosStatus = statuses[Permission.photos];

    return (newCameraStatus?.isGranted ?? false) &&
        (newPhotosStatus?.isGranted ?? newPhotosStatus?.isLimited ?? false);
  }


  static bool _isRequesting = false;

  static Future<bool> checkAndRequestPermission(
      BuildContext context,
      Permission permission,
      String permissionType
      ) async {
    if (_isRequesting) return false;
    _isRequesting = true;

    try {
      if (permission == Permission.photos && Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 33) {
          final status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            // await _showGalleryPermissionDialog(context);
            return false;
          }
          return true;
        } else {
          final status = await Permission.storage.request();
          if (status.isPermanentlyDenied) {
            // await _showGalleryPermissionDialog(context);
            return false;
          }
          return status.isGranted;
          /*final status = await Permission.storage.request();
          if (status.isPermanentlyDenied) {
            await _showGalleryPermissionDialog(context);
            return false;
          }
          return true;*/
        }
      }

      final status = await permission.status;
      if (status.isGranted || (permission == Permission.photos && status.isLimited)) {
        return true;
      }

      final newStatus = await permission.request();

      if (newStatus.isGranted ||
          (permission == Permission.photos && newStatus.isLimited)) {
        return true;
      }

      /*     if (!newStatus.isGranted) {
        if (newStatus.isPermanentlyDenied) {
          if (!context.mounted) return false;
          if (permission == Permission.camera) {
            await showCameraPermissionDialog(context);
          } else if (permission == Permission.photos) {
            await showGalleryPermissionDialog(context);
          }
        }
        return false;
      }*/


      return false;
    } finally {
      _isRequesting = false;
    }
  }

  static Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}

