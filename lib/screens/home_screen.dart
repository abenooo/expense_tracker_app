import 'package:ethiopian_bank_tracker/screens/utility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/bank_account.dart';
import '../services/bank_service.dart';
import 'base_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'income_screen.dart';
import 'expected_screen.dart';
import 'expenses_screen.dart';
import 'saving_screen.dart';
import 'loans_screen.dart';
import 'reports_screen.dart';
import 'debt_screen.dart';

class HomeScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin? notificationsPlugin;

  const HomeScreen({Key? key, this.notificationsPlugin}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BankService _bankService = BankService();
  List<BankAccount> _accounts = [];
  bool _isLoading = true;
  String? _error;
  bool _hideBalance = true;
  int _currentCardIndex = 0;
  //late final FlutterLocalNotificationsPlugin _notificationsPlugin;

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'ETB',
    decimalDigits: 2,
    customPattern: '¤ #,##0.00',
  );

  @override
  void initState() {
    super.initState();
    //_notificationsPlugin = widget.notificationsPlugin;
    _loadAccounts();
    _scheduleNotification();
  }

  Future<void> _scheduleNotification() async {
    if (widget.notificationsPlugin == null) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await widget.notificationsPlugin!.show(
        0,
        'Welcome to Expense Tracker App',
        'Track your finances with ease!',
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await _bankService.getBankAccounts();
      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  LinearGradient _getBankGradient(String bankName) {
    switch (bankName) {
      case 'Commercial Bank of Ethiopia':
        return const LinearGradient(
          colors: [Color(0xFF8E258B), Color(0xFFDDA0DD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Bank of Abyssinia':
        return const LinearGradient(
          colors: [Color(0xFFEAA613), Color(0xFFFFD700)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Dashen Bank':
        return const LinearGradient(
          colors: [Color(0xFF253171), Color(0xFF1B1F3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Hibret Bank':
        return const LinearGradient(
          colors: [Color(0xFF05ABA8), Color(0xFF20C4C1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Telebirr':
        return const LinearGradient(
          colors: [Color(0xFF0795D7), Color(0xFF89CFF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Awash Bank':
        return const LinearGradient(
          colors: [Color(0xFF061A57), Color(0xFF142F6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'M-PESA':
        return const LinearGradient(
          colors: [Color(0xFF12AE20), Color(0xFF3EDD3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Colors.blueGrey, Colors.grey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _formatAccountNumber(String number) {
    if (number.length < 4) return number;
    return number.replaceAll(RegExp(r'\d(?=\d{4})'), '*');
  }

  Widget _buildAccountCards() {
    if (_isLoading) {
      return _buildSkeletonCarousel();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadAccounts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_accounts.isEmpty) {
      return const Center(
        child: Text('No bank accounts found. Please check your SMS messages.'),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: FlutterCarousel.builder(
        itemCount: _accounts.length,
        itemBuilder: (context, index, realIndex) {
          final account = _accounts[index];
          return _buildAccountCard(account);
        },
        options: CarouselOptions(
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: true,
          padEnds: false,
          onPageChanged: (index, reason) {
            setState(() => _currentCardIndex = index);
          },
        ),
      ),
    );
  }

  Widget _buildAccountCard(BankAccount account) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: _getBankGradient(account.bankName),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    account.bankName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _hideBalance = !_hideBalance);
                    },
                    child: Icon(
                      _hideBalance ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _formatAccountNumber(account.accountNumber),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _hideBalance
                    ? '******'
                    : currencyFormatter.format(account.balance),
                style: TextStyle(
                  color: account.balance < 0 ? Colors.red : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Last updated: ${DateFormat('MMM d, y h:mm a').format(account.lastUpdated)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCarousel() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: FlutterCarousel.builder(
        itemCount: 3,
        itemBuilder: (context, index, realIndex) {
          return _buildSkeletonCard();
        },
        options: CarouselOptions(
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: true,
          padEnds: false,
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 18,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 28,
                  color: Colors.white,
                ),
                const SizedBox(height: 5),
                Container(
                  width: 150,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Income',
        'color': Colors.green
      },
      {'icon': Icons.trending_up, 'label': 'Expected', 'color': Colors.blue},
      {'icon': Icons.money_off, 'label': 'Expenses', 'color': Colors.red},
      {'icon': Icons.savings, 'label': 'Savings', 'color': Colors.purple},
      {'icon': Icons.credit_card, 'label': 'Loans', 'color': Colors.orange},
      {'icon': Icons.bar_chart, 'label': 'Reports', 'color': Colors.teal},
      {'icon': Icons.attach_money, 'label': 'Debt', 'color': Colors.pink},
      {
        'icon': Icons.electric_bolt,
        'label': 'Utilities',
        'color': Colors.orange,
        'onTap': () {
          if (widget.notificationsPlugin != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UtilityScreen(
                  notificationsPlugin: widget.notificationsPlugin!,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications plugin is not initialized.'),
              ),
            );
          }
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: menuItems[index]['onTap'] as void Function()?,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: menuItems[index]['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    menuItems[index]['icon'],
                    size: 36,
                    color: menuItems[index]['color'],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menuItems[index]['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 0,
      title: 'Home',
      body: RefreshIndicator(
        onRefresh: _loadAccounts,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildAccountCards(),
              const SizedBox(height: 16),
              _buildMenuGrid(),
              const SizedBox(height: 16),
              if (!_isLoading && _accounts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
