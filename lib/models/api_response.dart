// import 'package:hello_world/models/user.dart';

class ApiResponse {
  Object? data;
  // Map<String, dynamic>? error;
  String? error;
  int? ec; //error code

  @override
  String toString() {
    return 'ApiResponse(data: $data, error: $error, ec: $ec)';
  }
}
