import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_screen.dart';
import 'setting_screen.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: 75 + bottomPadding),
            child: body,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildCurvedNavigationBar(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'JD',
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          _buildDrawerItem(context, Icons.home, 'Dashboard'),
          _buildDrawerItem(context, Icons.history, 'Trip History'),
          _buildDrawerItem(context, Icons.payment, 'Payments'),
          const Padding(
            padding: EdgeInsets.all(14.0),
            child:
                Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildDrawerItem(context, Icons.settings, 'Profile Settings'),
          _buildDrawerItem(context, Icons.support, 'Support'),
          _buildDrawerItem(context, Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
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
          Icon(Icons.home, size: 30),
          Icon(Icons.map, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.notifications, size: 30),
          Icon(Icons.person, size: 30),
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
              screen = LocationScreen();
              break;
            case 2:
              screen = ChatScreen();
              break;
            case 3:
              screen = NotificationsScreen();
              break;
            case 4:
              screen = ProfileScreen();
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
