import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _EnhancedGameScreenState createState() => _EnhancedGameScreenState();
}

class _EnhancedGameScreenState extends State<GameScreen> {
  int userPosition = 1;
  int computerPosition = 1;
  int diceValue = 1;
  bool isUserTurn = true;
  int userTimer = 10;
  int computerTimer = 10;  // Changed from 3 to 10
  Timer? turnTimer;
  Timer? movementTimer;
  List<int> userMovementPath = [];
  List<int> computerMovementPath = [];
  bool gameFinished = false;  // Added game finished flag

  // ... (previous code remains the same)

  void startTurnTimer() {
    turnTimer?.cancel();
    userTimer = 10;
    computerTimer = 10;  // Changed from 3 to 10

    turnTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (gameFinished) {
          timer.cancel();
          return;
        }

        if (isUserTurn) {
          userTimer--;
          if (userTimer <= 0) {
            rollDice();
          }
        } else {
          computerTimer--;
          if (computerTimer <= 0) {
            rollDice();
          }
        }
      });
    });
  }

  void checkWinner() {
    if (userPosition == 100) {
      gameFinished = true;
      turnTimer?.cancel();
      movementTimer?.cancel();
      showEndDialog("Congratulations! 🎉\nYou Won the Game!");
    } else if (computerPosition == 100) {
      gameFinished = true;
      turnTimer?.cancel();
      movementTimer?.cancel();
      showEndDialog("Computer Wins! 🤖\nBetter luck next time!");
    }
  }

  void resetGame() {
    setState(() {
      userPosition = 1;
      computerPosition = 1;
      diceValue = 1;
      isUserTurn = true;
      userTimer = 10;
      computerTimer = 10;  // Changed from 3 to 10
      gameFinished = false;  // Reset game finished flag
      userMovementPath.clear();
      computerMovementPath.clear();
    });
    startTurnTimer();
  }

  void rollDice() {
    // Prevent rolling dice if game is finished
    if (gameFinished) return;

    turnTimer?.cancel();

    setState(() {
      diceValue = Random().nextInt(6) + 1;

      if (isUserTurn) {
        calculateMovementPath(userPosition, diceValue, true);
        isUserTurn = false;
      } else {
        calculateMovementPath(computerPosition, diceValue, false);
        isUserTurn = true;
      }
    });

    startTurnTimer();
  }

  void showSpecialTileTransition(int start, int end, bool isSnake) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSnake
              ? "Oops! Snake bite! Slid from $start to $end"
              : "Yay! Ladder climb! Moved from $start to $end",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isSnake ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void calculateMovementPath(int currentPosition, int diceRoll, bool isUser) {
    if (gameFinished) return;

    List<int> movementPath = [];
    int newPosition = currentPosition + diceRoll;

    // Ensure the position does not exceed 100
    if (newPosition > 100) {
      newPosition = 100;
    }

    // Generate step-by-step movement
    for (int i = currentPosition; i <= newPosition; i++) {
      movementPath.add(i);
    }

    // Check for snakes or ladders at the final position
    int finalPosition = snakesAndLadders[newPosition] ?? newPosition;

    // Determine if it's a snake or ladder
    bool isSnake = finalPosition < newPosition;
    bool isLadder = finalPosition > newPosition;

    if (finalPosition != newPosition) {
      movementPath.clear();

      // Generate path to final position
      if (finalPosition > newPosition) {
        // Ladder: going up
        movementPath = List.generate(
            finalPosition - currentPosition + 1,
                (index) => currentPosition + index
        );
      } else {
        // Snake: going down
        movementPath = List.generate(
            currentPosition - finalPosition + 1,
                (index) => currentPosition - index
        );
      }

      // Show transition notification
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSpecialTileTransition(newPosition, finalPosition, isSnake);
      });
    }

    // Set movement path and trigger animation
    if (isUser) {
      userMovementPath = movementPath;
      userPosition = finalPosition;
      animateMovement(userMovementPath, true);
    } else {
      computerMovementPath = movementPath;
      computerPosition = finalPosition;
      animateMovement(computerMovementPath, false);
    }

    // Check winner after updating position
    if (finalPosition == 100) {
      gameFinished = true;
      checkWinner();
    }
  }


  final List<Color> boardColors = [
    Color(0xFFFFF3E0),  // Light orange background
    Color(0xFFFFE0B2),  // Slightly darker orange
  ];

  final Color userColor = Color(0xFF4CAF50);     // Green for user
  final Color computerColor = Color(0xFFF44336); // Red for computer

  // Snakes and Ladders mapping
  final Map<int, int> snakesAndLadders = {
    // Snakes (going down)
    // 16: 6,    // Short snake
    // 47: 26,   // Medium snake
    //
    // 87: 24,   // Long snake
    // 98: 79,   // Existing snake
    //
    // // Ladders (going up)
    // 4: 14,    // Short ladder
    // 9: 31,    // Medium ladder
    // 20: 38,   // Existing ladder
    // 28: 84,   // Long ladder
    // 36: 44,   // Short ladder
    // 51: 67,   // Medium ladder
    // 71: 91,   // Long ladder
    // 80: 100,  // Final boost ladder
  };

  @override
  void initState() {
    super.initState();
    startTurnTimer();
  }

  @override
  void dispose() {
    turnTimer?.cancel();
    movementTimer?.cancel();
    super.dispose();
  }


  // void showSpecialTileTransition(int start, int end, bool isSnake) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: isSnake ? Colors.red[100] : Colors.green[100],
  //       title: Text(
  //         isSnake ? "Oops! Snake Bite! 🐍" : "Yay! Ladder Climb! 🪜",
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: isSnake ? Colors.red[800] : Colors.green[800],
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       content: RichText(
  //         textAlign: TextAlign.center,
  //         text: TextSpan(
  //           style: TextStyle(fontSize: 18, color: Colors.black87),
  //           children: [
  //             TextSpan(
  //               text: isSnake
  //                   ? "You slid down from "
  //                   : "You climbed up from ",
  //             ),
  //             TextSpan(
  //               text: "$start ",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             TextSpan(
  //               text: "to ",
  //             ),
  //             TextSpan(
  //               text: "$end!",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text(
  //             "Continue",
  //             style: TextStyle(
  //               color: isSnake ? Colors.red[800] : Colors.green[800],
  //             ),
  //           ),
  //         ),
  //       ],
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //     ),
  //   );
  // }

  // void animateMovement(List<int> movementPath, bool isUser) {
  //   int currentIndex = 0;
  //   movementTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
  //     if (currentIndex < movementPath.length - 1) {
  //       setState(() {
  //         if (isUser) {
  //           userPosition = movementPath[currentIndex];
  //         } else {
  //           computerPosition = movementPath[currentIndex];
  //         }
  //         currentIndex++;
  //       });
  //     } else {
  //       timer.cancel();
  //       checkWinner();
  //     }
  //   });
  // }
  void animateMovement(List<int> movementPath, bool isUser) {
    int currentIndex = 0;
    movementTimer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (currentIndex < movementPath.length - 1) {
        setState(() {
          if (isUser) {
            userPosition = movementPath[currentIndex];
          } else {
            computerPosition = movementPath[currentIndex];
          }
          currentIndex++;
        });
      } else {
        timer.cancel();
        // Remove the checkWinner() call from here
      }
    });
  }





  void showEndDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Game Over",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: Text(
              "Play Again",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }



  Widget buildBoard() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 100,
      reverse: true,
      itemBuilder: (context, index) {
        int tileNumber = 100 - index;

        // Determine tile color
        Color tileColor = boardColors[tileNumber % 2];

        // Highlight player positions
        if (userPosition == tileNumber) {
          tileColor = userColor.withOpacity(0.7);
        } else if (computerPosition == tileNumber) {
          tileColor = computerColor.withOpacity(0.7);
        }

        // Check if tile is a snake or ladder
        bool isSpecialTile = snakesAndLadders.containsKey(tileNumber) ||
            snakesAndLadders.values.contains(tileNumber);

        return Container(
          decoration: BoxDecoration(
            color: tileColor,
            border: Border.all(
              color: isSpecialTile
                  ? (snakesAndLadders.containsKey(tileNumber)
                  ? Colors.red
                  : Colors.green)
                  : Colors.black12,
              width: isSpecialTile ? 3 : 1,
            ),
            boxShadow: isSpecialTile
                ? [BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(1, 1)
            )]
                : [],
          ),
          child: Center(
            child: Text(
              '$tileNumber',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSpecialTile ? Colors.white : Colors.black87,
                shadows: isSpecialTile
                    ? [Shadow(
                    blurRadius: 2,
                    color: Colors.black45,
                    offset: Offset(1, 1)
                )]
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Snakes and Ladders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF5722), // Vibrant orange app bar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0B2),
              Color(0xFFFFF3E0),
            ],
          ),
        ),
        child: Column(
          children: [
            // Timer Displays
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'User Time: $userTimer',
                      style: TextStyle(
                          color: isUserTurn ? Colors.green : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Text(
                      'Computer Time: $computerTimer',
                      style: TextStyle(
                          color: !isUserTurn ? Colors.red : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildBoard(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Dice: $diceValue",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isUserTurn ? "Your Turn" : "Computer's Turn",
                    style: TextStyle(
                      fontSize: 20,
                      color: isUserTurn ? userColor : computerColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isUserTurn ? rollDice : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: userColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Roll Dice",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: !isUserTurn ? rollDice : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: computerColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Computer Roll",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ... (rest of the previous code remains the same)
}
