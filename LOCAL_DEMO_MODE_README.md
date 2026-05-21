# Ghorbhara Flutter App - Local Demo Mode Setup

## Overview
The Ghorbhara Flutter app now supports **Local Demo Mode** - allowing full demonstration of the app without requiring Firebase connection or backend API calls. All data is stored locally using dummy data.

## Files Added/Modified

### New Files Created:

1. **`lib/config/app_config.dart`** - App configuration manager
   - Controls app mode (local vs online)
   - Toggle between demo and production modes
   
2. **`lib/data/dummy_data.dart`** - Mock/dummy data provider
   - Contains 4 demo users (owners and tenants)
   - Contains 5 demo properties with full details
   - Contains 2 demo bookings
   - Provides utility functions for searching, filtering, and retrieving data

3. **`lib/services/local_auth_service.dart`** - Local authentication service
   - Handles sign-in without Firebase
   - Handles sign-up with local data storage
   - Manages user session locally using SharedPreferences
   - Demo password: `password`

4. **`lib/services/local_property_service.dart`** - Local property operations
   - Provides property listing, search, and filter functionality
   - Handles CRUD operations on properties
   - Simulates network delays for realistic UX

5. **`lib/services/local_user_service.dart`** - Local user operations
   - Provides user profile management
   - Handles user searches and favorites
   - Manages bookings for users

### Modified Files:

1. **`lib/main.dart`**
   - Added AppConfig import
   - Modified Firebase initialization to skip when in local mode
   - Conditional Firebase setup

2. **`lib/pages/sign_in.dart`**
   - Added LocalAuthService integration
   - Modified `_loginUser()` to support both local and online modes
   - Added demo mode UI showing all demo credentials
   - Added `_buildDemoCredential()` helper to fill credentials with single tap
   - Show mode indicator (DEMO/ONLINE) on sign-in screen

## How to Use

### Switching Modes

Edit `lib/config/app_config.dart`:

```dart
class AppConfig {
  static bool useLocalMode = true;   // Set to false for online mode
  static bool useDummyData = true;   // Use dummy/mock data
}
```

### Demo Credentials

When in local mode, the sign-in screen displays all available demo accounts:

| User Type | Email | Password |
|-----------|-------|----------|
| Owner | `owner@example.com` | `password` |
| Tenant | `tenant@example.com` | `password` |
| Property Owner | `mike.property@example.com` | `password` |
| Tenant 2 | `sarah.finder@example.com` | `password` |

**Quick Tip:** Click on any demo credential in the sign-in screen to auto-fill the email and password fields.

### Demo Data Overview

#### Users
- **John Owner** (owner@example.com) - Property owner with multiple listings
- **Jane Tenant** (tenant@example.com) - Tenant with active bookings
- **Mike Property** (mike.property@example.com) - Second property owner
- **Sarah Finder** (sarah.finder@example.com) - Second tenant

#### Properties
1. **Luxury Apartment in Downtown** - 3BHK, ₹50,000/month
2. **Cozy Studio Near Metro** - 1BHK, ₹25,000/month
3. **Spacious Villa with Garden** - 4BHK, ₹80,000/month
4. **Modern 2BHK Flat** - 2BHK, ₹35,000/month
5. **Budget-Friendly Room Share** - 1 Room, ₹15,000/month

#### Bookings
- Jane Tenant has a confirmed booking for Luxury Apartment
- Sarah Finder has a pending booking for Spacious Villa

### Features in Local Mode

✅ **Full Functionality:**
- User authentication (sign-in/sign-up)
- Browse all properties
- Search and filter properties
- View property details
- Save properties to favorites
- View user bookings
- Edit user profile
- Add new properties
- Update properties
- Delete properties

✅ **Demo Experience:**
- No internet required
- No Firebase setup needed
- Instant responses with simulated delays
- All features fully functional
- Persistent local data storage

## Integration with Existing Services

The local services are designed to be drop-in replacements:

```dart
// Instead of:
// response = await getUserProperties(userId);

// In local mode, use:
final localUserService = LocalUserService();
response = await localUserService.getUserProperties(userId);

// The API Response object is identical, so UI code doesn't need changes!
```

## Building on Demo Mode

### Adding More Demo Data

Edit `lib/data/dummy_data.dart`:

```dart
static final List<Property> dummyProperties = [
  // Add new Property objects here
  Property(
    id: 6,
    title: 'New Property',
    // ... other fields
  ),
];
```

### Extending Services

Create new local services following the same pattern:

```dart
// lib/services/local_booking_service.dart
class LocalBookingService {
  Future<ApiResponse> getBooking(int id) async {
    // Implementation
  }
}
```

## Switching Back to Online Mode

1. Set `useLocalMode = false` in `lib/config/app_config.dart`
2. Ensure Firebase is properly configured
3. The app will automatically use the original API services

## Data Persistence

In local mode, user data is stored using `SharedPreferences`:
- User session stored after login
- Supports sign-out and clearing local data
- New properties/bookings are kept in-memory (not persisted between app restarts)

## Future Enhancements

- Add local database (SQLite/Hive) for persistent property data
- Add message/chat mock data
- Add more diverse demo users and properties
- Add offline-first synchronization
- Add demo data reset functionality

## Troubleshooting

### "Firebase initialization failed" in local mode?
- Ensure `useLocalMode = true` in AppConfig
- Check that Firebase initialization is properly conditional in main.dart

### Demo data not showing?
- Verify DummyData.dummyProperties is populated
- Check that LocalPropertyService methods are being called
- Ensure app_config.dart has useLocalMode set correctly

### Sign-in fails with demo credentials?
- Verify email and password match exactly from DummyData
- Check LocalAuthService.localSignIn() logic
- Ensure LocalAuthService is imported in sign_in.dart

---

**Last Updated:** May 2026
**Version:** 1.0 - Local Demo Mode Support
