class GetBannerModel {
  bool? status;
  int? statusCode;
  String? message;
  List<BannerData>? data;

  GetBannerModel({this.status, this.statusCode, this.message, this.data});

  GetBannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(BannerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerData {
  int? id;
  String? title;
  String? image;
  String? type;
  String? redirectUrl;

  BannerData({this.id, this.title, this.image, this.type, this.redirectUrl});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    type = json['type'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['type'] = type;
    data['redirect_url'] = redirectUrl;
    return data;
  }

  bool get isVideo {
    if (type != null && type!.toLowerCase() == 'video') {
      return true;
    }
    if (image != null) {
      final url = image!.toLowerCase();
      return url.endsWith('.mp4') ||
          url.endsWith('.mov') ||
          url.endsWith('.mkv') ||
          url.endsWith('.webm') ||
          url.contains('.mp4?');
    }
    return false;
  }
}
