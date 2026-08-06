import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/motor_insurance_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/image_controller.dart';
import 'package:soperia_user/app_utils/Common%20Widgets/new_upload_documents_common_screen.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/app_utils/image_upload_widget.dart';
import 'package:soperia_user/model_class/get_engine_type_model.dart';
import 'package:soperia_user/model_class/get_vehicle_brand_model.dart';
import 'package:soperia_user/model_class/get_vehicle_color_model.dart';
import 'package:soperia_user/model_class/get_vehicle_type_model.dart';
import 'package:soperia_user/model_class/vehical_category_model.dart';

class AutomotiveInsuranceFourthScreen extends StatefulWidget {
  Function onNext;

  AutomotiveInsuranceFourthScreen({super.key, required this.onNext});

  @override
  State<AutomotiveInsuranceFourthScreen> createState() => _AutomotiveInsuranceFourthScreenState();
}

class _AutomotiveInsuranceFourthScreenState extends State<AutomotiveInsuranceFourthScreen> {
  MotorInsuranceController motorInsuranceController = Get.put(MotorInsuranceController());
  ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextfield(
                  hint: vehicleNoPlat,
                  lable: vehicleNoPlat,
                  controller: motorInsuranceController.vehiclePlateNoController.value,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  hint: vehiclechassisno,
                  lable: vehiclechassisno,
                  controller: motorInsuranceController.vehicleChassisNoController.value,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonColorApp,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      txtAlign: TextAlign.center,
                      text: clickToObtainVehicleInformation,
                      txtColor: primaryWhite,
                      size: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppText(text: vehicleInformationIsCorrect, size: 12),
                          )),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppText(text: vehicleInformationIsNotCorrect, size: 12),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AppText(
                  text: pleaseConfirmIfTheVehicleInformation,
                  size: 12,
                  txtAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                CustomDropDownBorder1(
                  onchage: (newValue) {
                    setState(() {
                      VehicleTypeList cdl = motorInsuranceController.vehicleTypeList.firstWhere((element) => element.id == newValue);
                      motorInsuranceController.selectVehicleType.value = cdl;
                    });
                  },
                  items: motorInsuranceController.vehicleTypeList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: motorInsuranceController.vehicleTypeList.any((element) => element.id == motorInsuranceController.selectVehicleType.value.id) ? motorInsuranceController.selectVehicleType.value.id ?? 0 : null,
                  dropdownTitle: vehicletype,
                ),
                CustomDropDownBorder1(
                  onchage: (newValue) {
                    setState(() {
                      VehicleBrandList cdl = motorInsuranceController.vehicleBrandList.firstWhere((element) => element.id == newValue);
                      motorInsuranceController.selectVehicleBrand.value = cdl;
                      motorInsuranceController.getVehicleCategoryApi(context, cdl.id.toString());
                    });
                  },
                  items: motorInsuranceController.vehicleBrandList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: motorInsuranceController.vehicleBrandList.any((element) => element.id == motorInsuranceController.selectVehicleBrand.value.id) ? motorInsuranceController.selectVehicleBrand.value.id ?? 0 : null,
                  dropdownTitle: vehiclebrand,
                ),
                motorInsuranceController.isLoadingVehicleCategory.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomDropDownBorder1(
                        onchage: (newValue) {
                          setState(() {
                            VehicleCategoryList cdl = motorInsuranceController.vehicleTypeListCategory.firstWhere((element) => element.id == newValue);
                            motorInsuranceController.selectVehicleTypeCategory.value = cdl;
                          });
                        },
                        items: motorInsuranceController.vehicleTypeListCategory.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                        selectedValue: motorInsuranceController.vehicleTypeListCategory.any((element) => element.id == motorInsuranceController.selectVehicleTypeCategory.value.id) ? motorInsuranceController.selectVehicleTypeCategory.value.id ?? 0 : null,
                        dropdownTitle: vehiclecategory,
                      ),
                CustomDropDownBorder1(
                  onchage: (newValue) {
                    setState(() {
                      VehicleColorList cdl = motorInsuranceController.vehicleColorList.firstWhere((element) => element.id == newValue);
                      motorInsuranceController.selectVehicleColor.value = cdl;
                    });
                  },
                  items: motorInsuranceController.vehicleColorList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: motorInsuranceController.vehicleColorList.any((element) => element.id == motorInsuranceController.selectVehicleColor.value.id) ? motorInsuranceController.selectVehicleColor.value.id ?? 0 : null,
                  dropdownTitle: vehiclecolor,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  hint: vehicleregno,
                  lable: vehicleregno,
                  controller: motorInsuranceController.vehicleRegistrationNoController.value,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  hint: vehicleengineno,
                  lable: vehicleengineno,
                  controller: motorInsuranceController.vehicleEngineNoController.value,
                ),
                const SizedBox(height: 20),
                CustomDropDownBorder1(
                  onchage: (newValue) {
                    setState(() {
                      GetEngineTypeList cdl = motorInsuranceController.engineTypeList.firstWhere((element) => element.id == newValue);
                      motorInsuranceController.selectEngineType.value = cdl;
                    });
                  },
                  items: motorInsuranceController.engineTypeList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                  selectedValue: motorInsuranceController.engineTypeList.any((element) => element.id == motorInsuranceController.selectEngineType.value.id) ? motorInsuranceController.selectEngineType.value.id ?? 0 : null,
                  dropdownTitle: vehicleenginetype,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  hint: vehicleenginecap,
                  lable: vehicleenginecap,
                  controller: motorInsuranceController.vehicleEngineCapacityController.value,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  readOnly: true,
                  hint: vehiclemandate,
                  lable: vehiclemandate,
                 /* ontap: () {
                    inceptionDateDialog();
                  },*/

                  ontap: () async {
                    int? selectedYear = await showDialog<int>(
                      context: context,
                      builder: (context) {
                        int currentYear = DateTime.now().year;
                        List<int> years = List.generate((currentYear + 1) - 1900 + 1, (index) => (currentYear + 1) - index);

                        return AlertDialog(
                          title: const Text('Select Year'),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: ListView.builder(
                              itemCount: years.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(years[index].toString()),
                                  onTap: () {
                                    Navigator.pop(context, years[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );

                    if (selectedYear != null) {
                      motorInsuranceController.vehicleManufactureDateController.value.text = selectedYear.toString();
                      setState(() {});
                    }
                  }

                  ,controller: motorInsuranceController.vehicleManufactureDateController.value,
                ),
                const SizedBox(height: 20),
                AppTextfield(
                  hint: vehiclevalue,
                  lable: vehiclevalue,
                  controller: motorInsuranceController.vehicleValueController.value,
                ),
                const SizedBox(height: 20),
                /* CustomDropDownBorder1(
              onchage: (newValue) {
                setState(() {
                  GetMotorPlaneList cdl = motorInsuranceController.motorPlaneList.firstWhere((element) => element.id == newValue);
                  motorInsuranceController.selectMotorPlane.value = cdl;
                });
              },
              items: motorInsuranceController.motorPlaneList
                  .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style:  TextStyle(fontSize: 15, color: primaryBlack))))
                  .toList(),
              selectedValue:motorInsuranceController.motorPlaneList.any((element) => element.id == motorInsuranceController.selectMotorPlane.value.id)
                  ? motorInsuranceController.selectMotorPlane.value.id ?? 0
                  : null,
              dropdownTitle: "Select Insurance Type",
            ),*/

                CustomDropDownBorder(
                  onchage: (newValue) {
                    setState(() {
                      motorInsuranceController.selectInsuranceType = newValue!;
                    });
                  },
                  //'Compulsory Insurance', 'Comprehensive Insurance', 'Total Loss Insurance'
                  items: const [
                  /*  compulsoryInsurance,
                    comprehensiveInsurance,
                    totalLossInsurance*/ comprehensivePlan, compulsory3MonthsPlan, compulsory6MonthsPlan, compulsory9MonthsPlan, compulsory12MonthsPlan, totalLossPlan
                  ],
                  selectedValue: motorInsuranceController.selectInsuranceType,
                  dropdownTitle: selectInsuranceType,
                ),
                motorInsuranceController.selectedResidenceIdFront.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectResidenceFrontDocument();
                        },
                        child: ImageUploadWidget(txt: addIdResidenceIdFront, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingResidenceIdFront.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: addIdResidenceIdFront1,
                        selectedDocumentsImg: motorInsuranceController.selectedResidenceIdFront,
                        removeDocumentFunction: (index) {
                          removeResidenceFrontImage(motorInsuranceController.selectedResidenceIdFront[index]);
                        },
                        addDocumentFunction: () {
                          selectResidenceFrontDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingResidenceIdFront.value,
                      ),
                motorInsuranceController.selectedResidenceIdBack.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectResidenceBackDocument();
                        },
                        child: ImageUploadWidget(txt: addIdResidenceIdBack, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingResidenceIdBack.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: addIdResidenceIdBack1,
                        selectedDocumentsImg: motorInsuranceController.selectedResidenceIdBack,
                        removeDocumentFunction: (index) {
                          removeResidenceBackImage(motorInsuranceController.selectedResidenceIdBack[index]);
                        },
                        addDocumentFunction: () {
                          selectResidenceBackDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingResidenceIdBack.value,
                      ),
                motorInsuranceController.selectedLicenseFront.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectLicenseFrontDocument();
                        },
                        child: ImageUploadWidget(txt: addVehicleLicenseFront, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingLicenseFront.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehicleLicenseFrontDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedLicenseFront,
                        removeDocumentFunction: (index) {
                          removeLicenseFrontImage(motorInsuranceController.selectedLicenseFront[index]);
                        },
                        addDocumentFunction: () {
                          selectLicenseFrontDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingLicenseFront.value,
                      ),
                motorInsuranceController.selectedLicenseBack.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectLicenseBackDocument();
                        },
                        child: ImageUploadWidget(txt: addVehicleLicenseBack, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingLicenseBack.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehicleLicenseBackDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedLicenseBack,
                        removeDocumentFunction: (index) {
                          removeLicenseBackImage(motorInsuranceController.selectedLicenseBack[index]);
                        },
                        addDocumentFunction: () {
                          selectLicenseBackDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingLicenseBack.value,
                      ),
                motorInsuranceController.selectedPhotoFront.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPhotoFrontDocument();
                        },
                        child: ImageUploadWidget(txt: addVehiclePhotoFront, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingPhotoFront.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehiclePhotoFrontDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedPhotoFront,
                        removeDocumentFunction: (index) {
                          removePhotoFrontImage(motorInsuranceController.selectedPhotoFront[index]);
                        },
                        addDocumentFunction: () {
                          selectPhotoFrontDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingPhotoFront.value,
                      ),
                motorInsuranceController.selectedPhotoBack.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPhotoBackDocument();
                        },
                        child: ImageUploadWidget(txt: addVehiclePhotoBack, borderColor: skyBlueShade2))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehiclePhotoBackDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedPhotoBack,
                        removeDocumentFunction: (index) {
                          removePhotoBackImage(motorInsuranceController.selectedPhotoBack[index]);
                        },
                        addDocumentFunction: () {
                          selectPhotoBackDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingPhotoBack.value,
                      ),
                motorInsuranceController.selectedPhotoRightSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPhotoRightSideDocument();
                        },
                        child: ImageUploadWidget(txt: addVehiclePhotoRightSide, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingPhotoRightSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehiclePhotoRightSideDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedPhotoRightSide,
                        removeDocumentFunction: (index) {
                          removePhotoRightSideImage(motorInsuranceController.selectedPhotoRightSide[index]);
                        },
                        addDocumentFunction: () {
                          selectPhotoRightSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingPhotoRightSide.value,
                      ),
                motorInsuranceController.selectedPhotoLeftSide.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectPhotoLeftSideDocument();
                        },
                        child: ImageUploadWidget(txt: addVehiclePhotoLeftSide, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingPhotoLeftSide.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: vehiclePhotoLeftSideDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedPhotoLeftSide,
                        removeDocumentFunction: (index) {
                          removePhotoLeftSideImage(motorInsuranceController.selectedPhotoLeftSide[index]);
                        },
                        addDocumentFunction: () {
                          selectPhotoLeftSideDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingPhotoLeftSide.value,
                      ),
                motorInsuranceController.selectedCarseer.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectCarseerDocument();
                        },
                        child: ImageUploadWidget(txt: addCarseer, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingCarseer.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: carseerDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedCarseer,
                        removeDocumentFunction: (index) {
                          removeCarseerImage(motorInsuranceController.selectedCarseer[index]);
                        },
                        addDocumentFunction: () {
                          selectCarseerDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingCarseer.value,
                      ),
                motorInsuranceController.selectedAutoScore.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectAutoScoreDocument();
                        },
                        child: ImageUploadWidget(txt: addAutoScore, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingAutoScore.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: autoScoreDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedAutoScore,
                        removeDocumentFunction: (index) {
                          removeAutoScoreImage(motorInsuranceController.selectedAutoScore[index]);
                        },
                        addDocumentFunction: () {
                          selectAutoScoreDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingAutoScore.value,
                      ),
                motorInsuranceController.selectedCustomsDeclaration.isEmpty
                    ? InkWell(
                        onTap: () {
                          selectCustomsDeclarationDocument();
                        },
                        child: ImageUploadWidget(txt: addCustomsDeclaration, borderColor: skyBlueShade2, isLoading: motorInsuranceController.isLoadingCustomsDeclaration.value))
                    : NewUploadDocumentsCommonScreen(
                        documentNameText: customDeclarationDocuments,
                        selectedDocumentsImg: motorInsuranceController.selectedCustomsDeclaration,
                        removeDocumentFunction: (index) {
                          removeCustomsDeclarationImage(motorInsuranceController.selectedCustomsDeclaration[index]);
                        },
                        addDocumentFunction: () {
                          selectCustomsDeclarationDocument();
                        },
                        addDocText: addDocuments,
                        isLoading: motorInsuranceController.isLoadingCustomsDeclaration.value,
                      ),
                const SizedBox(height: 20),
                AppBtnWithColorShades(
                  onTap: () {
                    if (motorInsuranceController.vehiclePlateNoController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehiclePlateNo, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectVehicleType.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVehicleType, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectVehicleBrand.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVehicleBrand, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectVehicleTypeCategory.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVehicleCategory, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectVehicleColor.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVehicleColor, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleRegistrationNoController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleRegistrationNo, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleEngineNoController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleEngineNo, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleChassisNoController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleChassisNo, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectEngineType.value.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVehicleEngineType, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleEngineCapacityController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleEngineCapacity, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleManufactureDateController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleManufactureDate, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.vehicleValueController.value.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterVehicleValue, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectInsuranceType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuranceType, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedResidenceIdFront.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadResidenceIdFront, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedResidenceIdBack.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadResidenceIdBack, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedLicenseFront.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadLicenseFront, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedLicenseBack.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadLicenseBack, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedPhotoFront.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPhotoFront, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedPhotoBack.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPhotoBack, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedPhotoRightSide.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPhotoRightSide, txtColor: primaryWhite, size: 12)));
                    } else if (motorInsuranceController.selectedPhotoLeftSide.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseUploadPhotoLeftSide, txtColor: primaryWhite, size: 12)));
                    } else {
                      widget.onNext();
                    }
                  },
                  btnTxt: next,
                  color1: darkBlue2,
                  color2: darkBlue1,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  inceptionDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), //get today's date
      firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      motorInsuranceController.vehicleManufactureDateController.value.text = commonDateFormat(formattedDate);
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }

  Future selectResidenceFrontDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingResidenceIdFront.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedResidenceIdFront.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingResidenceIdFront.value = false;
    setState(() {});
  }

  void removeResidenceFrontImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedResidenceIdFront.remove(item);
    }
    setState(() {});
  }

  Future selectResidenceBackDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingResidenceIdBack.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedResidenceIdBack.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingResidenceIdBack.value = false;
    setState(() {});
  }

  void removeResidenceBackImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedResidenceIdBack.remove(item);
    }
    setState(() {});
  }

  Future selectLicenseFrontDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingLicenseFront.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedLicenseFront.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingLicenseFront.value = false;
    setState(() {});
  }

  void removeLicenseFrontImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedLicenseFront.remove(item);
    }
    setState(() {});
  }

  Future selectLicenseBackDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingLicenseBack.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedLicenseBack.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingLicenseBack.value = false;
    setState(() {});
  }

  void removeLicenseBackImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedLicenseBack.remove(item);
    }
    setState(() {});
  }

  Future selectPhotoFrontDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingPhotoFront.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedPhotoFront.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingPhotoFront.value = false;
    setState(() {});
  }

  void removePhotoFrontImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedPhotoFront.remove(item);
    }
    setState(() {});
  }

  Future selectPhotoBackDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingPhotoBack.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedPhotoBack.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingPhotoBack.value = false;
    setState(() {});
  }

  void removePhotoBackImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedPhotoBack.remove(item);
    }
    setState(() {});
  }

  Future selectPhotoRightSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingPhotoRightSide.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedPhotoRightSide.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingPhotoRightSide.value = false;
    setState(() {});
  }

  void removePhotoRightSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedPhotoRightSide.remove(item);
    }
    setState(() {});
  }

  Future selectPhotoLeftSideDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingPhotoLeftSide.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedPhotoLeftSide.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingPhotoLeftSide.value = false;
    setState(() {});
  }

  void removePhotoLeftSideImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedPhotoLeftSide.remove(item);
    }
    setState(() {});
  }

  Future selectCarseerDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingCarseer.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedCarseer.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingCarseer.value = false;
    setState(() {});
  }

  void removeCarseerImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedCarseer.remove(item);
    }
    setState(() {});
  }

  Future selectAutoScoreDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingAutoScore.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedAutoScore.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingAutoScore.value = false;
    setState(() {});
  }

  void removeAutoScoreImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedAutoScore.remove(item);
    }
    setState(() {});
  }

  Future selectCustomsDeclarationDocument() async {
    RxList<String> selectedImg = <String>[].obs;
    motorInsuranceController.isLoadingCustomsDeclaration.value = true;
    final pickedFile = await motorInsuranceController.picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xFilePick = pickedFile;
    if (xFilePick.isNotEmpty) {
      for (var i = 0; i < xFilePick.length; i++) {
        selectedImg.add(xFilePick[i].path);
      }
      setState(() {});
    }
    if (selectedImg.isNotEmpty) {
      List<String> images = [];
      images.addAll(selectedImg);
      setState(() {});
      var imagesUrl = await imageController.uploadMultiImageApi(context, images, 12);
      motorInsuranceController.selectedCustomsDeclaration.addAll(imagesUrl);
    }
    motorInsuranceController.isLoadingCustomsDeclaration.value = false;
    setState(() {});
  }

  void removeCustomsDeclarationImage(String item) async {
    var isSuccess = await imageController.removeUploadDocumentApi(context, item);
    if (isSuccess == 200 || isSuccess == 201) {
      motorInsuranceController.selectedCustomsDeclaration.remove(item);
    }
    setState(() {});
  }
}
