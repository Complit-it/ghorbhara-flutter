import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Authentication Service for Demo Mode
/// Provides authentication without backend API calls

class LocalAuthService {
  static const String _userKey = 'local_user';
  static const String _tokenKey = 'local_token';

  /// Local sign in with dummy credentials
  Future<ApiResponse> localSignIn(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      // Demo credentials
      if ((email == 'owner@example.com' && password == 'password') ||
          (email == 'tenant@example.com' && password == 'password') ||
          (email == 'mike.property@example.com' && password == 'password') ||
          (email == 'sarah.finder@example.com' && password == 'password')) {
        // Find matching user
        User user = DummyData.dummyUsers
            .firstWhere((u) => u.email == email, orElse: () => User());

        if (user.email != null) {
          user.token = 'local_demo_token_${DateTime.now().millisecondsSinceEpoch}';
          await _saveUser(user);
          apiResponse.data = user;
          return apiResponse;
        }
      }

      apiResponse.error = 'Invalid email or password';
      apiResponse.ec = 401;
    } catch (e) {
      apiResponse.error = 'Authentication failed: ${e.toString()}';
      apiResponse.ec = 500;
    }

    return apiResponse;
  }

  /// Local sign up with demo credentials
  Future<ApiResponse> localSignUp(
    String name,
    String email,
    String password,
    String phone,
    String userType,
  ) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      // Create new user
      User newUser = User(
        id: DummyData.dummyUsers.length + 1,
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        google_id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        imageUrl: 'https://via.placeholder.com/150?text=$name',
        token: 'local_demo_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Add to dummy data
      DummyData.dummyUsers.add(newUser);

      // Save locally
      await _saveUser(newUser);

      apiResponse.data = newUser;
      return apiResponse;
    } catch (e) {
      apiResponse.error = 'Sign up failed: ${e.toString()}';
      apiResponse.ec = 500;
    }

    return apiResponse;
  }

  /// Get current local user
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        // Parse manually since we have the structure
        return _parseUserFromString(userJson);
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
    return null;
  }

  /// Save user locally
  Future<void> _saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = _convertUserToString(user);
      await prefs.setString(_userKey, userJson);
      await prefs.setString(_tokenKey, user.token ?? '');
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  /// Clear local user (sign out)
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error clearing user: $e');
    }
  }

  /// Helper to convert user to string
  String _convertUserToString(User user) {
    return '${user.id}|${user.name}|${user.email}|${user.token}|${user.phone}|${user.userType}|${user.google_id}|${user.imageUrl}';
  }

  /// Helper to parse user from string
  User? _parseUserFromString(String userString) {
    try {
      final parts = userString.split('|');
      if (parts.length >= 8) {
        return User(
          id: int.tryParse(parts[0]),
          name: parts[1],
          email: parts[2],
          token: parts[3],
          phone: parts[4],
          userType: parts[5],
          google_id: parts[6],
          imageUrl: parts[7],
        );
      }
    } catch (e) {
      print('Error parsing user: $e');
    }
    return null;
  }
}
