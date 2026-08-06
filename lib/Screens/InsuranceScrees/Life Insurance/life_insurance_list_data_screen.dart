import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class LifeInsuranceListDataScreen extends StatefulWidget {
  LifeInsuranceListDataScreen({super.key});

  @override
  State<LifeInsuranceListDataScreen> createState() => _LifeInsuranceListDataScreenState();
}

class _LifeInsuranceListDataScreenState extends State<LifeInsuranceListDataScreen> {
  LifeInsuranceController lifeInsuranceController = Get.put(LifeInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    lifeInsuranceController.getLifeInsurancePlanApi(context, lifeInsuranceController.selectedInsuranceLimit.value.limit.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: lifeinsurance, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return lifeInsuranceController.isLoadingGetLifeInsurance.value
              ? const Center(child: CircularProgressIndicator())
              : lifeInsuranceController.homeInsurancePlaneModel.value.data != null && lifeInsuranceController.homeInsurancePlaneModel.value.data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: lifeInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            // homeInsuranceController.insuranceLimit=criticalIllnessInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString()??'';
                            lifeInsuranceController.planId.value = lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].id ?? 0;

                            List<int?> selectedIds = lifeInsuranceController
                                .selectedChronicDiseasesList
                                .map((e) => e.id)
                                .toList();
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InsuranceDraftPdfScreen(
                                          screenTitle: lifeinsurance,
                                          pdfPath: lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                          insurancePolicyText: lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                          data: {
                                            'first_name': lifeInsuranceController.policyHolderFirstNameController.value.text ?? '',
                                            'last_name': lifeInsuranceController.policyHolderSecondNameController.value.text ?? '',
                                            'third_name': lifeInsuranceController.policyHolderThirdNameController.value.text ?? '',
                                            'family_name': lifeInsuranceController.policyHolderFamilyNameController.value.text ?? '',
                                            'nationality': lifeInsuranceController.nationalityController.value.text ?? '',
                                            'nationality_no': lifeInsuranceController.nationPassportNoController.value.text ?? '',
                                            'id_residence_no': lifeInsuranceController.idOrResidenceNoController.value.text ?? '',
                                            'birth_date': commonApiDateFormat(lifeInsuranceController.birthDateController.value.text),
                                            'gender': lifeInsuranceController.selectedgender,
                                            'beneficiary_first_name': lifeInsuranceController.beneficiaryFirstNameController.value.text ?? '',
                                            'beneficiary_last_name': lifeInsuranceController.beneficiarySecondNameController.value.text ?? '',
                                            'beneficiary_third_name': lifeInsuranceController.beneficiaryThirdNameController.value.text ?? '',
                                            'marital_status': lifeInsuranceController.selectedMaritalStatus,
                                            'place_residence': lifeInsuranceController.selectPlaceResidence.value.name,
                                            'occupancy_work': lifeInsuranceController.selectOccupation.value.name ?? '',
                                            'american_notionality_status': lifeInsuranceController.selectAmericanNationality == 'Yes' ? 2 : 1,
                                            'country_id': lifeInsuranceController.selectCountry.value.id ?? '',
                                            'city_id': lifeInsuranceController.selectCity.value.id ?? '',
                                            'district_id': lifeInsuranceController.selectDistrict.value.id ?? '',
                                            'street_name': lifeInsuranceController.streetNameController.value.text ?? '',
                                            'building_no': lifeInsuranceController.buildingNoController.value.text ?? '',
                                            'employee_status': lifeInsuranceController.selectedOption1 == 'Yes' ? 2 : 1,
                                            'company_name': lifeInsuranceController.companyNameController.value.text ?? '',
                                            'position': lifeInsuranceController.positionController.value.text,
                                            'work_nature': lifeInsuranceController.workNatureController.value.text ?? '',
                                            'employee_city_id': lifeInsuranceController.selectCompanyCity.value.id ?? '',
                                            'employee_district_id': lifeInsuranceController.selectCompanyDistrict.value.id ?? '',
                                            'employee_street_name': lifeInsuranceController.companyStreetNameController.value.text ?? '',
                                            'employee_building_no': lifeInsuranceController.companyBuildingNoController.value.text ?? '',
                                            'company_contact': lifeInsuranceController.companyContactNoController.value.text ?? '',
                                            'height': lifeInsuranceController.heightController.value.text ?? '',
                                            'wight': lifeInsuranceController.weightController.value.text ?? '',
                                            'chronic_diseases_id': lifeInsuranceController.selectedChronicDisease == yesTxt?selectedIds:[],
                                            'previous_operation': lifeInsuranceController.selectedAnyOperation == "Yes" ? 2 : 1,
                                            'operation_details': lifeInsuranceController.previousOperationDetailsController.value.text,
                                            'company_declined_policy': lifeInsuranceController.selectedDescline == "Yes" ? 2 : 1,
                                            'declined_policy_details': lifeInsuranceController.companyDeclinedIssueController.value.text,
                                            'exiting_life_insur': lifeInsuranceController.selectedNowAnyPolicy == "Yes" ? 2 : 1,
                                            'exiting_life_insur_details': lifeInsuranceController.existingLifeInsuranceController.value.text,
                                            'insurance_amount': lifeInsuranceController.selectedInsuranceLimit.value.limit.toString(),
                                            'effective_date': commonApiDateFormat(lifeInsuranceController.effectiveDateController.value.text),
                                            'plan_id': lifeInsuranceController.planId.value,
                                            'insurance_period': lifeInsuranceController.selectInsurancePeriod.value?.id??'',
                                            'photo_documents': lifeInsuranceController.photoDoc,
                                            'family_book_documents': lifeInsuranceController.familyBookDoc,
                                            'insured_documents': lifeInsuranceController.insuredDoc,
                                            'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                          },
                                          apiUrl: addLifeInsurance, insuranceType: lifeInsuranceTxt,
                                        )));
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
                                    text: lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quote is:  ${lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''} Term Plan", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                 // AppText(text: "Starting from ₹${lifeInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.bold),
                    );
        }));
  }
}
