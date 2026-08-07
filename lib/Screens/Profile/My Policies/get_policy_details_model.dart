class GetPolicyDetailsModel {
  bool? status;
  int? statusCode;
  String? message;
  List<PolicyData>? data;

  GetPolicyDetailsModel(
      {this.status, this.statusCode, this.message, this.data});

  GetPolicyDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PolicyData>[];
      json['data'].forEach((v) {
        data!.add(PolicyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyData {
  int? id;
  int? clientId;
  int? policyId;
  int? planId;
  dynamic policyPlanLimit;
  String? planName;
  dynamic netPremium;
  dynamic fees;
  dynamic stamps;
  dynamic salesTax;
  dynamic cbj;
  dynamic salesTaxCbj;
  dynamic grossPremium;
  dynamic commissionPercentage;
  dynamic commissionAmount;
  int? insuranceCompanyId;
  dynamic policyNo;
  String? policyPdfUrl;
  String? policyType;
  String? inceptionDate;
  String? expiryDate;
  int? paymentStatus;
  dynamic notify30Days;
  dynamic notify15Days;
  dynamic customNotify;
  String? cancelledAt;
  String? createdAt;
  String? updatedAt;
  dynamic renewed;
  String? deletedAt;
  String? companyName;
  String? pdfUrl;
  int? policyTypeNo;
  String? fullName;

  PolicyData({
    this.id,
    this.clientId,
    this.policyId,
    this.planId,
    this.policyPlanLimit,
    this.planName,
    this.netPremium,
    this.fees,
    this.stamps,
    this.salesTax,
    this.cbj,
    this.salesTaxCbj,
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
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.renewed,
    this.deletedAt,
    this.companyName,
    this.pdfUrl,
    this.policyTypeNo,
    this.fullName,
  });

  PolicyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    policyId = json['policy_id'];
    planId = json['plan_id'];
    policyPlanLimit = json['policy_plan_limit'];
    planName = json['plan_name'];
    netPremium = json['net_premium'];
    fees = json['fees'];
    stamps = json['stamps'];
    salesTax = json['sales_tax'];
    cbj = json['cbj'];
    salesTaxCbj = json['sales_tax_cbj'];
    grossPremium = json['gross_premium'];
    commissionPercentage = json['commission_percentage'];
    commissionAmount = json['commission_amount'];
    insuranceCompanyId = json['insurance_company_id'];
    policyNo = json['policy_no'];
    policyPdfUrl = json['policy_pdf_url'];
    policyType = json['policy_type'];
    inceptionDate = json['inception_date'];
    expiryDate = json['expiry_date'];
    paymentStatus = json['payment_status'];
    notify30Days = json['notify_30_days'];
    notify15Days = json['notify_15_days'];
    customNotify = json['custom_notify'];
    cancelledAt = json['cancelled_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    renewed = json['renewed'];
    deletedAt = json['deleted_at'];
    companyName = json['company_name'];
    pdfUrl = json['pdf_url'];
    policyTypeNo = json['policy_type_no'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['policy_id'] = policyId;
    data['plan_id'] = planId;
    data['policy_plan_limit'] = policyPlanLimit;
    data['plan_name'] = planName;
    data['net_premium'] = netPremium;
    data['fees'] = fees;
    data['stamps'] = stamps;
    data['sales_tax'] = salesTax;
    data['cbj'] = cbj;
    data['sales_tax_cbj'] = salesTaxCbj;
    data['gross_premium'] = grossPremium;
    data['commission_percentage'] = commissionPercentage;
    data['commission_amount'] = commissionAmount;
    data['insurance_company_id'] = insuranceCompanyId;
    data['policy_no'] = policyNo;
    data['policy_pdf_url'] = policyPdfUrl;
    data['policy_type'] = policyType;
    data['inception_date'] = inceptionDate;
    data['expiry_date'] = expiryDate;
    data['payment_status'] = paymentStatus;
    data['notify_30_days'] = notify30Days;
    data['notify_15_days'] = notify15Days;
    data['custom_notify'] = customNotify;
    data['cancelled_at'] = cancelledAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['renewed'] = renewed;
    data['deleted_at'] = deletedAt;
    data['company_name'] = companyName;
    data['pdf_url'] = pdfUrl;
    data['policy_type_no'] = policyTypeNo;
    data['full_name'] = fullName;
    return data;
  }
}
