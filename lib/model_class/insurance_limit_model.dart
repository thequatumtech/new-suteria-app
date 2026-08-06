class InsuranceLimitModel {
  bool? status;
  int? statusCode;
  String? message;
  List<InsuranceLimitListData>? data;

  InsuranceLimitModel({this.status, this.statusCode, this.message, this.data});

  InsuranceLimitModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InsuranceLimitListData>[];
      json['data'].forEach((v) {
        data!.add(new InsuranceLimitListData.fromJson(v));
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

class InsuranceLimitListData {
  String? limit;
  List<PlanName>? planName;

  InsuranceLimitListData({this.limit, this.planName});

  InsuranceLimitListData.fromJson(Map<String, dynamic> json) {
    limit = json['limit'] != null ? json['limit'].toString() : "0";
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
  int? policyPeriod;

  PlanName({this.planName, this.policyPeriod});

  PlanName.fromJson(Map<String, dynamic> json) {
    planName = json['plan_name'];
    policyPeriod = json['policy_period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_name'] = this.planName;
    data['policy_period'] = this.policyPeriod;
    return data;
  }
}
