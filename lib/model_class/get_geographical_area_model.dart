class GetGeographicalAreaModelClass {
  bool? status;
  int? statusCode;
  String? message;
  List<GetGeographicalAreaList>? data;

  GetGeographicalAreaModelClass(
      {this.status, this.statusCode, this.message, this.data});

  GetGeographicalAreaModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetGeographicalAreaList>[];
      json['data'].forEach((v) {
        data!.add(new GetGeographicalAreaList.fromJson(v));
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

class GetGeographicalAreaList {
  int? id;
  String? name;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  GetGeographicalAreaList({this.id, this.name, this.deletedAt, this.createdAt, this.updatedAt});

  GetGeographicalAreaList.fromJson(Map<String, dynamic> json) {
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

