import 'package:flutter/material.dart';
import 'package:hello_world/pages/fav_list.dart';
import 'package:hello_world/pages/my_props.dart';
import 'package:hello_world/pages/sign_in.dart';
import 'package:hello_world/services/user_service.dart';
import '../models/user.dart';
import 'bookings_screen.dart';
import 'edit_profile_screen.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoggingOut = false;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.person_rounded, 'label': 'My Profile', 'screen': EditProfileScreen()},
    {'icon': Icons.favorite_rounded, 'label': 'Favorites', 'screen': FavProps()},
    {'icon': Icons.home_work_rounded, 'label': 'My Properties', 'screen': MyPropertiesScreen()},
    {'icon': Icons.help_outline_rounded, 'label': 'FAQs', 'screen': FAQScreen()},
    {'icon': Icons.book_online_rounded, 'label': 'My Bookings', 'screen': MyBookings()},
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getUserFromSharedPreferences();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await clearUserFromSharedPreferences();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignIn()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.name ?? 'Demo User';
    final email = _user?.email ?? '';
    final userType = _user?.userType ?? 'tenant';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6246EA), Color(0xFF9B79FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Hind',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Hind',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, indent: 56, endIndent: 16),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => item['screen'] as Widget),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF6246EA).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData,
                          color: const Color(0xFF6246EA), size: 18),
                    ),
                    title: Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Hind',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF8E8E93), size: 20),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoggingOut
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF6246EA)))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout_rounded,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6246EA),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
