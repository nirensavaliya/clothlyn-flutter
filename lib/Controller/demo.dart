import 'package:flutter/material.dart';
import 'package:get/get.dart';

class demoController extends GetxController{

  Rx<PageController> introController = PageController().obs;

  RxInt initialIndex = 0.obs;
  @override
  void onInit() {}

  onPageChanged(int value) {
    if (initialIndex.value == 2) {}
    initialIndex.value = value;
  }

  routeToLoginScreen() {}

}