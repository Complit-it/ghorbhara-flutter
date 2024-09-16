class Options {
  int id;
  String name;

  Options({required this.id, required this.name});

  @override
  String toString() {
    return 'Options(id: $id, name: $name)';
  }
}

class PropTypeOptions {
  int id;
  String name;
  String? color;

  PropTypeOptions({required this.id, required this.name, this.color});

  @override
  String toString() {
    return 'PropTypeOptions(id: $id, name: $name, color: $color)';
  }
}



  // static fromJson(data) {}

  // factory Options.fromJson(Map<String, dynamic> json) {
  //   return Options(
  //     id: json['id'] as int,
  //     name: json['facility'] as String,
  //   );
  // }
// Future<ApiResponse> get_home_facilities() async {
//   ApiResponse apiResponse = ApiResponse();
//   Options resp = Options(); // Not used in this code

//   try {
//     final response = await http.get(Uri.parse(getHomeFacUrl));

//     switch (response.statusCode) {
//       case 200:
//         final jsonData = jsonDecode(response.body)['data'] as List;
//         apiResponse.data = jsonData.map((data) => Options.fromJson(data)).toList();
//         break;
//       case 500:
//         apiResponse.error = jsonDecode(response.body)['message'];
//         break;
//       default:
//         apiResponse.error = somethingWentWrong;
//     }
//   } catch (e) {
//     apiResponse.error = serverError;
//   }

//   print(apiResponse.data); // Now contains a list of Options objects
//   print(apiResponse.error);
//   return apiResponse;
// }

// // Add this method to your Options class:
// factory Options.fromJson(Map<String, dynamic> json) => Options(
//   id: json['id'] as int?,
//   name: json['facility'] as String?,
// );
