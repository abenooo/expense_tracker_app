import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onViewAll;

  const RecentTransactionsList({
    Key? key,
    required this.transactions,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.take(5).length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                _getTransactionTitle(transaction),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _getTransactionSubtitle(transaction),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              trailing: Text(
                _formatAmount(transaction),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: transaction.type == TransactionType.withdrawal 
                      ? Colors.red 
                      : Colors.green,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getTransactionTitle(Transaction transaction) {
    final description = transaction.description.toLowerCase();
    if (description.contains('uber')) return 'Uber';
    if (description.contains('nescafe')) return 'Nescafe';
    if (description.contains('chicken')) return 'Tasty Fried Chicken';
    return 'Transaction';
  }

  String _getTransactionSubtitle(Transaction transaction) {
    if (transaction.description.toLowerCase().contains('transfer')) {
      return 'Transfer';
    }
    return 'Debit Card';
  }

  String _formatAmount(Transaction transaction) {
    final prefix = transaction.type == TransactionType.withdrawal ? '-' : '+';
    return '$prefix\$${transaction.amount.toStringAsFixed(2)}';
  }
}

