class LocalMessage {
  final String fromId;
  final String toId;
  final String msg;
  final DateTime sentAt;

  LocalMessage({
    required this.fromId,
    required this.toId,
    required this.msg,
    required this.sentAt,
  });
}

class LocalChatService {
  static final Map<String, List<LocalMessage>> _chats = {};

  static String _key(String id1, String id2) {
    final sorted = [id1, id2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  static List<LocalMessage> getMessages(String userId1, String userId2) {
    return List.unmodifiable(
        _chats[_key(userId1, userId2)] ?? []);
  }

  static void sendMessage(String fromId, String toId, String msg) {
    final key = _key(fromId, toId);
    _chats[key] = [
      ...(_chats[key] ?? []),
      LocalMessage(fromId: fromId, toId: toId, msg: msg, sentAt: DateTime.now()),
    ];
  }

  static LocalMessage? getLastMessage(String userId1, String userId2) {
    final msgs = _chats[_key(userId1, userId2)];
    return msgs != null && msgs.isNotEmpty ? msgs.last : null;
  }
}
