# 🐛 Troubleshooting Guide - Local Demo Mode

## Common Issues & Solutions

---

## ❌ App Won't Start

### Issue: "Firebase initialization error"
**Symptoms:**
- App crashes on startup
- Error: "Firebase initialization failed" or similar

**Solutions:**
1. Verify `useLocalMode = true` in `lib/config/app_config.dart`
2. Check `lib/main.dart` has conditional Firebase init:
   ```dart
   if (!AppConfig.useLocalMode) {
     _initializeFireb();
   }
   ```
3. If in online mode, ensure Firebase is properly configured
4. Clean and rebuild: `flutter clean && flutter pub get`

**Still not working?**
- Check pubspec.yaml has all Firebase dependencies
- Verify firebase_options.dart exists
- Check for typos in imports

---

### Issue: "Cannot find package" or "Import error"
**Symptoms:**
- Compilation error about missing package/file
- Red squiggles in IDE

**Solutions:**
1. Verify all new files exist:
   - [ ] `lib/config/app_config.dart`
   - [ ] `lib/data/dummy_data.dart`
   - [ ] `lib/services/local_auth_service.dart`
   - [ ] `lib/services/local_property_service.dart`
   - [ ] `lib/services/local_user_service.dart`

2. Verify imports are correct (case-sensitive):
   ```dart
   import 'package:hello_world/config/app_config.dart';
   import 'package:hello_world/data/dummy_data.dart';
   import 'package:hello_world/services/local_auth_service.dart';
   // etc.
   ```

3. Run `flutter pub get` again
4. Restart IDE/editor

---

### Issue: "Null safety" or type errors
**Symptoms:**
- Compilation errors about null safety
- "Type 'X' is not a subtype of type 'Y'"

**Solutions:**
1. Ensure Flutter SDK is up to date: `flutter upgrade`
2. Check Dart version compatibility
3. Verify all type annotations in service files
4. Run analysis: `flutter analyze`

---

## ❌ Sign-In/Authentication Issues

### Issue: Sign-in fails with demo credentials
**Symptoms:**
- Error: "Invalid email or password"
- Can't sign in with any demo account

**Solutions:**
1. **Verify credentials are exactly correct (case-sensitive):**
   ```
   Email: owner@example.com
   Password: password
   ```

2. **Check LocalAuthService.localSignIn():**
   ```dart
   if ((email == 'owner@example.com' && password == 'password') ||
       // ... other valid combinations
   )
   ```

3. **Verify DummyData has users:**
   ```dart
   // In lib/data/dummy_data.dart
   static final List<User> dummyUsers = [
     User(email: 'owner@example.com', ...)
     // ... other users
   ];
   ```

4. **Debug steps:**
   - Add print statements to `localSignIn()`
   - Verify email and password match exactly
   - Check for extra spaces or hidden characters
   - Restart app

---

### Issue: Demo credentials not showing on login screen
**Symptoms:**
- No demo info box on login screen
- Demo credentials not visible

**Solutions:**
1. Verify `AppConfig.useLocalMode = true`
2. Check `sign_in.dart` has the demo credentials UI section:
   ```dart
   if (AppConfig.useLocalMode)
     Container(
       // ... demo credentials box
     ),
   ```

3. Verify `_buildDemoCredential()` method exists
4. Check if condition: `if (AppConfig.useLocalMode)`
5. Clear app cache: `flutter clean`

---

### Issue: Can't auto-fill credentials by clicking
**Symptoms:**
- Demo credentials show but clicking doesn't fill fields
- Credentials text not clickable

**Solutions:**
1. Verify `_buildDemoCredential()` method exists in _SignInState
2. Check method has `GestureDetector` wrapper
3. Verify `_mailController` and `_passwordController` exist
4. Check method is called in build():
   ```dart
   _buildDemoCredential('Owner', 'owner@example.com', 'password'),
   ```

5. Test with print statements in onTap:
   ```dart
   GestureDetector(
     onTap: () {
       print('Clicked: $email');
       _mailController.text = email;
     },
   )
   ```

---

### Issue: After sign-in, still on login screen
**Symptoms:**
- Sign-in successful but doesn't navigate
- "Loading..." shows forever

**Solutions:**
1. Check `_saveAndRedirectToHome()` function
2. Verify `SharedPreferences` is saving user:
   ```dart
   await saveUserToSharedPreferences(user, 'N');
   ```

3. Check navigation code:
   ```dart
   Navigator.of(context).pushAndRemoveUntil(
     MaterialPageRoute(builder: (context) => Home()),
     (route) => false
   );
   ```

4. Verify Home page exists and loads
5. Check for exceptions in debug console

---

## ❌ Data Not Showing

### Issue: Properties list is empty
**Symptoms:**
- Browse properties shows empty list
- "No properties found" or blank screen

**Solutions:**
1. **Verify DummyData is populated:**
   ```dart
   // lib/data/dummy_data.dart
   static final List<Property> dummyProperties = [
     Property(id: 1, title: 'Luxury Apartment', ...),
     Property(id: 2, title: 'Cozy Studio', ...),
     // ... should have 5 properties total
   ];
   ```

2. **Check LocalPropertyService.getAllProperties():**
   ```dart
   apiResponse.data = DummyData.dummyProperties;
   ```

3. **Verify page is calling service:**
   ```dart
   if (AppConfig.useLocalMode) {
     response = await LocalPropertyService().getAllProperties();
   }
   ```

4. **Debug steps:**
   - Add print: `print('Properties: ${DummyData.dummyProperties}');`
   - Verify list is not empty
   - Check UI is accessing response.data correctly

---

### Issue: Users list is empty
**Symptoms:**
- Can't see other users
- User search returns no results

**Solutions:**
1. Verify DummyData.dummyUsers has 4 users
2. Check search is using correct service
3. Add debug prints to verify data loading
4. Restart app

---

### Issue: Properties not loading when page first opens
**Symptoms:**
- Page shows "Loading..." indefinitely
- Properties eventually load after delay

**Solutions:**
1. Check `initState()` calls `_loadProperties()`
2. Verify no errors in service
3. Add error handling:
   ```dart
   if (response.error != null) {
     print('Error: ${response.error}');
   }
   ```

4. Increase timeout if needed:
   ```dart
   await Future.delayed(const Duration(milliseconds: 500));
   ```

5. Add try-catch for debugging

---

## ❌ Functionality Issues

### Issue: Can't add new property
**Symptoms:**
- Add property button does nothing
- No error shown

**Solutions:**
1. Verify `LocalPropertyService.addProperty()` exists
2. Check service is being called
3. Verify form validation passes
4. Add error handling and logging
5. Check property ID generation

---

### Issue: Favorites not working
**Symptoms:**
- Can't add to favorites
- Favorites list empty

**Solutions:**
1. Check `toggleFavorite()` in LocalUserService
2. Verify property isFav flag updates
3. Check favorites list retrieves correct properties
4. Ensure user is logged in

---

### Issue: Search not working
**Symptoms:**
- Search returns empty results
- Search crashes app

**Solutions:**
1. Verify `LocalPropertyService.searchProperties()` exists
2. Check search string matching logic
3. Verify case-insensitive search:
   ```dart
   property.title.toLowerCase().contains(query.toLowerCase())
   ```

4. Test with exact property names
5. Add debug logs

---

### Issue: Filter not working
**Symptoms:**
- Filter button does nothing
- Filtered results incorrect

**Solutions:**
1. Check `filterProperties()` method parameters
2. Verify filter logic in LocalPropertyService
3. Check all filter types are supported
4. Verify UI is passing correct values
5. Test individual filters first

---

## ❌ Performance Issues

### Issue: App is slow or freezes
**Symptoms:**
- UI lags when loading properties
- App freezes when searching

**Solutions:**
1. Check for long-running operations on main thread
2. Use async/await properly:
   ```dart
   Future<void> loadData() async {
     await someService.getData();
   }
   ```

3. Wrap heavy operations in Future
4. Profile with Flutter DevTools
5. Check for infinite loops

---

### Issue: High memory usage
**Symptoms:**
- App crashes with "Out of memory"
- Performance degrades over time

**Solutions:**
1. Check for memory leaks in services
2. Verify StreamController are closed
3. Clear cached data when not needed
4. Profile with DevTools memory tab
5. Limit list size if needed

---

## ❌ Mode Switching Issues

### Issue: Can't switch to online mode
**Symptoms:**
- App still uses local data after switching
- Firebase errors

**Solutions:**
1. Change `useLocalMode = false` in app_config.dart
2. Ensure Firebase is properly configured
3. Check firebase_options.dart exists
4. Rebuild app: `flutter clean && flutter pub get`
5. Verify backend is running

---

### Issue: Switching back to local mode doesn't work
**Symptoms:**
- After using online mode, local mode fails
- No data appears

**Solutions:**
1. Change `useLocalMode = true` in app_config.dart
2. Verify DummyData is still populated
3. Clear app state: `flutter clean`
4. Restart app completely
5. Check for data conflicts

---

## ❌ UI/UX Issues

### Issue: Demo credentials box not styled properly
**Symptoms:**
- Demo box looks wrong
- Text not visible or overlapping

**Solutions:**
1. Check Container styling in sign_in.dart
2. Verify colors are defined:
   ```dart
   color: Colors.amber[50],
   border: Border.all(color: Colors.amber[300]!),
   ```

3. Check padding and margins
4. Adjust if screen size different
5. Test on different devices

---

### Issue: Navigation buttons don't work
**Symptoms:**
- Can't navigate to other pages
- Back button doesn't work

**Solutions:**
1. Verify Navigator.push/pop are correct
2. Check route exists
3. Verify context is correct
4. Test with print statements
5. Check for navigation state issues

---

## ⚠️ Warnings & Best Practices

### Warning: Local data lost after restart
**Note:** In-memory data (new properties added) is lost when app restarts. This is by design for demo mode.

**Solution:** To persist data, implement SQLite or Hive:
```dart
// Future enhancement
class LocalDatabase {
  Future<void> saveProperty(Property p) async {
    // Save to SQLite/Hive
  }
}
```

---

### Warning: No real notifications
**Note:** Demo mode doesn't send real notifications since no backend.

**Solution:** Mock notifications for testing:
```dart
// Add to local services
Future<void> mockNotification(String title, String body) {
  // Show snackbar instead
}
```

---

## 🔍 Debug Tips

### Enable Verbose Logging
```bash
flutter run -v  # Shows detailed logs
```

### Check Console Output
- Look for print statements
- Watch for exceptions
- Check network calls
- Monitor memory usage

### Use Breakpoints
```dart
// Set breakpoints in IDE
void someFunction() {
  debugPrint('Checkpoint 1'); // Shows in console
  // ... code ...
  debugPrint('Checkpoint 2');
}
```

### Use DevTools
```bash
flutter pub global activate devtools
devtools  # Opens web-based tools
```

---

## 📋 Debugging Checklist

Before reporting issue:
- [ ] Check exact error message
- [ ] Provide reproducible steps
- [ ] Check all dependencies installed
- [ ] Verify Flutter/Dart versions
- [ ] Clear cache: `flutter clean`
- [ ] Rebuild: `flutter pub get`
- [ ] Check import statements
- [ ] Add debug prints
- [ ] Test on both platforms (Android/iOS)
- [ ] Check WiFi/internet (if online mode)

---

## 🆘 When All Else Fails

### Reset Everything
```bash
# Complete clean
flutter clean
rm -rf .dart_tool
flutter pub get
flutter pub upgrade
flutter analyze

# Rebuild
flutter run
```

### Verify File Structure
```
lib/
├── config/app_config.dart              ✓ Should exist
├── data/dummy_data.dart                ✓ Should exist
├── services/
│   ├── local_auth_service.dart        ✓ Should exist
│   ├── local_property_service.dart    ✓ Should exist
│   ├── local_user_service.dart        ✓ Should exist
│   ├── user_service.dart              ✓ Original file
│   └── property_functions.dart        ✓ Original file
└── pages/
    └── sign_in.dart                   ✓ Modified
```

### Restart from Scratch
1. Backup current code
2. Restore original files (if modified incorrectly)
3. Re-apply changes carefully
4. Test incrementally

---

## 📞 Getting Help

### Check Documentation
1. LOCAL_DEMO_MODE_README.md - Full details
2. DEMO_MODE_QUICK_REFERENCE.md - Quick lookup
3. MIGRATION_GUIDE.md - Integration help
4. This file - Troubleshooting

### Provide Complete Info
When asking for help, include:
- Exact error message
- Steps to reproduce
- What you tried
- Screenshots if visual
- Console/logcat output
- Flutter version: `flutter --version`

---

## 💡 Pro Tips

### Tip 1: Use Local Mode for Development
- Faster iteration
- No internet needed
- Consistent test data
- Great for offline work

### Tip 2: Test Both Modes Regularly
- Switch modes to verify both work
- Catch integration issues early
- Ensure smooth transition to production

### Tip 3: Add More Demo Data
- Copy existing data and modify
- Test edge cases with varied data
- Create realistic scenarios
- Use for stress testing

### Tip 4: Keep Services Simple
- Each service should do one thing
- Easy to test and debug
- Easier to migrate to real backend
- Better code organization

---

**Version:** 1.0  
**Last Updated:** May 2026  
**Status:** Ready to Debug! 🎯
