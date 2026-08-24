class GetPersonalAccidentInsuranceModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  GetPersonalAccidentInsuranceModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  GetPersonalAccidentInsuranceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'] != null ? int.tryParse(json['status_code'].toString()) : null;
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['status'] = status;
    dataMap['status_code'] = statusCode;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class Data {
  int? id;
  int? insuranceCompanyId;
  int? lineOfBusinessId;
  String? planName;
  int? policyPeriod;
  int? insurancePeriodId;
  String? insurancePolicyText;
  String? insurancePolicyPdf;
  String? restrictedCountryIds;
  String? restrictedCityIds;
  String? restrictedDistrictIds;
  String? restrictedAgeIds;
  String? restrictedOccupationIds;
  String? limit;
  double? netPremium;
  double? fees;
  double? stamps;
  double? salesTax;
  String? cbj;
  String? salesTaxCbj;
  double? grossPremium;
  double? commissionPercentage;
  double? commissionAmount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? restrictedDangerousActivitiesIds;
  int? clientAge;
  int? insurancePeriodMonths;
  double? pricingRate;
  double? feesAmount;
  double? stampsAmount;
  double? salesTaxAmount;
  double? cbjAmount;
  double? salesTaxCbjAmount;
  List<PricingSchedule>? pricingSchedule;
  List<PolicyCovers>? policyCovers;
  InsuranceCompany? insuranceCompany;

  Data({
    this.id,
    this.insuranceCompanyId,
    this.lineOfBusinessId,
    this.planName,
    this.policyPeriod,
    this.insurancePeriodId,
    this.insurancePolicyText,
    this.insurancePolicyPdf,
    this.restrictedCountryIds,
    this.restrictedCityIds,
    this.restrictedDistrictIds,
    this.restrictedAgeIds,
    this.restrictedOccupationIds,
    this.limit,
    this.netPremium,
    this.fees,
    this.stamps,
    this.salesTax,
    this.cbj,
    this.salesTaxCbj,
    this.grossPremium,
    this.commissionPercentage,
    this.commissionAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.restrictedDangerousActivitiesIds,
    this.clientAge,
    this.insurancePeriodMonths,
    this.pricingRate,
    this.feesAmount,
    this.stampsAmount,
    this.salesTaxAmount,
    this.cbjAmount,
    this.salesTaxCbjAmount,
    this.pricingSchedule,
    this.policyCovers,
    this.insuranceCompany,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    insuranceCompanyId = json['insurance_company_id'] != null ? int.tryParse(json['insurance_company_id'].toString()) : null;
    lineOfBusinessId = json['line_of_business_id'] != null ? int.tryParse(json['line_of_business_id'].toString()) : null;
    planName = json['plan_name']?.toString();
    policyPeriod = json['policy_period'] != null ? int.tryParse(json['policy_period'].toString()) : null;
    insurancePeriodId = json['insurance_period_id'] != null ? int.tryParse(json['insurance_period_id'].toString()) : null;
    insurancePolicyText = json['insurance_policy_text']?.toString();
    insurancePolicyPdf = json['insurance_policy_pdf']?.toString();
    restrictedCountryIds = json['restricted_country_ids']?.toString();
    restrictedCityIds = json['restricted_city_ids']?.toString();
    restrictedDistrictIds = json['restricted_district_ids']?.toString();
    restrictedAgeIds = json['restricted_age_ids']?.toString();
    restrictedOccupationIds = json['restricted_occupation_ids']?.toString();
    limit = json['limit']?.toString();
    netPremium = json['net_premium'] != null ? double.tryParse(json['net_premium'].toString()) : 0.0;
    fees = json['fees'] != null ? double.tryParse(json['fees'].toString()) : 0.0;
    stamps = json['stamps'] != null ? double.tryParse(json['stamps'].toString()) : 0.0;
    salesTax = json['sales_tax'] != null ? double.tryParse(json['sales_tax'].toString()) : 0.0;
    cbj = json['cbj']?.toString();
    salesTaxCbj = json['sales_tax_cbj']?.toString();
    grossPremium = json['gross_premium'] != null ? double.tryParse(json['gross_premium'].toString()) : 0.0;
    commissionPercentage = json['commission_percentage'] != null ? double.tryParse(json['commission_percentage'].toString()) : 0.0;
    commissionAmount = json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : 0.0;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    restrictedDangerousActivitiesIds = json['restricted_dangerous_activities_ids']?.toString();
    clientAge = json['client_age'] != null ? int.tryParse(json['client_age'].toString()) : null;
    insurancePeriodMonths = json['insurance_period_months'] != null ? int.tryParse(json['insurance_period_months'].toString()) : null;
    pricingRate = json['pricing_rate'] != null ? double.tryParse(json['pricing_rate'].toString()) : null;
    feesAmount = json['fees_amount'] != null ? double.tryParse(json['fees_amount'].toString()) : null;
    stampsAmount = json['stamps_amount'] != null ? double.tryParse(json['stamps_amount'].toString()) : null;
    salesTaxAmount = json['sales_tax_amount'] != null ? double.tryParse(json['sales_tax_amount'].toString()) : null;
    cbjAmount = json['cbj_amount'] != null ? double.tryParse(json['cbj_amount'].toString()) : null;
    salesTaxCbjAmount = json['sales_tax_cbj_amount'] != null ? double.tryParse(json['sales_tax_cbj_amount'].toString()) : null;

    if (json['pricing_schedule'] != null) {
      pricingSchedule = <PricingSchedule>[];
      json['pricing_schedule'].forEach((v) {
        pricingSchedule!.add(PricingSchedule.fromJson(v));
      });
    }

    if (json['policy_covers'] != null) {
      policyCovers = <PolicyCovers>[];
      json['policy_covers'].forEach((v) {
        policyCovers!.add(PolicyCovers.fromJson(v));
      });
    }

    insuranceCompany = json['insurance_company'] != null
        ? InsuranceCompany.fromJson(json['insurance_company'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['insurance_company_id'] = insuranceCompanyId;
    dataMap['line_of_business_id'] = lineOfBusinessId;
    dataMap['plan_name'] = planName;
    dataMap['policy_period'] = policyPeriod;
    dataMap['insurance_period_id'] = insurancePeriodId;
    dataMap['insurance_policy_text'] = insurancePolicyText;
    dataMap['insurance_policy_pdf'] = insurancePolicyPdf;
    dataMap['restricted_country_ids'] = restrictedCountryIds;
    dataMap['restricted_city_ids'] = restrictedCityIds;
    dataMap['restricted_district_ids'] = restrictedDistrictIds;
    dataMap['restricted_age_ids'] = restrictedAgeIds;
    dataMap['restricted_occupation_ids'] = restrictedOccupationIds;
    dataMap['limit'] = limit;
    dataMap['net_premium'] = netPremium;
    dataMap['fees'] = fees;
    dataMap['stamps'] = stamps;
    dataMap['sales_tax'] = salesTax;
    dataMap['cbj'] = cbj;
    dataMap['sales_tax_cbj'] = salesTaxCbj;
    dataMap['gross_premium'] = grossPremium;
    dataMap['commission_percentage'] = commissionPercentage;
    dataMap['commission_amount'] = commissionAmount;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    dataMap['restricted_dangerous_activities_ids'] = restrictedDangerousActivitiesIds;
    dataMap['client_age'] = clientAge;
    dataMap['insurance_period_months'] = insurancePeriodMonths;
    dataMap['pricing_rate'] = pricingRate;
    dataMap['fees_amount'] = feesAmount;
    dataMap['stamps_amount'] = stampsAmount;
    dataMap['sales_tax_amount'] = salesTaxAmount;
    dataMap['cbj_amount'] = cbjAmount;
    dataMap['sales_tax_cbj_amount'] = salesTaxCbjAmount;

    if (pricingSchedule != null) {
      dataMap['pricing_schedule'] = pricingSchedule!.map((v) => v.toJson()).toList();
    }
    if (policyCovers != null) {
      dataMap['policy_covers'] = policyCovers!.map((v) => v.toJson()).toList();
    }
    if (insuranceCompany != null) {
      dataMap['insurance_company'] = insuranceCompany!.toJson();
    }
    return dataMap;
  }
}

class PricingSchedule {
  int? id;
  int? personalAccidentPlanId;
  int? age;
  dynamic jsonData;
  String? m1;
  String? m2;
  String? m3;
  String? m4;
  String? m5;
  String? m6;
  String? m7;
  String? m8;
  String? m9;
  String? m10;
  String? m11;
  String? m12;
  String? m45;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PricingSchedule({
    this.id,
    this.personalAccidentPlanId,
    this.age,
    this.jsonData,
    this.m1,
    this.m2,
    this.m3,
    this.m4,
    this.m5,
    this.m6,
    this.m7,
    this.m8,
    this.m9,
    this.m10,
    this.m11,
    this.m12,
    this.m45,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  PricingSchedule.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    personalAccidentPlanId = json['personal_accident_plan_id'] != null
        ? int.tryParse(json['personal_accident_plan_id'].toString())
        : null;
    age = json['age'] != null ? int.tryParse(json['age'].toString()) : null;
    jsonData = json['json_data'];
    m1 = json['m_1']?.toString();
    m2 = json['m_2']?.toString();
    m3 = json['m_3']?.toString();
    m4 = json['m_4']?.toString();
    m5 = json['m_5']?.toString();
    m6 = json['m_6']?.toString();
    m7 = json['m_7']?.toString();
    m8 = json['m_8']?.toString();
    m9 = json['m_9']?.toString();
    m10 = json['m_10']?.toString();
    m11 = json['m_11']?.toString();
    m12 = json['m_12']?.toString();
    m45 = json['m_45']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['personal_accident_plan_id'] = personalAccidentPlanId;
    dataMap['age'] = age;
    dataMap['json_data'] = jsonData;
    dataMap['m_1'] = m1;
    dataMap['m_2'] = m2;
    dataMap['m_3'] = m3;
    dataMap['m_4'] = m4;
    dataMap['m_5'] = m5;
    dataMap['m_6'] = m6;
    dataMap['m_7'] = m7;
    dataMap['m_8'] = m8;
    dataMap['m_9'] = m9;
    dataMap['m_10'] = m10;
    dataMap['m_11'] = m11;
    dataMap['m_12'] = m12;
    dataMap['m_45'] = m45;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    return dataMap;
  }
}

class PolicyCovers {
  int? id;
  int? personalAccidentPlanId;
  String? coverName;
  String? coverLimit;
  String? coverLimitType;
  String? coverDeductible;
  String? coverDeductibleType;
  double? coverPremium;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PolicyCovers({
    this.id,
    this.personalAccidentPlanId,
    this.coverName,
    this.coverLimit,
    this.coverLimitType,
    this.coverDeductible,
    this.coverDeductibleType,
    this.coverPremium,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  PolicyCovers.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    personalAccidentPlanId = json['personal_accident_plan_id'] != null
        ? int.tryParse(json['personal_accident_plan_id'].toString())
        : null;
    coverName = json['cover_name']?.toString();
    coverLimit = json['cover_limit']?.toString();
    coverLimitType = json['cover_limit_type']?.toString();
    coverDeductible = json['cover_deductible']?.toString();
    coverDeductibleType = json['cover_deductible_type']?.toString();
    coverPremium = json['cover_premium'] != null
        ? double.tryParse(json['cover_premium'].toString())
        : 0.0;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['personal_accident_plan_id'] = personalAccidentPlanId;
    dataMap['cover_name'] = coverName;
    dataMap['cover_limit'] = coverLimit;
    dataMap['cover_limit_type'] = coverLimitType;
    dataMap['cover_deductible'] = coverDeductible;
    dataMap['cover_deductible_type'] = coverDeductibleType;
    dataMap['cover_premium'] = coverPremium;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    return dataMap;
  }
}

class InsuranceCompany {
  int? id;
  String? companyName;
  String? lineOfBusinessId;
  String? nationalId;
  String? registerNumber;
  String? taxNumber;
  String? email;
  String? email1;
  String? email2;
  String? claimEmail;
  String? mobileNumber;
  String? telephoneNumber;
  String? joiningDate;
  int? countryId;
  int? cityId;
  int? districtId;
  String? streetName;
  String? buildingNo;
  String? privacyPolicy;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  InsuranceCompany({
    this.id,
    this.companyName,
    this.lineOfBusinessId,
    this.nationalId,
    this.registerNumber,
    this.taxNumber,
    this.email,
    this.email1,
    this.email2,
    this.claimEmail,
    this.mobileNumber,
    this.telephoneNumber,
    this.joiningDate,
    this.countryId,
    this.cityId,
    this.districtId,
    this.streetName,
    this.buildingNo,
    this.privacyPolicy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  InsuranceCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    companyName = json['company_name']?.toString();
    lineOfBusinessId = json['line_of_business_id']?.toString();
    nationalId = json['national_id']?.toString();
    registerNumber = json['register_number']?.toString();
    taxNumber = json['tax_number']?.toString();
    email = json['email']?.toString();
    email1 = json['email_1']?.toString();
    email2 = json['email_2']?.toString();
    claimEmail = json['claim_email']?.toString();
    mobileNumber = json['mobile_number']?.toString();
    telephoneNumber = json['telephone_number']?.toString();
    joiningDate = json['joining_date']?.toString();
    countryId = json['country_id'] != null ? int.tryParse(json['country_id'].toString()) : null;
    cityId = json['city_id'] != null ? int.tryParse(json['city_id'].toString()) : null;
    districtId = json['district_id'] != null ? int.tryParse(json['district_id'].toString()) : null;
    streetName = json['street_name']?.toString();
    buildingNo = json['building_no']?.toString();
    privacyPolicy = json['privacy_policy']?.toString();
    status = json['status'] != null ? int.tryParse(json['status'].toString()) : null;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['company_name'] = companyName;
    dataMap['line_of_business_id'] = lineOfBusinessId;
    dataMap['national_id'] = nationalId;
    dataMap['register_number'] = registerNumber;
    dataMap['tax_number'] = taxNumber;
    dataMap['email'] = email;
    dataMap['email_1'] = email1;
    dataMap['email_2'] = email2;
    dataMap['claim_email'] = claimEmail;
    dataMap['mobile_number'] = mobileNumber;
    dataMap['telephone_number'] = telephoneNumber;
    dataMap['joining_date'] = joiningDate;
    dataMap['country_id'] = countryId;
    dataMap['city_id'] = cityId;
    dataMap['district_id'] = districtId;
    dataMap['street_name'] = streetName;
    dataMap['building_no'] = buildingNo;
    dataMap['privacy_policy'] = privacyPolicy;
    dataMap['status'] = status;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['deleted_at'] = deletedAt;
    return dataMap;
  }
}
