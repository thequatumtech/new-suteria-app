class ChatStartResponse {
  final int? id;
  final int? userOneId;
  final String? userOneType;
  final int? userTwoId;
  final String? userTwoType;
  final String? lastMessage;
  final String? lastMessageAt;
  final int? unreadCountClient;
  final int? unreadCountAdmin;

  ChatStartResponse({
    this.id,
    this.userOneId,
    this.userOneType,
    this.userTwoId,
    this.userTwoType,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCountClient,
    this.unreadCountAdmin,
  });

  factory ChatStartResponse.fromJson(Map<String, dynamic> json) {
    final chat = json['chat'] ?? json['data'] ?? json;
    return ChatStartResponse(
      id: chat['id'] is int ? chat['id'] : int.tryParse(chat['id']?.toString() ?? ''),
      userOneId: chat['user_one_id'] is int ? chat['user_one_id'] : int.tryParse(chat['user_one_id']?.toString() ?? ''),
      userOneType: chat['user_one_type']?.toString(),
      userTwoId: chat['user_two_id'] is int ? chat['user_two_id'] : int.tryParse(chat['user_two_id']?.toString() ?? ''),
      userTwoType: chat['user_two_type']?.toString(),
      lastMessage: chat['last_message']?.toString(),
      lastMessageAt: chat['last_message_at']?.toString(),
      unreadCountClient: chat['unread_count_client'] is int ? chat['unread_count_client'] : int.tryParse(chat['unread_count_client']?.toString() ?? ''),
      unreadCountAdmin: chat['unread_count_admin'] is int ? chat['unread_count_admin'] : int.tryParse(chat['unread_count_admin']?.toString() ?? ''),
    );
  }
}

class ChatMessageItem {
  final int id;
  final int chatId;
  final int senderId;
  final String senderType; // 'client' or 'admin'
  final String? message;
  final String? filePath;
  final String? fileType; // image, video, pdf, doc, other
  final String? fileName;
  final int? fileSize;
  final bool isRead;
  final String createdAt;

  ChatMessageItem({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderType,
    this.message,
    this.filePath,
    this.fileType,
    this.fileName,
    this.fileSize,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessageItem.fromJson(Map<String, dynamic> json) {
    return ChatMessageItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      chatId: json['chat_id'] is int ? json['chat_id'] : int.tryParse(json['chat_id']?.toString() ?? '0') ?? 0,
      senderId: json['sender_id'] is int ? json['sender_id'] : int.tryParse(json['sender_id']?.toString() ?? '0') ?? 0,
      senderType: json['sender_type']?.toString() ?? 'client',
      message: json['message']?.toString(),
      filePath: json['file_path']?.toString(),
      fileType: json['file_type']?.toString(),
      fileName: json['file_name']?.toString(),
      fileSize: json['file_size'] is int ? json['file_size'] : int.tryParse(json['file_size']?.toString() ?? ''),
      isRead: json['is_read'] == true || json['is_read'] == 1 || json['is_read'] == '1',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  bool get isClientMessage => senderType == 'client';
  bool get hasFile => filePath != null && filePath!.isNotEmpty;
  bool get isImage => fileType == 'image' || (filePath != null && (filePath!.endsWith('.jpg') || filePath!.endsWith('.png') || filePath!.endsWith('.jpeg') || filePath!.endsWith('.webp')));

  String fullFileUrl(String baseUrl) {
    if (filePath == null || filePath!.isEmpty) return '';
    if (filePath!.startsWith('http://') || filePath!.startsWith('https://')) {
      return filePath!;
    }
    String domain = baseUrl.replaceFirst('/api/', '').replaceFirst('/api', '');
    if (domain.endsWith('/')) domain = domain.substring(0, domain.length - 1);
    String path = filePath!.startsWith('/') ? filePath! : '/$filePath';
    return '$domain$path';
  }
}
