import 'package:ethiopian_bank_tracker/screens/setting/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<LocationScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  bool isBiometricsEnabled = true;

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "AS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Abenezer Kifle",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Premium Member",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.pencil),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    String? value,
    bool showToggle = false,
    bool? toggleValue,
    VoidCallback? onTap,
    Function(bool)? onToggleChanged,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.blue,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                )
              : null,
          trailing: showToggle
              ? CupertinoSwitch(
                  value: toggleValue ?? false,
                  activeColor: Colors.purple.shade400,
                  onChanged: onToggleChanged ?? (_) {},
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value != null)
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.chevron_forward,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
          onTap: showToggle ? null : (onTap ?? () {}),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildProfileSection(),
          _buildSectionHeader('PREFERENCES'),
          _buildSettingItem(
            title: 'Currency',
            icon: CupertinoIcons.money_dollar_circle_fill,
            iconColor: Colors.green,
            value: 'USD',
          ),
          // _buildSettingItem(
          //   title: 'Language',
          //   icon: CupertinoIcons.globe,
          //   iconColor: Colors.blue,
          //   value: 'English',
          // ),

// Usage:
          _buildSettingItem(
              title: 'Language',
              icon: CupertinoIcons.globe,
              iconColor: Colors.blue,
              value: 'English',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()),
                );
              }),

          _buildSettingItem(
            title: 'Theme',
            subtitle: 'Dark mode helps reduce eye strain',
            icon: CupertinoIcons.moon_stars_fill,
            iconColor: Colors.purple,
            showToggle: true,
            toggleValue: isDarkMode,
            onToggleChanged: (value) {
              setState(() => isDarkMode = value);
            },
          ),
          _buildSectionHeader('SECURITY'),
          _buildSettingItem(
            title: 'Biometric Authentication',
            icon: CupertinoIcons.person_crop_circle_fill_badge_checkmark,
            iconColor: Colors.red,
            showToggle: true,
            toggleValue: isBiometricsEnabled,
            onToggleChanged: (value) {
              setState(() => isBiometricsEnabled = value);
            },
          ),
          _buildSettingItem(
            title: 'Change PIN',
            icon: CupertinoIcons.lock_fill,
            iconColor: Colors.orange,
          ),
          _buildSectionHeader('NOTIFICATIONS'),
          _buildSettingItem(
            title: 'Push Notifications',
            icon: CupertinoIcons.bell_fill,
            iconColor: Colors.blue,
            showToggle: true,
            toggleValue: isNotificationsEnabled,
            onToggleChanged: (value) {
              setState(() => isNotificationsEnabled = value);
            },
          ),
          _buildSettingItem(
            title: 'Email Notifications',
            icon: CupertinoIcons.mail_solid,
            iconColor: Colors.red,
            showToggle: true,
            toggleValue: true,
            onToggleChanged: (value) {},
          ),
          _buildSectionHeader('ABOUT'),
          _buildSettingItem(
            title: 'App Version',
            icon: CupertinoIcons.info_circle_fill,
            iconColor: Colors.grey,
            value: '2.0.1',
          ),
          _buildSettingItem(
            title: 'Terms of Service',
            icon: CupertinoIcons.doc_text_fill,
            iconColor: Colors.blue,
          ),
          _buildSettingItem(
            title: 'Privacy Policy',
            icon: CupertinoIcons.shield_fill,
            iconColor: Colors.green,
          ),
          _buildSettingItem(
            title: 'Help & Support',
            icon: CupertinoIcons.question_circle_fill,
            iconColor: Colors.orange,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
