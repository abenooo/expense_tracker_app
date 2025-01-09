import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/sms_parser_service.dart';
import '../models/financial_account.dart';
import '../models/transaction.dart';
import '../widgets/recent_transactions_list.dart';
import 'base_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _smsParser = SmsParserService();
  List<FinancialAccount> _accounts = [];
  bool _isLoading = true;
  String? _error;
  int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  Future<void> _requestSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      _fetchAccounts();
    } else {
      setState(() {
        _isLoading = false;
        _error = 'SMS permission is required';
      });
    }
  }

  Future<void> _fetchAccounts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final accounts = await _smsParser.parseAllFinancialSms();
      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch accounts: ${e.toString()}';
      });
    }
  }

  List<Widget> _buildDemoCards() {
    return List.generate(5, (index) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                      'Card ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   const Icon(Icons.credit_card, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '**** **** **** ${(1000 + index).toString()}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${(10000 * (index + 1)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.account_balance_wallet, 'label': 'Income'},
      {'icon': Icons.trending_up, 'label': 'Expected'},
      {'icon': Icons.money_off, 'label': 'Expenses'},
      {'icon': Icons.savings, 'label': 'Savings'},
      {'icon': Icons.credit_card, 'label': 'Loans'},
      {'icon': Icons.bar_chart, 'label': 'Reports'},
      {'icon': Icons.attach_money, 'label': 'Debt'},
      {'icon': Icons.settings, 'label': 'Settings'},
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
          childAspectRatio: 0.9,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  menuItems[index]['icon'],
                  size: 24,
                  color: Colors.blue,
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      currentIndex: 0,
      title: 'Home', // This line is the update
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: FlutterCarousel.builder(
                itemCount: 5,
                itemBuilder: (context, index, realIndex) {
                  return _buildDemoCards()[index];
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
            ),
            const SizedBox(height: 24),
            _buildMenuGrid(),
            const SizedBox(height: 20),
            if (_accounts.isNotEmpty)
              RecentTransactionsList(
                transactions: _getAllTransactions(),
                onViewAll: () {
                  // TODO: Navigate to all transactions
                },
              ),
          ],
        ),
      ),
    );
  }

  List<Transaction> _getAllTransactions() {
    final allTransactions =
        _accounts.expand((account) => account.transactions).toList();
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }
}
