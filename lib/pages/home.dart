import 'package:flutter/material.dart';
import 'package:hello_world/pages/chat_list_screen.dart';
import 'package:hello_world/pages/explore_page.dart';
import 'package:hello_world/pages/profile_screen.dart';
import 'fav_list.dart';
import 'home_main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeMain(),
    const ExplorePage(),
    const ChatList(),
    const FavProps(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FF),
        body: SafeArea(child: _pages[_currentIndex]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: const Color(0xFF6246EA),
            unselectedItemColor: const Color(0xFFBBBBBB),
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded, size: 26), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore_rounded, size: 26),
                  label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline_rounded, size: 26),
                  label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_rounded, size: 26),
                  label: 'Saved'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded, size: 26),
                  label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
