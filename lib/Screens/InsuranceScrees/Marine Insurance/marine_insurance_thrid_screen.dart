import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_controller.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/app_textfileds.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/app_utils/custom_dropdown_button.dart';
import 'package:soperia_user/model_class/get_country_model.dart';
import 'package:soperia_user/model_class/get_dangerous_activities_model.dart';
import 'package:soperia_user/model_class/get_item_category_model.dart';
import 'package:soperia_user/model_class/get_item_subcategory_model.dart';
import 'package:soperia_user/model_class/get_type_cover_model.dart';
import 'package:soperia_user/model_class/insurance_limit_model.dart';

class MarineInsuranceThridScreen extends StatefulWidget {
  Function onNext;

  MarineInsuranceThridScreen({super.key, required this.onNext});

  @override
  State<MarineInsuranceThridScreen> createState() => _MarineInsuranceThridScreenState();
}

class _MarineInsuranceThridScreenState extends State<MarineInsuranceThridScreen> {
  MarineInsuranceController marineInsuranceController = Get.put(MarineInsuranceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    GetCountryList cdl = marineInsuranceController.voyageList.firstWhere((element) => element.id == newValue);
                    marineInsuranceController.selectVoyage.value = cdl;
                  });
                },
                items: marineInsuranceController.voyageList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: marineInsuranceController.voyageList.any((element) => element.id == marineInsuranceController.selectVoyage.value.id) ? marineInsuranceController.selectVoyage.value.id ?? 0 : null,
                dropdownTitle: marinevfrom,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    GetCountryList cdl = marineInsuranceController.throughCountryList.firstWhere((element) => element.id == newValue);
                    marineInsuranceController.selectThroughCountry.value = cdl;
                  });
                },
                items: marineInsuranceController.throughCountryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: marineInsuranceController.throughCountryList.any((element) => element.id == marineInsuranceController.selectThroughCountry.value.id) ? marineInsuranceController.selectThroughCountry.value.id ?? 0 : null,
                dropdownTitle: marinecountery,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    GetCountryList cdl = marineInsuranceController.finalDestinationCountryList.firstWhere((element) => element.id == newValue);
                    marineInsuranceController.selectFinalDestinationCountry.value = cdl;
                  });
                },
                items: marineInsuranceController.finalDestinationCountryList.map((item) => DropdownMenuItem(value: item.id ?? 0, child: Text(item.name ?? '', style: TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: marineInsuranceController.finalDestinationCountryList.any((element) => element.id == marineInsuranceController.selectFinalDestinationCountry.value.id) ? marineInsuranceController.selectFinalDestinationCountry.value.id ?? 0 : null,
                dropdownTitle: marinefdestination,
              ),



              Row(
                children: [
                  Expanded(child: AppText(text: goodsTransShippedThirdCountry, size: 15)),
                  IconButton(onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            contentPadding: EdgeInsetsDirectional.all(20),
                           /* title:  Text(verificationCode),*/
                            content: Text(goodsTransShippedThirdCountryLoadedAgain,style: TextStyle(fontSize: 16),),
                          );
                        });
                  }, icon:const Icon(Icons.info_outline))
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: marineInsuranceController.selectedMultipleCountry,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedMultipleCountry = value!;
                      });
                    },
                  ),
                  const Text(yesTxt),
                  Radio(
                    value: noTxt,
                    groupValue: marineInsuranceController.selectedMultipleCountry,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedMultipleCountry = value!;
                      });
                    },
                  ),
                  const Text(noTxt),
                ],
              ),
              marineInsuranceController.selectedMultipleCountry == yesTxt
                  ? MultiSelectDialogField<GetCountryList>(
                items: marineInsuranceController.additionalDestinationList
                    .map((e) => MultiSelectItem<GetCountryList>(e, e.name ?? ''))
                    .toList(),
                title: const Text(selectccountry),
                selectedColor: blueShade1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: blueShade1),
                ),
                buttonIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                buttonText: const Text(
                  selectccountry,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onConfirm: (List<GetCountryList> selectedValues) {
                  marineInsuranceController.selectedMultiDestinationList.value = selectedValues;
                },
                initialValue: marineInsuranceController.selectedMultiDestinationList.value,
              )
                  : const SizedBox(),



              const SizedBox(height: 8,),

              AppText(text: areYouShippingDangerousGoods, size: 15),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: marineInsuranceController.selectedDangerousActivity,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedDangerousActivity = value!;
                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: dangerousGoodsErrorMSG, txtColor: primaryWhite, size: 12)));

                      });
                    },
                  ),
                  const Text(yesTxt),
                  Radio(
                    value: noTxt,
                    groupValue: marineInsuranceController.selectedDangerousActivity,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedDangerousActivity = value!;

                       /* if(marineInsuranceController.selectedDangerousActivity ==yesTxt){
                        }*/

                      });
                    },
                  ),
                  const Text(noTxt),
                ],
              ),
             /* marineInsuranceController.selectedDangerousActivity == yesTxt
                  ? *//*MultiSelectDialogField<GetDangerousActivitiesList>(
                items: marineInsuranceController.getDangerousActivitiesList
                    .map((e) => MultiSelectItem<GetDangerousActivitiesList>(e, e.name ?? ''))
                    .toList(),
                title: const Text(dangerousActivities),
                selectedColor: blueShade1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: blueShade1),
                ),
                buttonIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                buttonText: const Text(
                  dangerousActivities,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onConfirm: (List<GetDangerousActivitiesList> selectedValues) {
                  marineInsuranceController.selectedDangerousActivitiesList.value = selectedValues;
                },
                initialValue: marineInsuranceController.selectedDangerousActivitiesList.value,
              )*//*
              AppText(
                text: dangerousGoodsErrorMSG,
                size: 14,
                txtColor: redShade2,
              )

              *//*AppTextfield(
                *//**//*ontap: () {
                  effectiveDateDialog();
                },*//**//*
                controller: marineInsuranceController.dangerousGoodsController.value,
                width: 10,
                hint: areYouShippingDangerousGoods,
                lable: areYouShippingDangerousGoods,

              )*//*


                  : const SizedBox(),
        const SizedBox(height: 10),*/




              CustomDropDownBorder(
                onchage: (newValue) {
                  setState(() {
                    marineInsuranceController.selectTypeTransportation = newValue!;
                  });
                },
                items: const [airFreight, seaFreight, landTransit],
                selectedValue: marineInsuranceController.selectTypeTransportation,
                dropdownTitle: marinetypeoftransportation,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    TypeCover cdl = marineInsuranceController.typeCoverList.firstWhere((element) => element.name == newValue);
                    marineInsuranceController.selectedTypeCover.value = cdl;
                  });
                },
                items: marineInsuranceController.typeCoverList.map((item) => DropdownMenuItem(value: item.name ?? 0, child: Text(item.name.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: marineInsuranceController.typeCoverList.any((element) => element.name == marineInsuranceController.selectedTypeCover.value.name) ? marineInsuranceController.selectedTypeCover.value.name ?? 0 : null,
                dropdownTitle: marinetypeofcover,
              ),
              CustomDropDownBorder1(
                onchage: (newValue) {
                  setState(() {
                    ItemCategory cdl = marineInsuranceController.itemCategoryList.firstWhere((element) => element.name == newValue);
                    marineInsuranceController.selectedItemCategory.value = cdl;
                    marineInsuranceController.getItemSubcategoryApi(context, cdl.id ?? 0);
                  });
                },
                items: marineInsuranceController.itemCategoryList.map((item) => DropdownMenuItem(value: item.name ?? 0, child: Text(item.name.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                selectedValue: marineInsuranceController.itemCategoryList.any((element) => element.name == marineInsuranceController.selectedItemCategory.value.name) ? marineInsuranceController.selectedItemCategory.value.name ?? 0 : null,
                dropdownTitle: marinecategoryofitem,
              ),
              marineInsuranceController.isLoadingItemSubcategory.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomDropDownBorder1(
                      onchage: (newValue) {
                        setState(() {
                          ItemSubcategory cdl = marineInsuranceController.itemSubcategoryList.firstWhere((element) => element.name == newValue);
                          marineInsuranceController.selectedItemSubcategory.value = cdl;
                          marineInsuranceController.getInsuranceLimit(context, '11', marineInsuranceController.selectedTypeCover.value.id ?? 0, marineInsuranceController.selectedItemCategory.value.id ?? 0, marineInsuranceController.selectedItemSubcategory.value.id ?? 0);
                        });
                      },
                      items: marineInsuranceController.itemSubcategoryList.map((item) => DropdownMenuItem(value: item.name ?? 0, child: Text(item.name.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                      selectedValue: marineInsuranceController.itemSubcategoryList.any((element) => element.name == marineInsuranceController.selectedItemSubcategory.value.name) ? marineInsuranceController.selectedItemSubcategory.value.name ?? 0 : null,
                      dropdownTitle: marinesubcategoryofitem,
                    ),
              marineInsuranceController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomDropDownBorder1(
                      onchage: (newValue) {
                        setState(() {
                          InsuranceLimitListData cdl = marineInsuranceController.insuranceLimitList.firstWhere((element) => element.limit == newValue);
                          marineInsuranceController.selectedInsuranceLimit.value = cdl;
                        });
                      },
                      items: marineInsuranceController.insuranceLimitList.map((item) => DropdownMenuItem(value: item.limit ?? 0, child: Text(item.limit.toString() ?? '0', style: const TextStyle(fontSize: 15, color: primaryBlack)))).toList(),
                      selectedValue: marineInsuranceController.insuranceLimitList.any((element) => element.limit == marineInsuranceController.selectedInsuranceLimit.value.limit) ? marineInsuranceController.selectedInsuranceLimit.value.limit ?? 0 : null,
                      dropdownTitle: marinebill,
                    ),
              const SizedBox(height: 10),
              AppTextfield(
                width: 10,
                hint: marinebillno,
                lable: marinebillno,
                controller: marineInsuranceController.billNoOrLadingNoController.value,
              ),
              const SizedBox(height: 10),
              AppTextfield(
                ontap: () {
                  effectiveDateDialog();
                },
                controller: marineInsuranceController.effectiveDateController.value,
                width: 10,
                hint: effectivedaate,
                lable: effectivedaate,
                readOnly: true,
              ),
              const SizedBox(height: 10),
              AppTextfield(
                controller: marineInsuranceController.expiryDateController.value,
                width: 10,
                hint: expiredaate,
                lable: expiredaate,
                readOnly: true,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              AppTextfield(
                width: 10,
                hint: marineinsureditem,
                lable: marineinsureditem,
                controller: marineInsuranceController.noOfInsuredItemController.value,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.topLeft,
                child: AppText(
                  text: marineq4,
                  size: 15,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: marineInsuranceController.selectedExistingInsurancePolicyOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedExistingInsurancePolicyOption = value!;
                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: dangerousGoodsErrorMSG, txtColor: primaryWhite, size: 12)));
                      });
                    },
                  ),
                  const Text(yesTxt),
                  Radio(
                    value: noTxt,
                    groupValue: marineInsuranceController.selectedExistingInsurancePolicyOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedExistingInsurancePolicyOption = value!;
                      });
                    },
                  ),
                  const Text(noTxt),
                ],
              ),
           /*   if (marineInsuranceController.selectedExistingInsurancePolicyOption == yesTxt)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    AppTextfield(
                      controller: marineInsuranceController.nameOfInsuranceCompanyAndExpiryController.value,
                      hint: homen1,
                      lable: homen1,
                    ),
                  ],
                ),*/
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: AppText(
                  text: mariq4,
                  size: 15,
                ),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption = value!;
                      });
                    },
                  ),
                  const Text(yesTxt),
                  Radio(
                    value: noTxt,
                    groupValue: marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption = value!;
                      });
                    },
                  ),
                  const Text(noTxt),
                ],
              ),
              if (marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption == yesTxt)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    AppTextfield(
                      maxLine: 2,
                      controller: marineInsuranceController.whyAnInsuranceCompanyDeclinedToIssueController.value,
                      hint: pleaseWriteAnInsuranceCompany,
                      lable: pleaseWriteAnInsuranceCompany,
                    ),
                  ],
                ),
              Align(
                alignment: Alignment.topLeft,
                child: AppText(
                  text: homeq3,
                  size: 15,
                ),
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: yesTxt,
                    groupValue: marineInsuranceController.selectedClaimsAccidentsInPastYearOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedClaimsAccidentsInPastYearOption = value!;
                      });
                    },
                  ),
                  const Text(yesTxt),
                  Radio(
                    value: noTxt,
                    groupValue: marineInsuranceController.selectedClaimsAccidentsInPastYearOption,
                    onChanged: (value) {
                      setState(() {
                        marineInsuranceController.selectedClaimsAccidentsInPastYearOption = value!;
                      });
                    },
                  ),
                  const Text(noTxt),
                ],
              ),
              if (marineInsuranceController.selectedClaimsAccidentsInPastYearOption == yesTxt)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    AppTextfield(
                      controller: marineInsuranceController.writeInDetailsClaimAccidentController.value,
                      hint: homen3,
                      lable: homen3,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
             /* marineInsuranceController.selectedDangerousActivity == yesTxt||marineInsuranceController.selectedExistingInsurancePolicyOption == yesTxt
                  ?  AppText(
                text: dangerousGoodsErrorMSG,
                size: 25,
                txtColor: redShade2,
              ):*/AppBtnWithColorShades(
                onTap: () {
                  if (checkValidations()) {
                   /* print("object  ?????????????");*/
                  } else {
                    widget.onNext(marineInsuranceController.selectedExistingInsurancePolicyOption == yesTxt);
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
   /* if (marineInsuranceController.getInsuranceCurrentModel.value.data != null) {
      if (marineInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate != null ) {
        marineInsuranceController.initialDate.value = DateFormat('yyyy-MM-dd').parse(marineInsuranceController.getInsuranceCurrentModel.value.data!.expiryDate ?? '');
        marineInsuranceController.initialDate.value = marineInsuranceController.initialDate.value.add(const Duration(days: 1));
      } else {
        marineInsuranceController.initialDate.value = DateTime.now();
      }
    } else {
      marineInsuranceController.initialDate.value = DateTime.now();
    }*/
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: marineInsuranceController.initialDate.value, //get today's date
      firstDate: marineInsuranceController.initialDate.value, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      marineInsuranceController.initialDate.value=pickedDate;
      marineInsuranceController.effectiveDateController.value.text = commonDateFormat(formattedDate);
      marineInsuranceController.expiryDateController.value.text = commonDateFormat(DateFormat("yyyy-MM-dd").format(DateTime.parse(DateTime.parse(DateFormat("yyyy-MM-dd").format(pickedDate)).add(const Duration(days: 60)).toString())));
      setState(() {});
    } else {
      print("Date is not selected");
    }
  }

  bool checkValidations() {
    if (marineInsuranceController.selectVoyage.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectVoyageFrom, txtColor: primaryWhite, size: 12)));
      return true;
    } /*else if (marineInsuranceController.selectThroughCountry.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectThroughCountry, txtColor: primaryWhite, size: 12)));
      return true;
    }*/ else if (marineInsuranceController.selectFinalDestinationCountry.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectFinalDestinationCountry, txtColor: primaryWhite, size: 12)));
      return true;
    }
    else if (marineInsuranceController.selectedDangerousActivity==null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterShippingDGoods, txtColor: primaryWhite, size: 12)));
      return true;
    }
    else if (marineInsuranceController.selectTypeTransportation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectTypeOfTransportation, txtColor: primaryWhite, size: 12)));
      return true;
    }

    else if (marineInsuranceController.selectedMultipleCountry == yesTxt) {
     if(marineInsuranceController.selectedMultiDestinationList.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: AppText(text: pleaseSelectOneTransShipmentCountry, txtColor: primaryWhite, size: 12)));
       return true;
     }
    }

    else if (marineInsuranceController.selectedTypeCover.value.name == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectTypeOfCover, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedItemCategory.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectCategoryOfInsuredItem, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedItemSubcategory.value.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectSubCategoryOfInsuredItem, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedInsuranceLimit.value.limit == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectInsuredLimitCoverageAmount, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.billNoOrLadingNoController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterBillBillOfLadingNo, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.effectiveDateController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectEffectiveDate, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.expiryDateController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectExpiryDate, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.noOfInsuredItemController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNoOfInsuredItem, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedExistingInsurancePolicyOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDoYouHaveAnExistingQuestion, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedExistingInsurancePolicyOption == yesTxt && marineInsuranceController.nameOfInsuranceCompanyAndExpiryController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterNameOfInsuranceCompanyAndExpiryDate, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectHasAnyInsuranceCompanyQuestion, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedInsuranceCompanyDeclinedToIssueOption == yesTxt && marineInsuranceController.whyAnInsuranceCompanyDeclinedToIssueController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterWhyAnInsuranceCompanyDeclinedToIssue, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedClaimsAccidentsInPastYearOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseSelectDidYouHaveAnyClaimsQuestion, txtColor: primaryWhite, size: 12)));
      return true;
    } else if (marineInsuranceController.selectedClaimsAccidentsInPastYearOption == yesTxt && marineInsuranceController.writeInDetailsClaimAccidentController.value.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: pleaseEnterClaimAccidentType, txtColor: primaryWhite, size: 12)));
      return true;
    }
    return false;
  }
}
