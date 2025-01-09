// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import '../services/sms_parser_service.dart';
// import '../services/localization_service.dart';
// import '../widgets/enhanced_financial_account_card.dart';
// import '../models/financial_account.dart';
// import '../models/bank_type.dart';
// import '../models/transaction_type.dart';
// import '../models/transaction.dart';
// import '../widgets/quick_action_button.dart';
// import '../widgets/summary_card.dart';
// import '../widgets/recent_transactions_list.dart';
// import './language_screen.dart';
// import './transactions_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _smsParser = SmsParserService();
//   List<FinancialAccount> _accounts = [];
//   bool _isLoading = true;
//   String? _error;
//   int _selectedIndex = 0;
//   int _currentCardIndex = 0;
//   bool _isDarkMode = false;
//   bool _hideAmounts = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _requestSmsPermission();
//   }

//   Future<void> _requestSmsPermission() async {
//     final status = await Permission.sms.request();
//     if (status.isGranted) {
//       _fetchAccounts();
//     } else {
//       setState(() {
//         _isLoading = false;
//         _error = 'SMS permission is required';
//       });
//     }
//   }

//   Future<void> _fetchAccounts() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _error = null;
//       });

//       final accounts = await _smsParser.parseAllFinancialSms();
//       setState(() {
//         _accounts = accounts;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _error = 'Failed to fetch accounts: ${e.toString()}';
//       });
//     }
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             accountName: Text(
//               'abenenzer Shieferaw',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             accountEmail: Text(
//               'My Wallet',
//               style: TextStyle(color: Colors.white),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.grey[200],
//               child: Text(
//                 'A',
//                 style: TextStyle(fontSize: 40.0, color: Colors.green),
//               ),
//             ),
//           ),
//           _buildDrawerItem(Icons.workspace_premium, 'Get Premium'),
//           _buildDrawerItem(Icons.account_balance, 'Bank Sync'),
//           _buildDrawerItem(Icons.home, 'Home', isSelected: true),
//           _buildDrawerItem(Icons.receipt_long, 'Records'),
//           _buildDrawerItem(Icons.trending_up, 'Investments', showNew: true),
//           _buildDrawerItem(Icons.analytics, 'Statistics'),
//           _buildDrawerItem(Icons.schedule, 'Planned payments'),
//           _buildDrawerItem(Icons.account_balance_wallet, 'Budgets'),
//           _buildDrawerItem(Icons.money_off, 'Debts'),
//           _buildDrawerItem(Icons.flag, 'Goals'),
//           _buildDrawerItem(Icons.business, 'Wallet for your business',
//               showNew: true),
//           _buildDrawerItem(Icons.shopping_cart, 'Shopping lists'),
//           _buildDrawerItem(Icons.security, 'Warranties'),
//           _buildDrawerItem(Icons.card_giftcard, 'Loyalty cards'),
//           _buildDrawerItem(Icons.currency_exchange, 'Currency rates'),
//           _buildDrawerItem(Icons.group, 'Group sharing'),
//           _buildDrawerItem(Icons.more_horiz, 'Others'),
//           Divider(),
//           SwitchListTile(
//             title: Text('Dark mode'),
//             value: _isDarkMode,
//             onChanged: (bool value) {
//               setState(() {
//                 _isDarkMode = value;
//               });
//             },
//           ),
//           SwitchListTile(
//             title: Text('Hide Amounts'),
//             value: _hideAmounts,
//             onChanged: (bool value) {
//               setState(() {
//                 _hideAmounts = value;
//               });
//             },
//           ),
//           Divider(),
//           _buildDrawerItem(Icons.person_add, 'Invite friends'),
//           _buildDrawerItem(Icons.favorite, 'Follow us'),
//           _buildDrawerItem(Icons.help, 'Help'),
//           _buildDrawerItem(Icons.settings, 'Settings'),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String title,
//       {bool isSelected = false, bool showNew = false}) {
//     return ListTile(
//       leading: Icon(icon, color: isSelected ? Colors.blue : null),
//       title: Text(title),
//       selected: isSelected,
//       trailing: showNew
//           ? Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 'New',
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             )
//           : null,
//       onTap: () {
//         Navigator.pop(context);
//       },
//     );
//   }

//   List<Widget> _buildDemoCards() {
//     return List.generate(5, (index) {
//       return Container(
//         width: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
//         child: Card(
//           margin: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.purple,
//                   Colors.blue,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Card ${index + 1}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Icon(Icons.credit_card, color: Colors.white),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   '**** **** **** ${(1000 + index).toString()}',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '\$${(10000 * (index + 1)).toStringAsFixed(2)}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   void _navigateToTransactions(FinancialAccount account) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TransactionsScreen(account: account),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.black),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//         title: const Text(
//           'Home',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       drawer: _buildDrawer(),
//       body: _buildBody(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.toggle_on),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _fetchAccounts,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: 200,
//             child: FlutterCarousel.builder(
//               itemCount: 5,
//               itemBuilder: (context, index, realIndex) {
//                 return _buildDemoCards()[index];
//               },
//               options: CarouselOptions(
//                 viewportFraction: 1.0,
//                 enlargeCenterPage: false,
//                 enableInfiniteScroll: true,
//                 padEnds: false,
//                 onPageChanged: (index, reason) {
//                   setState(() => _currentCardIndex = index);
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           if (_accounts.isNotEmpty)
//             RecentTransactionsList(
//               transactions: _getAllTransactions(),
//               onViewAll: () {
//                 // TODO: Navigate to all transactions
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   String _getLastFourDigits() {
//     if (_accounts.isEmpty) return '0000';
//     final firstAccount = _accounts.first;
//     final accountNumber = firstAccount.accountNumber;
//     if (accountNumber.length <= 4) return accountNumber.padLeft(4, '0');
//     return accountNumber.substring(accountNumber.length - 4);
//   }

//   double _calculateTotalBalance() {
//     return _accounts.fold(0.0, (sum, account) => sum + account.balance);
//   }

//   List<Transaction> _getAllTransactions() {
//     final allTransactions =
//         _accounts.expand((account) => account.transactions).toList();
//     allTransactions.sort((a, b) => b.date.compareTo(a.date));
//     return allTransactions;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../services/sms_parser_service.dart';
import '../services/localization_service.dart';
import '../widgets/enhanced_financial_account_card.dart';
import '../models/financial_account.dart';
import '../models/bank_type.dart';
import '../models/transaction_type.dart';
import '../models/transaction.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/summary_card.dart';
import '../widgets/recent_transactions_list.dart';
import './language_screen.dart';
import './transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _smsParser = SmsParserService();
  List<FinancialAccount> _accounts = [];
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;
  int _currentCardIndex = 0;
  bool _isDarkMode = false;
  bool _hideAmounts = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
                gradient:  LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text(
              'abenenzer kifle',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(
              'My Wallet',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Text(
                'A',
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
          ),
          _buildDrawerItem(Icons.workspace_premium, 'Get Premium'),
          _buildDrawerItem(Icons.account_balance, 'Bank Sync'),
          _buildDrawerItem(Icons.home, 'Home', isSelected: true),
          _buildDrawerItem(Icons.receipt_long, 'Records'),
          _buildDrawerItem(Icons.trending_up, 'Investments', showNew: true),
          _buildDrawerItem(Icons.analytics, 'Statistics'),
          _buildDrawerItem(Icons.schedule, 'Planned payments'),
          _buildDrawerItem(Icons.account_balance_wallet, 'Budgets'),
          _buildDrawerItem(Icons.money_off, 'Debts'),
          _buildDrawerItem(Icons.flag, 'Goals'),
          _buildDrawerItem(Icons.business, 'Wallet for your business',
              showNew: true),
                 const Divider(),
          _buildDrawerItem(Icons.shopping_cart, 'Shopping lists'),
          _buildDrawerItem(Icons.security, 'Warranties'),
          _buildDrawerItem(Icons.card_giftcard, 'Loyalty cards'),
          _buildDrawerItem(Icons.currency_exchange, 'Currency rates'),
          _buildDrawerItem(Icons.group, 'Group sharing'),
          _buildDrawerItem(Icons.more_horiz, 'Others'),
          const Divider(),
          SwitchListTile(
            title: Text('Dark mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Hide Amounts'),
            value: _hideAmounts,
            onChanged: (bool value) {
              setState(() {
                _hideAmounts = value;
              });
            },
          ),
          Divider(),
          _buildDrawerItem(Icons.person_add, 'Invite friends'),
          _buildDrawerItem(Icons.favorite, 'Follow us'),
          _buildDrawerItem(Icons.help, 'Help'),
          _buildDrawerItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,
      {bool isSelected = false, bool showNew = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: Text(title),
      selected: isSelected,
      trailing: showNew
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'New',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
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
              gradient:const  LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card ${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.credit_card, color: Colors.white),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '**** **** **** ${(1000 + index).toString()}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$${(10000 * (index + 1)).toStringAsFixed(2)}',
                  style: TextStyle(
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

  void _navigateToTransactions(FinancialAccount account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionsScreen(account: account),
      ),
    );
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                padding: EdgeInsets.all(12),
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
              SizedBox(height: 8),
              Text(
                menuItems[index]['label'],
                textAlign: TextAlign.center,
                style: TextStyle(
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

  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {'icon': Icons.swap_horiz, 'label': 'Transfer'},
      {'icon': Icons.request_page, 'label': 'Request'},
      {'icon': Icons.qr_code_scanner, 'label': 'Scan'},
      {'icon': Icons.sync_alt, 'label': 'Swap'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    actions[index]['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  actions[index]['label'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
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
            
            const SizedBox(height: 20),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toggle_on),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  String _getLastFourDigits() {
    if (_accounts.isEmpty) return '0000';
    final firstAccount = _accounts.first;
    final accountNumber = firstAccount.accountNumber;
    if (accountNumber.length <= 4) return accountNumber.padLeft(4, '0');
    return accountNumber.substring(accountNumber.length - 4);
  }

  double _calculateTotalBalance() {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  List<Transaction> _getAllTransactions() {
    final allTransactions =
        _accounts.expand((account) => account.transactions).toList();
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }
}

