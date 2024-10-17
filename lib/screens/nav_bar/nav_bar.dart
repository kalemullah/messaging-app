import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/nav_bar/add_images/add_images.dart';
import 'package:messaging/screens/nav_bar/all_images/all_images.dart';
import 'package:messaging/screens/nav_bar/chat/conversation_screen/conversation.dart';
import 'package:messaging/screens/nav_bar/home_screen/home_sccreen.dart';
import 'package:messaging/screens/nav_bar/profile_screen/profile_screen.dart';

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
    const HomeScreen(), //destination screen
    const AllImages(), //destination screen
    const ConversationScreen(),
    const ProfileScreen(),
    const AddImages(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _destination[_bottomNavIndex], //destination screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff472121),
        child: const Icon(
          Icons.add,
          color: Color(0xffe6c8b4),
        ),
        //params
        onPressed: () {
          setState(() {
            _bottomNavIndex = 4; // Navigate to the new screen index in the list
          });
        },
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
              color:
                  isActive ? const Color(0xff472121) : const Color(0xffe6c8b4),
            );
          }),
    );
  }
}
