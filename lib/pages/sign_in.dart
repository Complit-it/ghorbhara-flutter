import 'package:flutter/material.dart';
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/user.dart' as local_user;
import 'package:hello_world/pages/home.dart';
import 'package:hello_world/pages/signupp.dart';
import 'package:hello_world/services/local_auth_service.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.successMessage});
  final String? successMessage;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.successMessage!)),
        );
      });
    }
  }

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final email = _mailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    ApiResponse response;
    if (AppConfig.useLocalMode) {
      response = await LocalAuthService().localSignIn(email, password);
    } else {
      response = await signin(email, password);
    }

    if (!mounted) return;

    if (response.error == null && response.data != null) {
      final user = response.data as local_user.User;
      await saveUserToSharedPreferences(user, 'N');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('is_google_login', 'N');
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6246EA), Color(0xFF9B79FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.home_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(height: 24),
                const Text(
                  'GhorBhara',
                  style: TextStyle(
                    color: Color(0xFF6246EA),
                    fontSize: 16,
                    fontFamily: 'Hind',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 40,
                    fontFamily: 'Hind',
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'EMAIL',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _mailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF1A1A2E)),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    filled: true,
                    fillColor: const Color(0xFFF2F2F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF6246EA), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF1A1A2E)),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                    filled: true,
                    fillColor: const Color(0xFFF2F2F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF6246EA), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: const Color(0xFF8E8E93),
                        size: 20,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF6246EA)))
                      : ElevatedButton(
                          onPressed: _loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6246EA),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(color: Color(0xFF555555))),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Signupp()),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFF6246EA),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF6246EA),
                        ),
                      ),
                    ),
                  ],
                ),
                if (AppConfig.useLocalMode) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      border: Border.all(color: const Color(0xFFFFCC02)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_rounded,
                                color: Color(0xFFF59E0B), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'DEMO MODE — tap to fill credentials',
                              style: TextStyle(
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _demoCredential('Owner', 'owner@example.com'),
                        _demoCredential('Tenant', 'tenant@example.com'),
                        _demoCredential(
                            'Owner 2', 'mike.property@example.com'),
                        _demoCredential(
                            'Tenant 2', 'sarah.finder@example.com'),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _demoCredential(String label, String email) {
    return GestureDetector(
      onTap: () {
        _mailController.text = email;
        _passwordController.text = 'password';
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            const Icon(Icons.touch_app_rounded,
                size: 14, color: Color(0xFFF59E0B)),
            const SizedBox(width: 6),
            Text(
              '$label: $email',
              style: const TextStyle(
                  color: Color(0xFF92400E),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
