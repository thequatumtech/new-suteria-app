class PostInsuranceModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  PostInsuranceModel({this.status, this.statusCode, this.message, this.data});

  PostInsuranceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? purchaseId;
  String? url;
  String? planName;
  String? grossPremium;
//  String? grossPremium; ///remove comment

  String? netPremium; ///remove comment
  String? fees;
  String? salesTax;///remove comment double all
  String? stamps;///remove comment

  Data({this.id,this.purchaseId, this.url,this.planName,this.grossPremium,this.netPremium,this.fees,this.salesTax,this.stamps});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    purchaseId = json['purchase_id'];
    planName = json['plan_name'];
    url = json['url'];
    grossPremium = json['gross_premium']!= null ? json['gross_premium'].toString() : "0";
    //grossPremium = json['gross_premium']!= null ? json['gross_premium'].toString() : "0";
    netPremium = json['net_premium']!= null ? json['net_premium'].toString() : "0";
    fees = json['fees']!= null ? json['fees'].toString() : "0";
    salesTax = json['sales_tax']!= null ? json['sales_tax'].toString() : "0";
    stamps = json['stamps']!= null ? json['stamps'].toString() : "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['purchase_id'] = this.purchaseId;
    data['plan_name'] = this.planName;
    data['url'] = this.url;
    data['gross_premium'] = this.grossPremium;
    data['net_premium'] = this.netPremium;
    data['fees'] = this.fees;
    data['sales_tax'] = this.salesTax;
    data['stamps'] = this.stamps;
    return data;
  }
}
