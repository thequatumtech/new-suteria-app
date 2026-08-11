import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:soperia_user/Screens/AuthScreen/AuthController/auth_controller.dart';
import 'package:soperia_user/Screens/AuthScreen/update_password_screen.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class OtpScreen extends StatefulWidget {
  final bool isFromSignup;
  final String mobileNo;

  const OtpScreen({super.key, required this.isFromSignup, required this.mobileNo});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  AuthController authController = Get.put(AuthController());
  SignUpController signUpController = Get.put(SignUpController());
  Timer? _timer;
  int duration = 30;
  String otp = "";
  List<TextEditingController?> otpControllers = [];

  @override
  void initState() {
    listenForCode();
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        authController.mobileNoController.value.text = widget.mobileNo;
        bool success = await authController.forgotOtpSendPostApi(context: context, isResend: false, isFromSignup: widget.isFromSignup);
        if (success) {
          startTimer();
        }
      }
    });
    super.initState();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.isNotEmpty) {
      otp = code!;
      for (int i = 0; i < otpControllers.length && i < otp.length; i++) {
        otpControllers[i]?.text = otp[i];
      }
      if (mounted) {
        setState(() {});
      }
      submitOTP();
    }
  }

  void startTimer() {
    _timer?.cancel();
    duration = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        duration--;
        if (mounted) {
          setState(() {});
        }
      } else {
        _timer?.cancel();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  Future<void> resendOtp() async {
    if (duration <= 0 && !authController.isLoadingSendOtp.value) {
      listenForCode();
      for (var controller in otpControllers) {
        controller?.clear();
      }
      otp = "";
      bool success = await authController.forgotOtpSendPostApi(
        context: context,
        isResend: true,
        isFromSignup: widget.isFromSignup,
      );
      if (success) {
        startTimer();
      }
    }
  }

  @override
  void dispose() {
    cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(children: [AppText(text: verification, size: 25, fontWeight: FontWeight.bold)]),
                          Row(children: [AppText(text: otpnote, size: 15, maxLine: 2, fontWeight: FontWeight.w200)]),
                          Row(
                            children: [
                              AppText(
                                text: authController.mobileNoController.value.text.length > 3
                                    ? "${authController.mobileNoController.value.text.substring(0, authController.mobileNoController.value.text.length - 3)}***"
                                    : authController.mobileNoController.value.text,
                                txtColor: deepBlue,
                                size: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              if (!widget.isFromSignup)
                                InkWell(
                                  onTap: () {
                                    _timer?.cancel();
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2, left: 5),
                                        child: Container(
                                          height: 15,
                                          width: 20,
                                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(editPng))),
                                        ),
                                      ),
                                      AppText(
                                        text: editt,
                                        txtColor: gold,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: OtpTextField(
                              numberOfFields: 4,
                              fieldWidth: 65,
                              borderRadius: BorderRadius.circular(5),
                              borderColor: Colors.white,
                              showFieldAsBox: true,
                              handleControllers: (controllers) {
                                otpControllers = controllers;
                              },
                              onCodeChanged: (String code) {
                                otp = code;
                              },
                              onSubmit: (String val) {
                                otp = val;
                                submitOTP();
                              }, // end onSubmit
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: (duration <= 0 && !authController.isLoadingSendOtp.value)
                                    ? () => resendOtp()
                                    : null,
                                child: Text.rich(
                                    maxLines: 3,
                                    style: const TextStyle(fontSize: 12),
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: didnTReceiveTheCode,
                                      ),
                                      TextSpan(
                                        text: resend,
                                        style: TextStyle(
                                          color: duration <= 0 ? Colors.blue : Colors.grey,
                                          fontWeight: duration <= 0 ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ])),
                              ),
                              const Spacer(),
                              if (duration > 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      const Image(width: 12, image: AssetImage(clock)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      AppText(
                                        text: "$duration",
                                        size: 10,
                                        txtColor: deepBlue,
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 50),
                      child: AppBtnWithColorShades(
                        isLoad: signUpController.buttonLoading.value,
                        onTap: () {
                          submitOTP();
                        },
                        btnTxt: next,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ),
                  ],
                ),
              ),
              if (authController.isLoadingSendOtp.value)
                InkWell(onTap: () {}, child: Container(color: Colors.black54, width: double.infinity, height: double.infinity, child: const Center(child: CircularProgressIndicator())))
            ],
          );
        }),
      ),
    );
  }

  submitOTP() {
    if (otp.length == 4) {
      if ((authController.forgotOtpSendModel.value.data?.otp ?? "").isNotEmpty) {
        if (authController.forgotOtpSendModel.value.data!.otp == otp) {
          if (widget.isFromSignup) {
            signUpController.postSignUp(context);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: otpIsWrongPleaseEnterValidOtp, txtColor: primaryWhite, size: 12)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: "Something went wrong please try again", txtColor: primaryWhite, size: 12)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterOTP, txtColor: primaryWhite, size: 12)));
    }
  }
}

