import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_inurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class TraveInsuranceTypeScreen extends StatefulWidget {
  Function onNext;

  TraveInsuranceTypeScreen({super.key, required this.onNext});

  @override
  State<TraveInsuranceTypeScreen> createState() => _TraveInsuranceTypeScreenState();
}

class _TraveInsuranceTypeScreenState extends State<TraveInsuranceTypeScreen> {
  TravelInsuranceController travelInsuranceController = Get.put(TravelInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return travelInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          travelInsuranceController.isSelfType.value = true;
                          setState(() {});
                        },
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: travelInsuranceController.isSelfType.value ? skyBlue : primaryBlack,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: AppText(
                            text: self,
                            txtColor: travelInsuranceController.isSelfType.value ? skyBlue : primaryBlack,
                            fontWeight: FontWeight.bold,
                            size: 15,
                          )),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          travelInsuranceController.isSelfType.value = false;
                          setState(() {});
                        },
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(border: Border.all(color: travelInsuranceController.isSelfType.value ? primaryBlack : skyBlue), borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: AppText(
                            text: family,
                            fontWeight: FontWeight.bold,
                            txtColor: travelInsuranceController.isSelfType.value ? primaryBlack : skyBlue,
                            size: 15,
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  AppBtnWithColorShades(
                    onTap: () {
                      widget.onNext();
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ],
              ),
            );
    });
  }
}
