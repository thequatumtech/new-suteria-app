import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/language/language_constants.dart';

import 'package:soperia_user/model_class/personal_accident_insurance_model.dart';

import '../../../model_class/get_dangerous_activities_model.dart';

class PersonalAccidentInsuranceListDataScreen extends StatefulWidget {
  PersonalAccidentInsuranceListDataScreen({super.key});

  @override
  State<PersonalAccidentInsuranceListDataScreen> createState() => _PersonalAccidentInsuranceListDataScreenState();
}

class _PersonalAccidentInsuranceListDataScreenState extends State<PersonalAccidentInsuranceListDataScreen> {
  PersonalInsuranceController personalInsuranceController = Get.put(PersonalInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    personalInsuranceController.getPersonalAccidentInsurancePlanApi(context, personalInsuranceController.selectedInsuranceLimit.value.limit.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(
            text: personalinsurance,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Obx(() {
          final List<Data>? dataList = personalInsuranceController.personalAccidentInsuranceModel.value.data;
          return personalInsuranceController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : dataList != null && dataList.isNotEmpty
                  ? ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final Data item = dataList[index];
                        return InkWell(
                          onTap: () async {
                            personalInsuranceController.planId.value = item.id ?? 0;
                            setState(() {});
                            String periodValue = RegExp(r'\d+').stringMatch(personalInsuranceController.selectInsurancePeriod.value.name ?? '') ??
                                (personalInsuranceController.selectInsurancePeriod.value.name ?? personalInsuranceController.selectInsurancePeriod.value.id?.toString() ?? '');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InsuranceDraftPdfScreen(
                                          screenTitle: personalinsurance,
                                          pdfPath: item.insurancePolicyPdf ?? '',
                                          insurancePolicyText: item.insurancePolicyText ?? '',
                                          data: {
                                            'first_name': personalInsuranceController.policyHolderFirstNameController.value.text ?? '',
                                            'last_name': personalInsuranceController.policyHolderSecondNameController.value.text ?? '',
                                            'third_name': personalInsuranceController.policyHolderThirdNameController.value.text ?? '',
                                            'family_name': personalInsuranceController.policyHolderFamilyNameController.value.text ?? '',
                                            'nationality': personalInsuranceController.selectNationality.value.name ?? "",
                                            'nationality_no': personalInsuranceController.nationPassportNoController.value.text ?? '',
                                            'id_residence_no': personalInsuranceController.idOrResidenceNoController.value.text ?? '',
                                            'birth_date': commonApiDateFormat(personalInsuranceController.birthDateController.value.text),
                                            'gender': personalInsuranceController.selectedGender,
                                            'marital_status': personalInsuranceController.selectedMaritalStatus,
                                            'place_residence': personalInsuranceController.selectPlaceResidence.value.name,
                                            'company_name': personalInsuranceController.companyNameController.value.text,
                                            'position': personalInsuranceController.positionController.value.text,
                                            'work_nature': personalInsuranceController.workNatureController.value.text,
                                            'city_id': personalInsuranceController.selectCity.value.id ?? '',
                                            'district_id': personalInsuranceController.selectDistrict.value.id ?? '',
                                            'street_name': personalInsuranceController.streetNameController.value.text,
                                            'building_no': personalInsuranceController.buildingNoController.value.text,
                                            'company_contact': personalInsuranceController.companyTelephoneNoController.value.text,
                                            'company_city_id': personalInsuranceController.selectCompanyCity.value.id,
                                            'insurance_limit': item.limit ?? personalInsuranceController.selectedInsuranceLimit.value.limit ?? '',
                                            'limit': item.limit ?? personalInsuranceController.selectedInsuranceLimit.value.limit ?? '',
                                            'insurance_amount': item.limit ?? personalInsuranceController.selectedInsuranceLimit.value.limit ?? '',
                                            'inception_date': commonApiDateFormat(personalInsuranceController.inceptionDateController.value.text),
                                            'inception_period': periodValue,
                                            'insurance_period': periodValue,
                                            'insurance_period_id': personalInsuranceController.selectInsurancePeriod.value.id ?? '',
                                            'occupany_type_work': personalInsuranceController.occupancyController.value.text,
                                            'photo_documents_1': personalInsuranceController.documents1,
                                            'photo_documents_2': personalInsuranceController.documents2,
                                            'photo_documents_3': personalInsuranceController.documents3,
                                            'photo_documents_4': personalInsuranceController.documents4,
                                            'plan_id': personalInsuranceController.planId.value,
                                            'dangerours_field[]': chronicIdList(personalInsuranceController.selectedDangerousActivitiesList),
                                            'payment_status': 1,
                                            'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                          },
                                          apiUrl: addPersonalAccidentInsurance,
                                          insuranceType: personalAccidentsInsuranceTxt,
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
                                    text: item.insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: item.planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  item.limit != null && item.limit.toString().isNotEmpty
                                      ? AppText(
                                          text: "${getTranslated(context, theQuoteIs)}: ${item.grossPremium ?? ''} ${getTranslated(context, 'JOD')}",
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
                    )
                  : Center(child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.bold));
        }));
  }

  String chronicIdList(List<GetDangerousActivitiesList> listData) {
    return listData.map((e) => e.id?.toString()).where((id) => id != null).join(',');
  }
}
