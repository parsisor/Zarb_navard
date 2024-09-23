import 'package:flutter/material.dart';



import 'package:hive/hive.dart';
import 'package:zarb_navard_game/local_leader_board.dart';


class LeaderboardService {
  Box<UserModel>? _leaderboardBox;

  Future<void> init() async {
    _leaderboardBox = await Hive.openBox<UserModel>('leaderboardBox');
  }

  Future<void> addFakeUser(String name, int xp) async {
    final user = UserModel(name: name, xp: xp);
    await _leaderboardBox?.add(user);
  }

  List<UserModel> getLeaderboard() {
    List<UserModel> users = _leaderboardBox?.values.toList() ?? [];
    users.sort((a, b) => b.xp.compareTo(a.xp)); 
    return users.take(10).toList(); 
  }
}


class LeaderBoardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userData = [
    {'name': 'AmirAli', 'points': 123, 'rank': 1, 'avatar': 'assets/LeaderBoard_assets/character1.png'},
    {'name': 'Mehran', 'points': 120, 'rank': 2, 'avatar': 'assets/LeaderBoard_assets/character2.png'},
    {'name': 'Kianna', 'points': 112, 'rank': 3, 'avatar': 'assets/LeaderBoard_assets/character3.png'},
    {'name': 'Mobin', 'points': 109, 'rank': 4, 'avatar': 'assets/LeaderBoard_assets/character4.png'},
    {'name': 'Sina', 'points': 100, 'rank': 5, 'avatar': 'assets/LeaderBoard_assets/character5.png'},
    {'name': 'Mahin', 'points': 97, 'rank': 6, 'avatar': 'assets/LeaderBoard_assets/character6.png'},
  ];

  LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "بهترین بازیکنان",
          style: TextStyle(
            fontFamily: 'IranSans', 
            fontSize: screenWidth * 0.05, 
            color: theme.textTheme.bodyLarge?.color, 
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: _buildPodium(theme, screenHeight),
          ),
          SizedBox(height: screenHeight * 0.03),
          Expanded(
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return _buildUserCard(
                  userData[index]['name'],
                  userData[index]['points'],
                  userData[index]['rank'],
                  userData[index]['avatar'],
                  theme, 
                  screenHeight,
                  screenWidth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(ThemeData theme, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.35,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: screenHeight * 0.07,
            right: 0,
            child: _buildMedalist(2, 'assets/LeaderBoard_assets/character2.png', theme.cardColor, Colors.grey[300]!, screenHeight, theme),
          ),
          Positioned(
            bottom: screenHeight * 0.07,
            left: 0,
            child: _buildMedalist(3, 'assets/LeaderBoard_assets/character3.png', theme.cardColor, Colors.brown[700]!, screenHeight, theme),
          ),
          Positioned(
            bottom: screenHeight * 0.14,
            child: _buildMedalist(1, 'assets/LeaderBoard_assets/character1.png', theme.cardColor, Colors.yellow[800]!, screenHeight, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildMedalist(int rank, String avatarPath, Color avatarBg, Color borderColor, double screenHeight, ThemeData theme) {
    int xp = rank == 1 ? 200 : rank == 2 ? 150 : 100;

    return Column(
      children: [
        CircleAvatar(
          radius: screenHeight * 0.08,
          backgroundColor: borderColor,
          child: CircleAvatar(
            radius: screenHeight * 0.075,
            backgroundColor: avatarBg,
            backgroundImage: AssetImage(avatarPath),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "XP $xp",
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, 
            fontWeight: FontWeight.bold,
            fontSize: screenHeight * 0.018,
          ),
        ),
        Text(
          rank == 1 ? 'AmirAli' : rank == 2 ? 'Mehran' : 'Kianna',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, 
            fontSize: screenHeight * 0.018,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(String name, int points, int rank, String avatarPath, ThemeData theme, double screenHeight, double screenWidth) {
    Color bgColor;
    if (rank == 1) {
      bgColor = const Color.fromARGB(255, 242, 191, 24);
    } else if (rank == 2) {
      bgColor = const Color.fromARGB(192, 192, 192, 256);
    } else if (rank == 3) {
      bgColor = const Color.fromARGB(205, 127, 50, 256);
    } else {
      bgColor = theme.cardColor;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: rank != 1 ? theme.hintColor : Colors.transparent,
            width: 2,
          ),
        ),
        color: bgColor,
        child: ListTile(
          leading: Text(
            '$rank',
            style: TextStyle(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color, 
            ),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: screenHeight * 0.035,
                backgroundColor: theme.iconTheme.color,
                backgroundImage: AssetImage(avatarPath),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.025,
                  color: theme.textTheme.bodyLarge?.color, 
                ),
              ),
            ],
          ),
          subtitle: Text(
            'XP $points',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: screenHeight * 0.02,
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7), 
            ),
          ),
        ),
      ),
    );
  }
}
