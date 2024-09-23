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

  List<int> player1Answers = [];
  List<int> player2Answers = [];

  final Random random = Random();

  Timer? _timer;
  int _timeLeft = 30;

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

  void _showGameOverDialog() {
    String winner;
    if (player1Score > player2Score) {
      winner = 'بازیکن ۱ برنده شد!';
    } else if (player2Score > player1Score) {
      winner = 'بازیکن ۲ برنده شد!';
    } else {
      winner = 'مساوی!';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("پایان بازی"),
        content: Text("$winner\nامتیاز بازیکن ۱: $player1Score\nامتیاز بازیکن ۲: $player2Score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: Text("دوباره بازی کن"),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
      _timeLeft = 30;
      _generateQuestions();
      _startTimer();
    });
  }

  void _generateQuestions() {
    int num1 = random.nextInt(10) + 1;
    int num2 = random.nextInt(10) + 1;
    player1Question = '$num1 × $num2';
    player1Answer = num1 * num2;
    player1Answers = _getShuffledAnswers(player1Answer);

    num1 = random.nextInt(10) + 1;
    num2 = random.nextInt(10) + 1;
    player2Question = '$num1 × $num2';
    player2Answer = num1 * num2;
    player2Answers = _getShuffledAnswers(player2Answer);
  }

  void _checkPlayer1Answer(int answer) {
    if (answer == player1Answer) {
      setState(() {
        player1Score++;
      });
    } else {
      setState(() {
        player2Score++;
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _generateQuestions();
      });
    });
  }

  void _checkPlayer2Answer(int answer) {
    if (answer == player2Answer) {
      setState(() {
        player2Score++;
      });
    } else {
      setState(() {
        player1Score++;
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _generateQuestions();
      });
    });
  }

  List<int> _getShuffledAnswers(int correctAnswer) {
    Set<int> answers = {correctAnswer};

    while (answers.length < 3) {
      int randomAnswer = random.nextInt(90) + 1;
      answers.add(randomAnswer);
    }

    List<int> answerList = answers.toList();
    answerList.shuffle();
    return answerList;
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(pi),
                  child: Column(
                    children: [
                      _buildPlayerSection(
                        playerName: "بازیکن ۱",
                        question: player1Question,
                        score: player1Score,
                        answers: player1Answers,
                        isPlayer1: true,
                      ),
                    ],
                  ),
                ),
              ),
              // Add a SizedBox for spacing
              SizedBox(height: 30), // Adjust the height as needed
              Expanded(
                child: Column(
                  children: [
                    _buildPlayerSection(
                      playerName: "بازیکن ۲",
                      question: player2Question,
                      score: player2Score,
                      answers: player2Answers,
                      isPlayer1: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "زمان باقی‌مانده: $_timeLeft",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: MediaQuery.of(context).size.height / 2 - 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildPlayerSection({
    required String playerName,
    required String question,
    required int score,
    required List<int> answers,
    required bool isPlayer1,
  }) {
    return Column(
      children: [
        Text(
          playerName,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        SizedBox(height: 10),
        Text(
          question,
          style: TextStyle(fontSize: 32, color: Colors.orangeAccent),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: answers
              .map((answer) => _buildAnswerButton(answer, isPlayer1: isPlayer1))
              .toList(),
        ),
        SizedBox(height: 10),
        Text(
          "امتیاز: $score",
          style: TextStyle(fontSize: 24, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildAnswerButton(int value, {required bool isPlayer1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          if (isPlayer1) {
            _checkPlayer1Answer(value);
          } else {
            _checkPlayer2Answer(value);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: TextStyle(fontSize: 22),
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
        ),
        child: Text(value.toString()),
      ),
    );
  }
}
