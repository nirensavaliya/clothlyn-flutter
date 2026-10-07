import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';

PreferredSizeWidget commonAppBar({
  required String title,
  Widget? leading,
  Widget? actions,
  bool showBack = true,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(65 + MediaQuery.paddingOf(Get.context!).top),
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFCFC5B9),
                width: 2,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leading ??
                        (showBack
                            ? IconButton(
                          icon:  Icon(Icons.arrow_back_ios,
                              color: AppColors.iconColor, size: 20),
                          onPressed: Get.back,
                        )
                            : const SizedBox(width: 40)),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: FontFamily.hanKenSemiBold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    actions ?? const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}