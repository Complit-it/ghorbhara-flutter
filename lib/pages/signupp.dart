// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/pages/signup_form.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//singup otp
class Signupp extends StatefulWidget {
  const Signupp({super.key});
  // Function  getOtp;
  @override
  State<Signupp> createState() => _SignuppState();
}

class _SignuppState extends State<Signupp> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String phoneNo = '';
  //  final UserService _userService = UserService();
  bool loading2 = false;
  bool loading = false;

  void _verifyotp() async {
    final otp = _otpController.text;
    ApiResponse response = await verifyOtp(phoneNo, _otpController.text);
    // print('response:');
    // print('response: ${response.error}');
    // print('response: ${response.data}');

    if (response.error == null) {
      setState(() {
        loading2 = false;
      });
      print(phoneNo);
      _saveAndRedirectToHome(phoneNo);
    } else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading2 = false;
      });
    }
  }

  void _saveAndRedirectToHome(String phone) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('phone', phone ?? '');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Signup()), (route) => false);
  }

  void _getotp() async {
    String phoneNumber = _phoneController.text.trim();
    phoneNo = phoneNumber;
    // _phoneController.clear();

    if (phoneNumber.isEmpty ||
        phoneNumber.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Invalid phone number'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    ApiResponse response = await getOtp(phoneNumber);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (response.error == null) {
      setState(() {
        loading = false;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Image.asset(
            'assets/otp_img.png',
            height: 180,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 45,
                  fontFamily: 'Hind',
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'VERIFY THROUGH PHONE',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _phoneController,
              cursorColor: Colors.blue.shade300,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color.fromARGB(102, 235, 236, 236),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 2,
          // ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextField(
                    controller: _otpController,
                    cursorColor: Colors.blue.shade300,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(102, 235, 236, 236),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: '',
                      // contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                  )),
                  const SizedBox(width: 27),
                  loading
                      ? Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 46.5, right: 25),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              loading = true;
                              _getotp();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Get OTP',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                ],
              )),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(20),
            child: loading2
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loading2 = true;
                      });
                      FocusScope.of(context).unfocus();
                      _verifyotp();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          letterSpacing: .5),
                    ),
                  ),
          ),
          const SizedBox(height: 70),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Add your submit button logic here
          //       // _navigateToSignup(context);
          //     },
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          //       minimumSize: MaterialStateProperty.all<Size>(
          //           const Size(double.infinity, 40)),
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //       ),
          //     ),
          //     child: const Text(
          //       'Next',
          //       style: TextStyle(
          //         fontSize: 18,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Add your submit button logic here
          //       // _navigateToSignup(context);
          //     },
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all<Color>(
          //           Color.fromARGB(255, 255, 255, 255)),
          //       minimumSize: MaterialStateProperty.all<Size>(
          //           const Size(double.infinity, 40)),
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //       ),
          //     ),
          //     child: const Text(
          //       'back to login',
          //       style: TextStyle(
          //         fontSize: 18,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    )));
  }
}
