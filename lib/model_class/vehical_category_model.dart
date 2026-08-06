class GetVehicleCategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<VehicleCategoryList>? data;

  GetVehicleCategoryModel(
      {this.status, this.statusCode, this.message, this.data});

  GetVehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleCategoryList>[];
      json['data'].forEach((v) {
        data!.add(new VehicleCategoryList.fromJson(v));
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

class VehicleCategoryList {
  int? id;
  String? name;
  String? vehicleBrandId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  VehicleCategoryList(
      {this.id,
        this.name,
        this.vehicleBrandId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  VehicleCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleBrandId = json['vehicle_brand_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['vehicle_brand_id'] = this.vehicleBrandId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
