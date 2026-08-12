import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class PetInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  PetInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<PetInsuranceListDataScreen> createState() => _PetInsuranceListDataScreenState();
}

class _PetInsuranceListDataScreenState extends State<PetInsuranceListDataScreen> {
  PetInsuranceController petInsuranceController = Get.put(PetInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    petInsuranceController.getPetsInsurancePlanApi(context, petInsuranceController.selectedInsurancePlan.value.planName.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return petInsuranceController.isLoadingPetsInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : (petInsuranceController.homeInsurancePlaneModel.value.data == null || petInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty)
                  ? Center(
                      child: AppText(text: noInsurancePlanFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: petInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            petInsuranceController.insuranceLimit = petInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            petInsuranceController.planDd = petInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InsuranceDraftPdfScreen(
                                          screenTitle: widget.screenTitle,
                                          pdfPath: petInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                          insurancePolicyText: petInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                          data: {
                                            'pets_type': petInsuranceController.isDog.value ? 1 : 2,
                                            'first_name': petInsuranceController.policyHolderFirstNameController.value.text,
                                            'last_name': petInsuranceController.policyHolderSecondNameController.value.text,
                                            'third_name': petInsuranceController.policyHolderThirdNameController.value.text,
                                            'family_name': petInsuranceController.policyHolderFamilyNameController.value.text,
                                            'nationality_no': petInsuranceController.nationPassportNoController.value.text,
                                            'id_residence_no': petInsuranceController.idOrResidenceNoController.value.text,
                                            'birth_date': commonApiDateFormat(petInsuranceController.ownerBirthDateController.value.text),
                                            'pets_name': petInsuranceController.petNameController.value.text,
                                            'pets_dob': commonApiDateFormat(petInsuranceController.petBirthDateController.value.text),
                                            'gender': petInsuranceController.selectGender ?? '',
                                            'type_of_pets': petInsuranceController.selectBreed ?? '',
                                            'breed': petInsuranceController.petBreedNameController.value.text,
                                            'pets_existing_condition_status': petInsuranceController.selectedPreExistingConditions == 'Yes' ? 1 : 2,
                                            'pets_existing_condition': petInsuranceController.selectedPreExistingConditions == 'Yes' ? petInsuranceController.preExistingController.value.text : '',
                                            'insurance_limit': petInsuranceController.selectedInsuranceLimit.value.limit,
                                            'inception_date': commonApiDateFormat(petInsuranceController.inceptionDateController.value.text),
                                            'expiry_date': commonApiDateFormat(petInsuranceController.expiryDateController.value.text),
                                            'plan_id': petInsuranceController.planDd,
                                            'vaccine_document': petInsuranceController.selectedVaccineDocuments /*selectedVaccineDocuments*/,
                                            'pets_picture': petInsuranceController.selectedPetsImgDocuments /*selectedPetsImgDocuments*/,
                                            'pets_passport': petInsuranceController.selectedPetsPassportDocuments.isNotEmpty ? petInsuranceController.selectedPetsPassportDocuments : '' /*selectedPetsPassportDocuments*/,
                                            'pets_permit': petInsuranceController.selectedPetsPermitDocuments.isNotEmpty ? petInsuranceController.selectedPetsPermitDocuments : '' /*selectedPetsPermitDocuments*/,
                                            'payment_status': 1,
                                            'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                          },
                                          apiUrl: addPetsInsurance, insuranceType: petsInsuranceTxt,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: gold),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: petInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: petInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quote is: ${petInsuranceController.homeInsurancePlaneModel.value.data?[index].grossPremium ?? ''} JOD ", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  //AppText(text: "Starting from ₹${petInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
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
