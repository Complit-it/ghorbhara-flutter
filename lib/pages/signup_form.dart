// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/user.dart';
import 'package:hello_world/pages/components/reusables/form_fields.dart';
import 'package:hello_world/pages/sign_in.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userType = '2';
  bool isLoading = false;

  ///2 for renter/tenants,people who want to rent
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cpassController = TextEditingController();

  void _singUp() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String phone = pref.getString('phone') ?? '';
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    String fullName = '$firstName $lastName';
    if (passController.text == cpassController.text) {
      ApiResponse response = await register(
          fullName,
          emailController.text.trim(),
          passController.text.trim(),
          phone,
          userType);

      if (response.error == null) {
        // print('happy');
        _saveAndRedirectToHome(response.data as User);
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${response.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Password does not match.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.setString('token', user.token ?? '');
    // await pref.setInt('userId', user.id ?? 0);
    // await pref.setString('name', user.name ?? '');
    // await pref.setString('userType', user.userType ?? '');
    // await pref.setString('email', user.email ?? '');

    // await saveUserToSharedPreferences(user);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => SignIn(
                  successMessage: 'Sign Up successfull.',
                )),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 100,
            ),
            // Text(
            //   'Congratulations',
            //   style: TextStyle(
            //     color: Colors.blue[400],
            //     fontSize: 21,
            //     fontFamily: 'Hind',
            //     fontWeight: FontWeight.w600,
            //     height: -0.5,
            //     letterSpacing: 0.6,
            //   ),
            // ),
            // const SizedBox(
            //   height: 25,
            // ),
            // Text(
            //   'on verifying the email belongs to you',
            //   style: TextStyle(
            //     color: Colors.blue[400],
            //     fontSize: 14,
            //     fontFamily: 'Hind',
            //     fontWeight: FontWeight.w400,
            //     height: -0.5,
            //     letterSpacing: 0.6,
            //   ),
            // ),
            // const SizedBox(
            //   height: 60,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 44,
                  fontFamily: 'Hind',
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 22.0),
            //   child: Text(
            //     'we need something more',
            //     style: TextStyle(
            //       color: Colors.blue[400],
            //       fontSize: 18,
            //       fontFamily: 'Hind',
            //       fontWeight: FontWeight.w400,
            //       letterSpacing: 0.6,
            //       height: 1.5,
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 25,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 11.0),
                    // padding: const EdgeInsets.only(left: 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name.';
                        }
                        return null;
                      },
                      controller: firstNameController,
                      cursorColor: Colors.blue.shade300,
                      // cursorHeight: 20,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        label: Text(
                          'First Name',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'Hind',
                            // fontWeight: FontWeight.w400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(102, 235, 236, 236),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22.0, left: 11.0),
                    // padding: const EdgeInsets.only(left: 0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name.';
                        }
                        return null;
                      },
                      controller: lastNameController,
                      cursorColor: Colors.blue.shade300,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        label: Text(
                          'Last Name',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'Hind',
                            // fontWeight: FontWeight.w400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(102, 235, 236, 236),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputField(
              labelText: 'Email',
              controller: emailController,
              validator: (email) {
                final emailRegex = RegExp(
                    r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}");
                if (email == null || email.isEmpty) {
                  return 'Please enter your email address.';
                } else if (!emailRegex.hasMatch(email)) {
                  return 'Please enter a valid email address.';
                }
                return null; // No error, email is valid
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputField(
              obscureFlag: true,
              labelText: 'Password',
              controller: passController,
              validator: (password) {
                if (password == null || password.isEmpty) {
                  return 'Please enter your password.';
                } else if (password.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputField(
              obscureFlag: true,
              labelText: 'Confirm Password',
              controller: cpassController,
            ),
            SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          userType = '2'; //tenant
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userType == '2'
                            ? Color.fromARGB(229, 225, 238, 238)
                            : Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Text(
                        'I want to rent',
                        style: TextStyle(
                          color: userType == '2'
                              ? Color.fromARGB(255, 255, 255, 255)
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(width: 28),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          userType = '1';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userType == '1'
                            ? Color.fromARGB(229, 225, 238, 238)
                            : Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Text(
                        'I want to list',
                        style: TextStyle(
                          color: userType == '1'
                              ? Color.fromARGB(255, 255, 255, 255)
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _singUp();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
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
          ]),
        ),
      )),
    );
  }
}
