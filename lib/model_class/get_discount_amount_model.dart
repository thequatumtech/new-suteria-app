class GetDiscountAmountModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  GetDiscountAmountModel({this.status, this.statusCode, this.message, this.data});

  GetDiscountAmountModel.fromJson(Map<String, dynamic> json) {
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
  int? couponId;
  String? couponCode;
  double? netPremium;

  double? fees;
  double? stamps;
  double? salesTax;

  double? totalNetPremium;

  Data({this.couponId, this.couponCode, this.netPremium, this.fees, this.stamps, this.salesTax, this.totalNetPremium});

  Data.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    netPremium = json['net_premium'] != null ? double.parse(json['net_premium'].toString()) : 0;
    fees = json['fees'] != null ? double.parse(json['fees'].toString()) : 0;
    stamps = json['stamps'] != null ? double.parse(json['stamps'].toString()) : 0;
    salesTax = json['sales_tax'] != null ? double.parse(json['sales_tax'].toString()) : 0;
    totalNetPremium = json['total_net_premium'] != null ? double.parse(json['total_net_premium'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['coupon_code'] = this.couponCode;
    data['net_premium'] = this.netPremium;
    data['fees'] = this.fees;
    data['stamps'] = this.stamps;
    data['sales_tax'] = this.salesTax;
    data['total_net_premium'] = this.totalNetPremium;
    return data;
  }
}
