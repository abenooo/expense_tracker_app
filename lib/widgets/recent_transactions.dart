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

  Widget _buildTransactionIcon(Transaction transaction) {
    Color backgroundColor;
    IconData icon;
    Color iconColor;

    if (transaction.description.toLowerCase().contains('shopping')) {
      backgroundColor = Colors.orange.shade100;
      icon = Icons.shopping_bag;
      iconColor = Colors.orange;
    } else if (transaction.description.toLowerCase().contains('subscription')) {
      backgroundColor = Colors.purple.shade100;
      icon = Icons.subscriptions;
      iconColor = Colors.purple;
    } else if (transaction.description.toLowerCase().contains('food')) {
      backgroundColor = Colors.red.shade100;
      icon = Icons.restaurant;
      iconColor = Colors.red;
    } else if (transaction.description.toLowerCase().contains('salary')) {
      backgroundColor = Colors.green.shade100;
      icon = Icons.account_balance_wallet;
      iconColor = Colors.green;
    } else if (transaction.description.toLowerCase().contains('transport')) {
      backgroundColor = Colors.blue.shade100;
      icon = Icons.directions_car;
      iconColor = Colors.blue;
    } else {
      backgroundColor = Colors.grey.shade100;
      icon = Icons.attach_money;
      iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final transactionDate = DateTime(date.year, date.month, date.day);

    String headerText;
    if (transactionDate == DateTime(now.year, now.month, now.day)) {
      headerText = 'Today';
    } else if (transactionDate == yesterday) {
      headerText = 'Yesterday';
    } else {
      headerText = DateFormat('MMMM d').format(date);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        headerText,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in _filteredTransactions) {
      final date = DateFormat('yyyy-MM-dd').format(transaction.date);
      groupedTransactions.putIfAbsent(date, () => []);
      groupedTransactions[date]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              DropdownButton<String>(
                value: 'Month',
                items: ['Month'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterSheet,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Navigate to financial report
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'See your financial report',
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.purple.shade700,
                ),
              ],
            ),
          ),
        ),
        for (String date in sortedDates) ...[
          _buildDateHeader(DateTime.parse(date)),
          ...groupedTransactions[date]!.map((transaction) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: _buildTransactionIcon(transaction),
            title: Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            trailing: Text(
              '${transaction.type == TransactionType.withdrawal ? "- " : "+ "}${transaction.formattedAmount}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: transaction.type == TransactionType.withdrawal
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          )),
        ],
      ],
    );
  }
}

