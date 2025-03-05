import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:letsplay/news/news_main_screen.dart';
import 'package:letsplay/profile/profile_screen.dart';
import 'package:letsplay/tournament/tournament_screen_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'community/community_sreen.dart';


class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TournamentScreenNew(),
    NewsMainScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("bottom_nav_print init state called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("bottom_nav_print dispose state called");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      backgroundColor: Color(0xFF2B2E52),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 5 , top: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
            bottomRight:  Radius.circular(24.0),
            bottomLeft:  Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF38567E).withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 15,
              offset: Offset(0, 8), // Shadow position
            ),
          ],
        ),
        child:
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Container for the gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2B2E52),
                    Color(0xFF6173C7),
                    Color(0xFF2B2E52),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    _buildNavItem('assets/images/swords.png', 'Tournament', 0),
                    _buildNavItem('assets/images/newspaper.png', 'News', 1),
                    _buildNavItem('assets/images/network.png', 'Community', 2),
                    _buildNavItem('assets/images/battle.png', 'Profile', 3),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent, // Set to transparent to see the gradient
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: Colors.orangeAccent,
                  unselectedItemColor: Colors.white70,
                  selectedIconTheme: IconThemeData(size: 30 , color: Colors.orangeAccent),
                  unselectedIconTheme: IconThemeData(size: 25 , color: Colors.white),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: 160,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000000), // Start color
                    Color(0xFF6A0572), // End color
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Image.asset(assetPath , width: 30 , height: 30 , color: Colors.orangeAccent , ), // Adjust size as needed
        ],
      )
          : Image.asset(assetPath , width: 25, height: 25, color: Colors.white70),
      label: label,
    );
  }
}


