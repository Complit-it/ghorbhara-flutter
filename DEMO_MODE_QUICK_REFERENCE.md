# Quick Reference - Local Demo Mode

## 🚀 Quick Start

### 1. Enable Local Mode
Open `lib/config/app_config.dart` and ensure:
```dart
static bool useLocalMode = true;
```

### 2. Run the App
```bash
flutter run
```

### 3. Sign In with Demo Credentials
- Email: `owner@example.com`
- Password: `password`

**Or click any demo credential shown on the login screen to auto-fill!**

---

## 📋 Demo Accounts

### Property Owners
| Email | Password | Properties |
|-------|----------|-----------|
| `owner@example.com` | password | Luxury Apt, Studio, Budget Room |
| `mike.property@example.com` | password | Villa, 2BHK Flat |

### Tenants  
| Email | Password | Bookings |
|-------|----------|----------|
| `tenant@example.com` | password | Luxury Apt (Confirmed) |
| `sarah.finder@example.com` | password | Villa (Pending) |

---

## 🏠 Demo Properties

| # | Property | Type | Rooms | Price | Owner |
|---|----------|------|-------|-------|-------|
| 1 | Luxury Apartment Downtown | Apt | 3 | ₹50,000 | John |
| 2 | Cozy Studio Metro | Studio | 1 | ₹25,000 | John |
| 3 | Spacious Villa Garden | Villa | 4 | ₹80,000 | Mike |
| 4 | Modern 2BHK Flat | Apt | 2 | ₹35,000 | Mike |
| 5 | Budget Room Share | Room | 1 | ₹15,000 | John |

---

## 🔧 File Structure

```
lib/
├── config/
│   └── app_config.dart                    # ← Toggle local/online mode
├── data/
│   └── dummy_data.dart                    # ← All demo data
├── services/
│   ├── local_auth_service.dart           # ← Sign in/up (local)
│   ├── local_property_service.dart       # ← Properties (local)
│   ├── local_user_service.dart           # ← Users & bookings (local)
│   ├── user_service.dart                 # ← Original API service
│   └── property_functions.dart           # ← Original API calls
└── pages/
    └── sign_in.dart                       # ← Modified for demo mode
```

---

## 💻 API Responses

All local services return standard `ApiResponse` objects:

```dart
class ApiResponse {
  dynamic data;        // The actual data
  String? error;       // Error message (if any)
  int? ec;             // Error code (if any)
}
```

**No changes needed in UI code!**

---

## ⚙️ Switching Modes

### To Online Mode:
```dart
// lib/config/app_config.dart
static bool useLocalMode = false;  // Change to false
```

### To Local Demo Mode:
```dart
// lib/config/app_config.dart  
static bool useLocalMode = true;   // Change to true
```

The rest of your code remains unchanged!

---

## 🎯 Available Features in Demo Mode

✅ Sign-in/Sign-up  
✅ View all properties  
✅ Search properties  
✅ Filter properties  
✅ View property details  
✅ Add to favorites  
✅ View user profile  
✅ View bookings  
✅ Create new property  
✅ Update property  
✅ Delete property  

---

## 🔍 Key Implementation Details

### How Auth Works (Local Mode)
```dart
// Sign in - credentials checked against DummyData.dummyUsers
Future<ApiResponse> localSignIn(String email, String password)

// Response saved to SharedPreferences
// Available for entire session
```

### How Properties Work (Local Mode)
```dart
// Get all
Future<ApiResponse> getAllProperties()

// Search
Future<ApiResponse> searchProperties(String query)

// Filter  
Future<ApiResponse> filterProperties({String? rooms, ...})

// CRUD
Future<ApiResponse> addProperty(Property property)
Future<ApiResponse> updateProperty(int id, Property property)
Future<ApiResponse> deleteProperty(int id)
```

### In-Memory Storage
- Properties modified in current session
- Lost on app restart (by design)
- Can add SQLite/Hive for persistence

---

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Sign-in fails | Check email/password match exact spelling |
| Demo data not showing | Verify `useLocalMode = true` |
| Firebase error on startup | Ensure Firebase init is conditional in main.dart |
| Can't find local services | Check imports and file paths |

---

## 📝 Development Notes

### Adding More Demo Users
```dart
// lib/data/dummy_data.dart
static final List<User> dummyUsers = [
  User(
    id: 5,
    name: 'New User',
    email: 'new@example.com',
    // ... other fields
  ),
  // ... existing users
];
```

### Adding More Properties  
```dart
// lib/data/dummy_data.dart
static final List<Property> dummyProperties = [
  Property(
    id: 6,
    title: 'New Property',
    // ... other fields
  ),
  // ... existing properties
];
```

### Using Local Services in Code
```dart
// Import the service
import 'package:hello_world/services/local_property_service.dart';

// Create instance
final propertyService = LocalPropertyService();

// Use it
ApiResponse response = await propertyService.getAllProperties();

// Handle response (same as online mode!)
if (response.error == null) {
  List<Property> properties = response.data as List<Property>;
} else {
  print('Error: ${response.error}');
}
```

---

## 🚀 What's Next?

1. **Test all features** with demo accounts
2. **Try switching modes** to verify both work
3. **Add more demo data** as needed
4. **Customize properties** with real requirements
5. **Switch to online mode** when backend is ready

---

**Version:** 1.0  
**Last Updated:** May 2026  
**Mode:** Demo ✨
