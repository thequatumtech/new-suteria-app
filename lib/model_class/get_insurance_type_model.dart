class GetInsuranceTypeModel {
  bool? status;
  int? statusCode;
  String? message;
  List<InsuranceTypes>? data;

  GetInsuranceTypeModel(
      {this.status, this.statusCode, this.message, this.data});

  GetInsuranceTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InsuranceTypes>[];
      json['data'].forEach((v) {
        data!.add(new InsuranceTypes.fromJson(v));
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

class InsuranceTypes {
  int? id;
  String? name;

  InsuranceTypes({this.id, this.name});

  InsuranceTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
