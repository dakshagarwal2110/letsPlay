import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/app_size.dart';
import '../../utils/common_widgets.dart';


class DiceGameScreen extends StatefulWidget {
  @override
  _DiceGameScreenState createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen>
    with SingleTickerProviderStateMixin {
  int dice1 = 1;
  int dice2 = 1;
  String result = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    // Set duration to 2 seconds but add an oscillating effect
    _controller.duration = Duration(seconds: 2);

    _controller
      ..reset()
      ..repeat(period: Duration(milliseconds: 100)); // Faster oscillations within 2 seconds

    // Stop the animation after 2 seconds and show the result
    Future.delayed(Duration(seconds: 1), () {
      _controller.stop();
      setState(() {
        final random = Random();
        dice1 = random.nextInt(6) + 1;
        dice2 = random.nextInt(6) + 1;
        int sum = dice1 + dice2;
        result = sum > 7 ? '🎉 You Win!' : '😢 You Lose!';
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2E52),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
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
          child: Column(
            children: [
              // AppBar-style Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Row(
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
                        ).createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                        child: Text(
                          "Roll, Win, Repeat!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSize.getHeight(25, context),
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
              ),

              SizedBox(height: AppSize.getHeight(6, context),),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal:AppSize.getWidth(12, context)),
                child: Align(
                  alignment: Alignment.centerLeft, // Aligns the text to the left
                  child: Text(
                    "Destination:",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: AppSize.getHeight(25, context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal:AppSize.getWidth(12, context)),
                child: Align(
                  alignment: Alignment.centerLeft, // Aligns the text to the left
                  child: Text(
                    "Roll Two Dice, Score Over 7, and Win Big! Let's Go...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.getHeight(25, context),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // Centered Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Dice Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: _animation.value * 2 * pi,
                            child: Image.asset('assets/images/dice$dice1.png', width: 100, height: 100),
                          ),
                          SizedBox(width: 20),
                          Transform.rotate(
                            angle: _animation.value * 2 * pi,
                            child: Image.asset('assets/images/dice$dice2.png', width: 100, height: 100),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      Text(
                        result,
                        style: TextStyle(
                          color: result == '🎉 You Win!' ? Colors.greenAccent : Colors.redAccent,
                          fontSize: AppSize.getHeight(28, context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Roll Dice Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade400, Colors.orange.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: rollDice,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            child: Text(
                              'Roll Dice',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
