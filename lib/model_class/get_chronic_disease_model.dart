class GetChronicDiseaseModelClass {
  bool? status;
  int? statusCode;
  String? message;
  List<GetChronicDiseasesList>? data;

  GetChronicDiseaseModelClass(
      {this.status, this.statusCode, this.message, this.data});

  GetChronicDiseaseModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetChronicDiseasesList>[];
      json['data'].forEach((v) {
        data!.add(new GetChronicDiseasesList.fromJson(v));
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

class GetChronicDiseasesList {
  int? id;
  String? name;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  GetChronicDiseasesList({this.id, this.name, this.deletedAt, this.createdAt, this.updatedAt});

  GetChronicDiseasesList.fromJson(Map<String, dynamic> json) {
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
