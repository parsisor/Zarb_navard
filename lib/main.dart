import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart'; // Import adaptive_theme package
import 'package:zarb_navard_game/hub/home1.dart'; // Import your HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff8fc43), // Light mode primary color
        hintColor: Color(0xfff7c71),  // Light mode accent color
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'IranSansX',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'IranSansX'),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        cardColor: Color(0xffe0e0e0), // Light mode card color
        iconTheme: IconThemeData(color: Colors.black),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff5b9c32), // Dark mode primary color
        hintColor: Color(0xffd4a511),  // Dark mode accent color
        scaffoldBackgroundColor: Color(0xff121212),
        fontFamily: 'IranSansX',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff1e1e1e),
          titleTextStyle: TextStyle(color: Colors.white, fontFamily: 'IranSansX'),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Color(0xff2c2c2c), // Dark mode card color
        iconTheme: IconThemeData(color: Colors.white),
      ),
      initial: AdaptiveThemeMode.system, // Start with system theme
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(), // Your HomeScreen widget
      ),
    );
  }
}
