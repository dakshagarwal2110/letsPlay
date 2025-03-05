import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:letsplay/profile/profile_details_class.dart';
import 'package:letsplay/utils/loader.dart';
import 'package:lottie/lottie.dart';
import '../apis/all_apis.dart';
import '../auth/login.dart';
import '../utils/app_size.dart';
import '../utils/app_strings.dart';
import '../utils/common_widgets.dart';
import '../utils/daily_quest_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../win_tokens/win_token_tasks_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> newsList = [];
  bool isLoading = false;
  final double progress = 0.5;
  String? loginData;
  String username = "";

  @override
  void initState() {
    print("profile_screen init called");
    super.initState();
    _checkLoginStatusAndFetchProfile();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("profile_screen dispose called");

  }

// Check for login data and call fetchProfileData if it exists
  Future<void> _checkLoginStatusAndFetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginData = prefs.getString('login_data');
    String? usernameTemp = prefs.getString("username");

    if (loginData != null && loginData.isNotEmpty && usernameTemp!= null) {
      // Call fetchProfileData only if login_data exists and is not empty
      setState(() {
        username = usernameTemp;
      });
      fetchProfileData();
    } else {
      // Handle case where login_data is missing or empty
      setState(() {
        loginData = null; // To ensure UI shows sign-in prompt
      });
    }
  }

  Future<ProfileData> fetchProfileData() async {
    Loader.showLoading("Getting your profile");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/profile/$username'),
      );

      if (response.statusCode == 200) {
        Loader.hideLoading();
        final jsonResponse = json.decode(response.body);
        return ProfileResponse.fromJson(jsonResponse).data;
      } else {
        Loader.hideLoading();
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      Loader.hideLoading();
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: const Color(0xFF2B2E52),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2B2E52),
                Color(0xFF373B60),
                Color(0xFF3F4179),
                Color(0xFF3F4179),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: FutureBuilder<String?>(
            future: _getLoginData(),
            // A method that fetches login_data from SharedPreferences
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while fetching login_data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                // Show the profile content if login_data exists
                return Column(
                  children: [
                    // Header Section
                    buildHeaderSection(context),

                    // Content Section with Loading/Error handling
                    Expanded(
                      child: buildProfileContent(context),
                    ),
                  ],
                );
              } else {
                // Show the sign-in prompt if login_data is null or empty
                return _buildSignInPrompt();
              }
            },
          ),
        ),
        // Floating Action Button with Popup
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(

          type: ExpandableFabType.fan,
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.regular,
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.orangeAccent, // Icon color
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.regular,
            child: Icon(Icons.close, color: Colors.white),
            backgroundColor: Colors.deepOrange, // Icon color
          ),
          children: [
            FloatingActionButton(
              heroTag: "messageFab",
              onPressed: () {},
              child: Icon(Icons.message, color: Colors.white), // Icon color
              backgroundColor: Colors.blue, // Background color
            ),
            FloatingActionButton(
              heroTag: "mailFab",
              onPressed: () {},
              child: Icon(Icons.mail, color: Colors.white), // Icon color
              backgroundColor: Colors.red, // Background color
            ),
            FloatingActionButton(
              heroTag: "callFab",
              onPressed: () {},
              child: Icon(Icons.call, color: Colors.white), // Icon color
              backgroundColor: Colors.green, // Background color
            ),
          ],
        ),
      ),
    );
  }

// Helper method to fetch login_data from SharedPreferences
  Future<String?> _getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_data');
  }

// Method to show sign-in prompt when login_data is missing
  Widget _buildSignInPrompt() {
    return Column(
      children: [
        buildHeaderSection(context),
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.getWidth(16, context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: AppSize.getWidth(200, context),
                    height: AppSize.getHeight(200, context),
                    child: Lottie.asset(
                      'assets/animations/login_ask.json', // Path to sparkles animation
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),


                  Text(
                    'Please login to participate in the tournament or access your profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Mercenary',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orangeAccent, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the sign-in screen
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        backgroundColor: Colors.transparent, // Set background to transparent
                        shadowColor: Colors.transparent, // Remove shadow to show the gradient clearly
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 18, color: Colors.white , fontWeight: FontWeight.w600),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget for Login Prompt
  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 80,
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            "Sign in",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Please login to participate in tournaments or access profile.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFD5939),
                  Color(0xFFFD7E29),
                  Color(0xFFFDBF2E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.getWidth(12, context),
        vertical: AppSize.getHeight(8, context),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppSize.getHeight(7, context),
        ),
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  trophy(context, "assets/images/logo.png"),
                  Flexible(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFFFD5939),
                          Color(0xFFFD7E29),
                          Color(0xFFFDBF2E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                          Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                      child: Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'Mercenary',
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(10, context)),
                  trophy(context, "assets/images/logo.png"),
                ],
              ),
            ),
            buildSocialMediaIcons(context),
          ],
        ),
      ),
    );
  }

  Widget buildSocialMediaIcons(BuildContext context) {
    return Row(
      children: [
        socialMediaIcon(context, "assets/images/instagram.png"),
        SizedBox(width: AppSize.getWidth(10, context)),
        socialMediaIcon(context, "assets/images/twitter.png"),
        SizedBox(width: AppSize.getWidth(10, context)),
        socialMediaIconDiscord(context, "assets/images/discord.png"),
        SizedBox(width: AppSize.getWidth(10, context)),
        settingsIcon(context),
      ],
    );
  }

  Widget buildProfileContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.getWidth(12, context)),
      child: FutureBuilder<ProfileData>(
        future: fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFD5939),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error occurred! ${snapshot.error}',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: AppSize.getHeight(20, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: fetchProfileData,
              color: Color(0xFFFD5939),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: buildProfileDetails(snapshot.data!),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Column buildProfileDetails(ProfileData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSize.getHeight(15, context)),
        buildProfileSection(data),
        SizedBox(height: AppSize.getHeight(15, context)),
        buildOrangeGradientCard(
          context,
          "My Completed Tournaments",
          "History of Triumphs",
        ),
        DailyQuestBanner(
          questTitle: 'Play and win',
          questDescription: 'Complete your daily quest to win tokens',
          progress: 1,
          goal: 5,
          reward: '50 XP',
        ),
        Row(
          children: [
            Text(
              "Leaderboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(25, context),
                fontFamily: 'Mercenary',
                fontWeight: FontWeight.w400,
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        buildLeaderBoardCards(context ,"Legends Arena" ,"Are you ready to become a legend?"),

        SizedBox(height: AppSize.getHeight(8, context),),
        Row(
          children: [
            Text(
              "Win Tokens",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(25, context),
                fontFamily: 'Mercenary',
                fontWeight: FontWeight.w400,
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WinTokenTasksScreen(
                      ),
                    ),

                  );
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        SizedBox(height: AppSize.getHeight(8, context)),
        buildWinToken(context, "Unlock Rewards",
            "Complete daily quests and earn tokens!"),



      ],
    );
  }

  Row buildProfileSection(ProfileData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: 0.50,
                strokeWidth: 3.0,
                backgroundColor: Colors.grey.withOpacity(0.2),
                color: Color(0xFFFD7E29),
              ),
            ),
            ClipOval(
              child: Image.network(
                data.image,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(width: AppSize.getWidth(18, context)),
        buildUserInfo(data),
      ],
    );
  }

  Column buildUserInfo(ProfileData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.username,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSize.getHeight(25, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              data.token.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.getHeight(15, context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

// Widget for Discord icon (used in header)
  Widget settingsIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When tapped, open the bottom sheet
        _showSettingsBottomSheet(context);
      },
      child: Container(
        height: AppSize.getHeight(20, context),
        width: AppSize.getWidth(20, context),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Color(0xFFFD5939),
                Color(0xFFFD7E29),
                Color(0xFFFDBF2E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Icon(Icons.menu),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Ensures the bottom sheet adjusts to its content height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsOption(
                context,
                Icons.person,
                "Personal Details",
                onTap: () {
                  // Handle navigation to Personal Details
                  Navigator.pop(context); // Close the bottom sheet
                  // Navigate to personal details screen
                },
              ),
              Divider(),
              _buildSettingsOption(
                context,
                Icons.account_balance_wallet,
                "Wallet and Tokens",
                onTap: () {
                  // Handle navigation to Wallet and Tokens
                  Navigator.pop(context); // Close the bottom sheet
                  // Navigate to wallet screen
                },
              ),
              Divider(),
              _buildSettingsOption(
                context,
                Icons.privacy_tip,
                "Privacy",
                onTap: () {
                  // Handle navigation to Privacy settings
                  Navigator.pop(context); // Close the bottom sheet
                  // Navigate to privacy screen
                },
              ),
              Divider(),
          _buildSettingsOption(
            context,
            Icons.logout,
            "Logout",
            onTap: () async {
              Navigator.pop(context);
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Logout", style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 20),),
                    content: Text("Do you really want to logout?", style: TextStyle(color: Colors.black87 , fontWeight: FontWeight.w500 , fontSize: 18),),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog and bottom sheet if "No" is clicked
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text("No", style: TextStyle(color: Colors.black , fontWeight: FontWeight.w400 , fontSize: 18),),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Close the dialog if "Yes" is clicked
                          Navigator.of(context).pop(); // Close the dialog
                          // Close the bottom sheet

                          // Perform logout
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          // Navigate to the login screen
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text("Yes", style: TextStyle(color: Colors.red , fontWeight: FontWeight.w400 , fontSize: 18),),
                      ),
                    ],
                  );
                },
              );
            },
          )

          ],
          ),
        );
      },
    );
  }

// Helper widget to create each settings option in the bottom sheet
  Widget _buildSettingsOption(BuildContext context, IconData icon, String text,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _refreshData() async {
    // Simulate a refresh task (e.g., fetching data)
    await Future.delayed(Duration(seconds: 2)); // Example delay

    // Show snackbar after the refresh task is complete
    callToast();
  }

  Future<void> callToast() async {
    Get.snackbar(
      'LessGo!',
      "Welcome buddy!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 8,
      margin: EdgeInsets.all(16),
      duration: Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}
