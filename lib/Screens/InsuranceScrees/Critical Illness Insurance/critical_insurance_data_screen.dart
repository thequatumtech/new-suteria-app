import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_illness_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class CriticalInsuranceDataScreen extends StatefulWidget {
  CriticalInsuranceDataScreen({super.key});

  @override
  State<CriticalInsuranceDataScreen> createState() => _CriticalInsuranceDataScreenState();
}

class _CriticalInsuranceDataScreenState extends State<CriticalInsuranceDataScreen> {
  CriticalIllnessInsuranceController criticalIllnessInsuranceController = Get.put(CriticalIllnessInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    criticalIllnessInsuranceController.getCriticalIllnessInsurancePlanApi(context, criticalIllnessInsuranceController.selectedInsurancePlan.value.planName.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(
            text: criticalIllnessInsurance,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Obx(() {
          return criticalIllnessInsuranceController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data != null && criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            // homeInsuranceController.insuranceLimit=criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString()??'';
                            criticalIllnessInsuranceController.planId.value = criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].id ?? 0;
                            List<int?> selectedIds = criticalIllnessInsuranceController
                                .selectedChronicDiseasesList
                                .map((e) => e.id)
                                .toList();
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: criticalIllnessInsurance,
                                    pdfPath: criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'first_name': criticalIllnessInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': criticalIllnessInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': criticalIllnessInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': criticalIllnessInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': criticalIllnessInsuranceController.selectNationality.value.name,
                                      'nationality_no': criticalIllnessInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': criticalIllnessInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(criticalIllnessInsuranceController.birthDateController.value.text),
                                      'gender': criticalIllnessInsuranceController.selectedgender ?? '',
                                      'beneficiary_first_name': criticalIllnessInsuranceController.beneficiaryFirstNameController.value.text,
                                      'beneficiary_last_name': criticalIllnessInsuranceController.beneficiarySecondNameController.value.text,
                                      'beneficiary_third_name': criticalIllnessInsuranceController.beneficiaryThirdNameController.value.text,
                                      'marital_status': criticalIllnessInsuranceController.selectedMaritalStatus ?? '',
                                      'place_residence': criticalIllnessInsuranceController.selectPlaceResidence.value.name ?? '',
                                      'occupancy_work': criticalIllnessInsuranceController.selectOccupation.value.name,
                                      'city_id': criticalIllnessInsuranceController.selectCity.value.id,
                                      'district_id': criticalIllnessInsuranceController.selectDistrict.value.id,
                                      'street_name': criticalIllnessInsuranceController.streetNameController.value.text,
                                      'building_no': criticalIllnessInsuranceController.buildingNoController.value.text,
                                      'company_name': criticalIllnessInsuranceController.companyNameController.value.text,
                                      'position': criticalIllnessInsuranceController.positionController.value.text,
                                      'work_nature': criticalIllnessInsuranceController.workNatureController.value.text,
                                      'company_city_id': criticalIllnessInsuranceController.selectCompanyCity.value.id ?? 0,
                                      'company_district_id': criticalIllnessInsuranceController.selectCompanyDistrict.value.id ?? 0,
                                      'company_street_name': criticalIllnessInsuranceController.companyStreetNameController.value.text,
                                      'company_building_no': criticalIllnessInsuranceController.companyBuildingNoController.value.text,
                                      'company_contact': criticalIllnessInsuranceController.companyContactNoController.value.text,
                                      'height': criticalIllnessInsuranceController.heightController.value.text,
                                      'wight': criticalIllnessInsuranceController.weightController.value.text,
                                      'chronic_diseases_id': selectedIds,
                                      'previous_operation': criticalIllnessInsuranceController.selectedOption == 'Yes' ? 2 : 1,
                                      'operation_details': criticalIllnessInsuranceController.operationDetailsController.value.text,
                                      'previous_insurance_policy': criticalIllnessInsuranceController.selectedOption1 == 'Yes' ? 2 : 1,
                                      'previous_insurance_policy_details': criticalIllnessInsuranceController.previousInsurancePolicyDetailsController.value.text,
                                      'insurance_amount': criticalIllnessInsuranceController.selectedInsuranceLimit.value.limit.toString() ?? '',
                                      'insurance_plan': criticalIllnessInsuranceController.selectedInsurancePlan.value.planName ?? '',
                                      'inception_date': commonApiDateFormat(criticalIllnessInsuranceController.inceptionDateController.value.text),
                                      'expiry_date': commonApiDateFormat(criticalIllnessInsuranceController.expireDateController.value.text),
                                      'plan_id': criticalIllnessInsuranceController.planId.value,
                                      'payment_status': 1,
                                      'passport_id_documents': criticalIllnessInsuranceController.passportIdDocuments,
                                      'insured_documents': criticalIllnessInsuranceController.insuredDocuments,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                    },
                                    apiUrl: addCriticalIllnessInsurance, insuranceType: criticalIllnessInsuranceTxt,
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: gold),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quote is: ${criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].grossPremium ?? ''} JOD", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  // AppText(text: "Starting from ₹${criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: AppText(text: noInsurancePlanFound, size: 20, fontWeight: FontWeight.bold));
        }));
  }
}
