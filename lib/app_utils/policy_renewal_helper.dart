import 'package:flutter/material.dart';
import 'package:soperia_user/Screens/InsuranceScrees/AutoMotiveInsurance/automotive_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Critical%20Illness%20Insurance/critical_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Dental%20Insurance/dental_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/HomeInsurance/home_insurance_step.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20Family/individual_family_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Individual%20Medical%20Insurance/Individual%20Medical%20Insurance%20personal/individual_personal_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Life%20Insurance/life_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Marine%20Insurance/marine_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/OfficeInsurance/office_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Personal%20Accidents%20Insurance/personal_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Pet%20Insurance/pet_insurance_stepper.dart';
import 'package:soperia_user/Screens/InsuranceScrees/Travel%20Insurance/travel_insurance_stepper.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';

Widget? getLOBStepWidget(PolicyData policyData) {
  final String pType = (policyData.policyType ?? '').toLowerCase().trim();
  final int? pTypeNo = policyData.policyTypeNo;

  if (pTypeNo != null && pTypeNo > 0) {
    switch (pTypeNo) {
      case 1:
        return const IndividualFamilyInsuranceStep();
      case 2:
        return const IndividualPersonalInsuranceStep();
      case 3:
        return const LifeInsuranceStep();
      case 4:
        return const HomeInsuranceStep();
      case 5:
        return const PersonalInsuranceStep();
      case 6:
        return const TravelInsuranceStep();
      case 7:
        return const MarineInsuranceStep();
      case 8:
        return const AutomotiveInsuranceStep();
      case 9:
        return const OfficeInsuranceStep();
      case 10:
        return const CriticalInsuranceStep();
      case 11:
        return const PetInsuranceStep();
      case 12:
        return const DentalInsuranceStep();
    }
  }

  if (pType.contains('family')) {
    return const IndividualFamilyInsuranceStep();
  } else if (pType.contains('individual') || (pType.contains('medical') && !pType.contains('family'))) {
    return const IndividualPersonalInsuranceStep();
  } else if (pType.contains('life')) {
    return const LifeInsuranceStep();
  } else if (pType.contains('home')) {
    return const HomeInsuranceStep();
  } else if (pType.contains('personal') || pType.contains('accident')) {
    return const PersonalInsuranceStep();
  } else if (pType.contains('travel')) {
    return const TravelInsuranceStep();
  } else if (pType.contains('marine')) {
    return const MarineInsuranceStep();
  } else if (pType.contains('auto') || pType.contains('motor') || pType.contains('car') || pType.contains('vehicle')) {
    return const AutomotiveInsuranceStep();
  } else if (pType.contains('office')) {
    return const OfficeInsuranceStep();
  } else if (pType.contains('critical')) {
    return const CriticalInsuranceStep();
  } else if (pType.contains('pet')) {
    return const PetInsuranceStep();
  } else if (pType.contains('dental')) {
    return const DentalInsuranceStep();
  }

  return null;
}

void renewPolicy(BuildContext context, PolicyData policyData) {
  Widget? targetScreen = getLOBStepWidget(policyData);
  if (targetScreen != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => targetScreen,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          text: 'Line of business screen not found for this policy.',
          txtColor: primaryWhite,
          size: 12,
        ),
      ),
    );
  }
}
