import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_inurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';

class TravelInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  TravelInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<TravelInsuranceListDataScreen> createState() => _TravelInsuranceListDataScreenState();
}

class _TravelInsuranceListDataScreenState extends State<TravelInsuranceListDataScreen> {
  TravelInsuranceController travelInsuranceController = Get.put(TravelInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    travelInsuranceController.getHomeInsurancePlanApi(
      context,
      travelInsuranceController.selectedInsurancePlan.value.planName ?? '0',
      travelDays: travelInsuranceController.noOfDaysController.value.text,
    );
    super.initState();
  }

  List<int?> chronicIdList(List<GetDangerousActivitiesList> listData) {
    List<int?> selectedIds = listData.map((e) => e.id).toList();
    return selectedIds;
  }

  List<int?> multipleDestList(List<GetCountryList> listData) {
    List<int?> selectedIds = listData.map((e) => e.id).toList();
    return selectedIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return travelInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : (travelInsuranceController.homeInsurancePlaneModel.value.data == null || travelInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty)
                  ? Center(
                      child: AppText(text: noInsurancePlanFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: travelInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            travelInsuranceController.insuranceLimit = travelInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            travelInsuranceController.planDd = travelInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            List<Map<String, dynamic>> members = [
                              for (int i = 0; i < travelInsuranceController.memberFirstNameController.length; i++)
                                {
                                  "first_name": travelInsuranceController.memberFirstNameController[i].text,
                                  "last_name": travelInsuranceController.memberSecondNameController[i].text,
                                  "third_name": travelInsuranceController.memberThirdNameController[i].text,
                                  "family_name": travelInsuranceController.memberFamilyNameController[i].text,
                                  "relation": travelInsuranceController.selectedRelation[i],
                                  "nationality": travelInsuranceController.selectNationalityMember[i].name,
                                  "nationality_no": travelInsuranceController.memberNationPassportNoController[i].text,
                                  "id_residence_no": travelInsuranceController.memberIdOrResidenceNoController[i].text,
                                  "birth_date": commonApiDateFormat(travelInsuranceController.memberBirthDateController[i].text),
                                  "gender": travelInsuranceController.selectMemberGender[i],
                                  "place_residence": travelInsuranceController.memberSelectPlaceResidence[i].name,
                                  "passport_document": travelInsuranceController.selectedMembers[i],
                                },
                            ];

                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: travelInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: travelInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'self_family_status': travelInsuranceController.isSelfType.value ? '1' : '2',
                                      'first_name': travelInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': travelInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': travelInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': travelInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': travelInsuranceController.selectNationality.value.name,
                                      'nationality_no': travelInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': travelInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(travelInsuranceController.birthDateController.value.text),
                                      'gender': travelInsuranceController.selectedGender ?? '',
                                      'marital_status': travelInsuranceController.selectedMaritalStatus ?? '',
                                      'place_residence': travelInsuranceController.selectPlaceResidence.value.name ?? '',
                                      'passport_document': travelInsuranceController.selectedPassport,
                                      'departure_from_country_id': travelInsuranceController.selectDepartureFrom.value.id ?? 0,
                                      'destination_country_id': travelInsuranceController.selectDestination.value.id ?? 0,
                                      'additional_destination_country_id': travelInsuranceController.selectAdditionalDestination.value.id ?? 0,
                                      'geographical_area_id': travelInsuranceController.selectGeographicalArea.value.id ?? 0,
                                      'effective_date': commonApiDateFormat(travelInsuranceController.effectiveDateController.value.text),
                                      'travel_days': travelInsuranceController.noOfDaysController.value.text,
                                      'expiry_date': commonApiDateFormat(travelInsuranceController.expiryDateController.value.text),
                                      'other_documents': '',
                                      'insurance_limit': travelInsuranceController.insuranceLimit.isNotEmpty
                                          ? travelInsuranceController.insuranceLimit
                                          : (travelInsuranceController.homeInsurancePlaneModel.value.data?[index].limit?.toString() ?? ''),
                                      'plan_id': travelInsuranceController.planDd,
                                      'payment_status': 1,
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data != null ? draftPdfController.postInsuranceModel.value.data!.purchaseId ?? 0 : 0,
                                      'members': members,
                                      'dangerous_activities': chronicIdList(travelInsuranceController.selectedDangerousActivitiesList),
                                      'multiple_destination': multipleDestList(travelInsuranceController.selectedMultiDestinationList),
                                    },
                                    apiUrl: addTravelInsurance,
                                    insuranceType: travelInsuranceTxt,
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
                                    text: travelInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: travelInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),

                                  travelInsuranceController.homeInsurancePlaneModel.value.data?[index].limit!=null && travelInsuranceController.homeInsurancePlaneModel.value.data?[index].limit!='' ? AppText(
                                      text:
                                          "The Quote is: ${travelInsuranceController.homeInsurancePlaneModel.value.data?[index].grossPremium ?? ''} JOD",//Term Plan
                                      txtColor: deepBlue,
                                      fontWeight: FontWeight.bold,
                                      size: 15):const SizedBox(),
                                  // AppText(text: "Starting from ₹${travelInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month", txtColor: gold, fontWeight: FontWeight.bold, size: 12),
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
