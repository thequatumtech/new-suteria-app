class GetLanguageModelClass {
  bool? status;
  int? statusCode;
  String? message;
  List<LanguageData>? data;

  GetLanguageModelClass({this.status, this.statusCode, this.message, this.data});

  GetLanguageModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LanguageData>[];
      json['data'].forEach((v) {
        data!.add(LanguageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['status_code'] = statusCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LanguageData {
  int? id;
  String? name;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  LanguageData({
    this.id,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['deleted_at'] = deletedAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

  /// Extracts language code ('ar', 'en', etc.)
  String get code {
    if (name != null) {
      final lower = name!.toLowerCase().trim();
      if (lower.contains('ar') || name!.contains('عرب')) return 'ar';
      if (lower.contains('en')) return 'en';
    }
    return 'en';
  }

  /// Display name (defaults to name or fallback)
  String get displayName => name ?? (code == 'ar' ? 'العربية' : 'English');

  /// Subtitle shown under name (e.g. 'Arabic' or 'English')
  String get subtitle {
    if (code == 'ar') return 'Arabic';
    if (code == 'en') return 'English';
    return name ?? '';
  }

  /// 1-2 char avatar label
  String get shortLabel => code == 'ar' ? 'ع' : 'EN';
}
