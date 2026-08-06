import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/AuthScreen/account_created.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class OtpScreenSingUp extends StatefulWidget {
  const OtpScreenSingUp({super.key});

  @override
  State<OtpScreenSingUp> createState() => _OtpScreenSingUpState();
}

class _OtpScreenSingUpState extends State<OtpScreenSingUp> {
  Timer? _timer;
  int duration = 60;
  SignUpController signUpController = Get.put(SignUpController());

  TextEditingController otp = TextEditingController();

  bool check = false;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      duration--;

      if (duration < 1) {
        _timer?.cancel();
      }
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 35,
                        child: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AppText(text: verification, size: 25, fontWeight: FontWeight.bold),
                        ],
                      ),
                      Row(
                        children: [
                          AppText(text: otpnote, size: 15, maxLine: 2, fontWeight: FontWeight.w200),
                        ],
                      ),
                      Row(
                        children: [
                          AppText(
                            text: signUpController.mobileController.value.text,
                            /*"+91-9907678***",*/
                            txtColor: deepBlue,
                            size: 15,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: OtpTextField(
                          numberOfFields: 4,
                          fieldWidth: 65,
                          borderRadius: BorderRadius.circular(5),
                          borderColor: Colors.white,
                          //set to true to show as box or false to show as dash
                          showFieldAsBox: true,
                          //runs when a code is typed in
                          onCodeChanged: (String code) {
                            //handle validation or checks here
                          },
                          //runs when every textfield is filled
                          onSubmit: (String verificationCode) {
                            otp.text = verificationCode;
                          }, // end onSubmit
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          const Text.rich(
                              maxLines: 3,
                              style: TextStyle(fontSize: 10),
                              TextSpan(children: [
                                TextSpan(
                                  text: didnTReceiveTheCode,
                                ),
                                TextSpan(text: resend, style: TextStyle(color: Colors.blue)),
                              ])),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                const Image(width: 12, image: AssetImage(clock)),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppText(
                                  text: duration.toString(),
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
                /* InkWell(
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountCreated())),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 280),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(nextImg)),
                      ),
                    ),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 280),
                  child: AppBtnWithColorShades(
                    onTap: () {
                      if (otp.text == "1234") {
                        print(otp.text);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountCreated()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: AppText(
                          text: "Invalid Otp",
                          txtColor: primaryWhite,
                          size: 12,
                        )));
                      }
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
