import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:clothlyn/View/Constant/App_Font.dart';
import 'package:clothlyn/View/Constant/App_Images.dart';
import 'package:clothlyn/View/Widget/Custom_Spin_Loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../Controller/Login_Controller.dart';
import '../../Utills/Global.dart';
import '../../Widget/Custom_TextField.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
   final LoginController controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        disposeKeyboard(Get.context!);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgCream,
        body: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppColors.bgCream),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.sizeOf(context).height * 0.38,
              child: Image.asset(
                AppImages.imgLoginBg,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            Positioned(
              top: 86,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 194,
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(28),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.08),
                    //     blurRadius: 20,
                    //     offset: const Offset(0, 5),
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImages.imgTempAppLogo,
                        width: 112,
                        height: 112,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sitaram Cloth',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: FontFamily.guGi,
                          color: const Color(0xFF10233E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SingleChildScrollView(
                  reverse: true,
                  padding: const EdgeInsets.only(top: 330, bottom: 0),
                  child: Obx(() {
                  if (controller.isEmployeeFlowCompleted.value) {
                    if(!controller.isOtpSentForEmployeeFlow.value){
                      // Show Post-Employee Login Screen
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Welcome Back, Admin",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xff0B1C30),
                                    fontFamily: FontFamily.hanKenBold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  "Sign in to access your factory \ndashboard and inventory lots.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontFamily.hanKenMedium,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                              Gap(24),
                              Text(
                                'Phone Number*',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontFamily.hanKenBold,
                                ),
                              ),
                              Gap(8),
                              Obx(()
                                => CommonTextField(
                                  isTitle: false,
                                  controller: controller.employeeMobileNumberController,
                                  borderRadius: 8,
                                  textInputType: TextInputType.number,
                                  maxLength: 10,
                                  // showCursor: controller.isOtpSentForEmployeeFlow.value,
                                  readOnly: controller.isOtpSentForEmployeeFlow.value,
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mobile number is required';
                                    } else if (value.length != 10) {
                                      return 'Mobile number must be 10 digits';
                                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return 'Mobile number can contain only digits';
                                    }
                                    return null;
                                  },
                                  prefix: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      '+91',
                                      style: TextStyle(
                                        color: AppColors.appBtnColor,
                                        fontFamily: FontFamily.hanKenBold,
                                      ),
                                    ),
                                  ),
                                  hintText: 'Enter mobile number',
                                ),
                              ),
                              Gap(40),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // if (!controller.isRequestOTP.value)
                                  // SizedBox(
                                  //   width: 145,
                                  //   height: 52,
                                  //   child: ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: AppColors.greyColor,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //     ),
                                  //     onPressed: () {
                                  //       controller.openEmployeeView();
                                  //     },
                                  //     child: Text(
                                  //       "Back",
                                  //       style: TextStyle(
                                  //         fontFamily: FontFamily.jostBold,
                                  //         fontSize: 16,
                                  //         color: Colors.black,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

      /*
                                  SizedBox(
                                    width: 145,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.appColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: (){
                                        print('isOtpSent-----${controller.isOtpSent.value}');
                                        // controller.sendOtp(); // send OTP request
                                        controller.isOtpSentForEmployeeFlow.value = true; // trigger FlipCard to show back (OTP)

                                        // controller.sendOtp();
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontFamily: FontFamily.jostBold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
      */

                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      Obx(() => SizedBox(
                                        width:  double.infinity ,
                                        height: 52,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.floatingBtnColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: controller.isRequestOTP.value
                                              ? null
                                              : controller.sendOtpForAdmin,
                                          child: Text(
                                            controller.isRequestOTP.value
                                                ? "Login..."
                                                : "Login",
                                            style: TextStyle(
                                              fontFamily: FontFamily.hanKenBold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),

                                      Obx(() => controller.isRequestOTP.value
                                          ?  Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child:  CustomSpinLoader(size: 50, boxed: false)
                                      )
                                          : const SizedBox()),
                                    ],
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                                child: Icon(Icons.arrow_back_ios)),
                            Center(
                              child: Text(
                                'Enter OTP',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: FontFamily.hanKenBold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),
                      /*      Obx(()
                              => Center(
                                child: Text(
                                  "We've sent an OTP to ${controller.employeeMobileNumberController.text}.\n OTP: ${controller.getOtp.value}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontFamily.jostMedium,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),*/
                            Obx(
                                  () => Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.hanKenMedium,
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "We've sent an OTP to ",
                                      ),
                                      TextSpan(
                                        text: controller.employeeMobileNumberController.text,
                                        style:  TextStyle(
                                          fontFamily: FontFamily.hanKenMedium,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ".\nOTP: ",
                                      ),
                                      TextSpan(
                                        text: controller.getOtp.value,
                                        style:  TextStyle(
                                          fontFamily: FontFamily.hanKenBold,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            RichText(
                              text: TextSpan(
                                text: 'OTP ',
                                style: TextStyle(
                                  color: AppColors.appBtnColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.hanKenBold,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            Gap(8),
                            Center(child: _buildOtpBox(context: context,controller: controller.employeeOtpController)),
                            Gap(40),

                            // SizedBox(
                            //   width: double.infinity,
                            //   height: 52,
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: AppColors.appColor,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //       elevation: 0,
                            //     ),
                            //     onPressed: () {
                            //       controller.verifyOtp();
                            //
                            //
                            //     },
                            //     child:  Text(
                            //       'Verify OTP',
                            //       style: TextStyle(
                            //         fontSize: 16,
                            //         fontFamily: FontFamily.jostBold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Obx(() => SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.appBtnColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: controller.isLogin.value
                                          ? null
                                          : controller.verifyOtp,
                                      child: Text(
                                        controller.isLogin.value
                                            ? "Verifying..."
                                            : "Verify OTP",
                                        style: TextStyle(
                                          fontFamily: FontFamily.hanKenBold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),

                                  Obx(() => controller.isLogin.value
                                      ? const Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: AppColors.appBtnColor,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : const SizedBox()),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    );

                  }
                  if (controller.isEmployeeView.value) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: controller.adminFlipFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Welcome Back, Admin",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: FontFamily.hanKenBold,
                                  color: Color(0xff0B1C30)
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                "Sign in to access your factory \ndashboard and inventory lots.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontFamily.hanKenMedium,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            Gap(24),
                            Text(
                              'Phone Number*',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.hanKenBold,
                              ),
                            ),
                            Gap(8),
                            Obx(
                              () => CommonTextField(
                                isTitle: false,
                                controller: controller.employeeMobileNumberController,
                                borderRadius: 8,
                                textInputType: TextInputType.number,
                                maxLength: 10,
                                readOnly: controller.isOtpSentForEmployeeFlow.value,
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mobile number is required';
                                  } else if (value.length != 10) {
                                    return 'Mobile number must be 10 digits';
                                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Mobile number can contain only digits';
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '+91',
                                    style: TextStyle(
                                      color: AppColors.accentBrown,
                                      fontFamily: FontFamily.hanKenBold,
                                    ),
                                  ),
                                ),
                                hintText: 'Enter mobile number',
                              ),
                            ),
                            Gap(40),
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Obx(
                                      () => SizedBox(
                                    width: double.infinity,
                                    // width: controller.isRequestOTP.value ? double.infinity : 145,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.floatingBtnColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: controller.isRequestOTP.value
                                          ? null
                                          : controller.sendOtpForAdmin,
                                      child: Text(
                                        controller.isRequestOTP.value
                                            ? "Sign In..."
                                            : "Sign In",
                                        style: TextStyle(
                                          fontFamily: FontFamily.hanKenBold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(
                                      () => controller.isRequestOTP.value
                                      ? Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: CustomSpinLoader(size: 50, boxed: false),
                                  )
                                      : const SizedBox(),
                                ),
                              ],
                            ),

                            Center(
                              child: GestureDetector(
                                onTap: () =>
                                    controller.openOtherClientLogin(fromAdmin: true),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    "Other Client login",
                                    style: TextStyle(
                                      fontFamily: FontFamily.hanKenMedium,
                                      color: AppColors.appBtnColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: controller.openCustomerView,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    "ARE YOU AN USER ?",
                                    style: TextStyle(
                                      fontFamily: FontFamily.hanKenMedium,
                                      color: AppColors.appBtnColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.showOtherClientLogin.value) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: controller.clientCodeFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Enter Client Code',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: FontFamily.hanKenBold,
                                  color: const Color(0xff0B1C30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                "We'll verify your client to continue login.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontFamily.hanKenRegular,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                            Gap(24),
                            RichText(
                              text: TextSpan(
                                text: 'Client Code ',
                                style: TextStyle(
                                  color: AppColors.appBtnColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.hanKenRegular,
                                ),
                                children: const [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            Gap(8),
                            CommonTextField(
                              isTitle: false,
                              controller: controller.employeeCodeController,
                              borderRadius: 8,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Client code is required';
                                }
                                return null;
                              },
                              hintText: 'Enter Client Code (e.g. GI1001)',
                            ),
                            Gap(40),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.floatingBtnColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: controller.isLoading.value
                                            ? null
                                            : controller.continueWithClientCode,
                                        child: Text(
                                          controller.isLoading.value
                                              ? "Verifying..."
                                              : "Continue",
                                          style: TextStyle(
                                            fontFamily: FontFamily.hanKenBold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => controller.isLoading.value
                                        ? const Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: LinearProgressIndicator(
                                              minHeight: 3,
                                              backgroundColor:
                                                  AppColors.appBtnColor,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: controller.backToSitaramLogin,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "Back to Sitaram login",
                                    style: TextStyle(
                                      fontFamily: FontFamily.hanKenMedium,
                                      color: AppColors.appBtnColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: controller.backToUserLoginFromClientCode,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Are you User? ',
                                      style: TextStyle(
                                        fontFamily: FontFamily.hanKenRegular,
                                        color: AppColors.textColor,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Click here',
                                          style: TextStyle(
                                            fontFamily: FontFamily.hanKenBold,
                                            color: AppColors.appBtnColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.isOtpSent.value) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(35),topRight: Radius.circular(35)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Enter OTP',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: FontFamily.jostBold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.hanKenMedium,
                                      color: Colors.grey,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: "We've sent an OTP to ",
                                      ),
                                      TextSpan(
                                        text: controller.mobileNumberController.text,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ".\nOTP: ",
                                      ),
                                      TextSpan(
                                        text: controller.getOtp.value,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'OTP ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: FontFamily.jostBold,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            Gap(8),
                            Center(
                              child: _buildOtpBox(
                                controller: controller.otpController,
                                context: context,
                              ),
                            ),
                            Gap(40),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Obx(() => SizedBox(
                                        width: double.infinity,
                                        height: 52,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.floatingBtnColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: controller.isLogin.value
                                              ? null
                                              : controller.verifyOtpForEmployee,
                                          child: Text(
                                            controller.isLogin.value
                                                ? "Verifying..."
                                                : "Verify OTP",
                                            style: TextStyle(
                                              fontFamily: FontFamily.hanKenBold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Obx(() => controller.isLogin.value
                                      ? const Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: LinearProgressIndicator(
                                            minHeight: 3,
                                            backgroundColor: AppColors.accentBrown,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const SizedBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        key: controller.mobileFormKey,
                        children: [
                          Center(
                            child: Text(
                              'Enter Mobile Number',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: FontFamily.hanKenBold,
                                color: Color(0xff0B1C30)
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              "We'll send an OTP to verify your number.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontFamily.hanKenRegular,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          Obx(() {
                            final code = controller.activeClientCode.value;
                            if (code == LoginController.defaultClientCode) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Center(
                                child: Text(
                                  'Client: $code',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: FontFamily.hanKenMedium,
                                    color: AppColors.accentBrown,
                                  ),
                                ),
                              ),
                            );
                          }),
                          Gap(24),
                          RichText(
                            text: TextSpan(
                              text: 'Mobile Number ',
                              style: TextStyle(
                                color: AppColors.appBtnColor,
                                fontSize: 16,
                                fontFamily: FontFamily.hanKenRegular,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          Gap(8),
                          Obx(() => CommonTextField(
                                isTitle: false,
                                controller: controller.mobileNumberController,
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                borderRadius: 8,
                                textInputType: TextInputType.number,
                                maxLength: 10,
                                readOnly: controller.isOtpSent.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mobile number is required';
                                  } else if (value.length != 10) {
                                    return 'Mobile number must be 10 digits';
                                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Mobile number can contain only digits';
                                  }
                                  return null;
                                },
                                prefix: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '+91',
                                    style: TextStyle(
                                      color: AppColors.accentBrown,
                                      fontFamily: FontFamily.hanKenBold,
                                    ),
                                  ),
                                ),
                                hintText: 'Enter mobile number',
                              )),
                          Gap(40),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Obx(() => SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.floatingBtnColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: controller.isRequestOTP.value
                                            ? null
                                            : controller.sendOtpForEmployee,
                                        child: Text(
                                          controller.isRequestOTP.value
                                              ? "Verifying..."
                                              : "Send OTP",
                                          style: TextStyle(
                                            fontFamily: FontFamily.hanKenBold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )),
                                Obx(() => controller.isRequestOTP.value
                                    ? const Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: LinearProgressIndicator(
                                          minHeight: 3,
                                          backgroundColor: AppColors.appBtnColor,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const SizedBox()),
                              ],
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: controller.openOtherClientLogin,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  "Other Client login",
                                  style: TextStyle(
                                    fontFamily: FontFamily.hanKenMedium,
                                    color: AppColors.appBtnColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: controller.openEmployeeView,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  "ARE YOU AN ADMIN ?",
                                  style: TextStyle(
                                    fontFamily: FontFamily.hanKenMedium,
                                    color: AppColors.appBtnColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
               }

                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
   Widget _buildOtpBox({required BuildContext context,required TextEditingController controller}) {
     final defaultPinTheme = PinTheme(
       width: 50,
       height: 55,
       textStyle: TextStyle(
         fontSize: 20,
         fontFamily: FontFamily.hanKenBold,
         color: Colors.black,
       ),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(5),
         border: Border.all(color: AppColors.floatingBtnColor),
       ),
     );

     return Pinput(
       controller: controller,
       length: 6,
       keyboardType: TextInputType.number,
       defaultPinTheme: defaultPinTheme,
       focusedPinTheme: defaultPinTheme.copyWith(
         decoration: defaultPinTheme.decoration!
             .copyWith(border: Border.all(color: AppColors.floatingBtnColor, width: 2)),
       ),
       errorPinTheme: defaultPinTheme.copyWith(
         decoration: defaultPinTheme.decoration!
             .copyWith(border: Border.all(color: Colors.red)),
       ),
       validator: (value) {
         if (value == null || value.isEmpty) {
           return 'OTP required';
         } else if (value.length != 6) {
           return 'Enter 6 digits';
         }
         return null;
       },
     );
   }


}
