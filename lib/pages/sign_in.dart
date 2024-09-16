// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/helper/dialogs.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/user.dart' as local_user;
import 'package:hello_world/pages/components/reusables/snackbar.dart';
import 'package:hello_world/pages/home.dart';
import 'package:hello_world/pages/signupp.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.successMessage});
  final String? successMessage;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
    Future(() {
      _onLoad();
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //google sigin
  _handle_google_singin() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar

      if (user != null) {
        //function to check and register the user in sql db
        await regsiter_google_users(user.user).then((value) async {
          // print('value');

          if (value.error == null) {
            if (value.data is Map<String, dynamic>) {
              Map<String, dynamic> dataMap = value.data as Map<String, dynamic>;
              if (dataMap['status'] == 'success') {
                if ((await API.userExists(user.user))) {
                  // Dialogs.showProgressBar(context);
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                } else {
                  await API.createUser(user.user).then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Home()),
                        (route) => false);
                  });
                }
              } else {
                showErrorSnackBar(
                    context, "Oops, something went wrong. Please try again.");
              }
            } else {
              showErrorSnackBar(
                  context, "Oops, something went wrong. Please try again.");
            }
          } else {
            showErrorSnackBar(
                context, "Oops, something went wrong. Please try again.");
          }
        });
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow

    try {
      // await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('_signInWithGoogle : ${e}');
      // ignore: use_build_context_synchronously
      // Dialogs.showSnackbar(context, 'Check Internet Connection');
      return null;
    }
  }

  // _signOut_google() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn.signOut();
  // }

  void _loginUser() async {
    final email = _mailController.text.trim();
    final password = _passwordController.text.trim();
    ApiResponse response = await signin(email, password);
    // print(response.data);

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (response.error == null && response.data != null) {
      _saveAndRedirectToHome(response.data as local_user.User);
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

  void _saveAndRedirectToHome(local_user.User user) async {
    await saveUserToSharedPreferences(user, 'N');
    print(user);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('is_google_login', 'N');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const Home()),
    // );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  void _onLoad() {
    if (widget.successMessage != null) {
      // Show snackbar with provided message
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(widget.successMessage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // _onLoad();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 130),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ghorbhara',
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 30,
                              fontFamily: 'Hind',
                              fontWeight: FontWeight.w600,
                              height: -0.5,
                            ),
                          ),
                          Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 55,
                              fontFamily: 'Hind',
                              fontWeight: FontWeight.w800,
                              letterSpacing: .7,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YOUR EMAIL',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: _mailController,
                              cursorColor: Colors.blue.shade300,
                              decoration: InputDecoration(
                                // Move cursorColor here
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade300),
                                ),
                                // Set the cursor color
                                border: InputBorder.none,
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(102, 235, 236, 236),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'PASSWORD',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              cursorColor: Colors.blue.shade300,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // enabledBorder: OutlineInputBorder(
                                //     borderSide:
                                //         BorderSide(color: Colors.blue.shade300)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade300),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(102, 235, 236, 236),
                              ),
                            ),
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: loading
                                ? Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                        _loginUser();
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(double.infinity, 48)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          )),
                          const SizedBox(height: 32),
                          Center(
                            child: SignInButton(
                              Buttons.google,
                              onPressed: () {
                                //google sigin
                                _handle_google_singin();
                              },
                              elevation: 1,
                            ),
                          ),
                          // TextButton(
                          //     onPressed: () {},
                          //     child: Text(
                          //       'Signin with google',
                          //     )),
                          // TextButton(
                          //     onPressed: () async {
                          //       // _handle_google_singin();
                          //       await FirebaseAuth.instance.signOut();
                          //       await _googleSignIn.signOut();
                          //     },
                          //     child: Text(
                          //       'signout',
                          //     )),
                          const SizedBox(height: 42),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dont have an account?',
                                style: TextStyle(
                                  color: Color(0xFF121515),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signupp()),
                                  );
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Customize the color as needed
                                    decoration: TextDecoration
                                        .underline, // Underline the text
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),

                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => const Signupp()),
                          //     );
                          //   },
                          //   style: ButtonStyle(
                          //     backgroundColor: MaterialStateProperty.all<Color>(
                          //         const Color(0xFF121515)),
                          //     minimumSize: MaterialStateProperty.all<Size>(
                          //         const Size(double.infinity, 48)),
                          //     shape: MaterialStateProperty.all<
                          //         RoundedRectangleBorder>(
                          //       RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //     ),
                          //   ),
                          //   child: const Text(
                          //     'Create an Account',
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),

                          //google or phone option
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       'Continue with',
                          //       style: TextStyle(
                          //         color: Color(0xFF121515),
                          //       ),
                          //     ),
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => Signupp()),
                          //         );
                          //       },
                          //       child: Text(
                          //         'Google',
                          //         style: TextStyle(
                          //           color: Colors
                          //               .blue, // Customize the color as needed
                          //           decoration: TextDecoration
                          //               .underline, // Underline the text
                          //         ),
                          //       ),
                          //     ),
                          //     Text(
                          //       'or',
                          //       style: TextStyle(
                          //         color: Color(0xFF121515),
                          //       ),
                          //     ),
                          //     TextButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => Signupp()),
                          //         );
                          //       },
                          //       child: Text(
                          //         'Phone',
                          //         style: TextStyle(
                          //           color: Colors
                          //               .blue, // Customize the color as needed
                          //           decoration: TextDecoration
                          //               .underline, // Underline the text
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
