

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MathRaceScreen extends StatefulWidget {
  @override
  _MathRaceScreenState createState() => _MathRaceScreenState();
}

class _MathRaceScreenState extends State<MathRaceScreen> {
  int player1Score = 0;
  int player2Score = 0;

  String player1Question = '';
  String player2Question = '';

  int player1Answer = 0;
  int player2Answer = 0;

  final Random random = Random();

  // Timer for game countdown
  Timer? _timer;
  int _timeLeft = 30; // Game duration in seconds

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start the game timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _showGameOverDialog();
        }
      });
    });
  }

  // Show game over dialog
  void _showGameOverDialog() {
    String winner;
    if (player1Score > player2Score) {
      winner = 'Player 1 Wins!';
    } else if (player2Score > player1Score) {
      winner = 'Player 2 Wins!';
    } else {
      winner = 'It\'s a Tie!';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("$winner\nPlayer 1: $player1Score\nPlayer 2: $player2Score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  // Restart the game
  void _restartGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
      _timeLeft = 30;
      _generateQuestions();
      _startTimer();
    });
  }

  // Generate random math questions for both players
  void _generateQuestions() {
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    player1Question = '$num1 + $num2';
    player1Answer = num1 + num2;

    num1 = random.nextInt(10) + 1;
    num2 = random.nextInt(10) + 1;
    player2Question = '$num1 + $num2';
    player2Answer = num1 + num2;
  }

  // Check Player 1's answer
  void _checkPlayer1Answer(int answer) {
    if (answer == player1Answer) {
      setState(() {
        player1Score++;
        _generateQuestions(); // Generate new questions after correct answer
      });
    }
  }

  // Check Player 2's answer
  void _checkPlayer2Answer(int answer) {
    if (answer == player2Answer) {
      setState(() {
        player2Score++;
        _generateQuestions(); // Generate new questions after correct answer
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Math Race Game"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  "Player 1",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  player1Question,
                  style: TextStyle(fontSize: 32),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = player1Answer - 1; i <= player1Answer + 1; i++)
                      _buildPlayerButton(i, isPlayer1: true),
                  ],
                ),
                Text(
                  "Score: $player1Score",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Player 2",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  player2Question,
                  style: TextStyle(fontSize: 32),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = player2Answer - 1; i <= player2Answer + 1; i++)
                      _buildPlayerButton(i, isPlayer1: false),
                  ],
                ),
                Text(
                  "Score: $player2Score",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Time Left: $_timeLeft",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Build answer buttons for each player
  Widget _buildPlayerButton(int value, {required bool isPlayer1}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (isPlayer1) {
            _checkPlayer1Answer(value);
          } else {
            _checkPlayer2Answer(value);
          }
        },
        child: Text(
          value.toString(),
          style: TextStyle(fontSize: 24),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
