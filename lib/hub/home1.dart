import 'package:animations/animations.dart'; 
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:zarb_navard_game/hub/Settings/settings.dart';
import 'package:zarb_navard_game/hub/leader_board/leaderboard.dart';
import 'package:zarb_navard_game/hub/maze/maze.dart';
import 'package:zarb_navard_game/hub/reghabat/reghabat.dart';
import 'package:zarb_navard_game/platformer_game/game.dart';
import 'package:zarb_navard_game/platformer_game/overlay.dart';
import 'package:zarb_navard_game/puzzels/home.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600; 
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/Home_page_assets/logo.png', height: 50),
        leading: IconButton(
          icon: const Icon(Icons.emoji_events, size: 30),
          onPressed: () => navigateToPage(context, LeaderBoardScreen(), AxisDirection.left), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    darkModeEnabled: AdaptiveTheme.of(context).brightness == Brightness.dark,
                    onThemeToggle: (bool isDarkMode) {
                      if (isDarkMode) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isTablet ? 80 : 60), 
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: isTablet ? 30 : 26,
                  fontFamily: 'IranSans',
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
                duration: const Duration(milliseconds: 500),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'با ', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                      const TextSpan(text: 'بازی ', style: TextStyle(color: Colors.green)),
                      TextSpan(text: 'کردن \n', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                      const TextSpan(text: 'درس ', style: TextStyle(color: Colors.red)),
                      TextSpan(text: 'بخون', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isTablet ? 40 : 32),

              // Existing Game Cards
              buildOptionCard(
                'رقابت با دوستان',
                'assets/Home_page_assets/Box_gloves.png',
                context,
                isTablet: isTablet,
                isFeatured: true, 
              ),
              SizedBox(height: isTablet ? 20 : 16),
              buildOptionCard(
                'ماجراجویی در ماز',
                'assets/Home_page_assets/Maze_Icon.png',
                context,
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 20 : 16),
              buildOptionCard(
                'ضرب نورد',
                'assets/Home_page_assets/platformer_icon.png',
                context,
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 20 : 32),

              // Puzzle Vitrin Section
              Text(
                'پازل‌ها',
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 16),
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Expanded(child: buildPuzzleCard('پازل 1', 'assets/Home_page_assets/puzzle.png', context, isTablet)),
    Expanded(child: buildPuzzleCard('پازل 2', 'assets/Home_page_assets/puzzle.png', context, isTablet)),
    Expanded(child: buildPuzzleCard('پازل 3', 'assets/Home_page_assets/puzzle.png', context, isTablet)),
  ],
),

              SizedBox(height: isTablet ? 20 : 16),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, Widget page, AxisDirection direction) {
    if (page is MathRaceScreen) {
      Navigator.of(context).push(_createPushUpRoute(page)); 
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700), 
          pageBuilder: (context, animation, secondaryAnimation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: getBeginOffset(direction), 
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: page,
            );
          },
        ),
      );
    }
  }

  PageRouteBuilder _createPushUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical, 
          child: child,
        );
      },
    );
  }

  Widget buildOptionCard(String title, String iconPath, BuildContext context,
      {required bool isTablet, bool isFeatured = false}) {
    return GestureDetector(
      onTap: () {
        if (title == 'رقابت با دوستان') {
          navigateToPage(context, MathRaceScreen(), AxisDirection.up); 
        } else if (title == 'ماجراجویی در ماز') {
          navigateToPage(context, const MazeGame(rows: 10, cols: 10), AxisDirection.right); 
        } else if (title == 'ضرب نورد') {
          navigateToPage(
            context,
            GameWidget(
              game: ZarbGame(),
              overlayBuilderMap: {
                'MultiplicationOverlay': (context, game) => MultiplicationOverlay(game: game as ZarbGame),
                'LossOverlay': (context, game) => LossOverlay(game: game as ZarbGame),
              },
            ),
            AxisDirection.right,
          );
        }
      },
      child: buildCardFront(title, iconPath, isTablet, isFeatured),
    );
  }

  Widget buildPuzzleCard(String title, String iconPath, BuildContext context, bool isTablet) {
    return GestureDetector(
      onTap: () {
        // Navigate to your puzzle game screen
        navigateToPage(context, bistchehelohasht(), AxisDirection.right); 
      },
      child: buildCardFront(title, iconPath, isTablet, false), // Change to true for featured if needed
    );
  }

  Offset getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.right:
        return const Offset(-1.0, 0.0);
      case AxisDirection.left:
        return const Offset(1.0, 0.0);
      case AxisDirection.up:
        return const Offset(0.0, 1.0);
      case AxisDirection.down:
        return const Offset(0.0, -1.0);
      default:
        return Offset.zero;
    }
  }

  Widget buildCardFront(String title, String iconPath, bool isTablet, bool isFeatured) {
    double cardHeight = isTablet ? (isFeatured ? 320 : 140) : (isFeatured ? 230 : 90);
    double iconSize = isTablet ? (isFeatured ? 100 : 80) : (isFeatured ? 70 : 50);
    double textSize = isTablet ? (isFeatured ? 26 : 22) : (isFeatured ? 20 : 16);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: cardHeight,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 4.0,
                offset: const Offset(0, 6), 
              ),
            ],
          ),
        ),
        Container(
          height: cardHeight - 20, 
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFFD2D2D2), 
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: iconSize, height: iconSize),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
