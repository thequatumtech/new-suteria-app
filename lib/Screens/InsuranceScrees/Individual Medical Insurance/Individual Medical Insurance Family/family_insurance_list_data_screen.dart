import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/family_medical_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_chronic_disease_model.dart';

class FamilyMedicalInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  FamilyMedicalInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<FamilyMedicalInsuranceListDataScreen> createState() => _FamilyMedicalInsuranceListDataScreenState();
}

class _FamilyMedicalInsuranceListDataScreenState extends State<FamilyMedicalInsuranceListDataScreen> {
  FamilyMedicalInsuranceController familyMedicalInsuranceController = Get.put(FamilyMedicalInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    familyMedicalInsuranceController.getIndividualInsuranceApi(context, familyMedicalInsuranceController.insurancetypes ?? '', familyMedicalInsuranceController.selectedInsuranceLimit.value.limit!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return familyMedicalInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : familyMedicalInsuranceController.homeInsurancePlaneModel.value.data == null || familyMedicalInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty
                  ? Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            familyMedicalInsuranceController.insuranceLimit = familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            familyMedicalInsuranceController.planDd = familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';

                            List<Map<String, dynamic>> members = [
                              for (int i = 0; i < familyMedicalInsuranceController.memberFirstNameController.length; i++)
                                {
                                  "first_name": familyMedicalInsuranceController.memberFirstNameController[i].text,
                                  "last_name": familyMedicalInsuranceController.memberSecondNameController[i].text,
                                  "third_name": familyMedicalInsuranceController.memberThirdNameController[i].text,
                                  "family_name": familyMedicalInsuranceController.memberFamilyNameController[i].text,
                                  "relation": familyMedicalInsuranceController.selectedMemberRelation[i],
                                  "nationality": familyMedicalInsuranceController.selectNationalityMember[i],
                                  "nationality_no": familyMedicalInsuranceController.memberNationPassportNoController[i].text,
                                  "id_residence_no": familyMedicalInsuranceController.memberIdOrResidenceNoController[i].text,
                                  "birth_date": commonApiDateFormat(familyMedicalInsuranceController.memberBirthDateController[i].text),
                                  "gender": familyMedicalInsuranceController.selectMemberGender[i],
                                  "marital_status": familyMedicalInsuranceController.memberSelectedMaritalStatus[i],
                                  "occupancy_work": familyMedicalInsuranceController.selectOccupationMember[i],
                                  "height": familyMedicalInsuranceController.memberHeightController[i].text,
                                  "wight": familyMedicalInsuranceController.memberWeightController[i].text,
                                  "chronic_diseases_id": chronicIdList(familyMedicalInsuranceController.selectMemberChronicDiseases[i]),
                                  "previous_operation": familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[i] == "Yes" ? 1 : 2,
                                  "operation_details": familyMedicalInsuranceController.memberSelectedPreviousOperationsOption[i] == "Yes" ? familyMedicalInsuranceController.memberPreviousOperationDetailsController[i].text : '',
                                  "pregnant_status": familyMedicalInsuranceController.memberSelectedPregnantOption[i] == "Yes" ? 1 : 2,
                                  "pregnant_month": familyMedicalInsuranceController.memberSelectedPregnantOption[i] == "Yes" ? familyMedicalInsuranceController.memberSelectMonth[i] : '',
                                  "dangerous_status": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "Yes" ? 1 : 2,
                                  "dangerous_id": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "Yes" ? familyMedicalInsuranceController.selectMemberDangerousActivity[i].id : 0,
                                  "passport_front_id": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "No" ? familyMedicalInsuranceController.selectedIdFrontSideMember : '',
                                  "passport_back_id": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "No" ? familyMedicalInsuranceController.selectedIdBackSideMember : '',
                                  "family_book_documents": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "No" ? familyMedicalInsuranceController.selectedOtherDocumentsMember : '',
                                  "personal_picture_documents": familyMedicalInsuranceController.memberSelectedDangerousActivity[i] == "No" ? familyMedicalInsuranceController.selectedPersonalPicMember : '',
                                },
                            ];
                            List<int?> selectedIds = familyMedicalInsuranceController
                                .selectedChronicDiseasesList
                                .map((e) => e.id)
                                .toList();

                            List<int?> selectedIdsDange = familyMedicalInsuranceController
                                .selectDangerousActivitiesList
                                .map((e) => e.id)
                                .toList();
                            setState(() {});

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'first_name': familyMedicalInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': familyMedicalInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': familyMedicalInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': familyMedicalInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': familyMedicalInsuranceController.selectNationality.value.name ?? '',
                                      'nationality_no': familyMedicalInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': familyMedicalInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(familyMedicalInsuranceController.birthDateController.value.text),
                                      'gender': familyMedicalInsuranceController.selectedGender ?? '',
                                      'marital_status': familyMedicalInsuranceController.selectedMaritalStatus ?? '',
                                      'occupancy_work': familyMedicalInsuranceController.selectOccupation.value.name ?? '',
                                      'city_id': familyMedicalInsuranceController.selectCity.value.id ?? 0,
                                      'district_id': familyMedicalInsuranceController.selectDistrict.value.id ?? 0,
                                      'street_name': familyMedicalInsuranceController.streetNameController.value.text,
                                      'building_no': familyMedicalInsuranceController.buildingNoController.value.text,
                                      'company_name': familyMedicalInsuranceController.companyNameController.value.text,
                                      'position': familyMedicalInsuranceController.positionController.value.text,
                                      'work_nature': familyMedicalInsuranceController.workNatureController.value.text,
                                      'company_city_id': familyMedicalInsuranceController.selectCompanyCity.value.id ?? 0,
                                      'company_district_id': familyMedicalInsuranceController.selectCompanyDistrict.value.id ?? 0,
                                      'company_street_name': familyMedicalInsuranceController.companyStreetNameController.value.text,
                                      'company_building_no': familyMedicalInsuranceController.companyBuildingNoController.value.text,
                                      'company_company_contact': familyMedicalInsuranceController.companyContactNoController.value.text,
                                      'existing_policy_status': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? 1 : 2,
                                      'existing_policy_company_name': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? familyMedicalInsuranceController.insuranceCompanyNameController.value.text : '',
                                      'existing_policy_expiry_date': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? commonApiDateFormat(familyMedicalInsuranceController.existingMedicalInsurancePolicyExpiryDateController.value.text) : '',
                                      'existing_policy_card': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "Yes" ? familyMedicalInsuranceController.selectedMedicalCard : '',
                                      'height': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "No" ? familyMedicalInsuranceController.heightController.value.text : '',
                                      'wight': familyMedicalInsuranceController.selectedExistingMedicalInsurancePolicyOption == "No" ? familyMedicalInsuranceController.weightController.value.text : '',
                                      'chronic_diseases_id': familyMedicalInsuranceController.selectedChronicDisease == yesTxt?selectedIds:[],
                                      'previous_operation': familyMedicalInsuranceController.selectedPreviousOperationsOption == "Yes" ? 1 : 2,
                                      'operation_details': familyMedicalInsuranceController.selectedPreviousOperationsOption == "Yes" ? familyMedicalInsuranceController.detailsAboutPreviousOperationsController.value.text : '',
                                      'pregnant_status': familyMedicalInsuranceController.selectedPregnantOption == "Yes" ? 1 : 2,
                                      'pregnant_month': familyMedicalInsuranceController.selectedPregnantOption == "Yes" ? familyMedicalInsuranceController.selectmonth : '',
                                      'dangerous_status': familyMedicalInsuranceController.selectedDangerousActivity == "Yes" ? 1 : 2,
                                      'dangerous_id': familyMedicalInsuranceController.selectedDangerousActivity == "Yes" ? selectedIdsDange : [],
                                      'passport_front_id': familyMedicalInsuranceController.selectedDangerousActivity == "No" ? familyMedicalInsuranceController.selectedIdFrontSide : '',
                                      'passport_back_id': familyMedicalInsuranceController.selectedDangerousActivity == "No" ? familyMedicalInsuranceController.selectedIdBackSide : '',
                                      'family_book_documents': familyMedicalInsuranceController.selectedDangerousActivity == "No" ? familyMedicalInsuranceController.selectedFamilyBook : '',
                                      'personal_picture_documents': familyMedicalInsuranceController.selectedDangerousActivity == "No" ? familyMedicalInsuranceController.selectedPersonalPic : '',
                                      'other_documents': familyMedicalInsuranceController.selectedDangerousActivity == "No" ? familyMedicalInsuranceController.selectedOtherMembers : '',
                                      'inception_date': commonApiDateFormat(familyMedicalInsuranceController.inceptionDateController.value.text),
                                      'expiry_date': commonApiDateFormat(familyMedicalInsuranceController.expiryDateController.value.text),
                                      'insurance_type': familyMedicalInsuranceController.insurancetypes == 'In Patient Only' ? 1 : 2,
                                      'insurance_class': familyMedicalInsuranceController.selectclass ?? '',
                                      'inpatient_deductible_id': familyMedicalInsuranceController.selectInPatient.value.id ?? "",
                                      'outpatient_deductible_id': familyMedicalInsuranceController.selectOutPatient.value.id ?? "",
                                      'no_of_visits_id': familyMedicalInsuranceController.selectNoOfVisits.value.id ?? "",
                                      'insurance_limit': familyMedicalInsuranceController.selectedInsuranceLimit.value.limit ?? 0,
                                      'plan_id': familyMedicalInsuranceController.planDd ?? 0,
                                      'insurance_type_status': 2,
                                      'members': members,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                    },
                                    apiUrl: addFamilyMedicalInsurance, insuranceType: medicalInsuranceTxt,
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
                                    text: familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit!=null &&familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit!=''?  AppText(text: "The Quote is: ${familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15):const SizedBox(),
                                 // AppText(text: "Starting from ₹${familyMedicalInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        }));
  }

  List<int?> chronicIdList(List<GetChronicDiseasesList> listData){
    List<int?> selectedIds = listData
        .map((e) => e.id)
        .toList();
    return selectedIds;
  }

}
