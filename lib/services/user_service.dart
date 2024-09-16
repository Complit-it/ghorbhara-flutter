import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/message.dart';
import 'package:hello_world/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:io';

import 'package:crypto/crypto.dart';

import '../models/chat_user.dart';

Future<ApiResponse> signin(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> userData = {
      "email": email,
      "password": password
    };
    final response = await http.post(
      Uri.parse(signinURL),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(userData),
    );

    print(response.body);

    switch (response.statusCode) {
      case 200:
        // apiResponse.data = jsonDecode(response.body);
        // apiResponse.ec = response.statusCode;
        // print(apiResponse.data);
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        // apiResponse.error = jsonDecode(response.body);
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        apiResponse.error = decodedResponse['message'] ?? 'Unknown error';
        apiResponse.ec = response.statusCode;
        // print(jsonDecode(response.body));
        // print(apiResponse.error);
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register(String name, String email, String password,
    String phone, String userType) async {
  var hashedEmail = sha256.convert(utf8.encode(email)).toString();
  final Map<String, dynamic> userData = {
    'name': name,
    'email': email,
    'password': password,
    'phone_no': phone,
    'userType': userType,
    'google_id': hashedEmail
  };
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(userData));
    // print(userData);
    // print(jsonDecode(response.body));
    // print('register function start');
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        User data = apiResponse.data as User;
        if (data.email != null) {
          var hashedEmail = sha256.convert(utf8.encode(data.email!)).toString();
          await API.getSelfInfo_forCustomLogin(hashedEmail, data);
        }

        // print(apiResponse.data);
        break;
      case 422:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 410:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.error = errors;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  // print(apiResponse.error);
  // print('register function end');
  return apiResponse;
}

void handleEmail(String email) {
  // Perform actions with the email, e.g., display, store, send verification
  print('Received email: $email'); // Example usage
}

Future<ApiResponse> getOtp(String phone) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    // debugPrint(phone);
    print('xxx');
    final Map<String, dynamic> userData = {"phone_no": phone};
    final response = await http.post(
      Uri.parse(getOtpUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(userData),
    );

    // print(jsonDecode(response.body));
    print(response.statusCode);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print(apiResponse.data);
        break;
      case 422:
        // apiResponse.data = jsonDecode(response.body);
        apiResponse.error = jsonDecode(response.body)['message']['phone_no'][0];

        print(apiResponse.data);
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  // print(apiResponse.data);
  print(apiResponse.error);

  return apiResponse;
}

Future<ApiResponse> verifyOtp(String phone, String otp) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final Map<String, dynamic> userData = {"phone_no": phone, "otp": otp};
    debugPrint(jsonEncode(userData));
    final response = await http.post(Uri.parse(verifyOtpUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(userData));
    // debugPrint('sfds');
    // print(response.statusCode);
    // print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 410:
        apiResponse.error = jsonDecode(response.body)['message'];

        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message']['otp'][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  // print(apiResponse.data);
  // print(apiResponse.error);
  return apiResponse;
}

Future<void> saveUserToSharedPreferences(User user, String flag) async {
  // print('shared: $flag');
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString('token', user.token ?? '');
  await pref.setInt('userId', user.id ?? 0);
  await pref.setString('name', user.name ?? '');
  await pref.setString('userType', user.userType ?? '');
  await pref.setString('email', user.email ?? '');
  await pref.setString('google_id', user.google_id ?? '');
  await pref.setString('is_google_login', flag);
  await pref.setString('imageUrl', user.imageUrl ?? '');
  await pref.setString('phone', user.phone ?? '');
}

Future<User?> getUserFromSharedPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');
  int? id = pref.getInt('userId');
  String? name = pref.getString('name');
  String? userType = pref.getString('userType');
  String? email = pref.getString('email');
  String? google_id = pref.getString('google_id');
  String? is_google_login = pref.getString('is_google_login');
  String? imageUrl = pref.getString('imageUrl');
  String? phone = pref.getString('phone');

  // if (token != null &&
  //     id != null &&
  //     name != null &&
  //     userType != null &&
  //     email != null) {
  print('img: $imageUrl');
  return User(
      token: token,
      id: id,
      name: name,
      userType: userType,
      email: email,
      google_id: google_id,
      imageUrl: imageUrl,
      phone: phone
      // is_google_login: is_google_login
      );
  // } else {
  //   return null; // Return null if any of the required values are missing
  // }
}

Future<void> clearUserFromSharedPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove('token');
  await pref.remove('userId');
  await pref.remove('name');
  await pref.remove('userType');
  await pref.remove('email');
  await pref.remove('google_id');
  await pref.remove('is_google_login');
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//to save data of users who logs in from google login
Future<ApiResponse> regsiter_google_users(user) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // print(user);
    var hashedEmail = sha256.convert(utf8.encode(user.email!)).toString();
    final Map<String, dynamic> data = {
      'name': user.displayName,
      'email': user.email,
      'google_id': hashedEmail
    };

    final response = await http.post(Uri.parse(registerGoogleUserUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      print(response.body);
      apiResponse.data = jsonDecode(response.body);

      final responseBody = jsonDecode(response.body);
      final _user = User.fromJson(responseBody);
      //saving user info to shared prefrences
      await saveUserToSharedPreferences(_user, 'Y');
    } else {
      apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e);
  }
  // print(apiResponse.data);
  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<String> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email') ?? '';
}

Future<String> getPhone() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('phone') ?? '';
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

Future<void> storeTokefn(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

//---------------google fb related APIs
class API {
//video 23, 24 for profile related work

  //for authectication
  static fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
  static fb_auth.User get user => auth.currentUser!;

  // static void printUserDetails() {
  //   final user = auth.currentUser;
  //   if (user != null) {
  //     print('User ID: ${user.uid}');
  //     print('Email: ${user.email}');
  //     print('Display Name: ${user.displayName}');
  //     print('Photo URL: ${user.photoURL}');
  //     print('Phone Number: ${user.phoneNumber}');
  //     print('Email Verified: ${user.emailVerified}');
  //     print('Provider Data: ${user.providerData}');
  //   } else {
  //     print('No user is currently signed in.');
  //   }
  // }

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for checking if user exists
  static Future<bool> userExists(user) async {
    var hashedEmail = sha256.convert(utf8.encode(user.email!)).toString();
    // print(hashedEmail);
    return (await firestore.collection('users').doc(hashedEmail).get()).exists;
  }

//variable to store data of current user
  static late ChatUser me;

  //to get self information and store it in a variable
  static Future<void> getSelfInfo() async {
    try {
      var hashedEmail = sha256.convert(utf8.encode(user.email!)).toString();
      await firestore
          .collection('users')
          .doc(hashedEmail)
          .get()
          .then((user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
          // print('mydata: ${user.data()}');
        } else {
          await createUser(user).then((value) => getSelfInfo());
        }
      });
    } catch (e) {
      // print('getSelfInfo: $e');
    }
  }

  static Future<void> getSelfInfo_forCustomLogin(
      String email, User _user) async {
    try {
      // print('getSelfInfo_forCustomLogin function start');
      await firestore.collection('users').doc(email).get().then((user) async {
        // print('mail: ${email}');
        if (user.exists) {
          // print('NOTempty');
          return;
          // me = ChatUser.fromJson(user.data()!);
          // print('mydata: ${user.data()}');
        } else {
          // User user_ = User.fromJson(user.data()!);
          await createUser_forCustomLogin(_user)
              .then((value) => getSelfInfo_forCustomLogin(email, _user));
          // print('getSelfInfo_forCustomLogin function end');
        }
      });
    } catch (e) {
      // print('getSelfInfo: $e');
    }
  }

  //to create usr in users collectoin in fb
  static Future<void> createUser(user) async {
    var hashedEmail = sha256.convert(utf8.encode(user.email!)).toString();
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: hashedEmail,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chats!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(hashedEmail)
        .set(chatUser.toJson());
  }

  static Future<void> createUser_forCustomLogin(User user) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    var hashedEmail = sha256.convert(utf8.encode(user.email!));

    final chatUser = ChatUser(
        id: hashedEmail.toString(),
        name: user.name!,
        email: user.email.toString(),
        about: "Hey, I'm using We Chats!",
        image: null,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(hashedEmail.toString())
        .set(chatUser.toJson());
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers(
  //     String hashedMail) {
  //   //        QuerySnapshot querySnapshot = await firestore
  //   //     .collection('users')
  //   //     .doc(googleIdSender)
  //   //     .collection('my_users')
  //   //     .get();

  //   // for (var doc in querySnapshot.docs) {
  //   //   print(doc.id);  // This will print the document IDs of the users
  //   //   print(doc.data());  // This will print the data of each document
  //   // }
  //   return firestore
  //       .collection('users')
  //       .where('id', isNotEqualTo: hashedMail)
  //       .snapshots();
  // }

  static Stream<List<Map<String, dynamic>>> getChatUsers() async* {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? googleIdSender = pref.getString('google_id');

    if (googleIdSender == null) {
      throw Exception("Google ID not found in SharedPreferences");
    }

    final myUsersSnapshot = firestore
        .collection('users')
        .doc(googleIdSender)
        .collection('my_users')
        .snapshots();

    await for (var snapshot in myUsersSnapshot) {
      // print(
      //     'Retrieved my_users snapshot: ${snapshot.docs.length} documents found');

      List<String> userIds = snapshot.docs.map((doc) => doc.id).toList();
      // print('User IDs: $userIds');

      List<Map<String, dynamic>> userDetails = [];

      for (var userId in userIds) {
        var userDoc = await firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          // print('Retrieved user document for ID $userId: ${userDoc.data()}');
          userDetails.add(userDoc.data()!);
        } else {
          print('No user document found for ID $userId');
        }
      }

      // print('Final user details list: $userDetails');
      yield userDetails;
    }
  }

  ///-----------------------------Firebase apis

  // static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
  //     ? '${user.uid}_$id'
  //     : '${id}_${user.uid}';

  static Future<String> getConversationID(String id) async {
    User? _user = await getUserFromSharedPreferences();
    // print(_user?.google_id);
    // if (user == null || user.uid == null) {
    //   throw Exception("User details are missing");
    // }
    // print(_user!.google_id.hashCode);
    // print(id.hashCode);
    return _user!.google_id.hashCode <= id.hashCode
        ? '${_user.google_id}_$id'
        : '${id}_${_user.google_id}';
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
  //     ChatUser user) {
  //   return firestore
  //       .collection('chats/${getConversationID(user.id)}/messages/')
  //       .snapshots();
  // }
  static Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getAllMessages(
      ChatUser user) async {
    final conversationId = await getConversationID(user.id);
    return firestore.collection('chats/$conversationId/messages/').snapshots();
  }

  // static Future<void> sendMessage(ChatUser chatUser, String msg) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();

  //   String? google_id = pref.getString('google_id');
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   final Message message = Message(
  //       toId: chatUser.id,
  //       msg: msg,
  //       read: '',
  //       type: Type.text,
  //       fromId: google_id!,
  //       sent: time);
  //   print(getConversationID(chatUser.id));
  //   final ref = firestore
  //       .collection('chats/${getConversationID(chatUser.id)}/messages/');
  //   await ref.doc(time).set(message.toJson());
  // }

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? googleId = pref.getString('google_id');
    if (googleId == null) {
      throw Exception("Google ID not found in SharedPreferences");
    }
    await addChatUser(chatUser.email);

    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: googleId,
      sent: time,
    );

    final conversationId = await getConversationID(chatUser.id);
    print(conversationId);
    final ref = firestore.collection('chats/$conversationId/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //to store the ids of users with whom chat message
  static Future<bool> addChatUser(String email) async {
    // final data = await firestore
    //     .collection('users')
    //     .where('email', isEqualTo: email)
    //     .get();
    try {
      var hashedEmail_receiver = sha256.convert(utf8.encode(email)).toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? googleId_sender = pref.getString('google_id');

      // if (data.docs.isNotEmpty && data.docs.first.id != googleId_sender) {
      //adding id of the receiver to the sender
      firestore
          .collection('users')
          .doc(googleId_sender)
          .collection('my_users')
          .doc(hashedEmail_receiver)
          .set({});

      //adding id of the sender to the receiver
      firestore
          .collection('users')
          .doc(hashedEmail_receiver)
          .collection('my_users')
          .doc(googleId_sender)
          .set({});

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      String userId) async {
    try {
      print(userId);
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        print(userDoc);
        return userDoc;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error getting user by ID: $e");
      rethrow;
    }
  }
}
