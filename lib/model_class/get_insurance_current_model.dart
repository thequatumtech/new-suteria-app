class GetInsuranceCurrentModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  GetInsuranceCurrentModel(
      {this.status, this.statusCode, this.message, this.data});

  GetInsuranceCurrentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? clientId;
  int? policyId;
  int? planId;
  double? policyPlanLimit;
  String? planName;
  double? netPremium;
  double? fees;
  double? stamps;
  double? salesTax;
  double? grossPremium;
  double? commissionPercentage;
  double? commissionAmount;
  double? insuranceCompanyId;
  double? policyNo;
  String? policyPdfUrl;
  double? policyType;
  String? inceptionDate;
  String? expiryDate;
  double? paymentStatus;
  String? notify30Days;
  String? notify15Days;
  String? customNotify;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.clientId,
        this.policyId,
        this.planId,
        this.policyPlanLimit,
        this.planName,
        this.netPremium,
        this.fees,
        this.stamps,
        this.salesTax,
        this.grossPremium,
        this.commissionPercentage,
        this.commissionAmount,
        this.insuranceCompanyId,
        this.policyNo,
        this.policyPdfUrl,
        this.policyType,
        this.inceptionDate,
        this.expiryDate,
        this.paymentStatus,
        this.notify30Days,
        this.notify15Days,
        this.customNotify,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    policyId = json['policy_id'];
    planId = json['plan_id'];
    policyPlanLimit = json['policy_plan_limit']!= null ? double.parse(json['policy_plan_limit'].toString()) : 0;
    planName = json['plan_name'];
    netPremium = json['net_premium']!= null ? double.parse(json['net_premium'].toString()) : 0;
    fees = json['fees']!= null ? double.parse(json['fees'].toString()) : 0;
    stamps = json['stamps']!= null ? double.parse(json['stamps'].toString()) : 0;
    salesTax = json['sales_tax']!= null ? double.parse(json['sales_tax'].toString()) : 0;
    grossPremium = json['gross_premium']!= null ? double.parse(json['gross_premium'].toString()) : 0;
    commissionPercentage = json['commission_percentage']!= null ? double.parse(json['commission_percentage'].toString()) : 0;
    commissionAmount = json['commission_amount']!= null ? double.parse(json['commission_amount'].toString()) : 0;
    insuranceCompanyId = json['insurance_company_id']!= null ? double.parse(json['insurance_company_id'].toString()) : 0;
    policyNo = json['policy_no']!= null ? double.parse(json['policy_no'].toString()) : 0;
    policyPdfUrl = json['policy_pdf_url'];
    policyType = json['policy_type']!= null ? double.parse(json['policy_type'].toString()) : 0;
    inceptionDate = json['inception_date'];
    expiryDate = json['expiry_date'];
    paymentStatus = json['payment_status']!= null ? double.parse(json['payment_status'].toString()) : 0;
    notify30Days = json['notify_30_days'];
    notify15Days = json['notify_15_days'];
    customNotify = json['custom_notify'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['policy_id'] = this.policyId;
    data['plan_id'] = this.planId;
    data['policy_plan_limit'] = this.policyPlanLimit;
    data['plan_name'] = this.planName;
    data['net_premium'] = this.netPremium;
    data['fees'] = this.fees;
    data['stamps'] = this.stamps;
    data['sales_tax'] = this.salesTax;
    data['gross_premium'] = this.grossPremium;
    data['commission_percentage'] = this.commissionPercentage;
    data['commission_amount'] = this.commissionAmount;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['policy_no'] = this.policyNo;
    data['policy_pdf_url'] = this.policyPdfUrl;
    data['policy_type'] = this.policyType;
    data['inception_date'] = this.inceptionDate;
    data['expiry_date'] = this.expiryDate;
    data['payment_status'] = this.paymentStatus;
    data['notify_30_days'] = this.notify30Days;
    data['notify_15_days'] = this.notify15Days;
    data['custom_notify'] = this.customNotify;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
