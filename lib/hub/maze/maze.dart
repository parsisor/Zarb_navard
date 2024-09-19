import 'package:flutter/material.dart';


class MazeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MazeScreen(),
    );
  }
}

class MazeScreen extends StatefulWidget {
  @override
  _MazeScreenState createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  // 0 = path, 1 = wall
  final List<List<int>> maze = [
    [1, 1, 1, 1, 1, 1, 1],
    [1, 0, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 1],
    [1, 1, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 1],
    [1, 1, 1, 1, 1, 1, 1],
  ];

  // Player's current position
  int playerX = 1;
  int playerY = 1;

  // Exit position
  int exitX = 5;
  int exitY = 5;

  // Check if player reached the exit
  bool get hasWon => playerX == exitX && playerY == exitY;

  // Move player if possible
  void movePlayer(int dx, int dy) {
    int newX = playerX + dx;
    int newY = playerY + dy;

    // Check if the new position is a path (0)
    if (maze[newY][newX] == 0) {
      setState(() {
        playerX = newX;
        playerY = newY;
      });

      if (hasWon) {
        showWinDialog();
      }
    }
  }

  // Show a dialog when the player wins
  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You reached the exit!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maze Game"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < -10) {
            movePlayer(0, -1); // Move up
          } else if (details.delta.dy > 10) {
            movePlayer(0, 1); // Move down
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < -10) {
            movePlayer(-1, 0); // Move left
          } else if (details.delta.dx > 10) {
            movePlayer(1, 0); // Move right
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int y = 0; y < maze.length; y++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int x = 0; x < maze[y].length; x++)
                    buildMazeCell(x, y),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Build each cell of the maze
  Widget buildMazeCell(int x, int y) {
    Color color;

    if (x == playerX && y == playerY) {
      color = Colors.blue; // Player position
    } else if (x == exitX && y == exitY) {
      color = Colors.green; // Exit position
    } else {
      color = maze[y][x] == 1 ? Colors.black : Colors.white; // Wall or Path
    }

    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(2),
      color: color,
    );
  }
}
