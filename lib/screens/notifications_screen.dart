import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'transaction',
      'title': 'New Transaction',
      'description': 'You received 1000 ETB from John Doe',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
    {
      'type': 'alert',
      'title': 'Security Alert',
      'description': 'Unusual login attempt detected',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
    {
      'type': 'promotion',
      'title': 'Special Offer',
      'description': 'Get 5% cashback on your next transaction',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': false,
    },
    {
      'type': 'transaction',
      'title': 'Bill Payment',
      'description': 'Your electricity bill of 500 ETB has been paid',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
    },
    {
      'type': 'alert',
      'title': 'Password Changed',
      'description': 'Your account password was recently changed',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
    },
  ];

  bool _expenseAlertEnabled = true;
  bool _budgetAlertEnabled = true;
  bool _tipsArticlesEnabled = true;

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData icon;
    Color iconColor;

    switch (notification['type']) {
      case 'transaction':
        icon = CupertinoIcons.arrow_right_arrow_left;
        iconColor = Colors.green;
        break;
      case 'alert':
        icon = CupertinoIcons.exclamationmark_triangle;
        iconColor = Colors.red;
        break;
      case 'promotion':
        icon = CupertinoIcons.gift;
        iconColor = Colors.purple;
        break;
      default:
        icon = CupertinoIcons.bell;
        iconColor = Colors.blue;
    }

    return Dismissible(
      key: Key(notification['title']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(CupertinoIcons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification['isRead'] ? Colors.white : Colors.blue.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification['description'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification['time']),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              notification['isRead'] = true;
            });
            // TODO: Implement notification detail view
          },
        ),
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildToggleOption(
            title: 'Expense Alert',
            subtitle: 'Get notifications about your expenses',
            value: _expenseAlertEnabled,
            onChanged: (value) {
              setState(() {
                _expenseAlertEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildToggleOption(
            title: 'Budget Alert',
            subtitle: 'Get notifications when you\'re exceeding the budget limit',
            value: _budgetAlertEnabled,
            onChanged: (value) {
              setState(() {
                _budgetAlertEnabled = value;
              });
            },
          ),
          const Divider(),
          _buildToggleOption(
            title: 'Tips & Articles',
            subtitle: 'Small & useful pieces of practical financial advice',
            value: _tipsArticlesEnabled,
            onChanged: (value) {
              setState(() {
                _tipsArticlesEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.purple.shade400,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, y').format(time);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
            },
            child: Text(
              'Mark all as read',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNotificationPreferences(),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.white,
              child: _notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.bell_slash,
                              size: 70,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You\'re all caught up!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(_notifications[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

