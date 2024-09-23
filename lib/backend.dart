import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();  // Initialize Hive locally
  await Hive.openBox('userBox');  // Open a box to store data
}

Future<void> saveMaxXP(int xp) async {
  var box = Hive.box('userBox');
  box.put('maxXP', xp);  // Save max XP locally
}

Future<int> getMaxXP() async {
  var box = Hive.box('userBox');
  return box.get('maxXP', defaultValue: 0);  // Retrieve max XP
}
