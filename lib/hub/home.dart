// import 'package:flutter/material.dart';
// import 'package:animations/animations.dart'; // For smooth page transitions
// import 'package:flip_card/flip_card.dart';
// import 'package:zarb_navard_game/Platformer/game.dart';
// import 'package:zarb_navard_game/hub/Settings/settings.dart';
// import 'package:zarb_navard_game/hub/leader_board/leaderboard.dart';
// import 'package:zarb_navard_game/hub/maze/maze.dart';
// import 'package:zarb_navard_game/hub/reghabat/reghabat.dart';  // For flipping card animations


// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.of(context).size.width > 600; // Detect tablet

//     return Scaffold(
//       extendBodyBehindAppBar: true, // Makes the app bar transparent and stick to the top
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Image.asset('assets/Home_page_assets/logo.png', height: 50),
//         leading: IconButton(
//           icon: Icon(Icons.emoji_events, color: Colors.black, size: 30),
//           onPressed: () => navigateToPage(context, LeaderBoardScreen(), AxisDirection.left), // Slide from the left
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings, color: Colors.black, size: 30),
//             onPressed: () => navigateToPage(context, SettingsPage(), AxisDirection.right), // Slide from the right
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: isTablet ? 80 : 60), // Adjust spacing for app bar
//               AnimatedDefaultTextStyle(
//                 style: TextStyle(
//                   fontSize: isTablet ? 30 : 26,
//                   fontFamily: 'IranSans',
//                   fontWeight: FontWeight.w900,
//                   color: Colors.black,
//                 ),
//                 duration: Duration(milliseconds: 500),
//                 child: Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(text: 'با ', style: TextStyle(color: Colors.black)),
//                       TextSpan(text: 'بازی ', style: TextStyle(color: Colors.green)),
//                       TextSpan(text: 'کردن \n', style: TextStyle(color: Colors.black)),
//                       TextSpan(text: 'درس ', style: TextStyle(color: Colors.red)),
//                       TextSpan(text: 'بخون', style: TextStyle(color: Colors.black)),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: isTablet ? 40 : 32),

//               // Option cards with flipping animation
//               buildOptionCard(
//                 'رقابت با دوستان',
//                 'assets/Home_page_assets/Box_gloves.png',
//                 context,
//                 bigger: true,
//                 isTablet: isTablet,
//                 smallerBack: false, // Full height back for this card
//                 smallerFront: false,
//               ),
//               SizedBox(height: isTablet ? 20 : 16),
//               buildOptionCard(
//                 'ماجراجویی در ماز',
//                 'assets/Home_page_assets/Maze_Icon.png',
//                 context,
//                 isTablet: isTablet,
//                 smallerBack: true, // Smaller height back for maze
//                 smallerFront: true, // Smaller height front for maze
//               ),
//               SizedBox(height: isTablet ? 20 : 16),
//               buildOptionCard(
//                 'ضرب نورد',
//                 'assets/Home_page_assets/platformer_icon.png',
//                 context,
//                 isTablet: isTablet,
//                 smallerBack: true, // Smaller height back for platformer
//                 smallerFront: true, // Smaller height front for platformer
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Function for handling card clicks (navigate to a new page based on the title)
//   void navigateToPage(BuildContext context, Widget page, AxisDirection direction) {
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         transitionDuration: Duration(milliseconds: 700), // Smoother transition
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: getBeginOffset(direction), // Use custom slide direction
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOut,
//             )),
//             child: page,
//           );
//         },
//       ),
//     );
//   }

//   // Option card widget with flipping animation
//   Widget buildOptionCard(String title, String iconPath, BuildContext context,
//       {bool bigger = false, required bool isTablet, bool smallerBack = false, bool smallerFront = false}) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the correct page based on the title of the card
//         if (title == 'رقابت با دوستان') {
//           navigateToPage(context, MathRaceGame(), AxisDirection.right); // Navigate to Regabat
//         } else if (title == 'ماجراجویی در ماز') {
//           navigateToPage(context, MazeGame(), AxisDirection.right); // Navigate to Maze Adventure
//         } else if (title == 'ضرب نورد') {
//           navigateToPage(context, ZarbGame() as Widget, AxisDirection.right); // Navigate to Zarb Navard
//         }
//       },
//       child: FlipCard(
//         direction: FlipDirection.HORIZONTAL, // Horizontal flip
//         front: buildCardFront(title, iconPath, bigger, isTablet, smallerFront),
//         back: buildCardBack(title, isTablet, smallerBack), // Flips to show extra information
//       ),
//     );
//   }

//   // Front side of the card
//   Widget buildCardFront(String title, String iconPath, bool bigger, bool isTablet, bool smallerFront) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: isTablet
//               ? (smallerFront ? 180 : (bigger ? 280 : 140)) // Adjust height based on `smallerFront`
//               : (smallerFront ? 140 : (bigger ? 230 : 90)),
//           margin: EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 spreadRadius: 4,
//                 blurRadius: 10,
//                 offset: Offset(0, 6),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           height: isTablet
//               ? (smallerFront ? 150 : (bigger ? 250 : 130))
//               : (smallerFront ? 120 : (bigger ? 200 : 80)),
//           padding: EdgeInsets.all(isTablet ? 20 : 16),
//           decoration: BoxDecoration(
//             color: Color(0xFFD2D2D2),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: isTablet ? (bigger ? 30 : 24) : (bigger ? 26 : 20),
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Image.asset(iconPath,
//                   width: isTablet ? (bigger ? 150 : 100) : (bigger ? 120 : 80),
//                   height: isTablet ? (bigger ? 150 : 100) : (bigger ? 120 : 80)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Back side of the card (revealed on flip)
//   Widget buildCardBack(String title, bool isTablet, bool smallerBack) {
//     return Container(
//       height: isTablet
//           ? (smallerBack ? 180 : 250) // Set smaller height if `smallerBack` is true
//           : (smallerBack ? 140 : 200), // Set smaller height for mobile
//       margin: EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.orangeAccent,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             spreadRadius: 4,
//             blurRadius: 10,
//             offset: Offset(0, 6),
//           ),
//         ],
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         'More about $title',
//         style: TextStyle(
//           fontSize: isTablet ? 24 : 18,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Offset getBeginOffset(AxisDirection direction) {
//     switch (direction) {
//       case AxisDirection.up:
//         return Offset(0, 1);
//       case AxisDirection.down:
//         return Offset(0, -1);
//       case AxisDirection.left:
//         return Offset(1, 0);
//       case AxisDirection.right:
//         return Offset(-1, 0);
//     }
//   }
// }
