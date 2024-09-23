import 'package:hive/hive.dart';

part 'local_leader_board.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int xp;

  UserModel({required this.name, required this.xp});
}
