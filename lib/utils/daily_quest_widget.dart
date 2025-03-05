import 'package:flutter/material.dart';

class DailyQuestBanner extends StatelessWidget {
  final String questTitle;
  final String questDescription;
  final int progress;
  final int goal;
  final String reward;

  const DailyQuestBanner({
    Key? key,
    required this.questTitle,
    required this.questDescription,
    required this.progress,
    required this.goal,
    required this.reward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progressPercentage = (progress / goal).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xff72c2dc), Color(0xff285229)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            questTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),

          // Description
          Text(
            questDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 16),

          // Progress bar
          LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8.0,
          ),
          SizedBox(height: 8),

          // Progress Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress: $progress/$goal",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),

              // Reward
              Row(
                children: [
                  Text(
                    "Reward: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow[700],
                    size: 20,
                  ),
                  Text(
                    reward,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
