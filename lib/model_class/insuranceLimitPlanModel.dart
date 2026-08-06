/*
class InsuranceLimitPlanModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  InsuranceLimitPlanModel(
      {this.status, this.statusCode, this.message, this.data});

  InsuranceLimitPlanModel.fromJson(Map<String, dynamic> json) {
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
  int? limit;
  List<PlanName>? planName;

  Data({this.limit, this.planName});

  Data.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    if (json['plan_name'] != null) {
      planName = <PlanName>[];
      json['plan_name'].forEach((v) {
        planName!.add(new PlanName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    if (this.planName != null) {
      data['plan_name'] = this.planName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class PlanName {
  String? planName;

  PlanName({this.planName});

  PlanName.fromJson(Map<String, dynamic> json) {
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_name'] = this.planName;
    return data;
  }
}
*/




///OLD model

class InsuranceLimitPlanModel {
  bool? status;
  int? statusCode;
  String? message;
  List<InsurancePlanName>? data;

  InsuranceLimitPlanModel(
      {this.status, this.statusCode, this.message, this.data});

  InsuranceLimitPlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InsurancePlanName>[];
      json['data'].forEach((v) {
        data!.add(new InsurancePlanName.fromJson(v));
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

class InsurancePlanName {
  String? planName;

  InsurancePlanName({this.planName});

  InsurancePlanName.fromJson(Map<String, dynamic> json) {
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_name'] = this.planName;
    return data;
  }
}
