class GetDentalInsurancePlanModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  GetDentalInsurancePlanModel(
      {this.status, this.statusCode, this.message, this.data});

  GetDentalInsurancePlanModel.fromJson(Map<String, dynamic> json) {
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
  int? insuranceCompanyId;
  int? lineOfBusinessId;
  String? planName;
  String? startDate;
  String? endDate;
  String? insurancePolicyText;
  String? insurancePolicyPdf;
  String? restrictedCountryIds;
  String? restrictedCityIds;
  String? restrictedDistrictIds;
  String? restrictedAgeIds;
  int? limit;
  int? netPremium;
  double? fees;
  int? stamps;
  int? salesTax;
  double? grossPremium;
  int? commissionPercentage;
  double? commissionAmount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<PolicyCovers>? policyCovers;

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
        this.policyCovers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insuranceCompanyId = json['insurance_company_id'];
    lineOfBusinessId = json['line_of_business_id'];
    planName = json['plan_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    insurancePolicyText = json['insurance_policy_text'];
    insurancePolicyPdf = json['insurance_policy_pdf'];
    restrictedCountryIds = json['restricted_country_ids'];
    restrictedCityIds = json['restricted_city_ids'];
    restrictedDistrictIds = json['restricted_district_ids'];
    restrictedAgeIds = json['restricted_age_ids'];
    limit = json['limit'];
    netPremium = json['net_premium'];
    fees = json['fees'];
    stamps = json['stamps'];
    salesTax = json['sales_tax'];
    grossPremium = json['gross_premium'];
    commissionPercentage = json['commission_percentage'];
    commissionAmount = json['commission_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['policy_covers'] != null) {
      policyCovers = <PolicyCovers>[];
      json['policy_covers'].forEach((v) {
        policyCovers!.add(new PolicyCovers.fromJson(v));
      });
    }
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
    return data;
  }
}

class PolicyCovers {
  int? id;
  int? dentalPlanId;
  String? coverName;
  int? coverLimit;
  String? coverLimitType;
  int? coverDeductible;
  String? coverDeductibleType;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  PolicyCovers(
      {this.id,
        this.dentalPlanId,
        this.coverName,
        this.coverLimit,
        this.coverLimitType,
        this.coverDeductible,
        this.coverDeductibleType,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  PolicyCovers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dentalPlanId = json['dental_plan_id'];
    coverName = json['cover_name'];
    coverLimit = json['cover_limit'];
    coverLimitType = json['cover_limit_type'];
    coverDeductible = json['cover_deductible'];
    coverDeductibleType = json['cover_deductible_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dental_plan_id'] = this.dentalPlanId;
    data['cover_name'] = this.coverName;
    data['cover_limit'] = this.coverLimit;
    data['cover_limit_type'] = this.coverLimitType;
    data['cover_deductible'] = this.coverDeductible;
    data['cover_deductible_type'] = this.coverDeductibleType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
