
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import '../models/bank_account.dart';
import '../services/bank_service.dart';
import 'base_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BankService _bankService = BankService();
  List<BankAccount> _accounts = [];
  bool _isLoading = true;
  String? _error;
  bool _hideBalance = false;
  int _currentCardIndex = 0;

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'ETB',
    decimalDigits: 2,
    customPattern: '¤ #,##0.00',
  );

  @override
  void initState() {
    super.initState();
    _loadAccounts();
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

  Color _getBankColor(String bankName) {
    switch (bankName) {
      case 'Commercial Bank of Ethiopia':
        return Color(0xFF1E3F66);
      case 'Commercial Bank of Ethiopia Birr':
        return Color(0xFF1E3F66);
      case 'Bank of Abyssinia':
        return Color(0xFF662D91);
      case 'Dashen Bank':
        return Color(0xFF00AEEF);
      case 'Hibret Bank':
        return Color(0xFF00A651);
      case 'Telebirr':
        return Color(0xFF4CAF50);
      case 'Awash Bank':
        return Color(0xFFFBB040);
      case 'M-PESA':
        return Color(0xFF00AFF0);
      default:
        return Colors.blueGrey;
    }
  }

  String _formatAccountNumber(String number) {
    if (number.length < 4) return number;
    return number.replaceAll(RegExp(r'\d(?=\d{4})'), '*');
  }

  Widget _buildAccountCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadAccounts,
              child: Text('Retry'),
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
                  gradient: LinearGradient(
                    colors: [
                      _getBankColor(account.bankName),
                      _getBankColor(account.bankName).withOpacity(0.7),
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
                          ? '****'
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
          return Column(
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
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

