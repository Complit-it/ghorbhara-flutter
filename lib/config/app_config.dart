/// App Configuration
/// Controls the mode of the application (local demo mode or online mode)

class AppConfig {
  static bool useLocalMode = true; // Set to false to use online backend
  static bool useDummyData = true; // Use dummy/mock data
  
  /// Toggle between local and online mode
  static void setLocalMode(bool isLocal) {
    useLocalMode = isLocal;
  }
  
  /// Get current mode string
  static String getModeString() {
    return useLocalMode ? 'DEMO (LOCAL)' : 'ONLINE';
  }
}
