import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/Profile/Complaint/complaint_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_insurance_company_model.dart';
import 'package:soperia_user/model_class/get_insurance_type_model.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  ComplaintController complaintController = Get.put(ComplaintController());

  @override
  void initState() {
    complaintController.apiMethod(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(text: addComplaint, size: 18, fontWeight: FontWeight.bold)),
      body: Obx(() {
        return complaintController.isLoadingGetApi.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 16),
                  child: Column(
                    children: [
                      CustomDropDownBorder1(
                        onchage: (newValue) async {
                          InsuranceTypes cdl = complaintController.insuranceTypeList.firstWhere((element) => element.id == newValue);
                          complaintController.selectedInsuranceType.value = cdl;
                          await complaintController.getInsuranceCompanyApi(context, complaintController.selectedInsuranceType.value.id ?? 0);
                          setState(() {});
                        },
                        items: complaintController.insuranceTypeList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: complaintController.insuranceTypeList.any((element) => element.id == complaintController.selectedInsuranceType.value.id) ? complaintController.selectedInsuranceType.value.id ?? 0 : null,
                        dropdownTitle: insuranceTypeName,
                      ),
              
              
                      complaintController.isLoadingInsuranceCompany.value
                          ? const Center(child: CircularProgressIndicator())
                          : CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  InsuranceCompany cdl = complaintController.insuranceCompanyList.firstWhere((element) => element.id == newValue);
                                  complaintController.selectedInsuranceCompany.value = cdl;
                                });
                              },
                              items: complaintController.insuranceCompanyList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.companyName ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                              selectedValue: complaintController.insuranceCompanyList.any((element) => element.id == complaintController.selectedInsuranceCompany.value.id) ? complaintController.selectedInsuranceCompany.value.id ?? 0 : null,
                              dropdownTitle: insuranceCompanyName,
                            ),
                      const SizedBox(height: 10),
                      AppTextfield(
                        enabledBorderColor: skyBlueShade2,
                        maxLine: 12,
                        hint: '',
                        lable: pleaseWriteYourComplaint,
                        controller: complaintController.complaintNoteController.value,
                      ),
                      const SizedBox(height: 30),
                      AppBtnWithColorShades(
                        isLoad: complaintController.isLoadingPostComplaint.value,
                        onTap: () {
                          if (complaintController.selectedInsuranceType.value.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceType, txtColor: primaryWhite, size: 12)));
                          } else if (complaintController.selectedInsuranceCompany.value.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceCompany, txtColor: primaryWhite, size: 12)));
                          } else if (complaintController.complaintNoteController.value.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterComplaintNote, txtColor: primaryWhite, size: 12)));
                          } else {
                            complaintController.addComplaintApi(context);
                          }
                        },
                        btnTxt: send,
                        color1: darkBlue2,
                        color2: darkBlue1,
                      ),
                    ],
                  ),
                ),
            );
      }),
    );
  }
}
