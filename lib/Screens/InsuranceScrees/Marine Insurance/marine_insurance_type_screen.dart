import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

class MarineInsuranceTypeScreen extends StatefulWidget {
  Function onNext;

  MarineInsuranceTypeScreen({super.key, required this.onNext});

  @override
  State<MarineInsuranceTypeScreen> createState() => _MarineInsuranceTypeScreenState();
}

class _MarineInsuranceTypeScreenState extends State<MarineInsuranceTypeScreen> {
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    marineInsuranceController.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return marineInsuranceController.isLoading.value
          ? const Padding(padding: EdgeInsets.only(top: 140), child: Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        marineInsuranceController.individual.value = true;
                        setState(() {});
                      }, // Call _changeColor function when container is tapped
                      child: Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: marineInsuranceController.individual.value ? skyBlue : primaryBlack,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: AppText(
                          text: individual,
                          txtColor: marineInsuranceController.individual.value ? skyBlue : primaryBlack,
                          fontWeight: FontWeight.bold,
                          size: 15,
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        marineInsuranceController.individual.value = false;
                        setState(() {});
                      }, // Call _changeColor function when container is tapped
                      child: Container(
                        width: 120,
                        height: 60,
                        decoration: BoxDecoration(border: Border.all(color: marineInsuranceController.individual.value ? primaryBlack : skyBlue), borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: AppText(
                          text: company,
                          fontWeight: FontWeight.bold,
                          txtColor: marineInsuranceController.individual.value ? primaryBlack : skyBlue,
                          size: 15,
                        )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                  child: AppBtnWithColorShades(
                    onTap: () {
                      widget.onNext();
                    },
                    btnTxt: next,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ),
              ],
            );
    });
  }
}
