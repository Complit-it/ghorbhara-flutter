import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/property.dart' hide User;
import 'package:hello_world/models/user.dart';

/// Local User Service for Demo Mode
/// Provides user-related operations from dummy data

class LocalUserService {
  /// Get user by ID
  Future<ApiResponse> getUserById(int id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final apiResponse = ApiResponse();
      final user = DummyData.getUserById(id);
      if (user != null) {
        apiResponse.data = user;
      } else {
        apiResponse.error = 'User not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch user: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get all users
  Future<ApiResponse> getAllUsers() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final apiResponse = ApiResponse();
      apiResponse.data = DummyData.dummyUsers;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch users: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Update user profile
  Future<ApiResponse> updateUserProfile(User user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final apiResponse = ApiResponse();
      
      final index = DummyData.dummyUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        DummyData.dummyUsers[index] = user;
        apiResponse.data = user;
      } else {
        apiResponse.error = 'User not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to update profile: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get user properties
  Future<ApiResponse> getUserProperties(int userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      final properties = DummyData.dummyProperties
          .where((p) => p.userId == userId.toString())
          .toList();
      apiResponse.data = properties;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch user properties: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get user bookings
  Future<ApiResponse> getUserBookings(int userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      final bookings = DummyData.getUserBookings(userId);
      apiResponse.data = bookings;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch bookings: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Search users
  Future<ApiResponse> searchUsers(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      final results = DummyData.dummyUsers
          .where((u) =>
              u.name!.toLowerCase().contains(query.toLowerCase()) ||
              u.email!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      apiResponse.data = results;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Search failed: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get tenant properties
  Future<ApiResponse> getTenantProperties() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      apiResponse.data = DummyData.dummyProperties;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch properties: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get favorite properties for user
  Future<ApiResponse> getFavoriteProperties(int userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      final favorites = DummyData.dummyProperties
          .where((p) => p.isFav == true)
          .toList();
      apiResponse.data = favorites;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch favorites: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Toggle property favorite
  Future<ApiResponse> toggleFavorite(int propertyId, bool isFav) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final apiResponse = ApiResponse();
      final index = DummyData.dummyProperties.indexWhere((p) => p.id == propertyId);
      if (index != -1) {
        final property = DummyData.dummyProperties[index];
        DummyData.dummyProperties[index] = Property(
          id: property.id,
          title: property.title,
          rooms: property.rooms,
          address: property.address,
          area: property.area,
          userId: property.userId,
          about: property.about,
          propertyTypeId: property.propertyTypeId,
          price: property.price,
          location: property.location,
          isFav: isFav,
          homeFacilities: property.homeFacilities,
          user: property.user,
          images: property.images,
        );
        apiResponse.data = {'isFav': isFav};
      } else {
        apiResponse.error = 'Property not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to toggle favorite: ${e.toString()}';
      return apiResponse;
    }
  }
}
