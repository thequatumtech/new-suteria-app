import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_inurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_geographical_area_model.dart';
import 'package:soperia_user/model_class/insuranceLimitPlanModel.dart';

class TravelInsuranceSecondScreen extends StatefulWidget {
  Function onNext;

  TravelInsuranceSecondScreen({super.key, required this.onNext});

  @override
  State<TravelInsuranceSecondScreen> createState() => _TravelInsuranceSecondScreenState();
}

class _TravelInsuranceSecondScreenState extends State<TravelInsuranceSecondScreen> {
  TravelInsuranceController travelInsuranceController = Get.put(TravelInsuranceController());

  @override
  void initState() {
    int? destId = travelInsuranceController.selectDestination.value.id;
    int? geoId = travelInsuranceController.selectGeographicalArea.value.id;
    if (travelInsuranceController.geoGraphicalAreaList.isEmpty) {
      travelInsuranceController.getGeographicalAreaApiMethod(context);
    }
    travelInsuranceController.getInsuranceLimit(
      context,
      '10',
      destinationCountryId: (destId != null && destId != 0) ? destId : null,
      geographicalAreaId: (geoId != null && geoId != 0) ? geoId : null,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => travelInsuranceController.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.only(top: 140),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CustomDropDownBorder1(
                      onchage: (newValue) {
                        setState(() {
                          GetCountryList cdl = travelInsuranceController.departureFromList.firstWhere((element) => element.id == newValue);
                          travelInsuranceController.selectDepartureFrom.value = cdl;
                          if (travelInsuranceController.selectDestination.value.id == newValue) {
                            travelInsuranceController.selectDestination.value = GetCountryList();
                            travelInsuranceController.selectedInsurancePlan.value = InsurancePlanName();
                            travelInsuranceController.insurancePlanList.clear();
                            travelInsuranceController.getInsuranceLimit(
                              context,
                              '10',
                              destinationCountryId: null,
                              geographicalAreaId: travelInsuranceController.selectGeographicalArea.value.id,
                            );
                          }
                        });
                      },
                      items: travelInsuranceController.departureFromList
                          .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                          .toList(),
                      selectedValue: travelInsuranceController.departureFromList.any((element) => element.id == travelInsuranceController.selectDepartureFrom.value.id)
                          ? travelInsuranceController.selectDepartureFrom.value.id ?? 0
                          : null,
                      dropdownTitle: departurefrom,
                    ),

                    CustomDropDownBorder1(
                      onchage: (newValue) {
                        setState(() {
                          GetCountryList cdl = travelInsuranceController.destinationList.firstWhere((element) => element.id == newValue);
                          travelInsuranceController.selectDestination.value = cdl;
                          travelInsuranceController.selectedInsurancePlan.value = InsurancePlanName();
                        });
                        travelInsuranceController.getInsuranceLimit(
                          context,
                          '10',
                          destinationCountryId: (newValue != null && newValue != 0) ? newValue : null,
                          geographicalAreaId: travelInsuranceController.selectGeographicalArea.value.id,
                        );
                      },
                      items: filteredDestinationList
                          .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                          .toList(),
                      selectedValue: filteredDestinationList.any((element) => element.id == travelInsuranceController.selectDestination.value.id)
                          ? travelInsuranceController.selectDestination.value.id ?? 0
                          : null,
                      dropdownTitle: "$selectYour $destination",
                    ),

                    ///

                    AppText(text: multipleDestination, size: 15),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: travelInsuranceController.selectedMultipleCountry,
                          onChanged: (value) {
                            setState(() {
                              travelInsuranceController.selectedMultipleCountry = value!;
                            });
                          },
                        ),
                        AppText(text: yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: travelInsuranceController.selectedMultipleCountry,
                          onChanged: (value) {
                            setState(() {
                              travelInsuranceController.selectedMultipleCountry = value!;
                            });
                          },
                        ),
                        AppText(text: noTxt),
                      ],
                    ),
                    travelInsuranceController.selectedMultipleCountry == yesTxt
                        ? MultiSelectDialogField<GetCountryList>(
                            items: travelInsuranceController.additionalDestinationList.map((e) => MultiSelectItem<GetCountryList>(e, getTranslated(context, e.name ?? ''))).toList(),
                            title: Text(getTranslated(context, selectMultipleDestination)),
                            confirmText: Text(getTranslated(context, "OK"), style: const TextStyle(color: blueShade1)),
                            cancelText: Text(getTranslated(context, "CANCEL"), style: const TextStyle(color: blueShade1)),
                            selectedColor: blueShade1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: blueShade1),
                            ),
                            buttonIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black,
                            ),
                            buttonText: Text(
                              getTranslated(context, selectMultipleDestination),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            onConfirm: (List<GetCountryList> selectedValues) {
                              travelInsuranceController.selectedMultiDestinationList.value = selectedValues;
                            },
                            initialValue: travelInsuranceController.selectedMultiDestinationList,
                          )
                        : const SizedBox(),

                    ///

                    const SizedBox(
                      height: 8,
                    ),

                    AppText(text: anyDangerousActivities, size: 15),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: yesTxt,
                          groupValue: travelInsuranceController.selectedDangerousActivity,
                          onChanged: (value) {
                            setState(() {
                              travelInsuranceController.selectedDangerousActivity = value!;
                            });
                          },
                        ),
                        AppText(text: yesTxt),
                        Radio(
                          value: noTxt,
                          groupValue: travelInsuranceController.selectedDangerousActivity,
                          onChanged: (value) {
                            setState(() {
                              travelInsuranceController.selectedDangerousActivitiesList.value = [];
                              travelInsuranceController.selectedDangerousActivity = value!;
                            });
                          },
                        ),
                        AppText(text: noTxt),
                      ],
                    ),
                    travelInsuranceController.selectedDangerousActivity == yesTxt
                        ? MultiSelectDialogField<GetDangerousActivitiesList>(
                            items: travelInsuranceController.getDangerousActivitiesList.map((e) => MultiSelectItem<GetDangerousActivitiesList>(e, getTranslated(context, e.name ?? ''))).toList(),
                            title: Text(getTranslated(context, dangerousActivities)),
                            confirmText: Text(getTranslated(context, "OK"), style: const TextStyle(color: blueShade1)),
                            cancelText: Text(getTranslated(context, "CANCEL"), style: const TextStyle(color: blueShade1)),
                            selectedColor: blueShade1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: skyBlueShade1),
                            ),
                            buttonIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black,
                            ),
                            buttonText: Text(
                              getTranslated(context, dangerousActivities),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            onConfirm: (List<GetDangerousActivitiesList> selectedValues) {
                              setState(() {
                                travelInsuranceController.selectedDangerousActivitiesList.value = selectedValues;
                              });
                            },
                            initialValue: travelInsuranceController.selectedDangerousActivitiesList,
                          )
                        : const SizedBox(),

                    CustomDropDownBorder1(
                      onchage: (newValue) {
                        setState(() {
                          GetGeographicalAreaList cdl = travelInsuranceController.geoGraphicalAreaList.firstWhere((element) => element.id == newValue);
                          travelInsuranceController.selectGeographicalArea.value = cdl;
                          travelInsuranceController.selectedInsurancePlan.value = InsurancePlanName();
                        });
                        travelInsuranceController.getInsuranceLimit(
                          context,
                          '10',
                          destinationCountryId: travelInsuranceController.selectDestination.value.id,
                          geographicalAreaId: (newValue != null && newValue != 0) ? newValue : null,
                        );
                      },
                      items: travelInsuranceController.geoGraphicalAreaList
                          .map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(getTranslated(context, item.name ?? ''), style: const TextStyle(fontSize: 15, color: primaryBlack))))
                          .toList(),
                      selectedValue: travelInsuranceController.geoGraphicalAreaList.any((element) => element.id == travelInsuranceController.selectGeographicalArea.value.id)
                          ? travelInsuranceController.selectGeographicalArea.value.id ?? 0
                          : null,
                      dropdownTitle: "$selectYour $geoarea",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextfield(
                      ontap: () {
                        effectiveDateDialog();
                      },
                      controller: travelInsuranceController.effectiveDateController.value,
                      width: 10,
                      readOnly: true,
                      hint: effectivedaate,
                      lable: effectivedaate,
                    ),
                    const SizedBox(height: 10),
                    AppTextfield(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      width: 10,
                      hint: noofdays,
                      lable: noofdays,
                      controller: travelInsuranceController.noOfDaysController.value,
                      onChange: () {
                        setExpiryDate();
                      },
                    ),
                    const SizedBox(height: 10),
                    AppTextfield(
                      width: 10,
                      controller: travelInsuranceController.expiryDateController.value,
                      hint: expiredaate,
                      lable: expiredaate,
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => travelInsuranceController.isLoadingInsuranceLimit.value
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            )
                          : CustomDropDownBorder1(
                              onchage: (newValue) {
                                setState(() {
                                  InsurancePlanName cdl = travelInsuranceController.insurancePlanList.firstWhere((element) => element.planName == newValue);
                                  travelInsuranceController.selectedInsurancePlan.value = cdl;
                                });
                              },
                              items: travelInsuranceController.insurancePlanList
                                   .map((e) => e.planName)
                                  .where((e) => e != null && e!.trim().isNotEmpty)
                                  .toSet() // remove duplicate planName
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(name!, style: const TextStyle(fontSize: 15, color: primaryBlack)),
                                      ))
                                  .toList(),
                              selectedValue: travelInsuranceController.insurancePlanList.any((element) => element.planName == travelInsuranceController.selectedInsurancePlan.value.planName)
                                  ? travelInsuranceController.selectedInsurancePlan.value.planName ?? 0
                                  : null,
                              dropdownTitle: '$selectYour $linsuranceplan',
                            ),
                    ),
                    AppBtnWithColorShades(
                      onTap: () {
                        if (travelInsuranceController.selectDepartureFrom.value.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDepartureFrom, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectDestination.value.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDestination, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectedMultipleCountry == null || travelInsuranceController.selectedMultipleCountry == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMultipleDestinationOption, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectedMultipleCountry == yesTxt && travelInsuranceController.selectedMultiDestinationList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectMultipleDestinationIfAny, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectedDangerousActivity == null || travelInsuranceController.selectedDangerousActivity == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesOptions, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectedDangerousActivity == yesTxt && travelInsuranceController.selectedDangerousActivitiesList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDangerousActivitiesList, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectGeographicalArea.value.id == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectGeographicalArea, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.effectiveDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.noOfDaysController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNumberOfTotalDays, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.expiryDateController.value.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
                        } else if (travelInsuranceController.selectedInsurancePlan.value.planName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsurancePlan, txtColor: primaryWhite, size: 12)));
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
      ),
    );
  }

  effectiveDateDialog() async {
    /* if (travelInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (travelInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        travelInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(travelInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        travelInsuranceController.initialDate.value = travelInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        travelInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      travelInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: travelInsuranceController.initialDate.value, //get today's date
      firstDate: travelInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      travelInsuranceController.initialDate.value = pickedDate;
      setState(() {
        travelInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate); //set foratted date to TextField value.
      });
      setExpiryDate();
    } else {
      print("Date is not selected");
    }
  }

  setExpiryDate() {
    if (travelInsuranceController.noOfDaysController.value.text.isNotEmpty) {
      DateTime effectiveDate = DateFormat('yyyy-MM-dd').parse(commonApiDateFormat(travelInsuranceController.effectiveDateController.value.text));
      DateTime finalDate = effectiveDate.add(Duration(days: int.parse(travelInsuranceController.noOfDaysController.value.text)));
      print(finalDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(finalDate);
      travelInsuranceController.expiryDateController.value.text = commonDateFormat(formattedDate);
    } else {
      travelInsuranceController.expiryDateController.value.clear();
    }
  }

  List<GetCountryList> get filteredDestinationList {
    final selectedDepartureId = travelInsuranceController.selectDepartureFrom.value.id;
    return travelInsuranceController.destinationList.where((item) => item.id != selectedDepartureId).toList();
  }
}
