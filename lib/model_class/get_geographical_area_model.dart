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
        data!.add(GetGeographicalAreaList.fromJson(v));
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

class GetGeographicalAreaList {
  int? id;
  String? name;
  List<String>? countries;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  GetGeographicalAreaList({this.id, this.name, this.countries, this.deletedAt, this.createdAt, this.updatedAt});

  GetGeographicalAreaList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['countries'] != null) {
      countries = (json['countries'] as List).map((e) => e.toString()).toList();
    }
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (countries != null) {
      data['countries'] = countries;
    }
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

