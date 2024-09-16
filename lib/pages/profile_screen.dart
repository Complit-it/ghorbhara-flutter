// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hello_world/pages/fav_list.dart';
import 'package:hello_world/pages/my_props.dart';
// import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/sign_in.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/user.dart';
import 'bookings_screen.dart';
import 'edit_profile_screen.dart';
import 'faq_screen.dart';
import 'payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isloggingOut = false;
  bool isLoading = true;
  final List<Map<String, dynamic>> dataList = [
    {
      'icon': Icons.person,
      'text': 'My Profile',
      'screen': EditProfileScreen(),
    },
    {
      'icon': Icons.favorite,
      'text': 'Favorites',
      'screen': FavProps(),
    },
    {
      'icon': Icons.house,
      'text': 'My Properties',
      'screen': MyPropertiesScreen(),
    },
    {
      'icon': Icons.question_answer,
      'text': 'FAQs',
      'screen': FAQScreen(),
    },
    {
      'icon': Icons.add_home,
      'text': 'My Bookings',
      'screen': MyBookings(),
    },
  ];
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> _handleSignOut() async {
    try {
      fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
      await auth.signOut();
      await _googleSignIn.signOut();
      await clearUserFromSharedPreferences();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      User? user = await getUserFromSharedPreferences();
      if (mounted) {
        setState(() {
          _user = user;

          isLoading = false;
          print(_user);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  CircleAvatar(
                    radius: 36,
                    child:
                        _user?.imageUrl != null && _user!.imageUrl!.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: '$baseUrl${_user!.imageUrl!}',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person_rounded,
                                    size: 48,
                                    color: Color.fromARGB(255, 116, 116, 117),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 48,
                                color: Color.fromARGB(255, 116, 116, 117),
                              ),
                  ),

                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    _user!.name!,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Hind',
                        fontSize: 18),
                  ),
                  Text(
                    _user!.email!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Hind',
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      dataList[index]['screen'])));
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(21, 21, 21, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        dataList[index]['icon'],
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      dataList[index]['text'],
                                      style: TextStyle(
                                          fontFamily: 'Hind',
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.grey,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 21),
                    child: Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(21, 0, 21, 2),
                  //   // padding: EdgeInsets.all(0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Container(
                  //         child: Row(
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.all(6),
                  //               decoration: BoxDecoration(
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.grey.withOpacity(0.3),
                  //                     spreadRadius: 1,
                  //                     blurRadius: 5,
                  //                     offset: Offset(0, 2),
                  //                   ),
                  //                 ],
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(8),
                  //               ),
                  //               child: Icon(
                  //                 Icons.toggle_on,
                  //                 color: Colors.black,
                  //                 size: 18,
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               width: 16,
                  //             ),
                  //             Text(
                  //               "Switch to landlord",
                  //               style: TextStyle(
                  //                   fontFamily: 'Hind',
                  //                   fontSize: 16,
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w500),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Icon(
                  //         Icons.arrow_forward_ios_sharp,
                  //         color: Colors.grey,
                  //         size: 14,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(21, 20, 21, 0),
                    child: _isloggingOut
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            // onPressed: () {
                            //   // Add your "Get Started" button logic here
                            //   // _navigateToSignIn(context);
                            //   // print("Button pressed!");

                            // },
                            onPressed: () async {
                              // _handle_google_singin();
                              //------------------------
                              setState(() {
                                _isloggingOut = true;
                              });
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              String? is_google_login =
                                  pref.getString('is_google_login');
                              if (is_google_login == 'Y') {
                                bool signedOut = await _handleSignOut();

                                if (signedOut) {
                                  if (!context.mounted) return;
                                  _navigateToSignIn(context);
                                }
                              } else {
                                print('N');
                                await clearUserFromSharedPreferences();
                                if (!context.mounted) return;
                                _navigateToSignIn(context);
                              }

                              //------------------------
                              // final api = API();
                              // getChatUserIds();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF6246EA)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 48)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8.0), // Customize
                                ),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF)),
                            ),
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
