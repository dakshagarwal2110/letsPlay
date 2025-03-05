import 'dart:math';
import 'package:flutter/material.dart';
import 'package:letsplay/utils/app_size.dart';

class CoinGameScreen extends StatefulWidget {
  @override
  _CoinGameScreenState createState() => _CoinGameScreenState();
}

class _CoinGameScreenState extends State<CoinGameScreen> with SingleTickerProviderStateMixin {
  int? coinPosition;
  bool isGameStarted = false;
  bool showResult = false;
  int selectedGlass = -1;

  // Initialize animation controllers for shuffling and flipping animation
  late AnimationController _controller;
  late Animation<double> _shuffleAnimation;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _shuffleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Flip animation for showing the result
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    startGame();
  }

  void startGame() {
    // Reset the game state
    setState(() {
      isGameStarted = true;
      showResult = false;
      selectedGlass = -1;
      coinPosition = Random().nextInt(3); // Randomly assign the coin position
    });

    // Start shuffle animation
    _controller.forward(from: 0);
  }

  void onSelectGlass(int index) {
    setState(() {
      selectedGlass = index;
      showResult = true;
      isGameStarted = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget trophy(BuildContext context, String assetPath) {
    return Image.asset(
      assetPath,
      width: 30,
      height: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2E52),
      body: SafeArea(
        child: Container(
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
          child: Column(
            children: [
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
                          "Hidden Fortune",
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
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tap a card to find the coin!",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold ,color: Colors.white , fontFamily: "mulish"),
                      ),
                      SizedBox(height: 20),
                      // Row with three glasses
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: isGameStarted ? () => onSelectGlass(index) : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedBuilder(
                                animation: _shuffleAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 10 * sin(_shuffleAnimation.value * pi)),
                                    child: Container(
                                      width: 100,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.brown,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: AnimatedBuilder(
                                        animation: _flipAnimation,
                                        builder: (context, child) {
                                          return Transform(
                                            transform: Matrix4.rotationY(pi * _flipAnimation.value),
                                            alignment: Alignment.center,
                                            child: showResult && coinPosition == index
                                                ? Image.asset(
                                              "assets/images/coin_gold.png",
                                              width: 40, // Adjusted coin size
                                              height: 40, // Adjusted coin size
                                              fit: BoxFit.cover,
                                            )
                                                : Icon(Icons.wine_bar, color: Colors.white ,size: AppSize.getHeight(50, context),),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      if (showResult)
                        Text(
                          selectedGlass == coinPosition
                              ? "Jackpot! You found the fortune!"
                              : "So close! The treasure is just a flip away.",
                          style: TextStyle(
                            fontSize: AppSize.getHeight(20, context),
                            fontWeight: FontWeight.w600,
                            color: selectedGlass == coinPosition ? Colors.orange : Colors.red, // Conditional color
                            fontFamily: "mulish",
                          ),
                        ),
                      SizedBox(height: 20),
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
                          onPressed: startGame,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                            child: Text(
                              'Restart Game',
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
