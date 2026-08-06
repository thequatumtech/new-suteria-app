class GetDiscountCouponsModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  GetDiscountCouponsModel(
      {this.status, this.statusCode, this.message, this.data});

  GetDiscountCouponsModel.fromJson(Map<String, dynamic> json) {
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
  int? couponId;
  String? couponCode;
  int? clientId;
  int? insuranceCompanyId;
  int? lineOfBusinessId;
  int? percentage;
  String? effectiveDate;
  String? expiryDate;
  String? description;
  String? attachment;
  String? sendTo;
  String? isSent;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  LineOfBusiness? lineOfBusiness;

  Data(
      {this.id,
        this.couponId,
        this.couponCode,
        this.clientId,
        this.insuranceCompanyId,
        this.lineOfBusinessId,
        this.percentage,
        this.effectiveDate,
        this.expiryDate,
        this.description,
        this.attachment,
        this.sendTo,
        this.isSent,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.lineOfBusiness});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    clientId = json['client_id'];
    insuranceCompanyId = json['insurance_company_id'];
    lineOfBusinessId = json['line_of_business_id'];
    percentage = json['percentage'];
    effectiveDate = json['effective_date'];
    expiryDate = json['expiry_date'];
    description = json['description'];
    attachment = json['attachment'];
    sendTo = json['send_to'];
    isSent = json['is_sent'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    lineOfBusiness = json['line_of_business'] != null
        ? new LineOfBusiness.fromJson(json['line_of_business'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_id'] = this.couponId;
    data['coupon_code'] = this.couponCode;
    data['client_id'] = this.clientId;
    data['insurance_company_id'] = this.insuranceCompanyId;
    data['line_of_business_id'] = this.lineOfBusinessId;
    data['percentage'] = this.percentage;
    data['effective_date'] = this.effectiveDate;
    data['expiry_date'] = this.expiryDate;
    data['description'] = this.description;
    data['attachment'] = this.attachment;
    data['send_to'] = this.sendTo;
    data['is_sent'] = this.isSent;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.lineOfBusiness != null) {
      data['line_of_business'] = this.lineOfBusiness!.toJson();
    }
    return data;
  }
}

class LineOfBusiness {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? newId;

  LineOfBusiness(
      {this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.newId});

  LineOfBusiness.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    newId = json['new_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['new_id'] = this.newId;
    return data;
  }
}
