import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class DentalInsuranceListData extends StatefulWidget {
  String screenTitle = '';

  DentalInsuranceListData({super.key, required this.screenTitle});

  @override
  State<DentalInsuranceListData> createState() => _DentalInsuranceListDataState();
}

class _DentalInsuranceListDataState extends State<DentalInsuranceListData> {
  DentalInsuranceController dentalInsuranceController = Get.put(DentalInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    dentalInsuranceController.getDentalInsurancePlanApi(context, dentalInsuranceController.selectedInsurancePlan.value.planName.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return dentalInsuranceController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : dentalInsuranceController.homeInsurancePlaneModel.value.data == null
                  ? Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: dentalInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            // dentalInsuranceController.insuranceLimit = dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            dentalInsuranceController.planDd = dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InsuranceDraftPdfScreen(
                                          screenTitle: widget.screenTitle,
                                          pdfPath: dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                          insurancePolicyText: dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                          data: {
                                            'first_name': dentalInsuranceController.policyHolderFirstNameController.value.text,
                                            'last_name': dentalInsuranceController.policyHolderSecondNameController.value.text,
                                            'third_name': dentalInsuranceController.policyHolderThirdNameController.value.text,
                                            'family_name': dentalInsuranceController.policyHolderFamilyNameController.value.text,
                                            'nationality': dentalInsuranceController.selectNatonality.value.name ?? '',
                                            'nationality_no': dentalInsuranceController.selectNatonality.value.id ?? 0,
                                            'id_residence_no': dentalInsuranceController.selectResidence.value.id ?? 0,
                                            'birth_date': commonApiDateFormat(dentalInsuranceController.birthDateController.value.text),
                                            'gender': dentalInsuranceController.selectedgender ?? '',
                                            'marital_status': dentalInsuranceController.selectedMaritalStatus ?? '',
                                            'place_residence': dentalInsuranceController.selectResidence.value.name ?? '',
                                            'occupancy_work': dentalInsuranceController.selectOccupation.value.name ?? '',
                                            'city_id': dentalInsuranceController.selectCity.value.id ?? '',
                                            'district_id': dentalInsuranceController.selectDistrict.value.id ?? '',
                                            'street_name': dentalInsuranceController.streetNameController.value.text,
                                            'building_no': dentalInsuranceController.buildingNoController.value.text,
                                            'company_name': dentalInsuranceController.companyNameController.value.text,
                                            'position': dentalInsuranceController.positionController.value.text,
                                            'work_nature': dentalInsuranceController.workNatureController.value.text,
                                            'company_city_id': dentalInsuranceController.selectCompanyCity.value.id ?? 0,
                                            'company_district_id': dentalInsuranceController.selectCompanyDistrict.value.id ?? 0,
                                            'company_street_name': dentalInsuranceController.companyStreetNameController.value.text,
                                            'company_building_no': dentalInsuranceController.companyBuildingNoController.value.text,
                                            'company_contact': dentalInsuranceController.companyContactNoController.value.text,
                                            'insurance_limit': dentalInsuranceController.selectedInsuranceLimit.value.limit ?? '',
                                            'inception_date': commonApiDateFormat(dentalInsuranceController.effectiveDateController.value.text),
                                            'expiry_date': commonApiDateFormat(dentalInsuranceController.expiryDateController.value.text),
                                            'documents': dentalInsuranceController.photoDoc,
                                            'plan_id': dentalInsuranceController.planDd,
                                            'payment_status': 1,
                                            'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                          },
                                          apiUrl: addDentalInsurance, insuranceType: dentalInsuranceTxt,
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
                                    text: dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(text: "The Quate: JOD ${dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].limit ?? ''}", txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  // AppText(text: "Starting from ₹${dentalInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
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
