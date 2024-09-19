import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool darkModeEnabled;
  final Function(bool) onThemeToggle;

  SettingsPage({required this.darkModeEnabled, required this.onThemeToggle});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String username = 'مهرانه اسلامی';
  String phoneNumber = '';
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Use theme background color
      body: Stack(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: theme.colorScheme.primary, // Use theme primary color
            child: Center(
              child: Text(
                'تنظیمات',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary, // Use theme onPrimary color
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranSans',
                ),
              ),
            ),
          ),
          // Settings content
          Positioned(
            top: MediaQuery.of(context).size.height / 4, // Setting position for the container
            left: 16,
            right: 16,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // Use theme surface color
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1), // Use theme shadow color
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Adding padding around the content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end, // Right-aligning text
                    children: [
                      // User profile section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Right-aligning the profile picture and name
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                username, // Display current username
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.titleLarge!.color, // Use theme text color
                                ),
                              ),
                              Text(
                                'پروفایل کاربر',
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 14,
                                  color: theme.textTheme.titleMedium!.color, // Use theme subtitle color
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/LeaderBoard_assets/character1.png'), // Profile picture
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Account settings
                      buildListTile(
                        context,
                        'تغییر نام کاربری',
                        Icons.arrow_back_ios,
                        () {
                          _showChangeUsernameDialog(context);
                        },
                      ),
                      buildListTile(
                        context,
                        'تغییر رمز عبور',
                        Icons.arrow_back_ios,
                        () {
                          _showChangePasswordDialog(context);
                        },
                      ),
                      buildListTile(
                        context,
                        'اضافه کردن شماره تلفن',
                        Icons.add,
                        () {
                          _showAddPhoneNumberDialog(context);
                        },
                      ),
                      SizedBox(height: 20),

                      // Notification switch
                      buildSwitchTile(
                        context,
                        'اعلان‌ها',
                        notificationsEnabled, // Initially enabled
                        (value) {
                          setState(() {
                            notificationsEnabled = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),

                      // Theme change button
                      buildListTile(
                        context,
                        'تم را عوض کن', // "Change Theme"
                        Icons.color_lens, // Icon for theme change
                        () {
                          // Toggle the theme when tapped
                          widget.onThemeToggle(!widget.darkModeEnabled);
                        },
                      ),
                      SizedBox(height: 20),

                      // About and terms section
                      buildListTile(
                        context,
                        'درباره ما',
                        Icons.arrow_back_ios,
                        () {
                          // Action for about us
                        },
                      ),
                      buildListTile(
                        context,
                        'قوانین و شروط',
                        Icons.arrow_back_ios,
                        () {
                          // Action for terms and conditions
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build list tile
  Widget buildListTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);

    return ListTile(
      trailing: Icon(icon, color: theme.iconTheme.color), // Use theme icon color
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'IranSans',
          fontSize: 16,
          color: theme.textTheme.bodyLarge!.color, // Use theme body text color
        ),
      ),
      onTap: onTap, // Assign the action passed to the tile
    );
  }

  // Function to build switch tile
  Widget buildSwitchTile(BuildContext context, String title, bool initialValue, Function(bool) onChanged) {
    final theme = Theme.of(context);

    return SwitchListTile(
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'IranSans',
          fontSize: 16,
          color: theme.textTheme.bodyLarge!.color, // Use theme body text color
        ),
      ),
      value: initialValue,
      onChanged: onChanged, // Assign the action passed to the switch
      activeColor: theme.colorScheme.primary, // Use theme primary color for switch
    );
  }

  // Dialog for changing username
  void _showChangeUsernameDialog(BuildContext context) {
    TextEditingController _usernameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تغییر نام کاربری'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: "نام کاربری جدید"),
          ),
          actions: [
            TextButton(
              child: Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تأیید'),
              onPressed: () {
                setState(() {
                  username = _usernameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog for changing password
  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تغییر رمز عبور'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "رمز عبور جدید"),
          ),
          actions: [
            TextButton(
              child: Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تأیید'),
              onPressed: () {
                // Handle password change logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Dialog for adding phone number
  void _showAddPhoneNumberDialog(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اضافه کردن شماره تلفن'),
          content: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "شماره تلفن"),
          ),
          actions: [
            TextButton(
              child: Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تأیید'),
              onPressed: () {
                setState(() {
                  phoneNumber = _phoneController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
