import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:adaptive_theme/adaptive_theme.dart'; // Import adaptive_theme package

class MazeGame extends StatefulWidget {
  final int rows, cols;

  const MazeGame({super.key, required this.rows, required this.cols});

  @override
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  late MazeGenerator _mazeGenerator;
  late int _playerRow, _playerCol;
  late int _exitRow, _exitCol;

  @override
  void initState() {
    super.initState();
    _mazeGenerator = MazeGenerator(rows: widget.rows, cols: widget.cols);
    _playerRow = 0;
    _playerCol = 0;
    _exitRow = widget.rows - 1;
    _exitCol = widget.cols - 1;
  }

  void _movePlayer(Direction direction) {
  setState(() {
    Cell currentCell = _mazeGenerator.maze[_playerRow][_playerCol];

    if (direction == Direction.up && _playerRow > 0 && !currentCell.topWall) {
      _playerRow -= 1;
    } else if (direction == Direction.down && _playerRow < widget.rows - 1 && !currentCell.bottomWall) {
      _playerRow += 1;
    } else if (direction == Direction.left && _playerCol > 0 && !currentCell.leftWall) {
      _playerCol -= 1;
    } else if (direction == Direction.right && _playerCol < widget.cols - 1 && !currentCell.rightWall) {
      _playerCol += 1;
    }
    // Check for a win after each move
    _checkForWin();
  });
}


  void _checkForWin() {
    if (_playerRow == _exitRow && _playerCol == _exitCol) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('!!تبریک!!'),
            content: const Text('!شما از هزارتو خارج شدید'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => MazeGame(rows: widget.rows + 5, cols: widget.cols + 5)),
                  );
                },
                child: const Text('مرحله بعد'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
Widget build(BuildContext context) {
  double mazeAspectRatio = widget.cols / widget.rows;
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  double cellSize = min(
    screenWidth / widget.cols,
    (screenHeight - kToolbarHeight) / widget.rows
  );

  return Scaffold(
    appBar: AppBar(
      title: const Text('بازی ماز'),
      centerTitle: true,
    ),
    body: SwipeDetector(
      onSwipeUp: (Offset offset) => _movePlayer(Direction.up),
      onSwipeDown: (Offset offset) => _movePlayer(Direction.down),
      onSwipeLeft: (Offset offset) => _movePlayer(Direction.left),
      onSwipeRight: (Offset offset) => _movePlayer(Direction.right),
      child: Center(
        child: AspectRatio(
          aspectRatio: mazeAspectRatio,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: widget.cols * cellSize,
              height: widget.rows * cellSize,
              child: Stack(
                children: [
                  _buildMazeGrid(cellSize),
                  _buildPlayer(cellSize),
                  _buildExit(cellSize),  // Add the exit here
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildExit(double cellSize) {
  return Positioned(
    left: _exitCol * cellSize,
    top: _exitRow * cellSize,
    child: Container(
      width: cellSize * 0.8,
      height: cellSize * 0.8,
      decoration: BoxDecoration(
        color: Colors.green,  // Make the exit stand out
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


  Widget _buildMazeGrid(double cellSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _mazeGenerator.maze.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((cell) {
            return CustomPaint(
              size: Size(cellSize, cellSize),
              painter: CellPainter(cell),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

    Widget _buildPlayer(double cellSize) {
  return Positioned(
    left: _playerCol * cellSize,  // Player's horizontal position
    top: _playerRow * cellSize,   // Player's vertical position
    child: Container(
      width: cellSize * 0.8,  // Set the player's size
      height: cellSize * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

}

enum Direction { up, down, left, right }

class MazeGenerator {
  final int rows;
  final int cols;
  late List<List<Cell>> maze;

  MazeGenerator({required this.rows, required this.cols}) {
    maze = List.generate(rows, (r) => List.generate(cols, (c) => Cell(r, c)));
    _generateMaze();
  }

  void _generateMaze() {
    Cell start = maze[0][0];
    _carvePassages(start);
  }

  void _carvePassages(Cell current) {
    current.visited = true;
    List<Cell> neighbors = current.getUnvisitedNeighbors(maze);

    while (neighbors.isNotEmpty) {
      Cell next = neighbors[Random().nextInt(neighbors.length)];
      current.removeWall(next);
      next.visited = true;
      _carvePassages(next);
      neighbors = current.getUnvisitedNeighbors(maze);
    }
  }

  List<List<Cell>> getMaze() => maze;
}

class Cell {
  int row, col;
  bool visited = false;
  bool topWall = true, rightWall = true, bottomWall = true, leftWall = true;

  Cell(this.row, this.col);

  List<Cell> getUnvisitedNeighbors(List<List<Cell>> maze) {
    List<Cell> neighbors = [];
    if (row > 0 && !maze[row - 1][col].visited) neighbors.add(maze[row - 1][col]);
    if (row < maze.length - 1 && !maze[row + 1][col].visited) neighbors.add(maze[row + 1][col]);
    if (col > 0 && !maze[row][col - 1].visited) neighbors.add(maze[row][col - 1]);
    if (col < maze[0].length - 1 && !maze[row][col + 1].visited) neighbors.add(maze[row][col + 1]);
    return neighbors;
  }

  void removeWall(Cell neighbor) {
    if (row == neighbor.row) {
      if (col < neighbor.col) {
        rightWall = false;
        neighbor.leftWall = false;
      } else {
        leftWall = false;
        neighbor.rightWall = false;
      }
    } else if (col == neighbor.col) {
      if (row < neighbor.row) {
        bottomWall = false;
        neighbor.topWall = false;
      } else {
        topWall = false;
        neighbor.bottomWall = false;
      }
    }
  }
}

class CellPainter extends CustomPainter {
  final Cell cell;

  CellPainter(this.cell);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    if (cell.topWall) {
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
    }
    if (cell.rightWall) {
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
    if (cell.bottomWall) {
      canvas.drawLine(Offset(size.width, size.height), Offset(0, size.height), paint);
    }
    if (cell.leftWall) {
      canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
