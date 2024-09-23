// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:zarb_navard_game/hub/home1.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _rotationController;
//   late AnimationController _shakeController;

//   @override
//   void initState() {
//     super.initState();

    
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(); 

    
//     _rotationController = AnimationController(
//       duration: const Duration(seconds: 7), 
//       vsync: this,
//     )..repeat(); 

    
//     _shakeController = AnimationController(
//       duration: const Duration(milliseconds: 500), 
//       vsync: this,
//     )..repeat(reverse: true); 

    
//     Future.delayed(Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         _customPageRoute(HomeScreen()), 
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _rotationController.dispose();
//     _shakeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
          
//           Center(
//             child: Image.asset(
//               'assets/splash_screen_assets/logo.png',
//               width: screenSize.width * 0.5, 
//               height: screenSize.width * 0.5, 
//             ),
//           ),
          
//           Align(
//             alignment: Alignment(0.0, 0.85), 
//             child: SizedBox(
//               height: 80, 
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: AnimatedBuilder(
//                   animation: _animationController,
//                   builder: (context, child) {
//                     return Transform.translate(
//                       offset: Offset(_animationController.value * -screenSize.width, 0), 
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min, 
//                         children: [
//                           _buildImageRow(),
//                           _buildImageRow(),
//                           _buildImageRow(),
//                           _buildImageRow(), 
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  
//   Widget _buildImageRow() {
//     return Row(
//       children: [
//         _buildShakingImage('assets/splash_screen_assets/divide.png'),
//         SizedBox(width: 20), 
//         _buildShakingImage('assets/splash_screen_assets/plus.png'),
//         SizedBox(width: 20), 
//         _buildShakingImage('assets/splash_screen_assets/minus.png'),
//         SizedBox(width: 20), 
//         _buildShakingImage('assets/splash_screen_assets/multieply.png'),
//         SizedBox(width: 20), 
//       ],
//     );
//   }

  
//   Widget _buildShakingImage(String assetPath) {
//     return AnimatedBuilder(
//       animation: _shakeController,
//       builder: (context, child) {
        
//         final offset = (_shakeController.value - 0.5) * 10; 
//         return Transform(
//           transform: Matrix4.identity()..rotateZ(offset * 0.0175), 
//           alignment: Alignment.center,
//           child: RotationTransition(
//             turns: _rotationController,
//             child: Image.asset(
//               assetPath,
//               width: 50, 
//               height: 50, 
//             ),
//           ),
//         );
//       },
//     );
//   }

  
//   PageRouteBuilder _customPageRoute(Widget page) {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(0.0, 1.0); 
//         const end = Offset(0.0, 0.0); 
//         const curve = Curves.easeInOut; 

//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         var offsetAnimation = animation.drive(tween);

//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//       transitionDuration: Duration(milliseconds: 750), 
//     );
//   }
// }

