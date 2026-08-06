class GetInsuranceCompanyModel {
  bool? status;
  int? statusCode;
  String? message;
  List<InsuranceCompany>? data;

  GetInsuranceCompanyModel(
      {this.status, this.statusCode, this.message, this.data});

  GetInsuranceCompanyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InsuranceCompany>[];
      json['data'].forEach((v) {
        data!.add(new InsuranceCompany.fromJson(v));
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

class InsuranceCompany {
  int? id;
  int? clientId;
  int? policyId;
  int? planId;
  int? insuranceCompanyId;
  int? policyNo;
  int? policyType;
  String? inceptionDate;
  String? expiryDate;
  int? paymentStatus;
  String? createdAt;
  String? updatedAt;
  String? companyName;

  InsuranceCompany(
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
        this.companyName});

  InsuranceCompany.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
