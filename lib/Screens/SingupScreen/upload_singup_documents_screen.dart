import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/SingupScreen/create_password.dart';
import 'package:soperia_user/Screens/SingupScreen/sign_up_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custome.dart';
import 'package:soperia_user/app_utils/file_upload_gallary.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';

import 'package:soperia_user/language/language_constants.dart';

import '../../app_utils/Common Widgets/webview_title_url.dart';

class UploadSingUpDocumentsScreen extends StatefulWidget {
  const UploadSingUpDocumentsScreen({super.key});

  @override
  State<UploadSingUpDocumentsScreen> createState() => _UploadSingUpDocumentsScreenState();
}

class _UploadSingUpDocumentsScreenState extends State<UploadSingUpDocumentsScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            height: 40,
                            width: 35,
                            child: Icon(Icons.arrow_back, size: 25),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(text: personaldetails, size: 25),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(alignment: Alignment.topLeft, child: AppText(text: documents, size: 16)),
                        InkWell(
                            onTap: () async {
                              signUpController.residenceCardFont = (await selectImageFromGallery(context)) ?? signUpController.residenceCardFont;
                              setState(() {});
                            },
                            child: ImageUploadWidget(image: signUpController.residenceCardFont, txt: addIdResidenceCardFrontSide, borderColor: skyBlueShade2)),
                        InkWell(
                            onTap: () async {
                              signUpController.residenceCardBack = (await selectImageFromGallery(context)) ?? signUpController.residenceCardBack;
                              setState(() {});
                            },
                            child: ImageUploadWidget(image: signUpController.residenceCardBack, txt: addIdResidenceCardBackSide, borderColor: skyBlueShade2)),
                        InkWell(
                            onTap: () async {
                              signUpController.personalPicDoc = (await selectImageFromGallery(context)) ?? signUpController.personalPicDoc;
                              setState(() {});
                            },
                            child: ImageUploadWidget(image: signUpController.personalPicDoc, txt: addPersonalPicture, borderColor: skyBlueShade2)),
                        AppTextfield(hint: pleaseFillInNumber, lable: pleaseFillIn, keyboardType: TextInputType.number, controller: signUpController.agentNoController.value),
                        Padding(
                          padding:  EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: signUpController.check2,
                                onChanged: (value) {
                                  setState(() {
                                    signUpController.check2 = value ?? true;
                                  });
                                },
                              ),
                               Expanded(
                                  child: Text.rich(
                                      maxLines: 3,
                                      style: const TextStyle(fontSize: 10, fontFamily: "Montserrat_Regular"),
                                      TextSpan(children: [
                                        TextSpan(
                                          text: getTranslated(context, bySigningUpAgreeTo),
                                        ),
                                      TextSpan(text: getTranslated(context, termsConditions),
                                          recognizer:

                                          TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrivacyPolicyScreen(
                                                id: 5,
                                                url: 'https://www.sisirbc.com/terms-conditions.php', title: getTranslated(context, termsConditions),
                                              ),
                                            ),
                                          );
                                        },

                                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                        TextSpan(text: " ${getTranslated(context, and)} "),
                                      TextSpan(text: getTranslated(context, privacyPolicyTxt),

                                          recognizer:

                                          TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrivacyPolicyScreen(
                                                id: 6,
                                                url: 'https://www.sisirbc.com/privacy-policy.php', title: getTranslated(context, privacyPolicyTxt),
                                              ),
                                            ),
                                          );
                                        },
                                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                      ])),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        AppBtnWithColorShades(
                          onTap: () {
                            if (signUpController.residenceCardFont.path.isEmpty) {
                              showToast(pleaseUploadResidenceCardFrontSidePassportDocuments, context);
                            } else if (signUpController.residenceCardBack.path.isEmpty) {
                              showToast(pleaseUploadResidenceCardBackSidePassportDocuments, context);
                            } else if (signUpController.personalPicDoc.path.isEmpty) {
                              showToast(pleaseUploadPersonalPicture, context);
                            } else if (signUpController.check2 == false) {
                              showToast(pleaseAcceptTermsConditions, context);
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePassword()));
                            }
                          },
                          btnTxt: saveNext,
                          color1: darkBlue2,
                          color2: darkBlue1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
