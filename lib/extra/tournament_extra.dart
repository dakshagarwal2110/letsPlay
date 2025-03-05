// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:letsplay/auth/login.dart';
// import 'package:letsplay/tournament/tournament_details.dart';
// import 'package:letsplay/tournament/tournament_tab_layout_screen.dart';
//
// import '../utils/app_size.dart';
//
// class TournamentScreenNew extends StatefulWidget {
//   const TournamentScreenNew({super.key});
//
//   @override
//   State<TournamentScreenNew> createState() => _TournamentScreenNewState();
// }
//
// class _TournamentScreenNewState extends State<TournamentScreenNew> {
//   late List<Winners> _winners = [];
//
//   ScrollController _scrollControllerTournament = ScrollController();
//   ScrollController _scrollControllerWinner = ScrollController();
//   ScrollController _scrollControllerPastTournament = ScrollController();
//   bool isLoading = true;
//   List<Tournament> tournaments = [];
//
//   void _scrollForwardTournament() {
//     _scrollControllerTournament.animateTo(
//       _scrollControllerTournament.offset + 200,
//       // Adjust the scroll amount as needed
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _scrollForwardWinner() {
//     _scrollControllerWinner.animateTo(
//       _scrollControllerWinner.offset + 200,
//       // Adjust the scroll amount as needed
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _scrollForwardPastTournament() {
//     _scrollControllerPastTournament.animateTo(
//       _scrollControllerPastTournament.offset + 200,
//       // Adjust the scroll amount as needed
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   // Function to scroll the horizontal scroll view to the left
//   // void _scrollBack() {
//   //   _scrollControllerWinner.animateTo(
//   //     _scrollControllerWinner.offset - 200, // Adjust the scroll amount as needed
//   //     duration: Duration(milliseconds: 300),
//   //     curve: Curves.easeInOut,
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Color(0xFF6A0572), // Set your preferred color here
//       statusBarIconBrightness: Brightness.light, // Controls the icon color
//     ));
//
//     return SafeArea(
//         child: Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(-0.8, -0.5),
//                 end: Alignment(0.8, 0.5),
//                 colors: [
//                   Color(0xFF0808C7),
//                   Color(0xFF030530),
//                   Color(0xFFFF77FF),
//                   Color(0xFF0808C7),
//                   Color(0xFF030514),
//                 ],
//                 stops: [0.0, 0.25, 0.5, 0.75, 1.0],
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Fixed header
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppSize.getWidth(12, context),
//                     vertical: AppSize.getHeight(8, context),
//                   ),
//                   decoration: BoxDecoration(
//                     color: Color(0x4D606485), // Transparent dark color
//
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(0, 4),
//                         blurRadius: 10,
//                         // Increased blur radius for a stronger blur effect
//                         spreadRadius:
//                         2, // Optional: Adjust the spread for a wider shadow
//                       ),
//                     ],
//                   ), // Background color for the header
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           socialMediaIconDiscord(context, "assets/images/logo.png"),
//                           ShaderMask(
//                             shaderCallback: (bounds) => LinearGradient(
//                               colors: [
//                                 Color(0xFFFD5939),
//                                 Color(0xFFFD7E29),
//                                 Color(0xFFFDBF2E),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ).createShader(Rect.fromLTWH(
//                                 0.0, 0.0, bounds.width, bounds.height)),
//                             child: Text(
//                               "TourneyB",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 26,
//                                 fontFamily: 'Mercenary',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           socialMediaIconDiscord(context, "assets/images/logo.png"),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Login(),
//                                 ),
//                               );
//                             },
//                             child: socialMediaIconDiscord(
//                                 context, "assets/images/discord.png"),
//                           ),
//                           SizedBox(width: AppSize.getWidth(15, context)),
//                           socialMediaIcon(context, "assets/images/instagram.png"),
//                           SizedBox(width: AppSize.getWidth(15, context)),
//                           socialMediaIcon(context, "assets/images/twitter.png"),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Scrollable content
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       left: AppSize.getWidth(12, context),
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment(-0.8, -0.5),
//                         end: Alignment(0.8, 0.5),
//                         colors: [
//                           Color(0xFF0808C7),
//                           Color(0xFF030530),
//                           Color(0xFFFF77FF),
//                           Color(0xFF0808C7),
//                           Color(0xFF030514),
//                         ],
//                         stops: [0.0, 0.25, 0.5, 0.75, 1.0],
//                       ),
//                     ),
//                     // Background color for the content area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       // Vertical scrolling enabled
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Featured Tournaments Section
//
//                           Row(
//                             children: [
//                               Text(
//                                 "Featured Tournaments",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: AppSize.getHeight(25, context),
//                                   fontFamily: 'Mercenary',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: Icon(
//                                     Icons.arrow_forward_rounded,
//                                     color: Colors.white,
//                                   ))
//                             ],
//                           ),
//
//                           SizedBox(height: AppSize.getHeight(8, context)),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   controller: _scrollControllerTournament,
//                                   child: Row(
//                                     children: tournaments.map((tournament) {
//                                       return _buildTournamentCard(
//                                           context, tournament);
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios,
//                                     color: Colors.white),
//                                 onPressed: _scrollForwardTournament,
//                               ),
//                             ],
//                           ),
//
//                           SizedBox(height: AppSize.getHeight(8, context)),
//
//                           // Winners Section
//                           Row(
//                             children: [
//                               Text(
//                                 "Winners",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: AppSize.getHeight(25, context),
//                                   fontFamily: 'Mercenary',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: Icon(
//                                     Icons.arrow_forward_rounded,
//                                     color: Colors.white,
//                                   ))
//                             ],
//                           ),
//                           SizedBox(height: AppSize.getHeight(8, context)),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   controller: _scrollControllerWinner,
//                                   child: Row(
//                                     children: _winners.map((winner) {
//                                       return _buildWinnerCard(context, winner);
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios,
//                                     color: Colors.white),
//                                 onPressed: _scrollForwardWinner,
//                               ),
//                             ],
//                           ),
//
//                           SizedBox(height: AppSize.getHeight(8, context)),
//
//                           // Past Tournaments Section
//
//                           Row(
//                             children: [
//                               Text(
//                                 "Win Tokens",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: AppSize.getHeight(25, context),
//                                   fontFamily: 'Mercenary',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: Icon(
//                                     Icons.arrow_forward_rounded,
//                                     color: Colors.white,
//                                   ))
//                             ],
//                           ),
//                           SizedBox(height: AppSize.getHeight(8, context)),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   controller: _scrollControllerPastTournament,
//                                   child: Row(
//                                     children: tournaments.map((tournament) {
//                                       return _buildTournamentCard(
//                                           context, tournament);
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios,
//                                     color: Colors.white),
//                                 onPressed: _scrollForwardPastTournament,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Future<void> fetchTournaments() async {
//     final url =
//         'https://tourneyb-backend.vercel.app/api/v1/tournament/list?page=1&per_page=5&sortBy=date&sortOrder=desc';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         tournaments = List<Tournament>.from(
//             data['data'].map((t) => Tournament.fromJson(t)));
//         isLoading = false;
//       });
//     } else {
//       // Handle error
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     print("init state tournament_screen_new");
//
//     fetchTournaments();
//
//     _winners = [
//       Winners(
//           username: 'Daksh',
//           tournament_name: 'Chess Masters',
//           image: 'assets/images/uno.jpg',
//           date: '2024-09-10',
//           amount: "300"),
//       Winners(
//           username: 'Anmol',
//           tournament_name: 'BGMI',
//           image: 'assets/images/chess.jpg',
//           date: '2024-09-12',
//           amount: "450"),
//
//       Winners(
//           username: 'Avni',
//           tournament_name: 'Ludo Queen',
//           image: 'assets/images/uno.jpg',
//           date: '2024-09-10',
//           amount: "300"),
//       Winners(
//           username: 'Lakshya',
//           tournament_name: 'Clash of clans',
//           image: 'assets/images/chess.jpg',
//           date: '2024-09-12',
//           amount: "450"),
//       // Add more tournaments
//     ];
//   }
//
//   @override
//   void dispose() {
//     _scrollControllerTournament.dispose();
//     _scrollControllerWinner.dispose();
//     _scrollControllerPastTournament.dispose();
//     super.dispose();
//   }
//
//   Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TournamentTabLayoutScreen(
//               tournament_name: tournament.name,
//               image: tournament.image,
//               date: tournament.date,
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(right: 8.0),
//         child: Container(
//           width: 180,
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFFD5939), Color(0xFFFDBF2E)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 4,
//                 offset: Offset(2, 4),
//               ),
//             ],
//             border: Border.all(
//               color: Colors.orange, // Shining orange border
//               width: 2,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   tournament.image ??
//                       'https://via.placeholder.com/150', // Fallback image
//                   width: double.infinity,
//                   height: AppSize.getHeight(80, context),
//                   fit: BoxFit.cover,
//                   loadingBuilder: (BuildContext context, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       width: double.infinity,
//                       height: AppSize.getHeight(150, context),
//                       color: Colors.grey[300],
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   },
//                   errorBuilder: (BuildContext context, Object error,
//                       StackTrace? stackTrace) {
//                     return Container(
//                       width: double.infinity,
//                       height: AppSize.getHeight(150, context),
//                       color: Colors.grey[300],
//                       child: const Center(
//                         child: Icon(
//                           Icons.broken_image,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Tournament name
//               Text(
//                 tournament.name,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8),
//               // Date
//               Text(
//                 'Date: ${tournament.date}',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 8),
//               // Example amount (you can modify this as per your requirements)
//               Text(
//                 'Prize: \₹2000',
//                 style: TextStyle(
//                   color: Color(0xFF000000),
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWinnerCard(BuildContext context, Winners winner) {
//     return GestureDetector(
//       onTap: () {
//         print("On tap card Winner: ${winner.username}");
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(right: 8.0),
//         child: Container(
//           width: 180,
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               // colors: [Color(0xFFDA92AC),
//               //   Color(0xFFC25E82)],
//               colors: [
//                 Color(0xFFE069A2),
//                 Color(0xFFB74D79),
//                 Color(0xFF814459),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 4,
//                 offset: Offset(2, 4),
//               ),
//             ],
//             border: Border.all(
//               color: Color(0xFF6A0572), // Gradient border
//               width: 2,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Circular image
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF36013B),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.black, width: 2),
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/dp1.png"),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Tournament name
//               Text(
//                 winner.username,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontFamily: 'Mercenary',
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8),
//
//               // Example amount (you can modify this as per your requirements)
//               Text(
//                 '${winner.tournament_name}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               SizedBox(height: 8),
//               // Date
//               Text(
//                 'Date: ${winner.date}',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 8),
//               // Example amount (you can modify this as per your requirements)
//               Text(
//                 'Winning +₹${winner.amount}',
//                 style: TextStyle(
//                   color: Color(0xFF008C07),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget coinWalletMediaIcon(BuildContext context, String assetPath) {
//     return Container(
//       height: AppSize.getHeight(28, context),
//       width: AppSize.getWidth(28, context),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(assetPath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget socialMediaIcon(BuildContext context, String assetPath) {
//     return Container(
//       height: AppSize.getHeight(20, context),
//       width: AppSize.getWidth(20, context),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(assetPath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget socialMediaIconDiscord(BuildContext context, String assetPath) {
//     return Container(
//       height: AppSize.getHeight(28, context),
//       width: AppSize.getWidth(28, context),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(assetPath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
