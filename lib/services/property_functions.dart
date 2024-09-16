// ignore_for_file: empty_catches, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/options.dart';
import 'package:hello_world/models/property.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ad.dart';

Future<ApiResponse> save_prop() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> data = {
      "title": "title",
      "rooms": "rooms",
      "address": "address",
      "area": "area",
      "about": "about",
      "property_type_id": "prop_type_id"
    };

    final response = await http.post(
      Uri.parse(savePropUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'appliation/json'
      },
      body: jsonEncode(data),
    );
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> uploadProperty(
    List<XFile> selectedImages,
    String title,
    String address,
    String area,
    String about,
    int property_type_id,
    int room_id,
    List<Options> selectedFac,
    String location,
    String price,
    int userId,
    String? lat,
    String? long) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
    final request = http.MultipartRequest('POST', Uri.parse(uploadPropUrl));

    request.fields['title'] = title;
    request.fields['address'] = address;
    request.fields['area'] = area;
    request.fields['about'] = about;
    request.fields['property_type_id'] = property_type_id.toString();
    request.fields['room_id'] = room_id.toString();
    request.fields['location'] = location;
    request.fields['price'] = price;
    request.fields['userId'] = userId.toString();
    request.fields['lat'] = lat!;
    request.fields['long'] = long!;
    final selectedFacJson =
        jsonEncode(selectedFac.map((fac) => fac.id).toList());
    request.fields['selectedFac'] = selectedFacJson;

    request.fields.forEach((key, value) {});

    for (XFile image in selectedImages) {
      request.files.add(await http.MultipartFile.fromPath(
        'images[]',
        image.path,
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.transform(utf8.decoder).join();

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody)['success'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

List<MultiSelectItem> dropDownData = [];
List<Options> data = [];

Future<void> getHomeFacility() async {
  data.clear();
  dropDownData.clear();
  try {
    final response = await http.get(Uri.parse(getHomeFacUrl));

    if (response.statusCode == 200) {
      // print('daataa: ${response.body}');
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      print(decodedData);

      List<Options> tempSubjectData = [];
      decodedData['data'].forEach(
        (data) {
          tempSubjectData.add(
            Options(
              id: data['id'],
              name: data['facility'],
            ),
          );
        },
      );
      data.addAll(tempSubjectData);

      dropDownData = data.map((subjectdata) {
        return MultiSelectItem(subjectdata, subjectdata.name);
      }).toList();
      print('dropDownData: $dropDownData');
    } else {}
  } catch (e) {}
}

// List<MultiSelectItem> propType = [];
// List<PropTypeOptions> propTypedata = [];

// Future<void> getPropType() async {
//   propTypedata.clear();
//   propType.clear();
//   try {
//     final response = await http.get(Uri.parse(getPropTypeUrl));

//     if (response.statusCode == 200) {
//       final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
//       print(decodedData);

//       // List<PropTypeOptions> propTypes = [];
//       // decodedData['data'].forEach(
//       //   (data) {
//       //     propTypes.add(
//       //       PropTypeOptions(
//       //         id: data['id'],
//       //         name: data['property_type'],
//       //         // color: data['color'] ?? ''
//       //       ),
//       //     );
//       //   },
//       // );
//       // propTypedata.addAll(propTypes);

//       // propType = propTypedata.map((subjectdata) {
//       //   return MultiSelectItem(subjectdata, subjectdata.name);
//       // }).toList();
//     } else {}
//   } catch (e) {}
// }

List<MultiSelectItem> propType = [];
List<PropTypeOptions> propTypedata = [];

Future<void> getPropType() async {
  propTypedata.clear();
  propType.clear();
  try {
    final response = await http.get(Uri.parse(getPropTypeUrl));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      // print(decodedData);

      // Ensure you correctly parse the list of maps from the decodedData
      if (decodedData['data'] != null && decodedData['data'] is List) {
        List<PropTypeOptions> propTypes =
            (decodedData['data'] as List).map((data) {
          return PropTypeOptions(
            id: data['id'],
            name: data['property_type'],
            // color: data['color'], // Handle color if it is nullable
          );
        }).toList();

        propTypedata.addAll(propTypes);
        print(propTypedata);

        propType = propTypedata.map((subjectdata) {
          return MultiSelectItem(subjectdata, subjectdata.name);
        }).toList();

        // print(propType);
      }
    } else {
      print(
          'Failed to load property types with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<ApiResponse> get_all_property(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  // print('xxx');
  try {
    final response = await http.get(
      Uri.parse('$getAllPropUrl?user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ).timeout(Duration(seconds: 60));

    // print(response.body);
    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body) as List;
      // print(data);
      try {
        final List<Property> properties =
            data.map((item) => Property.fromJson(item)).toList();
        apiResponse.data = properties; // Set the data in ApiResponse
      } catch (e) {}
    } else {
      apiResponse.error = 'error'; // Set error flag in ApiResponse
    }
  } catch (e) {
    apiResponse.error = "true"; // Set error flag in ApiResponse
  }
  return apiResponse;
}

Future<ApiResponse> get_one_property(int id, int userID) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // print('$getOnePropUrl/$id');
    final response = await http.get(
      Uri.parse('$getOnePropUrl/$id?userID=$userID'),
      // Uri.parse(getOnePropUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // print(data);

      if (data['success'] == true) {
        // Map the property data from the response to the Property model
        Property property = Property.fromJson(data['property']);
        apiResponse.data = property; // Set the data in ApiResponse
      } else {
        apiResponse.error = 'Property not found';
      }
    } else {
      apiResponse.error = 'Error: ${response.statusCode}';
    }
  } catch (e) {}
  return apiResponse;
}

Future<ApiResponse> add_to_fav({int prop_id = 0, int user_id = 0}) async {
  final apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> data = {"prop_id": prop_id, "user_id": user_id};
    final response = await http.post(
      Uri.parse(addTofav),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }
  // print(apiResponse.data);
  // print(apiResponse.error);
  return apiResponse;
}

Future<ApiResponse> remove_fav({int prop_id = 0, int user_id = 0}) async {
  final apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> data = {"prop_id": prop_id, "user_id": user_id};
    final response = await http.post(
      Uri.parse(removeFav),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }
  // print(apiResponse.data);
  // print(apiResponse.error);
  return apiResponse;
}

//returns property based on user search
Future<ApiResponse> searched_property(String query) async {
  ApiResponse apiResponse = ApiResponse();
  // print('xxx');
  try {
    final Map<String, String> data = {"query": query};
    // final Map<String, dynamic> data = {"query": query};
    final response = await http.post(Uri.parse(searchPropUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print(data);
      // Convert each item to a Property object
      try {
        final List<Property> properties =
            data.map((item) => Property.fromJson(item)).toList();
        apiResponse.data = properties;
      } catch (e) {
        print(e);
      }
    } else {
      apiResponse.error = 'error';
    }
  } catch (e) {
    apiResponse.error = "true";
    print(e);
  }
  return apiResponse;
}

Future<ApiResponse> get_fav_props(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse('$getFavPropUrl?userID=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      // print('xxx');

      try {
        final data = jsonDecode(response.body) as List;
        final List<Property> properties =
            data.map((item) => Property.fromJson(item)).toList();
        apiResponse.data = properties;
      } catch (e) {}
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {}

  return apiResponse;
}

Future<ApiResponse> get_all_ads() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse(getAllAddUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }).timeout(Duration(seconds: 60));
    // print(response.body);

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Ad> ads = jsonList.map((json) => Ad.fromJson(json)).toList();
        apiResponse.data = ads;
      } catch (e) {
        apiResponse.error = 'Error parsing ads data';
      }
    } else {
      apiResponse.error = 'Error: ${response.statusCode}';
    }
  } catch (e) {}
  print(apiResponse.data);
  return apiResponse;
}

Future<ApiResponse> getAdd(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse('$getAdUrl?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Ad ad = Ad.fromJson(json);
      apiResponse.data = ad;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }

  return apiResponse;
}

Future<ApiResponse> getUserProps(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse('$getUserPropsUrl?userId=$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    // print(response.body);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body) as List;

      try {
        final List<Property> properties =
            data.map((item) => Property.fromJson(item)).toList();
        // properties.forEach((property) => print(property));
        apiResponse.data = properties; // Set the data in ApiResponse
      } catch (e) {
        apiResponse.error = 'error';
        print(e);
      }
    } else {
      apiResponse.error = 'error'; // Set error flag in ApiResponse
    }
  } catch (e) {}
  // print(apiResponse.data);
  return apiResponse;
}

Future<ApiResponse> bookProp(String userId, String propId, String orderId,
    String paymentId, int price) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(bookPropUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "propId": propId,
          "orderId": orderId,
          "paymentId": paymentId,
          "amount": price,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else {
      apiResponse.error = 'Error: ${response.statusCode}';
    }
  } catch (e) {
    apiResponse.error = 'Error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> getReq(String url, String data) async {
  ApiResponse apiResponse = ApiResponse();
  print('*');
  try {
    final response = await http.get(Uri.parse('$url?$data'),
        headers: {'Content-Type': 'application/json'});
    // print(response.body);

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
      // final List<Property> properties =
      //     data['properties'].map((item) => Property.fromJson(item)).toList();
      // print(data);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['booked'] = true) {
        final List<Property> properties = (responseData['properties']
                    as List<dynamic>?)
                ?.map((item) => Property.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];
        apiResponse.data = properties;
        // print(properties);
      } else {
        apiResponse.data = [];
      }
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e);
    apiResponse.error = somethingWentWrong;
  }
  return apiResponse;
}

Future<ApiResponse> getBookedProps(int userId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getBookedPropUrl?userId=$userId'),
      headers: {'Content-type': 'application/json'},
    );

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data["booked"] == true) {
        final List<Property> properties = (data['properties'] as List<dynamic>?)
                ?.map((item) => Property.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];
        print(properties);
        apiResponse.data = properties;
      } else {
        apiResponse.data = [];
      }
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e);
    apiResponse.error = somethingWentWrong;
  }
  return apiResponse;
}

Future<ApiResponse> updateUserProfile(
    String? name, String? phone, File? profileImage, int userId) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final Map<String, String> headers = {'Content-Type': 'multipart/form-data'};
    final request = http.MultipartRequest('POST', Uri.parse(updateProfileUrl));

    // Add form fields only if they are not null
    if (name != null) {
      request.fields['name'] = name;
    }
    if (phone != null) {
      request.fields['phone'] = phone;
    }
    request.fields['userId'] = userId.toString();
    print(request.fields);
    // print(profileImage!.path!);

    // Add profile image if it's not null
    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo_url', // The key expected by your Laravel backend
        profileImage.path,
      ));
    }

    // Set headers
    request.headers.addAll(headers);

    // Send request and get response
    final response = await request.send();
    final responseBody = await response.stream.transform(utf8.decoder).join();

    print(responseBody);
    // Handle response
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseBody)['success'];
        break;
      default:
        apiResponse.error = 'Something went wrong';
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

Future<ApiResponse> payLaterBookProp(int userID, int propID, int price) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(bookPropUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userID,
          "propId": propID,
          // "orderId": orderId,
          // "paymentId": paymentId,
          "amount": price,
        }));
    // print(response.body);
    if (response.statusCode == 200) {
      apiResponse.data = jsonDecode(response.body);
    } else {
      apiResponse.error = 'Error: ${response.statusCode}';
    }
  } catch (e) {
    apiResponse.error = 'Error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> saveInq(int userId, int adId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(saveinqURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": userId,
          "ad_id": adId,
        }));

    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      apiResponse.data = data;
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {}
  print(apiResponse.data);
  print(apiResponse.error);
  return apiResponse;
}
