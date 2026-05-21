# Migration Guide - Integrating Local Services

## Overview
This guide explains how to modify existing pages to work with both online and local modes.

## Core Principle

The local services use the same `ApiResponse` pattern as the online services, making integration seamless:

```dart
// Both return ApiResponse
ApiResponse response = await signin(email, password);              // Online
ApiResponse response = await localAuthService.localSignIn(email, password);  // Local
```

## Implementation Pattern

### 1. Check App Mode in Controllers/ViewModels

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';
import 'package:hello_world/services/property_functions.dart';

class PropertyController {
  final localPropertyService = LocalPropertyService();
  
  Future<List<Property>> getAllProperties() async {
    ApiResponse response;
    
    if (AppConfig.useLocalMode) {
      response = await localPropertyService.getAllProperties();
    } else {
      response = await getAllPropertiesOnline(); // Your original function
    }
    
    if (response.error == null && response.data != null) {
      return response.data as List<Property>;
    }
    throw Exception(response.error);
  }
}
```

### 2. Update Existing Service Functions

**Before:**
```dart
// pages/explore_page.dart
Future<void> _loadProperties() async {
  ApiResponse response = await getAllPropertiesFromServer();
  if (response.error == null) {
    setState(() {
      properties = response.data as List<Property>;
    });
  }
}
```

**After:**
```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';

Future<void> _loadProperties() async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await LocalPropertyService().getAllProperties();
  } else {
    response = await getAllPropertiesFromServer();
  }
  
  if (response.error == null) {
    setState(() {
      properties = response.data as List<Property>;
    });
  }
}
```

## Page-by-Page Integration

### Authentication Pages

#### sign_in.dart ✅ (Already Updated)
- Already integrated with LocalAuthService
- Shows demo credentials when in local mode
- No further changes needed

#### signupp.dart (Sign-up)

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_auth_service.dart';

void _handleSignUp() async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    final localAuth = LocalAuthService();
    response = await localAuth.localSignUp(
      name,
      email,
      password,
      phone,
      userType,
    );
  } else {
    response = await register(name, email, password, phone, userType);
  }
  
  if (response.error == null) {
    // Handle success
  } else {
    // Handle error
  }
}
```

### Property Pages

#### explore_page.dart

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _localPropertyService = LocalPropertyService();
  List<Property> properties = [];
  
  @override
  void initState() {
    super.initState();
    _loadProperties();
  }
  
  Future<void> _loadProperties() async {
    ApiResponse response;
    
    if (AppConfig.useLocalMode) {
      response = await _localPropertyService.getAllProperties();
    } else {
      response = await getAllPropertiesFromServer();
    }
    
    if (response.error == null && response.data != null) {
      setState(() {
        properties = response.data as List<Property>;
      });
    }
  }
  
  // Rest of the page implementation remains the same
}
```

#### new_property.dart

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';

Future<void> _submitProperty() async {
  Property newProperty = Property(
    // ... property fields
  );
  
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await LocalPropertyService().addProperty(newProperty);
  } else {
    response = await uploadPropertyToServer(newProperty);
  }
  
  if (response.error == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Property added successfully')),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${response.error}')),
    );
  }
}
```

### User Pages

#### profile_screen.dart

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_user_service.dart';

final _localUserService = LocalUserService();

Future<void> _loadUserProfile(int userId) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.getUserById(userId);
  } else {
    response = await fetchUserProfile(userId);
  }
  
  if (response.error == null) {
    setState(() {
      user = response.data as User;
    });
  }
}

Future<void> _updateProfile(User updatedUser) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.updateUserProfile(updatedUser);
  } else {
    response = await updateUserProfileOnServer(updatedUser);
  }
  
  if (response.error == null) {
    // Show success message
  } else {
    // Show error message
  }
}
```

#### my_props.dart (User's Properties)

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_user_service.dart';

final _localUserService = LocalUserService();

Future<void> _loadMyProperties(int userId) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.getUserProperties(userId);
  } else {
    response = await getUserProperties(userId);
  }
  
  if (response.error == null && response.data != null) {
    setState(() {
      myProperties = response.data as List<Property>;
    });
  }
}
```

#### my_bookings.dart (Bookings)

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_user_service.dart';

final _localUserService = LocalUserService();

Future<void> _loadBookings(int userId) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.getUserBookings(userId);
  } else {
    response = await getUserBookings(userId);
  }
  
  if (response.error == null && response.data != null) {
    setState(() {
      bookings = response.data as List<Booking>;
    });
  }
}
```

### Search & Filter Pages

#### search_page.dart

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';

Future<void> _searchProperties(String query) async {
  ApiResponse response;
  final propertyService = LocalPropertyService();
  
  if (AppConfig.useLocalMode) {
    response = await propertyService.searchProperties(query);
  } else {
    response = await searchOnServer(query);
  }
  
  if (response.error == null && response.data != null) {
    setState(() {
      searchResults = response.data as List<Property>;
    });
  }
}
```

#### filter_screen.dart

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';

Future<void> _applyFilters() async {
  ApiResponse response;
  final propertyService = LocalPropertyService();
  
  if (AppConfig.useLocalMode) {
    response = await propertyService.filterProperties(
      rooms: selectedRooms,
      priceRange: selectedPrice,
      propertyType: selectedType,
    );
  } else {
    response = await filterOnServer(
      rooms: selectedRooms,
      priceRange: selectedPrice,
      propertyType: selectedType,
    );
  }
  
  if (response.error == null && response.data != null) {
    setState(() {
      filteredProperties = response.data as List<Property>;
    });
  }
}
```

#### fav_list.dart (Favorites)

```dart
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_user_service.dart';

final _localUserService = LocalUserService();

Future<void> _loadFavorites(int userId) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.getFavoriteProperties(userId);
  } else {
    response = await getFavoritesFromServer(userId);
  }
  
  if (response.error == null && response.data != null) {
    setState(() {
      favorites = response.data as List<Property>;
    });
  }
}

Future<void> _toggleFavorite(int propertyId, bool isFav) async {
  ApiResponse response;
  
  if (AppConfig.useLocalMode) {
    response = await _localUserService.toggleFavorite(propertyId, isFav);
  } else {
    response = await toggleFavoriteOnServer(propertyId, isFav);
  }
  
  if (response.error == null) {
    // Update UI
  }
}
```

## Complete Example: Property Listing Page

Here's a complete, production-ready example:

```dart
// pages/explore_page.dart
import 'package:flutter/material.dart';
import 'package:hello_world/config/app_config.dart';
import 'package:hello_world/services/local_property_service.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/models/api_response.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _localPropertyService = LocalPropertyService();
  List<Property> properties = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      ApiResponse response;

      if (AppConfig.useLocalMode) {
        response = await _localPropertyService.getAllProperties();
      } else {
        response = await getAllPropertiesFromServer();
      }

      if (response.error == null && response.data != null) {
        setState(() {
          properties = response.data as List<Property>;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response.error ?? 'Unknown error occurred';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Properties (${AppConfig.getModeString()})',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProperties,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $errorMessage'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadProperties,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return PropertyCard(property: property);
                    },
                  ),
      ),
    );
  }
}
```

## Testing Checklist

- [ ] Sign in with each demo account
- [ ] View all properties in local mode
- [ ] Search for properties
- [ ] Filter properties
- [ ] Add new property
- [ ] Update existing property
- [ ] Delete property
- [ ] Add/remove favorites
- [ ] View bookings
- [ ] Switch to online mode
- [ ] Verify original functionality still works

## Common Pitfalls to Avoid

1. **Forget to import AppConfig**
   ```dart
   // ✅ Do this
   import 'package:hello_world/config/app_config.dart';
   ```

2. **Check mode before calling service**
   ```dart
   // ✅ Do this
   if (AppConfig.useLocalMode) {
     response = await localService.getData();
   }
   
   // ❌ Don't do this
   response = await localService.getData();
   ```

3. **Handle both error and data scenarios**
   ```dart
   // ✅ Do this
   if (response.error == null && response.data != null) {
     // Use data
   } else {
     // Show error
   }
   ```

## Troubleshooting

### Service returns empty data
- Check DummyData is populated in dummy_data.dart
- Verify correct service method is being called
- Add print statements for debugging

### Navigation not working after login
- Verify _saveAndRedirectToHome in sign_in.dart
- Check SharedPreferences is storing user data
- Ensure home page is properly initialized

### Properties not updating after add/edit
- Remember properties are in-memory only
- Add SQLite/Hive if persistence needed
- Reload properties after operations

---

## Support

For questions about specific pages or services, refer to:
- LOCAL_DEMO_MODE_README.md - Detailed documentation
- DEMO_MODE_QUICK_REFERENCE.md - Quick lookup
- lib/services/local_*_service.dart - Implementation details

---

**Version:** 1.0  
**Last Updated:** May 2026
