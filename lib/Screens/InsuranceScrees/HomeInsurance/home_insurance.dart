import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class HomeInsurance extends StatefulWidget {
  String screenTitle = '';

  HomeInsurance({super.key, required this.screenTitle});

  @override
  State<HomeInsurance> createState() => _HomeInsuranceState();
}

class _HomeInsuranceState extends State<HomeInsurance> {
  HomeInsuranceController homeInsuranceController = Get.put(HomeInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    homeInsuranceController.getHomeInsurancePlanApi(context, homeInsuranceController.selectedInsurancePlan.value.planName.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return homeInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : (homeInsuranceController.homeInsurancePlaneModel.value.data == null || homeInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty)
                  ? Center(
                      child: AppText(text: noInsurancePlanFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: homeInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async{
                            homeInsuranceController.insuranceLimit = homeInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            homeInsuranceController.planDd = homeInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: homeInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: homeInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'rent_contract': homeInsuranceController.rentContractDoc,
                                      'property_document': homeInsuranceController.propertyDoc,
                                      'content_document': homeInsuranceController.contentsDoc,
                                      'first_name': homeInsuranceController.policyHolderFirstNameController.value.text ,
                                      'last_name': homeInsuranceController.policyHolderSecondNameController.value.text ,
                                      'third_name': homeInsuranceController.policyHolderThirdNameController.value.text ,
                                      'family_name': homeInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': homeInsuranceController.selectNatonality.value.name ?? '',
                                      'nationality_no': homeInsuranceController.nationPassportNoController.value.text ?? '',
                                      'id_residence_no': homeInsuranceController.idOrResidenceNoController.value.text ?? '',
                                      'birth_date': commonApiDateFormat(homeInsuranceController.birthDateController.value.text),
                                      'gender': homeInsuranceController.selectedgender,
                                      'marital_status': homeInsuranceController.selectedMaritalStatus,
                                      'place_of_residence': homeInsuranceController.selectPlaceResidence.value.name,
                                      'home_type': homeInsuranceController.occupancyController.value.text ?? '',
                                      'no_of_floor': homeInsuranceController.selectNoOfFloors ?? '',
                                      'no_of_room': homeInsuranceController.selectedroomsItem ?? '',
                                      'size_of_apartment': homeInsuranceController.sizeOfApartmentController.value.text ?? '',
                                      'no_of_residence': homeInsuranceController.noOfResidence1.text ?? '',
                                      'home_category': homeInsuranceController.selectedOwnership ?? '',
                                      'block_no': homeInsuranceController.blockNoController.value.text ?? '',
                                      'plate_no': homeInsuranceController.plateNoController.value.text ?? '',
                                      'plot_no': homeInsuranceController.plotNoController.value.text ?? '',
                                      'country_id': homeInsuranceController.selectCountry.value.id ?? "",
                                      'city_id': homeInsuranceController.selectCity.value.id ?? '',
                                      'district_id': homeInsuranceController.selectDistrict.value.id ?? '',
                                      'street_name': homeInsuranceController.streetNameController.value.text.isNotEmpty ? homeInsuranceController.streetNameController.value.text : '',
                                      'building_no': homeInsuranceController.buildingNoController.value.text.isNotEmpty ? homeInsuranceController.buildingNoController.value.text : '',
                                      'company_name': homeInsuranceController.companyNameController.value.text.isNotEmpty ? homeInsuranceController.companyNameController.value.text : "",
                                      'city_id_2': homeInsuranceController.selectCompanyCity.value.id ?? '',
                                      'position': homeInsuranceController.positionController.value.text.isNotEmpty ? homeInsuranceController.positionController.value.text : '',
                                      'work_nature': homeInsuranceController.workNatureController.value.text.isNotEmpty ? homeInsuranceController.workNatureController.value.text : '',
                                      'previous_policy': homeInsuranceController.previousPolicyExplain.value.text.isNotEmpty ? homeInsuranceController.previousPolicyExplain.value.text : '',
                                      'company_declined_to_issue': homeInsuranceController.whyDeclineController.value.text.isNotEmpty ? homeInsuranceController.whyDeclineController.value.text : '',
                                      'claims_accidents_past': homeInsuranceController.claimIn5yearController.value.text.isNotEmpty ? homeInsuranceController.claimIn5yearController.value.text : '',
                                      'protection_system': homeInsuranceController.selectProtectionSystemList.isNotEmpty ? homeInsuranceController.selectProtectionSystemList.first.label : '',
                                      'insurance_limit': homeInsuranceController.insuranceLimit ?? '',
                                      'plan_id': homeInsuranceController.planDd ?? '',
                                      'effective_date': commonApiDateFormat(homeInsuranceController.effectiveDateController.value.text),
                                      'expiry_date': commonApiDateFormat(homeInsuranceController.expiryDateController.value.text),
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,

                                    },
                                    apiUrl: addHomeInsurance, insuranceType: homeInsuranceTxt,
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
                                    text: homeInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: homeInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  homeInsuranceController.homeInsurancePlaneModel.value.data?[index].limit !=null &&homeInsuranceController.homeInsurancePlaneModel.value.data?[index].limit !=""  ? AppText(text: "The Quote is: ${homeInsuranceController.homeInsurancePlaneModel.value.data?[index].grossPremium ?? ''} JOD", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15):const SizedBox(),
                                //  AppText(text: "Starting from ₹${homeInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
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
