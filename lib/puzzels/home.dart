import 'package:flutter/material.dart';
import 'mycolor.dart';
import 'tile.dart';
import 'grid.dart';
import 'game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class bistchehelohasht extends StatefulWidget {
  const bistchehelohasht({super.key});

  @override
  State<StatefulWidget> createState() {
    return _bistchehelohashtState();
  }
}

class _bistchehelohashtState extends State<bistchehelohasht> {
  List<List<int>> grid = [];
  List<List<int>> gridNew = [];
  late SharedPreferences sharedPreferences;
  int score = 0;
  bool isGameOver = false;
  bool isGameWon = false;

  List<Widget> getGrid(double width, double height) {
    List<Widget> grids = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        int num = grid[i][j];
        String number;
        int color;

        if (num == 0) {
          color = MyColor.emptyGridBackground;
          number = "";
        } else {
          color = MyColor.getGridColor(num);
          number = "$num";
        }

        double size;
        switch (number.length) {
          case 1:
          case 2:
            size = 40.0;
            break;
          case 3:
            size = 30.0;
            break;
          case 4:
            size = 20.0;
            break;
          default:
            size = 10.0;
        }

        grids.add(Tile(number, width, height, color, size));
      }
    }
    return grids;
  }

  void handleGesture(int direction) {
    bool flipped = false;
    bool played = true;
    bool rotated = false;

    if (direction == 0) {
      setState(() {
        grid = transposeGrid(grid);
        grid = flipGrid(grid);
        rotated = true;
        flipped = true;
      });
    } else if (direction == 1) {
      setState(() {
        grid = transposeGrid(grid);
        rotated = true;
      });
    } else if (direction == 2) {
      // Left: Do nothing for now
    } else if (direction == 3) {
      setState(() {
        grid = flipGrid(grid);
        flipped = true;
      });
    } else {
      played = false;
    }

    if (played) {
      List<List<int>> past = copyGrid(grid);
      for (int i = 0; i < 4; i++) {
        List result = operate(grid[i], score, sharedPreferences);
        score = result[0];
        grid[i] = result[1];
      }

      bool changed = compare(past, grid);
      if (flipped) {
        setState(() {
          grid = flipGrid(grid);
        });
      }

      if (rotated) {
        setState(() {
          grid = transposeGrid(grid);
        });
      }

      if (changed) {
        setState(() {
          grid = addNumber(grid, gridNew);
        });
      }

      bool gameOver = isGameOver;
      if (gameOver) {
        setState(() {
          isGameOver = true;
        });
      }

      bool gameWon = isGameWon;
      if (gameWon) {
        setState(() {
          isGameWon = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    grid = blankGrid();
    gridNew = blankGrid();
    addNumber(grid, gridNew);
    addNumber(grid, gridNew);
  }

  Future<String> getHighScore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int? score = sharedPreferences.getInt('high_score');
    return score?.toString() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 80) / 4;
    double gridHeight = gridWidth;
    double height = 30 + (gridHeight * 4) + 10;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '۲۰۴۸',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(MyColor.gridBackground),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(MyColor.gridBackground),
                  ),
                  height: 82.0,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                        child: Text(
                          'امتیاز',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '$score',
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: height,
                color: Color(MyColor.gridBackground),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: GridView.count(
                          primary: false,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 4,
                          children: getGrid(gridWidth, gridHeight),
                        ),
                        onVerticalDragEnd: (DragEndDetails details) {
                          if (details.primaryVelocity!.isNegative) {
                            handleGesture(0); // Up
                          } else {
                            handleGesture(1); // Down
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity!.isNegative) {
                            handleGesture(2); // Left
                          } else {
                            handleGesture(3); // Right
                          }
                        },
                      ),
                    ),
                    if (isGameOver)
                      Container(
                        height: height,
                        color: Color(MyColor.transparentWhite),
                        child: Center(
                          child: Text(
                            'بازی به پایان رسید!',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color(MyColor.gridBackground)),
                          ),
                        ),
                      ),
                    if (isGameWon)
                      Container(
                        height: height,
                        color: Color(MyColor.transparentWhite),
                        child: Center(
                          child: Text(
                            'شما برنده شدید!',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Color(MyColor.gridBackground)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(MyColor.gridBackground),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          iconSize: 35.0,
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              grid = blankGrid();
                              gridNew = blankGrid();
                              addNumber(grid, gridNew);
                              addNumber(grid, gridNew);
                              score = 0;
                              isGameOver = false;
                              isGameWon = false;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(MyColor.gridBackground),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'بیشترین امتیاز',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder<String>(
                              future: getHighScore(),
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show a loading indicator
                                } else if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data ?? '۰',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return const Text(
                                    '۰',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
