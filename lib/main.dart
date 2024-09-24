import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:zarb_navard_game/puzzels/models/board_adapter.dart';

import 'hub/home1.dart'; // Your home screen.

void main() async {
  // Ensuring that Flutter bindings and Hive are initialized before the app runs.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the orientation to portrait mode for Android & iOS.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Hive and open a box for user data.
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  Hive.registerAdapter(BoardAdapter()); // Assuming this adapter is for the 2048 game.

  // Run the app with ProviderScope for Riverpod state management and AdaptiveTheme for light/dark mode.
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0x0ff8fc43), // Light mode primary color
        hintColor: const Color(0x0fff7c71),  // Light mode accent color
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'IranSansX',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'IranSansX'),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        cardColor: const Color(0xffe0e0e0), // Light mode card color
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xff5b9c32), // Dark mode primary color
        hintColor: const Color(0xffd4a511),  // Dark mode accent color
        scaffoldBackgroundColor: const Color(0xff121212),
        fontFamily: 'IranSansX',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1e1e1e),
          titleTextStyle: TextStyle(color: Colors.white, fontFamily: 'IranSansX'),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: const Color(0xff2c2c2c), // Dark mode card color
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(), // Default home screen.
      ),
    );
  }
}

