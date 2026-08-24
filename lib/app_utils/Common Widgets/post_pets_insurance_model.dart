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
  int? clientId;
  int? purchaseId;
  int? purchasePolicyId;
  String? url;
  String? planName;
  String? grossPremium;
  String? netPremium;
  String? fees;
  String? salesTax;
  String? cbj;
  String? salesTaxCbj;
  String? stamps;

  Data({
    this.id,
    this.clientId,
    this.purchaseId,
    this.purchasePolicyId,
    this.url,
    this.planName,
    this.grossPremium,
    this.netPremium,
    this.fees,
    this.salesTax,
    this.cbj,
    this.salesTaxCbj,
    this.stamps,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    clientId = json['client_id'] != null ? int.tryParse(json['client_id'].toString()) : null;
    purchasePolicyId = json['purchase_policy_id'] != null
        ? int.tryParse(json['purchase_policy_id'].toString())
        : (json['purchasePolicyId'] != null
            ? int.tryParse(json['purchasePolicyId'].toString())
            : null);
    purchaseId = json['purchase_id'] != null
        ? int.tryParse(json['purchase_id'].toString())
        : (json['purchaseId'] != null
            ? int.tryParse(json['purchaseId'].toString())
            : purchasePolicyId);
    planName = json['plan_name']?.toString() ?? json['purchase_plan_name']?.toString();
    url = json['url']?.toString();
    grossPremium = json['gross_premium'] != null
        ? json['gross_premium'].toString()
        : (json['total_premium'] != null ? json['total_premium'].toString() : "0");
    netPremium = json['net_premium'] != null
        ? json['net_premium'].toString()
        : (json['net_premium_amount'] != null ? json['net_premium_amount'].toString() : "0");
    fees = json['fees_amount'] != null
        ? json['fees_amount'].toString()
        : (json['plan_fees'] != null ? json['plan_fees'].toString() : (json['fees'] != null ? json['fees'].toString() : "0"));
    salesTax = json['sales_tax_amount'] != null
        ? json['sales_tax_amount'].toString()
        : (json['plan_sales_tax'] != null ? json['plan_sales_tax'].toString() : (json['sales_tax'] != null ? json['sales_tax'].toString() : "0"));
    cbj = json['cbj_amount'] != null
        ? json['cbj_amount'].toString()
        : (json['cbj'] != null ? json['cbj'].toString() : "0");
    salesTaxCbj = json['sales_tax_cbj_amount'] != null
        ? json['sales_tax_cbj_amount'].toString()
        : (json['sales_tax_cbj'] != null ? json['sales_tax_cbj'].toString() : "0");
    stamps = json['stamps_amount'] != null
        ? json['stamps_amount'].toString()
        : (json['plan_stamps'] != null ? json['plan_stamps'].toString() : (json['stamps'] != null ? json['stamps'].toString() : "0"));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['purchase_id'] = this.purchaseId;
    data['purchase_policy_id'] = this.purchasePolicyId;
    data['plan_name'] = this.planName;
    data['url'] = this.url;
    data['gross_premium'] = this.grossPremium;
    data['net_premium'] = this.netPremium;
    data['fees'] = this.fees;
    data['sales_tax'] = this.salesTax;
    data['cbj'] = this.cbj;
    data['sales_tax_cbj'] = this.salesTaxCbj;
    data['stamps'] = this.stamps;
    return data;
  }
}
