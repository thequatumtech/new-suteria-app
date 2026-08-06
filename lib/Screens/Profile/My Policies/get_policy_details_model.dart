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
        data!.add(new PolicyData.fromJson(v));
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

class PolicyData {
  int? id;
  int? clientId;
  int? policyId;
  int? planId;
  int? insuranceCompanyId;
  int? policyNo;
  String? policyType;
  String? inceptionDate;
  String? expiryDate;
  int? paymentStatus;
  String? createdAt;
  String? updatedAt;
  String? companyName;
  String? pdfUrl;
  int? policyTypeNo;

  PolicyData(
      {this.id,
        this.clientId,
        this.policyId,
        this.planId,
        this.insuranceCompanyId,
        this.policyNo,
        this.policyType,
        this.inceptionDate,
        this.expiryDate,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt,
        this.companyName,
        this.pdfUrl,
        this.policyTypeNo});

  PolicyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    policyId = json['policy_id'];
    planId = json['plan_id'];
    insuranceCompanyId = json['insurance_company_id'];
    policyNo = json['policy_no'];
    policyType = json['policy_type'];
    inceptionDate = json['inception_date'];
    expiryDate = json['expiry_date'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyName = json['company_name'];
    pdfUrl = json['pdf_url'];
    policyTypeNo = json['policy_type_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['policy_id'] = this.policyId;
    data['plan_id'] = this.planId;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['policy_no'] = this.policyNo;
    data['policy_type'] = this.policyType;
    data['inception_date'] = this.inceptionDate;
    data['expiry_date'] = this.expiryDate;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['company_name'] = this.companyName;
    data['pdf_url'] = this.pdfUrl;
    data['policy_type_no'] = this.policyTypeNo;
    return data;
  }
}
