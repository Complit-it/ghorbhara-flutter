// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/pages/chat_list_screen.dart';
import 'package:hello_world/pages/explore_page.dart';
import 'package:hello_world/pages/profile_screen.dart';
// import 'package:hello_world/pages/sc1.dart';
// import 'package:hello_world/pages/sc2.dart';
// import 'package:hello_world/pages/sc3.dart';
// import 'package:hello_world/pages/sc4.dart';
// import 'package:hello_world/pages/sc5.dart';
// import 'package:hello_world/pages/tenant_finder.dart';
// import 'sign_in.dart';
// import 'components/home_first_corousel.dart';
// import 'components/home_second_corousel.dart';
// import 'components/home_third_corousel.dart';
// import 'components/home_btm_banner.dart';
import 'fav_list.dart';
import 'home_main.dart';
// import 'new_property.dart';
// import 'tenant_finder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeMain(),
    // ScreenTwo(),
    // FindTenant(),
    ExplorePage(),
    // ScreenThree(),
    ChatList(),
    FavProps(),
    // ScreenFour(),
    // ScreenFive(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //so that when user taps anywhere on the screen the keyboard hides
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(child: _pages[_currentIndex]),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            selectedFontSize: 22,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 28,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.explore,
                  size: 28,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 28),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite, size: 28),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
