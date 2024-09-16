import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;

  MyCustomAppBar({
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Hides the default back button
      backgroundColor: Theme.of(context).primaryColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => onBackPressed(),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  height: 2,
                  letterSpacing: 0.8,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Hind', // Your preferred font
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 80,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}
