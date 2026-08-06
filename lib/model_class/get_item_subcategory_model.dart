class GetItemSubcategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<ItemSubcategory>? data;

  GetItemSubcategoryModel(
      {this.status, this.statusCode, this.message, this.data});

  GetItemSubcategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ItemSubcategory>[];
      json['data'].forEach((v) {
        data!.add(new ItemSubcategory.fromJson(v));
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

class ItemSubcategory {
  int? id;
  int? insuredItemCategoryId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ItemSubcategory(
      {this.id,
        this.insuredItemCategoryId,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ItemSubcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insuredItemCategoryId = json['insured_item_category_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['insured_item_category_id'] = this.insuredItemCategoryId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
