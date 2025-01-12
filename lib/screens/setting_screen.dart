import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'base_screen.dart';
import 'setting/language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    return BaseScreen(
      currentIndex: 3,
      title: 'Settings',
      body: ListView(
        children: [
          _buildProfileSection(),
          _buildSectionHeader('PREFERENCES'),
          _buildSettingItem(
            title: 'Currency',
            icon: CupertinoIcons.money_dollar_circle_fill,
            iconColor: Colors.green,
            value: 'ETB',
          ),
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
            },
          ),
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
            showToggle: false,
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
        ],
      ),
    );
  }
}

