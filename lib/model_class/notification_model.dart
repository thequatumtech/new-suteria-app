import 'dart:convert';

class NotificationPaginationModel {
  int? currentPage;
  List<NotificationItem>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<PaginationLink>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  NotificationPaginationModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory NotificationPaginationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> target = json;
    if (json.containsKey('data') && json['data'] is Map && (json['data'] as Map).containsKey('data')) {
      target = Map<String, dynamic>.from(json['data'] as Map);
    }

    List<NotificationItem> items = [];
    final rawData = target['data'];
    if (rawData is List) {
      for (var item in rawData) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          items.add(NotificationItem.fromJson(map));
        }
      }
    }

    List<PaginationLink> parsedLinks = [];
    if (target['links'] is List) {
      for (var link in target['links']) {
        if (link is Map) {
          parsedLinks.add(PaginationLink.fromJson(Map<String, dynamic>.from(link)));
        }
      }
    }

    return NotificationPaginationModel(
      currentPage: target['current_page'] is int
          ? target['current_page']
          : int.tryParse(target['current_page']?.toString() ?? '1'),
      data: items,
      firstPageUrl: target['first_page_url']?.toString(),
      from: target['from'] is int
          ? target['from']
          : int.tryParse(target['from']?.toString() ?? ''),
      lastPage: target['last_page'] is int
          ? target['last_page']
          : int.tryParse(target['last_page']?.toString() ?? '1'),
      lastPageUrl: target['last_page_url']?.toString(),
      links: parsedLinks,
      nextPageUrl: target['next_page_url']?.toString(),
      path: target['path']?.toString(),
      perPage: target['per_page'] is int
          ? target['per_page']
          : int.tryParse(target['per_page']?.toString() ?? '20'),
      prevPageUrl: target['prev_page_url']?.toString(),
      to: target['to'] is int
          ? target['to']
          : int.tryParse(target['to']?.toString() ?? ''),
      total: target['total'] is int
          ? target['total']
          : int.tryParse(target['total']?.toString() ?? '0'),
    );
  }
}

class PaginationLink {
  String? url;
  String? label;
  bool? active;

  PaginationLink({this.url, this.label, this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: json['active'] == true || json['active'] == 'true',
    );
  }
}

class NotificationItem {
  int? id;
  int? clientId;
  String? type;
  String? title;
  String? body;
  Map<String, dynamic>? data;
  String? readAt;
  bool isRead;
  dynamic rawCreatedAt;
  String? updatedAt;

  NotificationItem({
    this.id,
    this.clientId,
    this.type,
    this.title,
    this.body,
    this.data,
    this.readAt,
    this.isRead = false,
    this.rawCreatedAt,
    this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parsedData;
    if (json['data'] != null) {
      if (json['data'] is Map) {
        parsedData = Map<String, dynamic>.from(json['data']);
      } else if (json['data'] is String) {
        try {
          parsedData = Map<String, dynamic>.from(jsonDecode(json['data']));
        } catch (_) {}
      }
    }

    bool readStatus = false;
    if (json.containsKey('read')) {
      readStatus = json['read'] == true || json['read'] == 1 || json['read'] == 'true';
    } else if (json['read_at'] != null && json['read_at'].toString().isNotEmpty && json['read_at'].toString() != 'null') {
      readStatus = true;
    }

    int? parsedId = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');

    int? parsedClientId = json['client_id'] is int
        ? json['client_id']
        : int.tryParse(json['client_id']?.toString() ?? '');

    return NotificationItem(
      id: parsedId,
      clientId: parsedClientId,
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      data: parsedData,
      readAt: json['read_at']?.toString(),
      isRead: readStatus,
      rawCreatedAt: json['created_at'],
      updatedAt: json['updated_at']?.toString(),
    );
  }

  factory NotificationItem.fromRtdb(Map<String, dynamic> map, {String? key}) {
    final item = NotificationItem.fromJson(map);
    if (item.id == null && key != null) {
      item.id = int.tryParse(key);
    }
    return item;
  }

  DateTime? get createdAt {
    if (rawCreatedAt == null) return null;
    if (rawCreatedAt is int) {
      final val = rawCreatedAt as int;
      if (val > 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(val);
      }
      return DateTime.fromMillisecondsSinceEpoch(val * 1000);
    }
    if (rawCreatedAt is String) {
      final str = rawCreatedAt as String;
      final asInt = int.tryParse(str);
      if (asInt != null) {
        if (asInt > 100000000000) {
          return DateTime.fromMillisecondsSinceEpoch(asInt);
        }
        return DateTime.fromMillisecondsSinceEpoch(asInt * 1000);
      }
      return DateTime.tryParse(str);
    }
    return null;
  }

  /// Helper to get specific IDs from data object
  int? get chatId => _getIntFromData('chat_id');
  int? get claimId => _getIntFromData('claim_id');
  int? get complaintId => _getIntFromData('complaint_id');
  int? get couponId => _getIntFromData('coupon_id');
  String? get couponCode => data?['coupon_code']?.toString();
  int? get planId => _getIntFromData('plan_id');
  String? get status => data?['status']?.toString();
  String? get expiryDate => data?['expiry_date']?.toString();

  int? _getIntFromData(String key) {
    if (data == null || !data!.containsKey(key) || data![key] == null) {
      return null;
    }
    final val = data![key];
    if (val is int) return val;
    return int.tryParse(val.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'read_at': readAt,
      'read': isRead,
      'created_at': rawCreatedAt,
      'updated_at': updatedAt,
    };
  }
}
