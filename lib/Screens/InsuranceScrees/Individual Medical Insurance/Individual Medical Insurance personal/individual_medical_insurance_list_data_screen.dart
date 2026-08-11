import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class IndividualMedicalInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  IndividualMedicalInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<IndividualMedicalInsuranceListDataScreen> createState() => _IndividualMedicalInsuranceListDataScreenState();
}

class _IndividualMedicalInsuranceListDataScreenState extends State<IndividualMedicalInsuranceListDataScreen> {
  IndividualMedicalInsuranceController individualMedicalInsuranceController = Get.put(IndividualMedicalInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    individualMedicalInsuranceController.getIndividualInsuranceApi(
        context, individualMedicalInsuranceController.insurancetypes ?? '', individualMedicalInsuranceController.selectedInsuranceLimit.value.limit!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return individualMedicalInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : individualMedicalInsuranceController.homeInsurancePlaneModel.value.data == null || individualMedicalInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty
                  ? Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            individualMedicalInsuranceController.insuranceLimit = individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            individualMedicalInsuranceController.planDd = individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});

                            List<int?> selectedIds = individualMedicalInsuranceController.selectedChronicDiseasesList.map((e) => e.id).toList();

                            List<int?> selectedIdsDanger = individualMedicalInsuranceController.selectDangerousActivitiesList.map((e) => e.id).toList();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'first_name': individualMedicalInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': individualMedicalInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': individualMedicalInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': individualMedicalInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': individualMedicalInsuranceController.selectNationality.value.name ?? '',
                                      'nationality_no': individualMedicalInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': individualMedicalInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(individualMedicalInsuranceController.birthDateController.value.text),
                                      'gender': individualMedicalInsuranceController.selectedGender ?? '',
                                      'marital_status': individualMedicalInsuranceController.selectedMaritalStatus ?? '',
                                      'occupancy_work': individualMedicalInsuranceController.selectOccupation.value.name ?? '',
                                      'city_id': individualMedicalInsuranceController.selectCity.value.id ?? 0,
                                      'district_id': individualMedicalInsuranceController.selectDistrict.value.id ?? 0,
                                      'street_name': individualMedicalInsuranceController.streetNameController.value.text,
                                      'building_no': individualMedicalInsuranceController.buildingNoController.value.text,
                                      'company_name': individualMedicalInsuranceController.companyNameController.value.text,
                                      'position': individualMedicalInsuranceController.positionController.value.text,
                                      'work_nature': individualMedicalInsuranceController.workNatureController.value.text,
                                      'company_city_id': individualMedicalInsuranceController.selectCompanyCity.value.id ?? 0,
                                      'company_district_id': individualMedicalInsuranceController.selectCompanyDistrict.value.id ?? 0,
                                      'company_street_name': individualMedicalInsuranceController.companyStreetNameController.value.text,
                                      'company_building_no': individualMedicalInsuranceController.companyBuildingNoController.value.text,
                                      'company_company_contact': individualMedicalInsuranceController.companyContactNoController.value.text,
                                      'existing_policy_status': individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? 1 : 2,
                                      'existing_policy_company_name': individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes"
                                          ? individualMedicalInsuranceController.insuranceCompanyNameController.value.text
                                          : '',
                                      'existing_policy_expiry_date': individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes"
                                          ? commonApiDateFormat(individualMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text)
                                          : '',
                                      'existing_policy_card':
                                          individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? individualMedicalInsuranceController.selectedMedicalCard : '',
                                      'height': individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "No"
                                          ? individualMedicalInsuranceController.heightController.value.text
                                          : '',
                                      'wight': individualMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "No"
                                          ? individualMedicalInsuranceController.weightController.value.text
                                          : '',
                                      'chronic_diseases_id': individualMedicalInsuranceController.selectedChronicDisease == yesTxt ? selectedIds : [],
                                      'previous_operation': individualMedicalInsuranceController.selectedPreviousOperationsOption == "Yes" ? 1 : 2,
                                      'operation_details': individualMedicalInsuranceController.selectedPreviousOperationsOption == "Yes"
                                          ? individualMedicalInsuranceController.detailsAboutPreviousOperationsController.value.text
                                          : '',
                                      'pregnant_status': individualMedicalInsuranceController.selectedPregnantOption == "Yes" ? 1 : 2,
                                      'pregnant_month': individualMedicalInsuranceController.selectedPregnantOption == "Yes" ? individualMedicalInsuranceController.selectmonth : '',
                                      'dangerous_status': individualMedicalInsuranceController.selectDangerousActivity == "Yes" ? 1 : 2,
                                      'dangerous_id': individualMedicalInsuranceController.selectDangerousActivity == "Yes" ? selectedIdsDanger : [],
                                      'passport_front_id': individualMedicalInsuranceController.selectDangerousActivity == "No" ? individualMedicalInsuranceController.selectedIdFrontSide : '',
                                      'passport_back_id': individualMedicalInsuranceController.selectDangerousActivity == "No" ? individualMedicalInsuranceController.selectedIdBackSide : '',
                                      'family_book_documents': individualMedicalInsuranceController.selectDangerousActivity == "No" ? individualMedicalInsuranceController.selectedFamilyBook : '',
                                      'personal_picture_documents':
                                          individualMedicalInsuranceController.selectDangerousActivity == "No" ? individualMedicalInsuranceController.selectedPersonalPic : '',
                                      'other_documents': individualMedicalInsuranceController.selectDangerousActivity == "No" ? individualMedicalInsuranceController.selectedOtherMembers : '',
                                      'inception_date': commonApiDateFormat(individualMedicalInsuranceController.inceptionDateController.value.text),
                                      'expiry_date': commonApiDateFormat(individualMedicalInsuranceController.expiryDateController.value.text),
                                      'insurance_type': individualMedicalInsuranceController.insurancetypes == 'In Patient Only' ? 1 : 2,
                                      'insurance_class': individualMedicalInsuranceController.selectclass ?? "",
                                      'inpatient_deductible_id': individualMedicalInsuranceController.selectInPatient.value.id ?? '',
                                      'outpatient_deductible_id': individualMedicalInsuranceController.selectOutPatient.value.id ?? '',
                                      'no_of_visits_id': individualMedicalInsuranceController.selectNoOfVisits.value.id ?? '',
                                      'insurance_limit': individualMedicalInsuranceController.selectedInsuranceLimit.value.limit ?? 0,
                                      'plan_id': individualMedicalInsuranceController.planDd ?? 0,
                                      'american_notionality_status': individualMedicalInsuranceController.selectAmericanNationality == 'Yes' ? 2 : 1,
                                      'insurance_type_status': 1,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                    },
                                    apiUrl: addIndividualMedicalInsurance,
                                    insuranceType: medicalInsuranceTxt,
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
                                    text: individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(
                                      text: individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  (individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit ?? "").isNotEmpty
                                      ? AppText(
                                          text: "The Quote is: ${individualMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}",
                                          txtColor: deepBlue,
                                          fontWeight: FontWeight.bold,
                                          size: 15)
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        }));
  }
}
