import 'package:flutter/material.dart';
import 'package:letsplay/utils/app_size.dart';
import 'package:letsplay/win_tokens/random_games/dice_game.dart';
import 'package:letsplay/win_tokens/random_games/find_coin.dart';

import '../streak/fetch_streak.dart';
import '../utils/common_widgets.dart';

class WinTokenTasksScreen extends StatefulWidget {
  const WinTokenTasksScreen({super.key});

  @override
  State<WinTokenTasksScreen> createState() => _WinTokenTasksScreenState();
}

class _WinTokenTasksScreenState extends State<WinTokenTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2B2E52),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2B2E52),
                Color(0xFF38567E),
                Color(0xFF2B2E52),
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Row with Back Button and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    trophy(context, "assets/images/logo.png"),
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFFFD5939),
                            Color(0xFFFD7E29),
                            Color(0xFFFDBF2E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(Rect.fromLTWH(
                            0.0, 0.0, bounds.width, bounds.height)),
                        child: Text(
                          "Daily quests",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    trophy(context, "assets/images/logo.png"),
                  ],
                ),

                // Three Cards
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      // Daily Call Card
                      buildCard('Daily Call', 'assets/images/daily_call.png',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StreakShowCalender(),
                          ),
                        );
                      }),
                      SizedBox(height: 8),
                      // Roll, Win, Repeat Card
                      buildCard(
                          'Roll, Win, Repeat', 'assets/images/dice_game.jpg',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiceGameScreen(),
                          ),
                        );
                      }),
                      SizedBox(height: 8),
                      // Glass and Win Card
                      buildCard('Hidden Fortune', 'assets/images/glass_coin.jpg',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoinGameScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build each card
  Widget buildCard(String gameName, String imagePath, Function onClick) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Card(
        elevation: 5,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Game image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              // Game name with completed status and forward arrow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSize.getHeight(20, context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(4, context)),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        SizedBox(width: AppSize.getHeight(4, context)),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: AppSize.getHeight(16, context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

// Dummy trophy widget for the Row
}
