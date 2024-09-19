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

//     // کنترل انیمیشن جابجایی بی‌نهایت
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(); // انیمیشن بی‌نهایت

//     // کنترل انیمیشن چرخش بی‌نهایت با سرعت کمتر
//     _rotationController = AnimationController(
//       duration: const Duration(seconds: 7), // کندتر کردن چرخش
//       vsync: this,
//     )..repeat(); // تکرار چرخش

//     // کنترل انیمیشن لرزش
//     _shakeController = AnimationController(
//       duration: const Duration(milliseconds: 500), // مدت زمان لرزش
//       vsync: this,
//     )..repeat(reverse: true); // تکرار لرزش با رفت و برگشت

//     // شبیه‌سازی تاخیر لود شدن اپلیکیشن
//     Future.delayed(Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         _customPageRoute(HomeScreen()), // استفاده از انیمیشن سفارشی
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
//     // دریافت ابعاد صفحه
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // لوگو در وسط صفحه
//           Center(
//             child: Image.asset(
//               'assets/splash_screen_assets/logo.png',
//               width: screenSize.width * 0.5, // 50% از عرض صفحه
//               height: screenSize.width * 0.5, // 50% از عرض صفحه
//             ),
//           ),
//           // تصاویر متحرک در پایین صفحه به همراه چرخش
//           Align(
//             alignment: Alignment(0.0, 0.85), // انتقال ردیف به بالاتر
//             child: SizedBox(
//               height: 80, // کاهش ارتفاع برای تصاویر
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: AnimatedBuilder(
//                   animation: _animationController,
//                   builder: (context, child) {
//                     return Transform.translate(
//                       offset: Offset(_animationController.value * -screenSize.width, 0), // جابجایی بی‌نهایت تصاویر
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min, // جلوگیری از overflow با تنظیم اندازه اصلی
//                         children: [
//                           _buildImageRow(),
//                           _buildImageRow(),
//                           _buildImageRow(),
//                           _buildImageRow(), // اضافه کردن ۴ تا Row
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

//   // تابعی برای ساختن نوار تصاویر با فاصله بیشتر بین تصاویر
//   Widget _buildImageRow() {
//     return Row(
//       children: [
//         _buildShakingImage('assets/splash_screen_assets/divide.png'),
//         SizedBox(width: 20), // افزودن فاصله بین تصویر اول و دوم
//         _buildShakingImage('assets/splash_screen_assets/plus.png'),
//         SizedBox(width: 20), // افزودن فاصله بین تصویر دوم و سوم
//         _buildShakingImage('assets/splash_screen_assets/minus.png'),
//         SizedBox(width: 20), // افزودن فاصله بین تصویر سوم و چهارم
//         _buildShakingImage('assets/splash_screen_assets/multieply.png'),
//         SizedBox(width: 20), // افزودن فاصله بین تصویر چهارم و پنجم
//       ],
//     );
//   }

//   // تابعی برای ساختن تصویر با انیمیشن چرخش و لرزش
//   Widget _buildShakingImage(String assetPath) {
//     return AnimatedBuilder(
//       animation: _shakeController,
//       builder: (context, child) {
//         // لرزش تصویر
//         final offset = (_shakeController.value - 0.5) * 10; // 10 پیکسل لرزش
//         return Transform(
//           transform: Matrix4.identity()..rotateZ(offset * 0.0175), // لرزش به سمت چپ و راست
//           alignment: Alignment.center,
//           child: RotationTransition(
//             turns: _rotationController,
//             child: Image.asset(
//               assetPath,
//               width: 50, // کوچک‌تر کردن عرض تصویر
//               height: 50, // کوچک‌تر کردن ارتفاع تصویر
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // تابعی برای ایجاد انیمیشن انتقال سفارشی
//   PageRouteBuilder _customPageRoute(Widget page) {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(0.0, 1.0); // شروع از پایین
//         const end = Offset(0.0, 0.0); // پایان در مرکز
//         const curve = Curves.easeInOut; // انیمیشن صاف و سریع

//         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//         var offsetAnimation = animation.drive(tween);

//         return SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         );
//       },
//       transitionDuration: Duration(milliseconds: 750), // مدت زمان انیمیشن
//     );
//   }
// }

