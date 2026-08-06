class GetClaimsListModel {
  bool? status;
  int? statusCode;
  String? message;
  List<ClaimsListData>? data;

  GetClaimsListModel({this.status, this.statusCode, this.message, this.data});

  GetClaimsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ClaimsListData>[];
      json['data'].forEach((v) {
        data!.add(new ClaimsListData.fromJson(v));
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

class ClaimsListData {
  int? id;
  int? clientId;
  int? policyId;
  int? insuranceCompanyId;
  String? claimNo;
  String? policyType;
  String? effectiveDate;
  String? expiryDate;
  String? status;
  String? notifyClient;
  String? notifyInsuranceCompany;
  String? claimNote;
  String? attachments;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? companyName;

  ClaimsListData(
      {this.id,
        this.clientId,
        this.policyId,
        this.insuranceCompanyId,
        this.claimNo,
        this.policyType,
        this.effectiveDate,
        this.expiryDate,
        this.status,
        this.notifyClient,
        this.notifyInsuranceCompany,
        this.claimNote,
        this.attachments,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.companyName});

  ClaimsListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    policyId = json['policy_id'];
    insuranceCompanyId = json['insurance_company_id'];
    claimNo = json['claim_no'];
    policyType = json['policy_type'];
    effectiveDate = json['effective_date'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    notifyClient = json['notify_client'];
    notifyInsuranceCompany = json['notify_insurance_company'];
    claimNote = json['claim_note'];
    attachments = json['attachments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['policy_id'] = this.policyId;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['claim_no'] = this.claimNo;
    data['policy_type'] = this.policyType;
    data['effective_date'] = this.effectiveDate;
    data['expiry_date'] = this.expiryDate;
    data['status'] = this.status;
    data['notify_client'] = this.notifyClient;
    data['notify_insurance_company'] = this.notifyInsuranceCompany;
    data['claim_note'] = this.claimNote;
    data['attachments'] = this.attachments;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['company_name'] = this.companyName;
    return data;
  }
}
