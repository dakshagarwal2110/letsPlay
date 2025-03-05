// import 'package:flutter/material.dart';
//
// import 'tournament_details.dart';
//
//
// class RoadmapScreen extends StatefulWidget {
//
//   final Tournament tournament;
//   const RoadmapScreen({super.key, required this.tournament});
//
//   @override
//   State<RoadmapScreen> createState() => _RoadmapScreenState();
// }
//
// class _RoadmapScreenState extends State<RoadmapScreen> {
//   final List<Map<String, String>> stages = [
//     {"stage": "Stage 1", "date": "2024-11-01"},
//     {"stage": "Stage 2", "date": "2024-11-05"},
//     {"stage": "Stage 3", "date": "2024-11-10"},
//     {"stage": "Stage 4", "date": "2024-11-15"},
//     {"stage": "Stage 5", "date": "2024-11-20"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF2B2E52),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF2B2E52),
//               Color(0xFF38567E),
//               Color(0xFF2B2E52),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.topRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Roadmap',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       for (int i = 0; i < stages.length; i++) ...[
//                         Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Zig-zag path
//                             Container(
//                               height: 150,
//                               width: double.infinity,
//                               child: CustomPaint(
//                                 painter: ZigZagPainter(
//                                   isLeft: i % 2 == 0,
//                                   isLast: i == stages.length - 1,
//                                 ),
//                               ),
//                             ),
//                             // Rock with flag
//                             Positioned(
//                               top: 40,
//                               left: i % 2 == 0 ? 50 : null,
//                               right: i % 2 == 0 ? null : 50,
//                               child: Column(
//                                 children: [
//                                   ShaderMask(
//                                     shaderCallback: (Rect bounds) {
//                                       return LinearGradient(
//                                         colors: [Colors.orange.shade200, Colors.orange.shade900],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ).createShader(bounds);
//                                     },
//                                     child: Icon(
//                                       Icons.flag,
//                                       size: 40,
//                                       color: Colors.white, // Set this color to white to apply the gradient properly
//                                     ),
//                                   ),
//
//                                   SizedBox(height: 10),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [Color(0xfffdd835), Color(0xffffc107)], // Yellow gradient
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     padding: EdgeInsets.all(10),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           stages[i]["stage"]!,
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Text(
//                                           "Participation: ${stages[i]["date"]!}",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ZigZagPainter extends CustomPainter {
//   final bool isLeft;
//   final bool isLast;
//
//   ZigZagPainter({required this.isLeft, required this.isLast});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // No drawing is performed here, as the black lines are removed.
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
