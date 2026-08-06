class GetComplaintListModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  GetComplaintListModel(
      {this.status, this.statusCode, this.message, this.data});

  GetComplaintListModel.fromJson(Map<String, dynamic> json) {
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
  String? complaintNumber;
  int? clientId;
  String? lineOfBusinessId;
  int? insuranceCompanyId;
  String? complaintDate;
  int? complaintStatusId;
  String? complaintMessage;
  String? attachments;
  String? complaintLog;
  String? isSentToAdmin;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Status? status;

  Data(
      {this.id,
        this.complaintNumber,
        this.clientId,
        this.lineOfBusinessId,
        this.insuranceCompanyId,
        this.complaintDate,
        this.complaintStatusId,
        this.complaintMessage,
        this.attachments,
        this.complaintLog,
        this.isSentToAdmin,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    complaintNumber = json['complaint_number'];
    clientId = json['client_id'];
    lineOfBusinessId = json['line_of_business_id'];
    insuranceCompanyId = json['insurance_company_id'];
    complaintDate = json['complaint_date'];
    complaintStatusId = json['complaint_status_id'];
    complaintMessage = json['complaint_message'];
    attachments = json['attachments'];
    complaintLog = json['complaint_log'];
    isSentToAdmin = json['is_sent_to_admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['complaint_number'] = this.complaintNumber;
    data['client_id'] = this.clientId;
    data['line_of_business_id'] = this.lineOfBusinessId;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['complaint_date'] = this.complaintDate;
    data['complaint_status_id'] = this.complaintStatusId;
    data['complaint_message'] = this.complaintMessage;
    data['attachments'] = this.attachments;
    data['complaint_log'] = this.complaintLog;
    data['is_sent_to_admin'] = this.isSentToAdmin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Status({this.id, this.name, this.deletedAt, this.createdAt, this.updatedAt});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
