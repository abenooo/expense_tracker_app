import 'package:ethiopian_bank_tracker/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_screen.dart';
import 'setting_screen.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final String title;

  const BaseScreen({
    Key? key,
    required this.body,
    required this.currentIndex,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: body, 
      extendBody: true,
      bottomNavigationBar: _buildCurvedNavigationBar(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Abenezer Kifle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              'abenezerkifle@gmail.com',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'AB',
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection(
                  context,
                  'Main Features',
                  [
                    _buildDrawerItem(
                        context, Icons.workspace_premium, 'Get Premium'),
                    _buildDrawerItem(
                        context, Icons.account_balance, 'Bank Sync'),
                    _buildDrawerItem(context, Icons.home, 'Home'),
                    _buildDrawerItem(context, Icons.receipt_long, 'Records'),
                    _buildDrawerItem(context, Icons.trending_up, 'Investments'),
                  ],
                ),
                _buildDrawerSection(
                  context,
                  'Finance Management',
                  [
                    _buildDrawerItem(context, Icons.analytics, 'Statistics'),
                    _buildDrawerItem(
                        context, Icons.schedule, 'Planned Payments'),
                    _buildDrawerItem(
                        context, Icons.account_balance_wallet, 'Budgets'),
                    _buildDrawerItem(context, Icons.money_off, 'Debts'),
                    _buildDrawerItem(context, Icons.flag, 'Goals'),
                    _buildDrawerItem(
                        context, Icons.business, 'Wallet for Business'),
                  ],
                ),
                _buildDrawerSection(
                  context,
                  'Additional Tools',
                  [
                    _buildDrawerItem(
                        context, Icons.shopping_cart, 'Shopping Lists'),
                    _buildDrawerItem(context, Icons.security, 'Warranties'),
                    _buildDrawerItem(
                        context, Icons.card_giftcard, 'Loyalty Cards'),
                    _buildDrawerItem(
                        context, Icons.currency_exchange, 'Currency Rates'),
                    _buildDrawerItem(context, Icons.group, 'Group Sharing'),
                    _buildDrawerItem(context, Icons.more_horiz, 'Others'),
                  ],
                ),
                _buildDrawerSection(
                  context,
                  'Settings',
                  [
                    _buildDrawerItem(
                        context, Icons.settings, 'Profile Settings'),
                    _buildDrawerItem(context, Icons.support, 'Support'),
                    _buildDrawerItem(context, Icons.logout, 'Logout'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        ...items,
        const Divider(),
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      {bool isSelected = false, bool showNew = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.green : Colors.black87,
        ),
      ),
      trailing: showNew
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCurvedNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 60.0,
       items: const [
  Icon(Icons.home, size: 30), // Home icon remains unchanged
  Icon(Icons.account_balance_wallet, size: 30), // Transaction (account balance wallet)
  Icon(Icons.bar_chart, size: 30), // Report (chart or analytics icon)
  Icon(Icons.settings, size: 30), // Settings icon remains unchanged
  Icon(Icons.info, size: 30), // About Us (info icon for about section)
],

        color: Colors.green,
        buttonBackgroundColor: Colors.green,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          if (index == currentIndex) return;

          Widget screen;
          switch (index) {
            case 0:
              screen = HomeScreen();
              break;
            case 1:
              screen = const NotificationsScreen();
              break;
            case 2:
              screen = const ChatScreen();
              break;
            case 3:
              screen = const SettingsScreen();
              break;
            case 4:
              screen = const AboutScreen();
              break;
            default:
              return;
          }

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      ),
    );
  }
}
