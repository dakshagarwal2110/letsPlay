import 'package:flutter/material.dart';
import 'tournament_details.dart'; // Assuming it contains the Tournament class

class RoadmapScreen extends StatefulWidget {
  final Tournament tournament;
  const RoadmapScreen({super.key, required this.tournament});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late List<Map<String, dynamic>> stages;

  @override
  void initState() {
    super.initState();
    // Extracting roadmap from the tournament object
    final roadmap = widget.tournament.roadmap;
    stages = roadmap.entries.map((entry) => {
      "stage": entry.key[0].toUpperCase() + entry.key.substring(1), // Capitalize the stage name
      "timestamp": entry.value.timestamp.toIso8601String(),
      "isCompleted": entry.value.completed,
    }).toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2E52),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B2E52),
              Color(0xFF353967),
              Color(0xFF2B2E52),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < stages.length; i++) ...[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Zig-zag path
                            SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: ZigZagPainter(
                                  isLeft: i % 2 == 0,
                                  isLast: i == stages.length - 1,
                                ),
                              ),
                            ),
                            // Rock with flag
                            Positioned(
                              top: 40,
                              left: i % 2 == 0 ? 50 : null,
                              right: i % 2 == 0 ? null : 50,
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: [
                                          Colors.orange.shade200,
                                          Colors.orange.shade900,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds);
                                    },
                                    child: Image.asset(
                                      stages[i]["isCompleted"]
                                          ? "assets/images/flag_green.png"
                                          : "assets/images/flag_red.png",
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amberAccent.shade200,
                                          Colors.amberAccent.shade400,
                                          Colors.amberAccent.shade700,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text(
                                          stages[i]["stage"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Participation: ${DateTime.parse(stages[i]["timestamp"]).toLocal()}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  final bool isLeft;
  final bool isLast;

  ZigZagPainter({required this.isLeft, required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    // Optional: Implement zigzag path visuals
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
