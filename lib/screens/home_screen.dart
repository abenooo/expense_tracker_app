
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:intl/intl.dart';
import '../models/financial_account.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/bank_type.dart';
import 'base_screen.dart';
import "../widgets/transaction_tabs.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FinancialAccount> _accounts = [];
  bool _isLoading = true;
  String? _error;
  int _currentCardIndex = 0;
  int _selectedTabIndex = 0;

  List<Transaction> get sampleTransactions => [
        Transaction(
          amount: 120.00,
          type: TransactionType.withdrawal,
          date: DateTime(2024, 1, 11, 10, 0),
          description: 'Buy some grocery',
          bankType: BankType.cbe,
          accountNumber: '1234',
          subtitle: 'Shopping',
          icon: Icons.shopping_bag_outlined,
          iconColor: Colors.orange,
          iconBackground: Color(0xFFFFF3E0),
        ),
        Transaction(
          amount: 80.00,
          type: TransactionType.withdrawal,
          date: DateTime(2024, 1, 11, 15, 30),
          description: 'Disney+ Annual..',
          bankType: BankType.cbe,
          accountNumber: '1234',
          subtitle: 'Subscription',
          icon: Icons.subscriptions_outlined,
          iconColor: Colors.purple,
          iconBackground: Color(0xFFF3E5F5),
        ),
        Transaction(
          amount: 32.00,
          type: TransactionType.withdrawal,
          date: DateTime(2024, 1, 11, 19, 30),
          description: 'Buy a ramen',
          bankType: BankType.cbe,
          accountNumber: '1234',
          subtitle: 'Food',
          icon: Icons.restaurant_outlined,
          iconColor: Colors.pink,
          iconBackground: Color(0xFFFCE4EC),
        ),
      ];

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: 'ETB',
    decimalDigits: 2,
    customPattern: '¤ #,##0.00',
  );

  void _handleTabChange(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  List<Widget> _buildDemoCards() {
    return List.generate(5, (index) {
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
                  currencyFormatter.format(10000 * (index + 1)),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            _buildMenuGrid(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transaction',
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
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sampleTransactions.length,
              itemBuilder: (context, index) {
                final transaction = sampleTransactions[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: transaction.iconBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          transaction.icon,
                          color: transaction.iconColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.subtitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '- \$${transaction.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a').format(transaction.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}