import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:soperia_user/Screens/AuthScreen/AuthController/auth_controller.dart';
import 'package:soperia_user/Screens/AuthScreen/otp_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_imgs.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custome.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  AuthController authController = Get.put(AuthController());
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
          () {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 35,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(splashImg)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppText(
                          text: sis,
                          txtColor: Colors.blue.shade700,
                          size: 25,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [AppText(text: resetPassword, size: 25, fontWeight: FontWeight.bold)],
                        ),
                        Row(
                          children: [
                            AppText(text: enterMobileNumberToResetPassword, size: 15, maxLine: 2, fontWeight: FontWeight.w200),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        IntlPhoneField(
                          controller: authController.mobileNoController.value,
                          decoration: InputDecoration(
                            hintText: entermobileno,
                            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                          ),
                          initialCountryCode: 'JO',
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: AppBtnWithColorShades(
                      isLoad: false,
                      onTap: () {
                        if (_isNavigating) return;
                        if (authController.mobileNoController.value.text.isEmpty) {
                          showToast(pleaseEnterMobileNo, context);
                        } else {
                          _isNavigating = true;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(isFromSignup: false, mobileNo: authController.mobileNoController.value.text))).then((_) {
                            _isNavigating = false;
                          });
                        }
                      },
                      btnTxt: continuE,
                      color1: darkBlue2,
                      color2: darkBlue1,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
