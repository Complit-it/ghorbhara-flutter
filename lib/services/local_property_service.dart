import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/models/api_response.dart';

/// Local Property Service for Demo Mode
/// Provides property data from dummy data instead of API calls

class LocalPropertyService {
  /// Get all properties
  Future<ApiResponse> getAllProperties() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      final apiResponse = ApiResponse();
      apiResponse.data = DummyData.dummyProperties;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch properties: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get property by ID
  Future<ApiResponse> getPropertyById(int id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final apiResponse = ApiResponse();
      final property = DummyData.getPropertyById(id);
      if (property != null) {
        apiResponse.data = property;
      } else {
        apiResponse.error = 'Property not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch property: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Search properties
  Future<ApiResponse> searchProperties(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      apiResponse.data = DummyData.searchProperties(query);
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Search failed: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Filter properties
  Future<ApiResponse> filterProperties({
    String? priceRange,
    String? rooms,
    String? propertyType,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      apiResponse.data = DummyData.filterProperties(
        priceRange: priceRange,
        rooms: rooms,
        propertyType: propertyType,
      );
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Filter failed: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Get user properties
  Future<ApiResponse> getUserProperties(int userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      final userProperties = DummyData.dummyProperties
          .where((p) => p.userId == userId.toString())
          .toList();
      apiResponse.data = userProperties;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to fetch user properties: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Add property
  Future<ApiResponse> addProperty(Property property) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final apiResponse = ApiResponse();
      
      // Add to dummy data with new ID
      final newProperty = Property(
        id: DummyData.dummyProperties.length + 1,
        title: property.title,
        rooms: property.rooms,
        address: property.address,
        area: property.area,
        userId: property.userId,
        about: property.about,
        propertyTypeId: property.propertyTypeId,
        price: property.price,
        location: property.location,
        isFav: false,
        homeFacilities: property.homeFacilities,
        user: property.user,
        images: property.images,
      );
      
      DummyData.dummyProperties.add(newProperty);
      apiResponse.data = newProperty;
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to add property: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Update property
  Future<ApiResponse> updateProperty(int id, Property property) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final apiResponse = ApiResponse();
      
      final index = DummyData.dummyProperties.indexWhere((p) => p.id == id);
      if (index != -1) {
        DummyData.dummyProperties[index] = Property(
          id: id,
          title: property.title,
          rooms: property.rooms,
          address: property.address,
          area: property.area,
          userId: property.userId,
          about: property.about,
          propertyTypeId: property.propertyTypeId,
          price: property.price,
          location: property.location,
          isFav: property.isFav,
          homeFacilities: property.homeFacilities,
          user: property.user,
          images: property.images,
        );
        apiResponse.data = DummyData.dummyProperties[index];
      } else {
        apiResponse.error = 'Property not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to update property: ${e.toString()}';
      return apiResponse;
    }
  }

  /// Delete property
  Future<ApiResponse> deleteProperty(int id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final apiResponse = ApiResponse();
      
      final index = DummyData.dummyProperties.indexWhere((p) => p.id == id);
      if (index != -1) {
        DummyData.dummyProperties.removeAt(index);
        apiResponse.data = {'message': 'Property deleted successfully'};
      } else {
        apiResponse.error = 'Property not found';
        apiResponse.ec = 404;
      }
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse();
      apiResponse.error = 'Failed to delete property: ${e.toString()}';
      return apiResponse;
    }
  }
}
