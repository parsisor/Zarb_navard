import 'package:animations/animations.dart'; // Import the animations package
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:zarb_navard_game/hub/Settings/settings.dart';
import 'package:zarb_navard_game/hub/leader_board/leaderboard.dart';
import 'package:zarb_navard_game/hub/maze/maze.dart';
import 'package:zarb_navard_game/hub/reghabat/reghabat.dart';
import 'package:zarb_navard_game/platformer_game/game.dart';

import 'package:zarb_navard_game/platformer_game/overlay.dart'; // Import the overlay code

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600; // Detect tablet
    final theme = Theme.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Makes the app bar transparent and stick to the top
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/Home_page_assets/logo.png', height: 50),
        leading: IconButton(
          icon: Icon(Icons.emoji_events, size: 30),
          onPressed: () => navigateToPage(context, LeaderBoardScreen(), AxisDirection.left), // Slide from the left
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            onPressed: () {
              // Pass the current theme state to SettingsPage
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
              SizedBox(height: isTablet ? 80 : 60), // Adjust spacing for app bar
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontSize: isTablet ? 30 : 26,
                  fontFamily: 'IranSans',
                  fontWeight: FontWeight.w900,
                  color: theme.textTheme.bodyLarge!.color!,
                ),
                duration: Duration(milliseconds: 500),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'با ', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                      TextSpan(text: 'بازی ', style: TextStyle(color: Colors.green)),
                      TextSpan(text: 'کردن \n', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                      TextSpan(text: 'درس ', style: TextStyle(color: Colors.red)),
                      TextSpan(text: 'بخون', style: TextStyle(color: theme.textTheme.bodyLarge!.color!)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isTablet ? 40 : 32),

              // Option cards
              buildOptionCard(
                'رقابت با دوستان',
                'assets/Home_page_assets/Box_gloves.png',
                context,
                isTablet: isTablet,
                isFeatured: true, // Mark this card as featured for bigger size
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
            ],
          ),
        ),
      ),
    );
  }

  // Function for handling card clicks (navigate to a new page based on the title)
  void navigateToPage(BuildContext context, Widget page, AxisDirection direction) {
    if (page is MathRaceScreen) {
      Navigator.of(context).push(_createPushUpRoute(page)); // Use the custom push-up animation
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 700), // Smoother transition
          pageBuilder: (context, animation, secondaryAnimation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: getBeginOffset(direction), // Use custom slide direction
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

  // Custom route for push-up animation using SharedAxisTransition
  PageRouteBuilder _createPushUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical, // Push up effect
          child: child,
        );
      },
    );
  }

  // Option card widget with conditional size adjustments
  Widget buildOptionCard(String title, String iconPath, BuildContext context,
      {required bool isTablet, bool isFeatured = false}) {
    return GestureDetector(
      onTap: () {
        if (title == 'رقابت با دوستان') {
          // Navigate to Math Race with push-up animation
          navigateToPage(context, MathRaceScreen(), AxisDirection.up); 
        } else if (title == 'ماجراجویی در ماز') {
          navigateToPage(context, MazeGame(), AxisDirection.right); // Navigate to Maze Adventure
        } else if (title == 'ضرب نورد') {
          navigateToPage(
            context,
          GameWidget(game: ZarbGame() , overlayBuilderMap: {
          'MultiplicationOverlay': (context, game) => MultiplicationOverlay(game: game as ZarbGame),
          'LossOverlay': (context, game) => LossOverlay(game: game as ZarbGame), // Add the LossOverlay
        },), // Wrap ZarbGame in GameWidget
            
            AxisDirection.right,
          ); // Navigate to Zarb Navard
        }
      },
      child: buildCardFront(title, iconPath, isTablet, isFeatured),
    );
  }

  // Get the beginning offset for slide transition
  Offset getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.right:
        return Offset(-1.0, 0.0);
      case AxisDirection.left:
        return Offset(1.0, 0.0);
      case AxisDirection.up:
        return Offset(0.0, 1.0);
      case AxisDirection.down:
        return Offset(0.0, -1.0);
      default:
        return Offset.zero;
    }
  }

  Widget buildCardFront(String title, String iconPath, bool isTablet, bool isFeatured) {
    // Sizes based on whether the card is featured or not
    double cardHeight = isTablet
        ? (isFeatured ? 320 : 140)
        : (isFeatured ? 230 : 90);
    double iconSize = isTablet
        ? (isFeatured ? 100 : 80)
        : (isFeatured ? 70 : 50);
    double textSize = isTablet
        ? (isFeatured ? 26 : 22)
        : (isFeatured ? 20 : 16);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Card background with shadow
        Container(
          height: cardHeight,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the card
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 4.0,
                offset: Offset(0, 6), // Shadow position
              ),
            ],
          ),
        ),
        // Card content
        Container(
          height: cardHeight - 20, // Slightly smaller height for inner content
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            color: Color(0xFFD2D2D2), // Background color for inner content
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
              ),
              SizedBox(width: 10), // Spacing between icon and text
              // Title text
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
