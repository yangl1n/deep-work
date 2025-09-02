import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900],
      title: Text(
        title,
        style: const TextStyle(color: Colors.white,fontSize: 20),
        
      ),
      centerTitle: true, // center the text
      elevation: 0,      // flat style like WeChat
    );
  }

  // required to tell Flutter how tall the AppBar is
  @override
  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight);
}
