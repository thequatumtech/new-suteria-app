class GetVehicleTypeModelClass {
  bool? status;
  int? statusCode;
  String? message;
  List<VehicleTypeList>? data;

  GetVehicleTypeModelClass(
      {this.status, this.statusCode, this.message, this.data});

  GetVehicleTypeModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleTypeList>[];
      json['data'].forEach((v) {
        data!.add(new VehicleTypeList.fromJson(v));
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

class VehicleTypeList {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  VehicleTypeList(
      {this.id,
        this.name,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  VehicleTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
