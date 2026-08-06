import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class OfficeInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  OfficeInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<OfficeInsuranceListDataScreen> createState() => _OfficeInsuranceListDataScreenState();
}

class _OfficeInsuranceListDataScreenState extends State<OfficeInsuranceListDataScreen> {
  OfficeInsuranceController officeInsuranceController = Get.put(OfficeInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    print(officeInsuranceController.selectedInsurancePlan.value.planName);
    officeInsuranceController.getHomeInsurancePlanApi(context, officeInsuranceController.selectedInsurancePlan.value.planName ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return officeInsuranceController.isLoadingOfficeInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : officeInsuranceController.officeInsurancePlanModel.value.data == null
                  ? Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: officeInsuranceController.officeInsurancePlanModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            officeInsuranceController.insuranceLimit = officeInsuranceController.officeInsurancePlanModel.value.data?[index].limit.toString() ?? '';
                            officeInsuranceController.planDd = officeInsuranceController.officeInsurancePlanModel.value.data?[index].id.toString() ?? '';

                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: officeInsuranceController.officeInsurancePlanModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: officeInsuranceController.officeInsurancePlanModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'first_name': officeInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': officeInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': officeInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': officeInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': officeInsuranceController.selectNationality.value.name,
                                      'nationality_no': officeInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': officeInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(officeInsuranceController.birthDateController.value.text),
                                      'gender': officeInsuranceController.selectedgender ?? '',
                                      'place_residence': officeInsuranceController.selectPlaceResidence.value.name ?? '',
                                      'company_name': officeInsuranceController.companyNameController.value.text,
                                      'company_register_national_id': officeInsuranceController.companyRegisterNationalIdNoController.value.text,
                                      'company_register_id': officeInsuranceController.companyRegisterNoController.value.text,
                                      'office_type': officeInsuranceController.selectofficetype ?? '',
                                      'no_of_floor': officeInsuranceController.selectNoOfFloor ?? '',
                                      'no_of_room': officeInsuranceController.selectedroomsItem ?? '',
                                      'size_of_apartment': officeInsuranceController.officeSizeController.value.text,
                                      'age_of_apartment': officeInsuranceController.selectAgeOfBuilding ?? '',
                                      'no_of_residence': officeInsuranceController.idOrResidenceNoController.value.text,
                                      'office_category': officeInsuranceController.selectedOfficeCategory ?? '',
                                      'block_no': officeInsuranceController.blockNoController.value.text,
                                      'plate_no': officeInsuranceController.plateNoController.value.text,
                                      'plot_no': officeInsuranceController.plotNoController.value.text,
                                      'effective_date': commonApiDateFormat(officeInsuranceController.effectiveDateController.value.text),
                                      'expiry_date': commonApiDateFormat(officeInsuranceController.effectiveExpiryDateController.value.text),
                                      'no_of_employee': officeInsuranceController.selectNoOfEmployee ?? '0',
                                      'country_id': officeInsuranceController.selectCountry.value.id ?? '0',
                                      'city_id': officeInsuranceController.selectCity.value.id ?? '0',
                                      'district_id': officeInsuranceController.selectDistrict.value.id ?? '0',
                                      'street_name': officeInsuranceController.streetNameController.value.text,
                                      'building_no': officeInsuranceController.buildingNoController.value.text,
                                      'office_no': officeInsuranceController.officeNoController.value.text,
                                      'company_telephone': officeInsuranceController.companyTelephoneNoController.value.text,
                                      'company_owner_name': officeInsuranceController.companyOwnerFirstNameController.value.text,
                                      'company_owner_telephone': officeInsuranceController.companyOwnerTelephoneNoController.value.text,
                                      'partner_company_status': officeInsuranceController.selectedPartnerInTheCompany == 'Yes' ? 2 : 1,
                                      'authorized_insurance_police_status': officeInsuranceController.selectedAuthorizedToIssue == 'Yes' ? 2 : 1,
                                      'auth_company_register_status': officeInsuranceController.selectedPreviousInsurancePolicy == 'Yes' ? 2 : 1,
                                      'provious_insurance_policy': officeInsuranceController.selectedAuthorizedIsStated == 'Yes' ? 2 : 1,
                                      'insurance_declined_issue_status': officeInsuranceController.selectedOfficeInsurancePolicyBefore == 'Yes' ? 2 : 1,
                                      'claims_5_year_status': officeInsuranceController.selectedClaimsAndAccidentsYears == 'Yes' ? 2 : 1,
                                      'protection_system': officeInsuranceController.selectProtectionSystemList,
                                      'insurance_limit': officeInsuranceController.selectedInsuranceLimit.value.limit ?? 0,
                                      'insurance_plan': officeInsuranceController.selectedInsurancePlan.value.planName ?? '',
                                      'inception_date': commonApiDateFormat(officeInsuranceController.inceptionDateController.value.text),
                                      'insurance_expiry_date': commonApiDateFormat(officeInsuranceController.inceptionExpiryDate1Controller.value.text),
                                      'plan_id': officeInsuranceController.planDd,
                                      'rent_contract_documents': officeInsuranceController.selectedRentDocument,
                                      'property_photo_documents': officeInsuranceController.selectedPropertyDocument,
                                      'contents_documents': officeInsuranceController.selectedContentsDocument,
                                      'policy_issuer_documents': officeInsuranceController.selectedAuthorizationDocument,
                                      'company_owner_documents': officeInsuranceController.selectedRegistrationDocument,
                                      'career_municipality_license_documents': officeInsuranceController.selectedLicenseDocument,
                                      'owner_id_documents': officeInsuranceController.selectedOwnersIdDocument,
                                      'practice_documents': officeInsuranceController.selectedPracticeCertificateDocument,
                                      'company_tax_certi_documents': officeInsuranceController.selectedCompanyTaxCertificateDocument,
                                      'payment_status': 1,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                    },
                                    apiUrl: addOfficeInsurance, insuranceType: officeInsuranceTxt,
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
                                    text: officeInsuranceController.officeInsurancePlanModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: officeInsuranceController.officeInsurancePlanModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quote is: ${officeInsuranceController.officeInsurancePlanModel.value.data?[index].netPremium ?? ''} ", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                 // AppText(text: "Starting from ₹${officeInsuranceController.officeInsurancePlanModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
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
