class GetPersonalAccidentPlanModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Null>? data;

  GetPersonalAccidentPlanModel(
      {this.status, this.statusCode, this.message, this.data});

  GetPersonalAccidentPlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Null>[];
      json['data'].forEach((v) {
        // data!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      // data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
