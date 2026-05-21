import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/pages/chat_screen.dart';
import 'package:hello_world/services/local_chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int _currentUserId = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _currentUserId = prefs.getInt('userId') ?? 0);
  }

  List<User> get _contacts => DummyData.dummyUsers
      .where((u) => u.id != _currentUserId)
      .where((u) =>
          _searchQuery.isEmpty ||
          (u.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (u.email ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Hind',
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) =>
                        setState(() => _searchQuery = v),
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF1A1A2E)),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          color: Color(0xFF6246EA), size: 20),
                      hintText: 'Search contacts...',
                      hintStyle:
                          TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentUserId == 0
                ? const Center(child: CircularProgressIndicator())
                : _contacts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded,
                                size: 64, color: Color(0xFFDDDDDD)),
                            SizedBox(height: 16),
                            Text('No contacts found',
                                style: TextStyle(
                                    color: Color(0xFF8E8E93), fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _contacts.length,
                        itemBuilder: (context, index) {
                          final user = _contacts[index];
                          final lastMsg = LocalChatService.getLastMessage(
                            _currentUserId.toString(),
                            (user.id ?? 0).toString(),
                          );
                          return _ContactTile(
                            user: user,
                            lastMessage: lastMsg,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LocalChatScreen(
                                    otherUserId: user.id ?? 0,
                                    otherUserName: user.name ?? 'User',
                                  ),
                                ),
                              );
                              if (mounted) setState(() {});
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final User user;
  final LocalMessage? lastMessage;
  final VoidCallback onTap;

  const _ContactTile({
    required this.user,
    required this.lastMessage,
    required this.onTap,
  });

  static const List<List<Color>> _avatarColors = [
    [Color(0xFF6246EA), Color(0xFF9B79FF)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFF7971E), Color(0xFFFFD200)],
    [Color(0xFF2193B0), Color(0xFF6DD5ED)],
  ];

  @override
  Widget build(BuildContext context) {
    final idx = (user.id ?? 0) % _avatarColors.length;
    final colors = _avatarColors[idx];
    final name = user.name ?? 'User';
    final initial = name[0].toUpperCase();
    final roleLabel =
        user.userType == 'owner' ? 'Property Owner' : 'Tenant';

    String lastMsgText = 'Tap to start a conversation';
    String lastMsgTime = '';
    if (lastMessage != null) {
      lastMsgText = lastMessage!.msg.length > 40
          ? '${lastMessage!.msg.substring(0, 40)}...'
          : lastMessage!.msg;
      final t = lastMessage!.sentAt;
      lastMsgTime =
          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (lastMsgTime.isNotEmpty)
                        Text(lastMsgTime,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF8E8E93))),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: colors[0].withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          roleLabel,
                          style: TextStyle(
                              color: colors[0],
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMsgText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: lastMessage != null
                          ? const Color(0xFF555555)
                          : const Color(0xFFAAAAAA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }
}
