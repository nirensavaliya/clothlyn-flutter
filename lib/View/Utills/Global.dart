import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Model/User_Model.dart';
import '../Constant/App_Font.dart';

enum LoginViewState {
  mobile,
  otp,
  employee,
}

enum UserType{
  employee,
  admin
}

void disposeKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String getInitials(User user) {
  if (user.name.isEmpty) return 'A';

  final parts = user.name.trim().split(' ');

  if (parts.length == 1) {
    return parts[0][0].toUpperCase();
  }

  final firstInitial = parts[0][0].toUpperCase();
  final lastInitial = parts[1][0].toUpperCase();

  return '$firstInitial$lastInitial';
}

// String getInitials(User user) {
//   final firstNameInitial =
//   user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '';
//   final lastNameInitial =
//   user.lastName.isNotEmpty ? user.lastName[0].toUpperCase() : '';
//
//   if (firstNameInitial.isEmpty && lastNameInitial.isEmpty) {
//     return 'A'; // default
//   }
//  print('firstNameInitial------${firstNameInitial}${lastNameInitial}');
//   print('lastName---${user.lastName.codeUnits}');
//   return '$firstNameInitial$lastNameInitial';
// }

String formatDate(String? date) {
  if (date == null || date.isEmpty) return "";

  DateTime parsedDate = DateTime.parse(date);
  return DateFormat("dd MMM yyyy").format(parsedDate);
}

String convertToApiDate(String uiDate) {
  DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(uiDate);
  return DateFormat("yyyy-MM-dd").format(parsedDate);
}

String apiToUiDate(String apiDate) {
  final value = apiDate.trim();
  if (value.isEmpty || value.toLowerCase() == 'null') return "-";

  final parsedDate = DateTime.tryParse(value);
  if (parsedDate == null) return "-";

  return DateFormat("dd/MM/yyyy").format(parsedDate);
}

String salaryFormatDate(String? date) {
  if (date == null || date.isEmpty) return "";

  try {
    DateTime parsedDate;

    if (date.contains('/')) {
      parsedDate = DateFormat("dd/MM/yyyy").parse(date);
    } else {
      parsedDate = DateTime.parse(date);
    }

    return DateFormat("dd MMM yyyy").format(parsedDate);
  } catch (e) {
    return date;
  }
}

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.manageExternalStorage.request().isGranted) {
    } else {
      openAppSettings();
      return false;
    }
  }
  return true;
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return "Good Morning";
  if (hour < 17) return "Good Afternoon";
  return "Good Evening";
}

Widget infoItem({
  required String title,
  required String value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style:  TextStyle(
          fontFamily: FontFamily.hanKenBold,
          fontSize: 14,
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


class FigmaBackgroundBlur extends StatelessWidget {
  const FigmaBackgroundBlur({super.key});

  /// Figma: Background+Blur — 353×353, #6A5C44 @ 25%, layer blur 80
  static const Color _blob = Color(0xFF6A5C44);
  static const double _size = 353;
  static const double _opacity = 0.25;
  static const double _blur = 80;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _circle(),
          ),
          Positioned(
            top: -40,
            right: -100,
            child: _circle(),
          ),
          Positioned(
            top: 220,
            left: -160,
            child: _circle(),
          ),
          Positioned(
            top: 280,
            right: -140,
            child: _circle(),
          ),
        ],
      ),
    );
  }

  Widget _circle() {
    const pad = _blur;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
      child: Container(
        width: _size + pad * 2,
        height: _size + pad * 2,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _blob.withValues(alpha: _opacity),
          ),
        ),
      ),
    );
  }
}