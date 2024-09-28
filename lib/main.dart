import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:zarb_navard_game/puzzels/models/board_adapter.dart';
import 'package:flame_audio/flame_audio.dart'; // Import Flame audio

import 'hub/home1.dart'; // Your home screen.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the orientation to portrait mode for Android & iOS.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Hive and open a box for user data.
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  Hive.registerAdapter(BoardAdapter()); // Assuming this adapter is for the 2048 game.

  // Initialize the background music player
  FlameAudio.bgm.initialize();

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
        primaryColor: const Color(0x0ff8fc43),
        hintColor: const Color(0x0fff7c71),
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
        cardColor: const Color(0xffe0e0e0),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xff5b9c32),
        hintColor: const Color(0xffd4a511),
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
        cardColor: const Color(0xff2c2c2c),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => PopScope(
        onPopInvoked: (bool didPop) {
          // Stop background music when the back button is pressed
          FlameAudio.bgm.stop();
        },
        child: MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(), // Default home screen.
        ),
      ),
    );
  }
}
