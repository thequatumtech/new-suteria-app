import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:soperia_user/model_class/chat_model.dart';

class ChatRealtimeService {
  DatabaseReference? _ref;
  StreamSubscription? _subscription;
  final Set<int> _seenIds = {};

  void init(int chatId) {
    try {
      if (Firebase.apps.isNotEmpty) {
        _ref = FirebaseDatabase.instance.ref('chats/$chatId/messages');
      }
    } catch (e) {
      print('ChatRealtimeService init error: $e');
    }
  }

  void seedExistingIds(List<int> existingMessageIds) {
    _seenIds.addAll(existingMessageIds);
  }

  void listenForNewMessages(Function(ChatMessageItem) onNewMessage) {
    if (_ref == null) return;
    try {
      _subscription?.cancel();
      _subscription = _ref!.onChildAdded.listen((event) {
        try {
          if (event.snapshot.value != null && event.snapshot.value is Map) {
            final data = Map<String, dynamic>.from(event.snapshot.value as Map);
            final id = data['id'] is int ? data['id'] : int.tryParse(data['id']?.toString() ?? '0') ?? 0;
            if (id != 0 && !_seenIds.contains(id)) {
              _seenIds.add(id);
              final msg = ChatMessageItem.fromJson(data);
              onNewMessage(msg);
            }
          }
        } catch (e) {
          print('Firebase chat parse error: $e');
        }
      });
    } catch (e) {
      print('Firebase listen error: $e');
    }
  }

  void dispose() {
    try {
      _subscription?.cancel();
    } catch (_) {}
  }
}

class InboxRealtimeService {
  DatabaseReference? _ref;
  StreamSubscription? _changeSubscription;
  StreamSubscription? _addSubscription;

  void init(int clientId) {
    try {
      if (Firebase.apps.isNotEmpty) {
        _ref = FirebaseDatabase.instance.ref('inbox/client/$clientId');
      }
    } catch (e) {
      print('InboxRealtimeService init error: $e');
    }
  }

  void listenForInboxUpdates(Function(Map<String, dynamic>) onUpdate) {
    if (_ref == null) return;
    try {
      _changeSubscription?.cancel();
      _changeSubscription = _ref!.onChildChanged.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          onUpdate(Map<String, dynamic>.from(event.snapshot.value as Map));
        }
      });
      _addSubscription?.cancel();
      _addSubscription = _ref!.onChildAdded.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map) {
          onUpdate(Map<String, dynamic>.from(event.snapshot.value as Map));
        }
      });
    } catch (e) {
      print('InboxRealtimeService listen error: $e');
    }
  }

  void dispose() {
    try {
      _changeSubscription?.cancel();
      _addSubscription?.cancel();
    } catch (_) {}
  }
}
