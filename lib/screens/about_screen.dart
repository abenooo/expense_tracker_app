import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'base_screen.dart';
import 'setting/language_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<AboutScreen> {
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
                "</>",
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
                  "CodeX Africa",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Software company in Ethiopia",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
    return BaseScreen(
      currentIndex: 4,
      title: 'Settings',
      body: ListView(
        children: [
          _buildProfileSection(),
          _buildSectionHeader('SOCIAL'),
          _buildSettingItem(
            title: 'Telegram',
            icon: CupertinoIcons.paperplane_fill, // More suitable for Telegram
            iconColor: Colors.blue, // Reflects Telegram's branding color
            value: 'CodeX',
          ),
          _buildSettingItem(
            title: 'Facebook',
            icon: CupertinoIcons
                .person_2_fill, // Represents social networking better
            iconColor:
                Colors.blueAccent, // Slightly different shade for distinction
            value: 'CodeX',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
          _buildSettingItem(
            title: 'LinkedIn',
            icon: CupertinoIcons.link_circle_fill, // More suitable for LinkedIn
            iconColor: Colors.blueGrey, // Reflects LinkedIn's branding
            value: 'CodeX',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
          _buildSectionHeader('MORE'),
          _buildSettingItem(
            title: 'Rate Us On Google Play',
            icon: CupertinoIcons.star_fill, // Suggests rating
            iconColor: Colors.orange,
          ),
          _buildSettingItem(
            title: 'App Version',
            icon: CupertinoIcons.info_circle_fill,
            iconColor: Colors.grey,
            value: '1.0.0',
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
        ],
      ),
    );
  }
}
