import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,   // remove tap splash
        highlightColor: Colors.transparent, // remove long-press highlight
        hoverColor: Colors.transparent,     // remove hover (desktop/web)
      ),
      child: BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.grey[900],   // dark grey background
      selectedItemColor: Colors.green,     // selected icon/text
      unselectedItemColor: Colors.white70, // unselected icon/text
      type: BottomNavigationBarType.fixed, // ensures color applies properly
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Interupts"),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
      ],
    ));
  }
}
