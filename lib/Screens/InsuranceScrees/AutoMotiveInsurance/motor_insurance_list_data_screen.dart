import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/draft_pdf_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/isurance_draft_screen.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';

class MotorInsuranceListDataScreen extends StatefulWidget {
  String screenTitle = '';

  MotorInsuranceListDataScreen({super.key, required this.screenTitle});

  @override
  State<MotorInsuranceListDataScreen> createState() => _MotorInsuranceListDataScreenState();
}

class _MotorInsuranceListDataScreenState extends State<MotorInsuranceListDataScreen> {
  MotorInsuranceController motorInsuranceController = Get.put(MotorInsuranceController());
  DraftPdfController draftPdfController = Get.put(DraftPdfController());

  @override
  void initState() {
    motorInsuranceController.getMotorInsuranceApis(context, motorInsuranceController.selectInsuranceType ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
        ),
        body: Obx(() {
          return motorInsuranceController.isLoadingInsurancePlan.value
              ? const Center(child: CircularProgressIndicator())
              : motorInsuranceController.homeInsurancePlaneModel.value.data == null || motorInsuranceController.homeInsurancePlaneModel.value.data!.isEmpty
                  ? Center(
                      child: AppText(text: noDataFound, size: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      itemCount: motorInsuranceController.homeInsurancePlaneModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            motorInsuranceController.insuranceLimit = motorInsuranceController.homeInsurancePlaneModel.value.data?[index].limit.toString() ?? '';
                            motorInsuranceController.planDd = motorInsuranceController.homeInsurancePlaneModel.value.data?[index].id.toString() ?? '';
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsuranceDraftPdfScreen(
                                    screenTitle: widget.screenTitle,
                                    pdfPath: motorInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyPdf ?? '',
                                    insurancePolicyText: motorInsuranceController.homeInsurancePlaneModel.value.data?[index].insurancePolicyText ?? '',
                                    data: {
                                      'first_name': motorInsuranceController.policyHolderFirstNameController.value.text,
                                      'last_name': motorInsuranceController.policyHolderSecondNameController.value.text,
                                      'third_name': motorInsuranceController.policyHolderThirdNameController.value.text,
                                      'family_name': motorInsuranceController.policyHolderFamilyNameController.value.text,
                                      'nationality': motorInsuranceController.selectNatonality.value.name,
                                      'nationality_no': motorInsuranceController.nationPassportNoController.value.text,
                                      'id_residence_no': motorInsuranceController.idOrResidenceNoController.value.text,
                                      'birth_date': commonApiDateFormat(motorInsuranceController.birthDateController.value.text),
                                      'gender': motorInsuranceController.selectedGender,
                                      'marital_status': motorInsuranceController.selectedMaritalStatus,
                                      'occupancy': motorInsuranceController.selectOccupation.value.name,
                                      'city_id': motorInsuranceController.selectCity.value.id,
                                      'district_id': motorInsuranceController.selectDistrict.value.id,
                                      'street_name': motorInsuranceController.streetNameController.value.text,
                                      'building_no': motorInsuranceController.buildingNoController.value.text,
                                      'user_mobile_no': motorInsuranceController.userMobileNoController.value.text,
                                      'company_name': motorInsuranceController.companyNameController.value.text,
                                      'position': motorInsuranceController.positionController.value.text,
                                      'work_nature': motorInsuranceController.workOfNatureController.value.text,
                                      'company_contact_no': motorInsuranceController.companyContactNoController.value.text,
                                      'inception_date': commonApiDateFormat(motorInsuranceController.inceptionDateController.value.text),
                                      'expiry_date': commonApiDateFormat(motorInsuranceController.expiryDateController.value.text),
                                      'national_id_number': motorInsuranceController.nationIdController.value.text,
                                      'residency_number': motorInsuranceController.residencyNumberController.value.text,
                                      'no_accident_3_year': motorInsuranceController.noOfAccidentController.value.text,
                                      'no_ticket_12_month': motorInsuranceController.noOfTicketsController.value.text,
                                      'no_point_12_month': motorInsuranceController.noOfPointsController.value.text,
                                      'vahicle_no': motorInsuranceController.vehiclePlateNoController.value.text,
                                      'obtain_vahicle_info': '',
                                      'vahicle_type_id': motorInsuranceController.selectVehicleType.value.id,
                                      'vahicle_brand_id': motorInsuranceController.selectVehicleBrand.value.id,
                                      'vahicle_category_id': motorInsuranceController.selectVehicleTypeCategory.value.id,
                                      'vahicle_color_id': motorInsuranceController.selectVehicleColor.value.id,
                                      'vahicle_register_no': motorInsuranceController.vehicleRegistrationNoController.value.text,
                                      'engine_no': motorInsuranceController.vehicleEngineNoController.value.text,
                                      'chassis_no': motorInsuranceController.vehicleChassisNoController.value.text,
                                      'engine_type_id': motorInsuranceController.selectEngineType.value.id,
                                      'engine_capacity': motorInsuranceController.vehicleEngineCapacityController.value.text,
                                      'vehicle_manufacturing_date': commonApiDateFormat(motorInsuranceController.vehicleManufactureDateController.value.text),
                                      'vehicle_value': motorInsuranceController.vehicleValueController.value.text,
                                      'insurance_type': motorInsuranceController.selectInsuranceType,
                                      'plan_id': motorInsuranceController.planDd,
                                      'residence_id_front': motorInsuranceController.selectedResidenceIdFront,
                                      'residence_id_back': motorInsuranceController.selectedResidenceIdBack,
                                      'vehicle_license_front': motorInsuranceController.selectedLicenseFront,
                                      'vehicle_license_back': motorInsuranceController.selectedLicenseBack,
                                      'vehicle_photo_front': motorInsuranceController.selectedPhotoFront,
                                      'vehicle_photo_back': motorInsuranceController.selectedPhotoBack,
                                      'vehicle_photo_right': motorInsuranceController.selectedPhotoRightSide,
                                      'vehicle_photo_left': motorInsuranceController.selectedPhotoLeftSide,
                                      'carseer_documents': motorInsuranceController.selectedCarseer.isNotEmpty ? motorInsuranceController.selectedCarseer : '',
                                      'autoscore_documents': motorInsuranceController.selectedAutoScore.isNotEmpty ? motorInsuranceController.selectedAutoScore : '',
                                      'customs_declaration': motorInsuranceController.selectedCustomsDeclaration.isNotEmpty ? motorInsuranceController.selectedCustomsDeclaration : '',
                                      'purchase_id': draftPdfController.postInsuranceModel.value.data?.purchaseId ?? 0,
                                    },
                                    apiUrl: addMotorInsurance,
                                    insuranceType: motorInsuranceTxt,
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
                                    text: motorInsuranceController.homeInsurancePlaneModel.value.data?[index].insuranceCompany?.companyName ?? '',
                                    size: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                  AppText(text: motorInsuranceController.homeInsurancePlaneModel.value.data?[index].planName ?? '', txtColor: deepBlue, fontWeight: FontWeight.bold, size: 15),
                                  AppText(
                                      text: "₹ ${motorInsuranceController.homeInsurancePlaneModel.value.data?[index].limit ?? ''} Term Plan",
                                      txtColor: deepBlue,
                                      fontWeight: FontWeight.bold,
                                      size: 15),
                                  AppText(
                                      text: "Starting from ₹${motorInsuranceController.homeInsurancePlaneModel.value.data?[index].netPremium ?? ''}/month",
                                      txtColor: gold,
                                      fontWeight: FontWeight.bold,
                                      size: 12),
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
