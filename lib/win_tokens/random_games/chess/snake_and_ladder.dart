import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';



class DiceGameScreen extends StatefulWidget {
  const DiceGameScreen({super.key});

  @override
  State<DiceGameScreen> createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen> {
  int playerScore = 0;
  int computerScore = 0;
  int currentDice = 1;
  bool isPlayerTurn = true;
  String gameStatus = '';
  Timer? autoRollTimer;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startAutoRollTimer();
  }

  @override
  void dispose() {
    autoRollTimer?.cancel();
    super.dispose();
  }

  void startAutoRollTimer() {
    autoRollTimer?.cancel();
    autoRollTimer = Timer(const Duration(seconds: 8), () {
      if (!gameOver) {
        if (isPlayerTurn) {
          playerRoll();
        } else {
          computerRoll();
        }
      }
    });
  }

  void playerRoll() {
    if (gameOver) return;

    setState(() {
      currentDice = Random().nextInt(6) + 1;
      playerScore += currentDice;
      isPlayerTurn = false;

      if (playerScore >= 100) {
        gameStatus = 'Congratulations! You Won! 🎉';
        gameOver = true;
        autoRollTimer?.cancel();
      } else {
        gameStatus = 'Computer\'s turn';
        startAutoRollTimer();
        // Add delay before computer's turn
        Timer(const Duration(seconds: 1), () {
          if (!gameOver) computerRoll();
        });
      }
    });
  }

  void computerRoll() {
    if (gameOver) return;

    setState(() {
      currentDice = Random().nextInt(6) + 1;
      computerScore += currentDice;
      isPlayerTurn = true;

      if (computerScore >= 100) {
        gameStatus = 'Game Over! Computer Won! 😅';
        gameOver = true;
        autoRollTimer?.cancel();
      } else {
        gameStatus = 'Your turn';
        startAutoRollTimer();
      }
    });
  }

  void resetGame() {
    setState(() {
      playerScore = 0;
      computerScore = 0;
      currentDice = 1;
      isPlayerTurn = true;
      gameStatus = 'Your turn';
      gameOver = false;
      startAutoRollTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Race to 100'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Score Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScoreCard(
                  title: 'Player',
                  score: playerScore,
                  isActive: isPlayerTurn && !gameOver,
                ),
                ScoreCard(
                  title: 'Computer',
                  score: computerScore,
                  isActive: !isPlayerTurn && !gameOver,
                ),
              ],
            ),

            // Dice Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$currentDice',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),

            // Game Status
            Text(
              gameStatus,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Progress Bars
            Column(
              children: [
                ProgressBar(
                  label: 'Player',
                  progress: playerScore / 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                ProgressBar(
                  label: 'Computer',
                  progress: computerScore / 100,
                  color: Colors.red,
                ),
              ],
            ),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isPlayerTurn && !gameOver ? playerRoll : null,
                  child: const Text('Roll Dice'),
                ),
                ElevatedButton(
                  onPressed: resetGame,
                  child: const Text('Reset Game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final String title;
  final int score;
  final bool isActive;

  const ScoreCard({
    super.key,
    required this.title,
    required this.score,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;

  const ProgressBar({
    super.key,
    required this.label,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey.shade200,
            minHeight: 20,
          ),
        ),
      ],
    );
  }
}