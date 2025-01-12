import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import 'transaction_filter_sheet.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final VoidCallback onViewAll;

  const RecentTransactionsList({
    Key? key,
    required this.transactions,
    required this.onViewAll,
  }) : super(key: key);

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList> {
  FilterType? _currentFilter;
  SortType? _currentSort;
  List<Transaction> _filteredTransactions = [];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(widget.transactions);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterSheet(
        onFilterChanged: (filter) {
          setState(() => _currentFilter = filter);
        },
        onSortChanged: (sort) {
          setState(() => _currentSort = sort);
        },
        onReset: () {
          setState(() {
            _currentFilter = null;
            _currentSort = null;
            _filteredTransactions = List.from(widget.transactions);
          });
        },
        onApply: () {
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _applyFilters() {
    List<Transaction> filtered = List.from(widget.transactions);

    // Apply time period filter based on selected tab
    final now = DateTime.now();
    filtered = filtered.where((t) {
      switch (_selectedTabIndex) {
        case 0: // Today
          return t.date.year == now.year && 
                 t.date.month == now.month && 
                 t.date.day == now.day;
        case 1: // Week
          final weekAgo = now.subtract(const Duration(days: 7));
          return t.date.isAfter(weekAgo);
        case 2: // Month
          return t.date.year == now.year && t.date.month == now.month;
        case 3: // Year
          return t.date.year == now.year;
        default:
          return true;
      }
    }).toList();

    // Apply type filter
    if (_currentFilter != null) {
      filtered = filtered.where((t) {
        switch (_currentFilter!) {
          case FilterType.income:
            return t.type == TransactionType.deposit;
          case FilterType.expense:
            return t.type == TransactionType.withdrawal;
          case FilterType.transfer:
            return t.description.toLowerCase().contains('transfer');
        }
      }).toList();
    }

    // Apply sort
    if (_currentSort != null) {
      switch (_currentSort!) {
        case SortType.highest:
          filtered.sort((a, b) => b.amount.compareTo(a.amount));
          break;
        case SortType.lowest:
          filtered.sort((a, b) => a.amount.compareTo(b.amount));
          break;
        case SortType.newest:
          filtered.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SortType.oldest:
          filtered.sort((a, b) => a.date.compareTo(b.date));
          break;
      }
    }

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  Widget _buildTimePeriodTabs() {
    final tabs = ['Today', 'Week', 'Month', 'Year'];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
                _applyFilters();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.orange.shade700 : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;

    if (transaction.description.toLowerCase().contains('shopping')) {
      icon = Icons.shopping_bag_outlined;
      iconColor = Colors.orange;
      backgroundColor = Colors.orange.shade50;
    } else if (transaction.description.toLowerCase().contains('subscription')) {
      icon = Icons.subscriptions_outlined;
      iconColor = Colors.purple;
      backgroundColor = Colors.purple.shade50;
    } else if (transaction.description.toLowerCase().contains('food')) {
      icon = Icons.restaurant_outlined;
      iconColor = Colors.pink;
      backgroundColor = Colors.pink.shade50;
    } else {
      icon = Icons.account_balance_wallet_outlined;
      iconColor = Colors.blue;
      backgroundColor = Colors.blue.shade50;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  transaction.description,
                  style: TextStyle(
                    fontSize: 13,
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
                '${transaction.type == TransactionType.withdrawal ? "- " : "+ "}${transaction.formattedAmount}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: transaction.type == TransactionType.withdrawal
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(transaction.date),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimePeriodTabs(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: widget.onViewAll,
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.purple.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_filteredTransactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No transactions found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredTransactions.length,
            itemBuilder: (context, index) => _buildTransactionItem(_filteredTransactions[index]),
          ),
      ],
    );
  }
}

