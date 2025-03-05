// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:letsplay/profile/profile_details_class.dart';
// import 'package:letsplay/utils/loader.dart';
// import '../apis/all_apis.dart';
// import '../auth/login.dart';
// import '../utils/app_size.dart';
// import '../utils/common_widgets.dart';
// import '../utils/daily_quest_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class ProfileScreen extends StatefulWidget {
//
//
//   const ProfileScreen({
//
//     super.key,
//   }) ;
//
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
//   List<Map<String, dynamic>> newsList = [];
//   bool isLoading = false;
//   final double progress = 0.5;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfileData();
//
//   }
//
//   Future<ProfileData> fetchProfileData() async {
//     Loader.showLoading("Getting your profile");
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/v1/user/profile/daksh22'),
//       );
//
//       if (response.statusCode == 200) {
//         Loader.hideLoading();
//         final jsonResponse = json.decode(response.body);
//         return ProfileResponse.fromJson(jsonResponse).data;
//       } else {
//         Loader.hideLoading();
//         throw Exception('Failed to load profile');
//       }
//     } catch (e) {
//       Loader.hideLoading();
//       throw Exception('Failed to load profile');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: const Color(0xFF2B2E52),
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFF2B2E52),
//                 Color(0xFF373B60),
//                 Color(0xFF3F4179),
//                 Color(0xFF3F4179),
//               ],
//               stops: [0.0, 0.3, 0.7, 1.0],
//             ),
//           ),
//           child: Column(
//             children: [
//               // Header Section
//               buildHeaderSection(context),
//
//               // Content Section with Loading/Error handling
//               Expanded(
//                 child: buildProfileContent(context),
//               ),
//             ],
//           ),
//         ),
//         // Floating Action Button with Popup
//         floatingActionButtonLocation: ExpandableFab.location,
//         floatingActionButton: ExpandableFab(
//           type: ExpandableFabType.fan,
//           openButtonBuilder: DefaultFloatingActionButtonBuilder(
//               fabSize: ExpandableFabSize.regular,
//               child: Icon(Icons.add, color: Colors.white),
//               backgroundColor: Colors.orangeAccent// Icon color
//           ),
//           closeButtonBuilder: DefaultFloatingActionButtonBuilder(
//               fabSize: ExpandableFabSize.regular,
//               child: Icon(Icons.close, color: Colors.white),
//               backgroundColor: Colors.deepOrange// Icon color
//           ),
//           children: [
//             FloatingActionButton(
//               onPressed: () {},
//               child: Icon(Icons.message, color: Colors.white), // Icon color
//               backgroundColor: Colors.blue, // Background color
//             ),
//             FloatingActionButton(
//               onPressed: () {},
//               child: Icon(Icons.mail, color: Colors.white), // Icon color
//               backgroundColor: Colors.red, // Background color
//             ),
//             FloatingActionButton(
//               onPressed: () {},
//               child: Icon(Icons.call, color: Colors.white), // Icon color
//               backgroundColor: Colors.green, // Background color
//             ),
//
//           ],
//         ),
//
//       ),
//     );
//   }
//
//   Widget buildHeaderSection(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppSize.getWidth(12, context),
//         vertical: AppSize.getHeight(8, context),
//       ),
//       child: Container(
//         margin: EdgeInsets.symmetric(
//           vertical: AppSize.getHeight(7, context),
//         ),
//         padding: const EdgeInsets.only(right: 10.0, left: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Row(
//                 children: [
//                   trophy(context, "assets/images/logo.png"),
//                   Flexible(
//                     child: ShaderMask(
//                       shaderCallback: (bounds) => LinearGradient(
//                         colors: [
//                           Color(0xFFFD5939),
//                           Color(0xFFFD7E29),
//                           Color(0xFFFDBF2E),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ).createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
//                       child: Text(
//                         "TourneyB",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 26,
//                           fontFamily: 'Mercenary',
//                           fontWeight: FontWeight.bold,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: AppSize.getWidth(10, context)),
//                   trophy(context, "assets/images/logo.png"),
//                 ],
//               ),
//             ),
//             buildSocialMediaIcons(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSocialMediaIcons(BuildContext context) {
//     return Row(
//       children: [
//         socialMediaIcon(context, "assets/images/instagram.png"),
//         SizedBox(width: AppSize.getWidth(10, context)),
//         socialMediaIcon(context, "assets/images/twitter.png"),
//         SizedBox(width: AppSize.getWidth(10, context)),
//         socialMediaIconDiscord(context, "assets/images/discord.png"),
//         SizedBox(width: AppSize.getWidth(10, context)),
//         settingsIcon(context),
//       ],
//     );
//   }
//
//   Widget buildProfileContent(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: AppSize.getWidth(12, context)),
//       child: FutureBuilder<ProfileData>(
//         future: fetchProfileData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFFD5939),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error occurred! ${snapshot.error}',
//                 style: TextStyle(
//                   color: Colors.redAccent,
//                   fontSize: AppSize.getHeight(20, context),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           } else if (snapshot.hasData) {
//             return RefreshIndicator(
//               onRefresh: fetchProfileData,
//               color: Color(0xFFFD5939),
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: buildProfileDetails(snapshot.data!),
//               ),
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
//
//   Column buildProfileDetails(ProfileData data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: AppSize.getHeight(15, context)),
//         buildProfileSection(data),
//         SizedBox(height: AppSize.getHeight(20, context)),
//         buildOrangeGradientCard(
//           context,
//           "My Completed Tournaments",
//           "History of Triumphs",
//         ),
//         DailyQuestBanner(
//           questTitle: 'Play and win',
//           questDescription: 'Complete your daily quest to win tokens',
//           progress: 1,
//           goal: 5,
//           reward: '50 XP',
//         ),
//       ],
//     );
//   }
//
//   Row buildProfileSection(ProfileData data) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: 100,
//               height: 100,
//               child: CircularProgressIndicator(
//                 value: 0.50,
//                 strokeWidth: 3.0,
//                 backgroundColor: Colors.grey.withOpacity(0.2),
//                 color: Color(0xFFFD7E29),
//               ),
//             ),
//             ClipOval(
//               child: Image.network(
//                 data.image,
//                 width: 85,
//                 height: 85,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(width: AppSize.getWidth(18, context)),
//         buildUserInfo(data),
//       ],
//     );
//   }
//
//   Column buildUserInfo(ProfileData data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           data.username,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: AppSize.getHeight(25, context),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Row(
//           children: [
//             Icon(
//               Icons.star,
//               color: Colors.yellow,
//               size: 20,
//             ),
//             SizedBox(width: 5),
//             Text(
//               data.token.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: AppSize.getHeight(15, context),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//
//
//
//
// // Widget for Discord icon (used in header)
//   Widget settingsIcon(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // When tapped, open the bottom sheet
//         _showSettingsBottomSheet(context);
//       },
//       child: Container(
//         height: AppSize.getHeight(20, context),
//         width: AppSize.getWidth(20, context),
//         child: ShaderMask(
//           shaderCallback: (Rect bounds) {
//             return LinearGradient(
//               colors: [
//                 Color(0xFFFD5939),
//                 Color(0xFFFD7E29),
//                 Color(0xFFFDBF2E),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ).createShader(bounds);
//           },
//           blendMode: BlendMode.srcIn,
//           child: Icon(Icons.menu),
//         ),
//       ),
//     );
//   }
//
//
//
//
//   void _showSettingsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             // Ensures the bottom sheet adjusts to its content height
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//
//
//               _buildSettingsOption(
//                 context,
//                 Icons.person,
//                 "Personal Details",
//                 onTap: () {
//                   // Handle navigation to Personal Details
//                   Navigator.pop(context); // Close the bottom sheet
//                   // Navigate to personal details screen
//                 },
//               ),
//               Divider(),
//               _buildSettingsOption(
//                 context,
//                 Icons.account_balance_wallet,
//                 "Wallet and Tokens",
//                 onTap: () {
//                   // Handle navigation to Wallet and Tokens
//                   Navigator.pop(context); // Close the bottom sheet
//                   // Navigate to wallet screen
//                 },
//               ),
//               Divider(),
//               _buildSettingsOption(
//                 context,
//                 Icons.privacy_tip,
//                 "Privacy",
//                 onTap: () {
//                   // Handle navigation to Privacy settings
//                   Navigator.pop(context); // Close the bottom sheet
//                   // Navigate to privacy screen
//                 },
//               ),
//               Divider(),
//               _buildSettingsOption(
//                 context,
//                 Icons.logout,
//                 "Logout",
//                 onTap: () async {
//                   // Handle logout
//                   Navigator.pop(context); // Close the bottom sheet
//                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                   await prefs.clear();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
// // Helper widget to create each settings option in the bottom sheet
//   Widget _buildSettingsOption(BuildContext context, IconData icon, String text,
//       {required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.orangeAccent),
//       title: Text(
//         text,
//         style: TextStyle(
//           fontSize: 18,
//           color: Colors.black87,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Future<void> _refreshData() async {
//     // Simulate a refresh task (e.g., fetching data)
//     await Future.delayed(Duration(seconds: 2)); // Example delay
//
//     // Show snackbar after the refresh task is complete
//     callToast();
//   }
//
//   Future<void> callToast() async {
//     Get.snackbar(
//       'LessGo!',
//       "Welcome buddy!",
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.BOTTOM,
//       borderRadius: 8,
//       margin: EdgeInsets.all(16),
//       duration: Duration(seconds: 3),
//       snackStyle: SnackStyle.FLOATING,
//     );
//   }}
