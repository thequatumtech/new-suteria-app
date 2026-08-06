class ForgotOtpSendModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  ForgotOtpSendModel({this.status, this.statusCode, this.message, this.data});

  ForgotOtpSendModel.fromJson(Map<String, dynamic> json) {
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
  int? clientId;
  String? phone;
  String? otp;
  String? date;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.clientId,
        this.phone,
        this.otp,
        this.date,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    phone = json['phone'];
    otp = json['otp'];
    date = json['date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['date'] = this.date;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
