class ClaimsChatSModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  ClaimsChatSModel({this.status, this.statusCode, this.message, this.data});

  ClaimsChatSModel.fromJson(Map<String, dynamic> json) {
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
  int? claimId;
  int? clientId;
  String? message;
  String? isMessage;
  String? sentBy;
  String? isRead;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Data(
      {this.id,
        this.claimId,
        this.clientId,
        this.message,
        this.isMessage,
        this.sentBy,
        this.isRead,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimId = json['claim_id'];
    clientId = json['client_id'];
    message = json['message'];
    isMessage = json['is_message'];
    sentBy = json['sent_by'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['claim_id'] = this.claimId;
    data['client_id'] = this.clientId;
    data['message'] = this.message;
    data['is_message'] = this.isMessage;
    data['sent_by'] = this.sentBy;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
