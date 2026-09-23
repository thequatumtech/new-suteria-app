class GetAgesModelClass {
  bool? status;
  int? statusCode;
  String? message;
  List<AgeData>? data;

  GetAgesModelClass({this.status, this.statusCode, this.message, this.data});

  GetAgesModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AgeData>[];
      json['data'].forEach((v) {
        data!.add(AgeData.fromJson(v));
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

class AgeData {
  int? id;
  int? age;
  String? type;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  AgeData({this.id, this.age, this.type, this.deletedAt, this.createdAt, this.updatedAt});

  AgeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    age = json['age'];
    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['age'] = age;
    data['type'] = type;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
