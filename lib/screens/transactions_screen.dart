import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/financial_account.dart';
import '../models/transaction_type.dart';
import '../services/localization_service.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  final FinancialAccount account;

  const TransactionsScreen({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.translate('Transactions')),
      ),
      body: account.transactions.isEmpty
          ? Center(
              child: Text(
                localizationService.translate('No transactions found'),
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: account.transactions.length,
              itemBuilder: (context, index) {
                final transaction = account.transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction.type == TransactionType.deposit
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        transaction.type == TransactionType.deposit
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      transaction.description,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(DateFormat('MMM d, y HH:mm').format(transaction.date)),
                    trailing: Text(
                      '${transaction.type == TransactionType.deposit ? '+' : '-'} ETB ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: transaction.type == TransactionType.deposit
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

