import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';

class MarineInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  MarineInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<MarineInsuranceListDataScreen> createState() => _MarineInsuranceListDataScreenState();
}

class _MarineInsuranceListDataScreenState extends State<MarineInsuranceListDataScreen> {
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    print("sdkjfhsjkfhksjhfkjsd");
    print(marineInsuranceController.selectedInsuranceLimit.value.limit.toString());
    marineInsuranceController.getMarineInsurancePlanApi(context, marineInsuranceController.selectedInsuranceLimit.value.limit.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return marineInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : marineInsuranceController.homeInsurancePlaneModel.value.data == null || marineInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty
                  ? Center(child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600))
                  : ListView.builder(
                      itemCount: marineInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            marineInsuranceController.insuranceLimit = marineInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            marineInsuranceController.planDd = marineInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: marineInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: marineInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'company_status': marineInsuranceController.individual.value ? 1 : 2,
                                      'first_name': marineInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': marineInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': marineInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': marineInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': '',
                                      'nationality_no': marineInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': marineInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(marineInsuranceController.birthDateController.value.text),
                                      'gender': marineInsuranceController.selectedGender ?? '',
                                      'company_name': marineInsuranceController.companyNameController.value.text,
                                      'company_reg_notional_id': marineInsuranceController.companyRegisterNationalIdNoController.value.text,
                                      'company_reg_no': marineInsuranceController.companyRegisterNoController.value.text,
                                      'company_country_id': marineInsuranceController.selectCompanyCountry.value.id ?? 0,
                                      'company_city_id': marineInsuranceController.selectCompanyCity.value.id ?? 0,
                                      'company_district_id': marineInsuranceController.selectCompanyDistrict.value.id ?? 0,
                                      'company_street_name': marineInsuranceController.streetNameController.value.text,
                                      'company_building_no': marineInsuranceController.buildingNoController.value.text,
                                      'company_office_no': marineInsuranceController.officeNoController.value.text,
                                      'company_contact': marineInsuranceController.companyTelephoneNoController.value.text,
                                      'owner_first_name': marineInsuranceController.companyOwnerFirstNameController.value.text,
                                      'owner_last_name': marineInsuranceController.companyOwnerSecondNameController.value.text,
                                      'owner_third_name': marineInsuranceController.companyOwnerThirdNameController.value.text,
                                      'owner_family_name': marineInsuranceController.companyOwnerFamilyNameController.value.text,
                                      'company_owner_contact': marineInsuranceController.companyOwnerTelephoneNoController.value.text,
                                      'company_partner_status': marineInsuranceController.selectedPartnerInTheCompanyOption == "Yes" ? 1 : 2,
                                      'company_authorized_status': marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == "Yes" ? 1 : 2,
                                      'authorized_positions': marineInsuranceController.selectedAuthorizedToIssueInsurancePolicyOption == "Yes" ? marineInsuranceController.authorizedPositionController.value.text : '',
                                      'company_register_status': marineInsuranceController.selectedCompanyRegistrationOption == "Yes" ? 1 : 2,
                                      'register_document': marineInsuranceController.selectedCompanyRegistrationOption == "No"
                                          ? marineInsuranceController.selectedDocuments.isNotEmpty
                                              ? marineInsuranceController.selectedDocuments
                                              : ''
                                          : '',
                                      'vayage_from_id': marineInsuranceController.selectVoyage.value.id ?? 0,
                                      'through_country_id': marineInsuranceController.selectThroughCountry.value.id ?? 0,
                                      'destination_country_id': marineInsuranceController.selectFinalDestinationCountry.value.id ?? 0,
                                      'trans_shipped_third_country':multipleDestList(marineInsuranceController.selectedMultiDestinationList),///Add this in APi
                                      'dangerous_activities':marineInsuranceController.dangerousGoodsController.value.text,///Add in API
                                      'type_of_transportation': marineInsuranceController.selectTypeTransportation ?? '',
                                      'type_of_cover': marineInsuranceController.selectedTypeCover.value.name ?? '',
                                      'item_category_id': marineInsuranceController.selectedItemCategory.value.id ?? 0,
                                      'item_subcategory_id': marineInsuranceController.selectedItemSubcategory.value.id ?? 0,
                                      'insurance_limit': marineInsuranceController.selectedInsuranceLimit.value.limit ?? 0,
                                      'bill_no': marineInsuranceController.billNoOrLadingNoController.value.text,
                                      'effective_date': commonApiDateFormat(marineInsuranceController.effectiveDateController.value.text),
                                      'expiry_date': commonApiDateFormat(marineInsuranceController.expiryDateController.value.text),
                                      'insured_items': marineInsuranceController.noOfInsuredItemController.value.text,
                                      'existing_policy_status': marineInsuranceController.selectedExistingInsurancePolicyOption == "Yes" ? 1 : 2,
                                      'existing_policy_desc': marineInsuranceController.selectedExistingInsurancePolicyOption == "Yes" ? marineInsuranceController.nameOfInsuranceCompanyAndExpiryController.value.text : '',
                                      'declined_insurance_status': marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption == "Yes" ? 1 : 2,
                                      'declined_insurance_desc': marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption == "Yes" ? marineInsuranceController.whyAnInsuranceCompanyDeclinedToIssueController.value.text : '',
                                      'claims_accident_status': marineInsuranceController.selectedClaimsAccidentsInPastYearOption == "Yes" ? 1 : 2,
                                      'claims_accident_desc': marineInsuranceController.selectedClaimsAccidentsInPastYearOption == "Yes" ? marineInsuranceController.writeInDetailsClaimAccidentController.value.text : '',
                                      'billing_of_landing_doc': marineInsuranceController.selectedBillOfLadingDocuments.isNotEmpty ? marineInsuranceController.selectedBillOfLadingDocuments : '',
                                      'copy_of_invoice_doc': marineInsuranceController.selectedCopyOfInvoice.isNotEmpty ? marineInsuranceController.selectedCopyOfInvoice : '',
                                      'insured_id_doc': marineInsuranceController.selectedInsuredsId.isNotEmpty ? marineInsuranceController.selectedInsuredsId : '',
                                      'policy_issuer_doc': marineInsuranceController.selectedPolicyIssuerAuthorization.isNotEmpty ? marineInsuranceController.selectedPolicyIssuerAuthorization : '',
                                      'company_reg_owner_doc': marineInsuranceController.selectedCompanyRegistrationOwnership.isNotEmpty ? marineInsuranceController.selectedCompanyRegistrationOwnership : '',
                                      'career_municipality_license_doc': marineInsuranceController.selectedCareerMunicipalityLicense.isNotEmpty ? marineInsuranceController.selectedCareerMunicipalityLicense : '',
                                      'company_tax_certificate_doc': marineInsuranceController.selectedCompanyTaxCertificate.isNotEmpty ? marineInsuranceController.selectedCompanyTaxCertificate : '',
                                      'practice_certificate_doc': marineInsuranceController.selectedPracticeCertificate.isNotEmpty ? marineInsuranceController.selectedPracticeCertificate : '',
                                      'plan_id': marineInsuranceController.planDd ?? '',
                                      'payment_status': 1,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                    },
                                    apiUrl: addMarineInsurance, insuranceType: marineInsuranceTxt,
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
                                    text: marineInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: marineInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quote is:  ${marineInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                //  AppText(text: "Starting from ₹${marineInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        }));
  }

  List<int?> chronicIdList(List<GetDangerousActivitiesList> listData){
    List<int?> selectedIds = listData
        .map((e) => e.id)
        .toList();
    return selectedIds;
  }

  List<int?> multipleDestList(List<GetCountryList> listData){
    List<int?> selectedIds = listData
        .map((e) => e.id)
        .toList();
    return selectedIds;
  }

}
