import 'package:flutter/material.dart';

class LeaderBoardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userData = [
    {'name': 'AmirAli', 'points': 123, 'rank': 1, 'avatar': 'assets/LeaderBoard_assets/character1.png'},
    {'name': 'Mehran', 'points': 120, 'rank': 2, 'avatar': 'assets/LeaderBoard_assets/character2.png'},
    {'name': 'Kianna', 'points': 112, 'rank': 3, 'avatar': 'assets/LeaderBoard_assets/character3.png'},
    {'name': 'Mobin', 'points': 109, 'rank': 4, 'avatar': 'assets/LeaderBoard_assets/character4.png'},
    {'name': 'Sina', 'points': 100, 'rank': 5, 'avatar': 'assets/LeaderBoard_assets/character5.png'},
    {'name': 'Mahin', 'points': 97, 'rank': 6, 'avatar': 'assets/LeaderBoard_assets/character6.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the entire screen
      appBar: AppBar(
        title: Text("بهترین بازیکنان",
            style: TextStyle(fontFamily: 'IranSans', fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          // Top 3 Medalists in a podium-style layout with padding for alignment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding for alignment
            child: _buildPodium(),
          ),

          SizedBox(height: 20),

          // User List with enhanced styling
          Expanded(
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return _buildUserCard(
                  userData[index]['name'],
                  userData[index]['points'],
                  userData[index]['rank'],
                  userData[index]['avatar'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the podium for top 3 players
  Widget _buildPodium() {
    return SizedBox(
      height: 300, // Adjust height to fit the podium effect
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 2nd place (Right side of 1st place)
          Positioned(
            bottom: 50,
            right: 0,
            child: _buildMedalist(2, 'assets/LeaderBoard_assets/character2.png', Color(0xFFBDC3C7), Colors.grey[300]!),
          ),
          // 3rd place (Left side of 1st place)
          Positioned(
            bottom: 50,
            left: 0,
            child: _buildMedalist(3, 'assets/LeaderBoard_assets/character3.png', Color(0xFFCD7F32), Colors.brown[700]!),
          ),
          // 1st place (Top center, slightly above the others)
          Positioned(
            bottom: 100,
            child: _buildMedalist(1, 'assets/LeaderBoard_assets/character1.png', Color(0xFFFFD700), Colors.yellow[800]!),
          ),
        ],
      ),
    );
  }

  // Helper method to create each medalist with avatar, XP, and name
  Widget _buildMedalist(int rank, String avatarPath, Color avatarBg, Color borderColor) {
    int xp = rank == 1 ? 200 : rank == 2 ? 150 : 100; // Correct XP values

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: borderColor, // Gold, silver, or bronze border
          child: CircleAvatar(
            radius: 45,
            backgroundColor: avatarBg, // Inner avatar background
            backgroundImage: AssetImage(avatarPath), // PNG image for avatar
          ),
        ),
        SizedBox(height: 10),
        Text(
          "XP $xp", // Correct XP
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          rank == 1 ? 'AmirAli' : rank == 2 ? 'Mehran' : 'Kianna', // Example names
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  // Helper method to create user cards with rank, avatar, and points
  Widget _buildUserCard(String name, int points, int rank, String avatarPath) {
    Color bgColor;
    if (rank == 1) {
      bgColor = Color.fromARGB(255, 242, 191, 24); // Light goldish for 1st
    } else if (rank == 2) {
      bgColor = Color.fromARGB(192, 192, 192, 256); // Light silverish for 2nd
    } else if (rank == 3) {
      bgColor = Color.fromARGB(205, 127, 50, 256); // Light bronze for 3rd
    } else {
      bgColor = Color.fromARGB(255, 201, 201, 201); // White for others
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: rank != 1 ? Colors.green[900]! : Colors.transparent, // Dark green border except for 1st
            width: 2,
          ),
        ),
        color: bgColor, // Color changes based on rank
        child: ListTile(
          leading: Text(
            '$rank',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(avatarPath), // Use PNG image for avatar
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          subtitle: Text(
            'XP $points',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
