import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  final bool darkModeEnabled;
  final Function(bool) onThemeToggle;

  SettingsPage({required this.darkModeEnabled, required this.onThemeToggle});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Box userBox;
  String username = 'نام کاربری خود را وارد کنید';
  String phoneNumber = '';
  bool notificationsEnabled = true;
  String password = '';
  String? profilePicturePath;
  String? phoneError;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      username = userBox.get('username', defaultValue: username);
      phoneNumber = userBox.get('phoneNumber', defaultValue: phoneNumber);
      password = userBox.get('password', defaultValue: password);
      notificationsEnabled = userBox.get('notificationsEnabled', defaultValue: true);
      profilePicturePath = userBox.get('profilePicture', defaultValue: null);
    });
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        profilePicturePath = pickedFile.path;
        userBox.put('profilePicture', profilePicturePath);
      });
    }
  }

  bool _validatePhoneNumber(String phone) {
    // Simple validation: Check if the number contains only digits and is of a specific length
    return RegExp(r'^\d{10,15}$').hasMatch(phone); // Adjust length as necessary
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: theme.colorScheme.primary,
            child: Center(
              child: Text(
                'تنظیمات',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranSans',
                ),
              ),
            ),
          ),
          // Settings content
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: 16,
            right: 16,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // User profile section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.titleLarge!.color,
                                ),
                              ),
                              Text(
                                'پروفایل کاربر',
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 14,
                                  color: theme.textTheme.titleMedium!.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _pickProfilePicture,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: profilePicturePath != null
                                      ? FileImage(File(profilePicturePath!))
                                      : const AssetImage('assets/LeaderBoard_assets/character1.png') as ImageProvider,
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

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
                      // Updated section for phone number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (phoneNumber.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'شماره تلفن: $phoneNumber',
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 16,
                                  color: theme.textTheme.bodyLarge!.color,
                                ),
                              ),
                            ),
                          if (phoneError != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                phoneError!,
                                style: TextStyle(
                                  fontFamily: 'IranSans',
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          buildListTile(
                            context,
                            phoneNumber.isEmpty ? 'اضافه کردن شماره تلفن' : 'تغییر شماره',
                            phoneNumber.isEmpty ? Icons.add : Icons.edit,
                            () {
                              _showAddPhoneNumberDialog(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Notification switch
                      buildSwitchTile(
                        context,
                        'اعلان‌ها',
                        notificationsEnabled,
                        (value) {
                          setState(() {
                            notificationsEnabled = value;
                            userBox.put('notificationsEnabled', value);
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Theme change button
                      buildListTile(
                        context,
                        'تم را عوض کن',
                        Icons.color_lens,
                        () {
                          widget.onThemeToggle(!widget.darkModeEnabled);
                        },
                      ),
                      const SizedBox(height: 20),

                      // About and terms section
                      buildListTile(
                        context,
                        'درباره ما',
                        Icons.arrow_back_ios,
                        () {
                          _showInfoDialog(context, 'درباره ما', 'این برنامه توسط تیم ما ساخته شده است.');
                        },
                      ),
                      buildListTile(
                        context,
                        'قوانین و شروط',
                        Icons.arrow_back_ios,
                        () {
                          _showInfoDialog(context, 'قوانین و شروط', 'شروط استفاده از برنامه...');
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

  Widget buildListTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ListTile(
      trailing: Icon(icon, color: theme.iconTheme.color),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'IranSans',
          fontSize: 16,
          color: theme.textTheme.bodyLarge!.color,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget buildSwitchTile(BuildContext context, String title, bool initialValue, Function(bool) onChanged) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'IranSans',
          fontSize: 16,
          color: theme.textTheme.bodyLarge!.color,
        ),
      ),
      value: initialValue,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
    );
  }

  void _showChangeUsernameDialog(BuildContext context) {
    TextEditingController _usernameController = TextEditingController();
    _usernameController.text = username;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تغییر نام کاربری'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: "نام کاربری جدید"),
          ),
          actions: [
            TextButton(
              child: const Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('تأیید'),
              onPressed: () {
                setState(() {
                  username = _usernameController.text;
                  userBox.put('username', username);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تغییر رمز عبور'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "رمز عبور جدید"),
          ),
          actions: [
            TextButton(
              child: const Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('تأیید'),
              onPressed: () {
                setState(() {
                  password = _passwordController.text;
                  userBox.put('password', password);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddPhoneNumberDialog(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();
    _phoneController.text = phoneNumber;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اضافه کردن شماره تلفن'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: "شماره تلفن"),
              ),
              if (phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    phoneError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('لغو'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('تأیید'),
              onPressed: () {
                setState(() {
                  String newPhoneNumber = _phoneController.text;
                  if (_validatePhoneNumber(newPhoneNumber)) {
                    phoneNumber = newPhoneNumber;
                    userBox.put('phoneNumber', phoneNumber);
                    phoneError = null; // Clear error if valid
                  } else {
                    phoneError = 'لطفا شماره تلفن معتبر وارد کنید';
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('بستن'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
