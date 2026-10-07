
import 'dart:io';

import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MethodConstants{

  static Future<String> cropImage({required BuildContext context, required String myImage}) async {
    String croppedImage = "";
    if (myImage != null && myImage.isNotEmpty) {
      FocusScope.of(context).unfocus();
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: myImage,
        compressFormat: ImageCompressFormat.jpg,
        // cropStyle: CropStyle.rectangle,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              cropStyle: CropStyle.rectangle,
              toolbarTitle: "cropper",
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              statusBarColor: Colors.black,
              cropGridColor: Colors.white,
              backgroundColor: Color(0xffFFFFFF),
              activeControlsWidgetColor: AppColors.appColor,
              lockAspectRatio: false),
          IOSUiSettings(title:  "cropper"),
          WebUiSettings(
            context: context,
            // presentStyle: CropperPresentStyle.dialog,
            // boundary: const CroppieBoundary(width: 520, height: 520),
            // viewPort: CroppieViewPort(width: 480, height: 480, type: LanguageConstants.circle.tr),
            // enableExif: true,
            // enableZoom: true,
            // showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        croppedImage = croppedFile.path;
      }
    }

    return croppedImage;
  }

  static Future<String> getImage(
      {required ImageSource imageSource, required BuildContext context, CameraDevice preferredCameraDevice = CameraDevice.rear}) async {
    String myImage = "";
    final picker = ImagePicker();
    // if(Permission.photos.isGranted!=null )

    final pickedFile = await picker.pickImage(source: imageSource, preferredCameraDevice: preferredCameraDevice);

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      myImage = await MethodConstants.cropImage(context: context, myImage: image.path);
    }
    return myImage;
  }

}