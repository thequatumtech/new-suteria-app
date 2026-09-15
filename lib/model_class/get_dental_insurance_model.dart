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
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    insuranceCompanyId = json['insurance_company_id'] != null ? int.tryParse(json['insurance_company_id'].toString()) : null;
    lineOfBusinessId = json['line_of_business_id'] != null ? int.tryParse(json['line_of_business_id'].toString()) : null;
    planName = json['plan_name']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    insurancePolicyText = json['insurance_policy_text']?.toString();
    insurancePolicyPdf = json['insurance_policy_pdf']?.toString();
    restrictedCountryIds = json['restricted_country_ids']?.toString();
    restrictedCityIds = json['restricted_city_ids']?.toString();
    restrictedDistrictIds = json['restricted_district_ids']?.toString();
    restrictedAgeIds = json['restricted_age_ids']?.toString();
    limit = json['limit'] != null ? int.tryParse(json['limit'].toString()) : null;
    netPremium = json['net_premium'] != null ? double.tryParse(json['net_premium'].toString()) : null;
    fees = json['fees'] != null ? double.tryParse(json['fees'].toString()) : null;
    stamps = json['stamps'] != null ? double.tryParse(json['stamps'].toString()) : null;
    salesTax = json['sales_tax'] != null ? double.tryParse(json['sales_tax'].toString()) : null;
    grossPremium = json['gross_premium'] != null ? double.tryParse(json['gross_premium'].toString()) : null;
    commissionPercentage = json['commission_percentage'] != null ? double.tryParse(json['commission_percentage'].toString()) : null;
    commissionAmount = json['commission_amount'] != null ? double.tryParse(json['commission_amount'].toString()) : null;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
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
  String? coverLimit;
  String? coverLimitType;
  String? coverDeductible;
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
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    dentalPlanId = json['dental_plan_id'] != null ? int.tryParse(json['dental_plan_id'].toString()) : null;
    coverName = json['cover_name']?.toString();
    coverLimit = json['cover_limit']?.toString();
    coverLimitType = json['cover_limit_type']?.toString();
    coverDeductible = json['cover_deductible']?.toString();
    coverDeductibleType = json['cover_deductible_type']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
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
