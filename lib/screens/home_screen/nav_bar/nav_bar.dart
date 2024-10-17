import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/home_screen/chat/conversation_screen/conversation.dart';
import 'package:messaging/screens/home_screen/nav_bar/all_images/all_images.dart';
import 'package:messaging/screens/home_screen/profile_screen/profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.image,
    Icons.message,
    Icons.person,
  ];
  final List _destination = <Widget>[
    Container(), //destination screen
    const AllImages(), //destination screen
    const ConversationScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _destination[_bottomNavIndex], //destination screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        //params
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 12,
          rightCornerRadius: 12,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Icon(
              iconList[index],
              size: 24,
              color: isActive ? Colors.amber : Colors.black,
            );
          }),
    );
  }
}
