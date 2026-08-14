class GetPetBreedsModel {
  bool? success;
  bool? status;
  int? statusCode;
  String? message;
  List<PetBreedData>? data;

  GetPetBreedsModel({this.success, this.status, this.statusCode, this.message, this.data});

  GetPetBreedsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? json['status'];
    status = json['status'] ?? json['success'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PetBreedData>[];
      json['data'].forEach((v) {
        data!.add(PetBreedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PetBreedData {
  int? id;
  String? type;
  String? breed;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  PetBreedData({this.id, this.type, this.breed, this.deletedAt, this.createdAt, this.updatedAt});

  PetBreedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    breed = json['breed'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['breed'] = breed;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
