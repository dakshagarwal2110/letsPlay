import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsplay/win_tokens/random_games/chess/chess_game.dart';
import 'package:letsplay/win_tokens/win_token_tasks_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../leaderboard/leaderboard_screen.dart';
import '../tournament/tournament_details.dart';
import 'app_size.dart';

Widget coinWalletMediaIcon(BuildContext context, String assetPath) {
  return Container(
    height: AppSize.getHeight(28, context),
    width: AppSize.getWidth(28, context),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
      ),
    ),
  );
}

// Widget socialMediaIcon(BuildContext context, String assetPath) {
//   return Container(
//     height: AppSize.getHeight(20, context),
//     width: AppSize.getWidth(20, context),
//     decoration: BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage(assetPath),
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }
//
// Widget socialMediaIconDiscord(BuildContext context, String assetPath) {
//   return Container(
//     height: AppSize.getHeight(28, context),
//     width: AppSize.getWidth(28, context),
//     decoration: BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage(assetPath),
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }

class EnterPincodeField extends StatelessWidget {
  final Function(String) onCompleted;
  final Function(String) onChanged;

  const EnterPincodeField(
      {super.key, required this.onCompleted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 280,
        child: PinCodeTextField(
          autoFocus: true,
          showCursor: true,
          length: 4,
          obscureText: false,
          animationType: AnimationType.fade,
          cursorColor: Colors.purple,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderWidth: 0.1,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: 50,
            fieldWidth: 50,
            fieldOuterPadding: const EdgeInsets.all(0),
            activeFillColor: Colors.orangeAccent,
            inactiveFillColor: Colors.orange,
            selectedFillColor: Colors.orange,
          ),
          animationDuration: const Duration(milliseconds: 300),
          //backgroundColor: Colors.orangeAccent,
          enableActiveFill: true,
          onCompleted: onCompleted,
          onChanged: onChanged,
          beforeTextPaste: (text) {
            return true;
          },
          appContext: context,
        ),
      ),
    );
  }
}


Widget buildOrangeGradientCard(BuildContext context, String title, String description) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFD7E29),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.orangeAccent.withOpacity(0.3),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Tournament name
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                  SizedBox(height: 8),
                  // Example amount (you can modify this as per your requirements)
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xFFFD7E29),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFFFFFFE),
              ),
            )
          ],
        ),
      ),
    ),
  );
}


Widget buildLeaderBoardCards(BuildContext context, String title, String description) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LeaderboardScreen()
          )
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFD7E29),
            width: 1,
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF4FC07D).withOpacity(0.5),
              Color(0xFFA26FCC).withOpacity(0.15),
              Color(0xFF6CC290).withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Tournament name

                  Row(
                    children: [
                      trophy(context , "assets/images/logo.png"),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis, // Prevents overflow
                      ),
                      trophy(context , "assets/images/logo.png"),
                    ],
                  ),

                  SizedBox(height: 8),
                  // Example amount (you can modify this as per your requirements)
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xFFFD7E29),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFFFFFFE),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildWinToken(BuildContext context, String title, String description) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GameScreen()
          )
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFD7E29),
            width: 1,
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFFC9829A).withOpacity(0.5),
              Color(0xFFA26FCC).withOpacity(0.15),
              Color(0xFFC9829A).withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Tournament name

                  Row(
                    children: [
                      trophy(context , "assets/images/logo.png"),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis, // Prevents overflow
                      ),
                      trophy(context , "assets/images/logo.png"),
                    ],
                  ),

                  SizedBox(height: 8),
                  // Example amount (you can modify this as per your requirements)
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xFFFD7E29),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFFFFFFE),
              ),
            )
          ],
        ),
      ),
    ),
  );
}



Widget _buildWinnerCard(BuildContext context, Winners winner) {
  return GestureDetector(
    onTap: () {
      print("On tap card Winner: ${winner.username}");
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFD7E29),
            width: 1.5,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.orangeAccent.withOpacity(0.3),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF36013B),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                image: DecorationImage(
                  image: AssetImage("assets/images/dp1.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Tournament name
            Text(
              winner.username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Mercenary',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            // Example amount (you can modify this as per your requirements)
            Text(
              '${winner.tournament_name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),
            // Date
            Text(
              'Date: ${winner.date}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            // Example amount (you can modify this as per your requirements)
            Text(
              'Winning +₹${winner.amount}',
              style: TextStyle(
                color: Color(0xFF008C07),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildOrangeGradientCards(BuildContext context) {
  return GestureDetector(
    onTap: (){
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => TournamentTabLayoutScreen(tournament_name: tournament.name, image: tournament.image, date: tournament.date,),
      //   ),
      // );
    },
    child:  Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFFD7E29),
          width: 1.5,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.orangeAccent.withOpacity(0.3),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ruined Karma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1350 RP',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
  );

}


Widget socialMediaIcon(BuildContext context, String assetPath) {
  return Container(
    height: AppSize.getHeight(20, context),
    width: AppSize.getWidth(20, context),
    child:  ShaderMask(
      shaderCallback: (Rect bounds) {
        return  LinearGradient(
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
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget socialMediaIconDiscord(BuildContext context, String assetPath) {
  return Container(
    height: AppSize.getHeight(28, context),
    width: AppSize.getWidth(28, context),
    child: ShaderMask(
      shaderCallback: (Rect bounds) {
        return  LinearGradient(
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
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    ),
  );
}


Widget trophy(BuildContext context, String assetPath) {
  return Container(
    height: AppSize.getHeight(28, context),
    width: AppSize.getWidth(28, context),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
      ),
    ),
  );
}





