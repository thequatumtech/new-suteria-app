class HomeInsurancePlaneModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  HomeInsurancePlaneModel(
      {this.status, this.statusCode, this.message, this.data});

  HomeInsurancePlaneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  double? insuranceCompanyId;
  double? lineOfBusinessId;
  String? planName;
  String? startDate;
  String? endDate;
  String? insurancePolicyText;
  String? insurancePolicyPdf;
  String? restrictedCountryIds;
  String? restrictedCityIds;
  String? restrictedDistrictIds;
  String? restrictedAgeIds;
  String? limit;
  double? netPremium;
  double? fees;
  double? stamps;
  double? salesTax;
  double? grossPremium;
  double? commissionPercentage;
  double? commissionAmount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<PolicyCovers>? policyCovers;
  InsuranceCompany? insuranceCompany;

  Data(
      {this.id,
        this.insuranceCompanyId,
        this.lineOfBusinessId,
        this.planName,
        this.startDate,
        this.endDate,
        this.insurancePolicyText,
        this.insurancePolicyPdf,
        this.restrictedCountryIds,
        this.restrictedCityIds,
        this.restrictedDistrictIds,
        this.restrictedAgeIds,
        this.limit,
        this.netPremium,
        this.fees,
        this.stamps,
        this.salesTax,
        this.grossPremium,
        this.commissionPercentage,
        this.commissionAmount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.policyCovers,
        this.insuranceCompany});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insuranceCompanyId = json['insurance_company_id']!= null ? double.parse(json['insurance_company_id'].toString()) : 0;
    lineOfBusinessId = json['line_of_business_id']!= null ? double.parse(json['line_of_business_id'].toString()) : 0;
    planName = json['plan_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    insurancePolicyText = json['insurance_policy_text'];
    insurancePolicyPdf = json['insurance_policy_pdf'];
    restrictedCountryIds = json['restricted_country_ids'];
    restrictedCityIds = json['restricted_city_ids'];
    restrictedDistrictIds = json['restricted_district_ids'];
    restrictedAgeIds = json['restricted_age_ids'];
    limit = json['limit'].toString()??'';
    netPremium = json['net_premium']!= null ? double.parse(json['net_premium'].toString()) : 0;
    fees = json['fees']!= null ? double.parse(json['fees'].toString()) : 0;
    stamps = json['stamps']!= null ? double.parse(json['stamps'].toString()) : 0;
    salesTax = json['sales_tax']!= null ? double.parse(json['sales_tax'].toString()) : 0;
    grossPremium = json['gross_premium']!= null ? double.parse(json['gross_premium'].toString()) : 0;
    commissionPercentage = json['commission_percentage']!= null ? double.parse(json['commission_percentage'].toString()) : 0;
    commissionAmount = json['commission_amount']!= null ? double.parse(json['commission_amount'].toString()) : 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['policy_covers'] != null) {
      policyCovers = <PolicyCovers>[];
      json['policy_covers'].forEach((v) {
        policyCovers!.add(new PolicyCovers.fromJson(v));
      });
    }
    insuranceCompany = json['insurance_company'] != null
        ? new InsuranceCompany.fromJson(json['insurance_company'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['line_of_business_id'] = this.lineOfBusinessId;
    data['plan_name'] = this.planName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['insurance_policy_text'] = this.insurancePolicyText;
    data['insurance_policy_pdf'] = this.insurancePolicyPdf;
    data['restricted_country_ids'] = this.restrictedCountryIds;
    data['restricted_city_ids'] = this.restrictedCityIds;
    data['restricted_district_ids'] = this.restrictedDistrictIds;
    data['restricted_age_ids'] = this.restrictedAgeIds;
    data['limit'] = this.limit;
    data['net_premium'] = this.netPremium;
    data['fees'] = this.fees;
    data['stamps'] = this.stamps;
    data['sales_tax'] = this.salesTax;
    data['gross_premium'] = this.grossPremium;
    data['commission_percentage'] = this.commissionPercentage;
    data['commission_amount'] = this.commissionAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.policyCovers != null) {
      data['policy_covers'] =
          this.policyCovers!.map((v) => v.toJson()).toList();
    }
    if (this.insuranceCompany != null) {
      data['insurance_company'] = this.insuranceCompany!.toJson();
    }
    return data;
  }
}

class PolicyCovers {
  int? id;
  double? homePlanId;
  String? coverName;
  String? coverLimit;
  String? coverLimitType;
  double? coverDeductible;
  String? coverDeductibleType;
  String? coverRate;
  String? coverRateType;
  double? coverPremium;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PolicyCovers(
      {this.id,
        this.homePlanId,
        this.coverName,
        this.coverLimit,
        this.coverLimitType,
        this.coverDeductible,
        this.coverDeductibleType,
        this.coverRate,
        this.coverRateType,
        this.coverPremium,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  PolicyCovers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    homePlanId = json['home_plan_id']!= null ? double.parse(json['home_plan_id'].toString()) : 0;
    coverName = json['cover_name'];
    coverLimit = json['cover_limit'].toString()??'';
    coverLimitType = json['cover_limit_type'].toString();
    coverDeductible = json['cover_deductible']!= null ? double.parse(json['cover_deductible'].toString()) : 0;
    coverDeductibleType = json['cover_deductible_type'];
    coverRate = json['cover_rate'].toString()??'';
    coverRateType = json['cover_rate_type'];
    coverPremium = json['cover_premium']!= null ? double.parse(json['cover_premium'].toString()) : 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['home_plan_id'] = this.homePlanId;
    data['cover_name'] = this.coverName;
    data['cover_limit'] = this.coverLimit;
    data['cover_limit_type'] = this.coverLimitType;
    data['cover_deductible'] = this.coverDeductible;
    data['cover_deductible_type'] = this.coverDeductibleType;
    data['cover_rate'] = this.coverRate;
    data['cover_rate_type'] = this.coverRateType;
    data['cover_premium'] = this.coverPremium;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
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
  double? countryId;
  double? cityId;
  double? districtId;
  String? streetName;
  String? buildingNo;
  String? privacyPolicy;
  double? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  InsuranceCompany(
      {this.id,
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
        this.deletedAt});

  InsuranceCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    lineOfBusinessId = json['line_of_business_id'];
    nationalId = json['national_id'];
    registerNumber = json['register_number'];
    taxNumber = json['tax_number'];
    email = json['email'];
    email1 = json['email_1'];
    email2 = json['email_2'];
    claimEmail = json['claim_email'];
    mobileNumber = json['mobile_number'];
    telephoneNumber = json['telephone_number'];
    joiningDate = json['joining_date'];
    countryId = json['country_id']!= null ? double.parse(json['country_id'].toString()) : 0;
    cityId = json['city_id']!= null ? double.parse(json['city_id'].toString()) : 0;
    districtId = json['district_id']!= null ? double.parse(json['district_id'].toString()) : 0;
    streetName = json['street_name'];
    buildingNo = json['building_no'];
    privacyPolicy = json['privacy_policy'];
    status = json['status']!= null ? double.parse(json['status'].toString()) : 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['line_of_business_id'] = this.lineOfBusinessId;
    data['national_id'] = this.nationalId;
    data['register_number'] = this.registerNumber;
    data['tax_number'] = this.taxNumber;
    data['email'] = this.email;
    data['email_1'] = this.email1;
    data['email_2'] = this.email2;
    data['claim_email'] = this.claimEmail;
    data['mobile_number'] = this.mobileNumber;
    data['telephone_number'] = this.telephoneNumber;
    data['joining_date'] = this.joiningDate;
    data['country_id'] = this.countryId;
    data['city_id'] = this.cityId;
    data['district_id'] = this.districtId;
    data['street_name'] = this.streetName;
    data['building_no'] = this.buildingNo;
    data['privacy_policy'] = this.privacyPolicy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
