import 'package:ethiopian_bank_tracker/screens/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String _currentPeriod = 'Week';

  @override
// expense_screen.dart
// Update the build method with this new design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final now = DateTime.now();
          final periodExpenses =
              _getExpensesForCurrentPeriod(expenseProvider, now);
          final recentExpenses = expenseProvider.expenses.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Income', 'ETB 30000')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildMetricCard('Expense',
                            'ETB ${_calculateTotal(periodExpenses).toStringAsFixed(0)}')),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Spend Frequency'),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups:
                          _createBarGroups(periodExpenses, _currentPeriod),
                      // Add other bar chart configurations as needed
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildRecentTransactions(recentExpenses),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
// Widget _buildBalanceCard() {
//   return Card(
//     elevation: 4,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//     child: Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           Text('Account Balance', style: TextStyle(color: Colors.grey)),
//           SizedBox(height: 10),
//           Text(
//             'ETB 9400',
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     ),
//   );
// }

  Widget _buildMetricCard(String title, String value) {
    String imagePath;
    Color backgroundColor;
    if (title == 'Income') {
      imagePath = 'asset/IncomeIcon.png'; // Path to the income icon
      backgroundColor = Colors.green; // Green background for income
    } else if (title == 'Expense') {
      imagePath = 'asset/ExpensesIcon.png'; // Path to the expense icon
      backgroundColor = Colors.red; // Red background for expense
    } else {
      imagePath = ''; // Default empty path
      backgroundColor = Colors.grey; // Default background color
    }
    return Card(
      elevation: 2,
      color: backgroundColor, // Set the background color of the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the image if the path is not empty
            if (imagePath.isNotEmpty)
              Image.asset(
                imagePath,
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                // color: Colors.white, // Set icon color to white for better visibility
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white, // White text for better contrast
                fontSize: 16, // Customize the text size
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for better contrast
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: Text('See All'),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(List<Expense> expenses) {
    return Column(
      children: [
        _buildSectionTitle('Recent Transaction'),
        SizedBox(height: 10),
        ...expenses.map((expense) => _buildTransactionItem(expense)).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Expense expense) {
    final categoryIcons = {
      'Food': Icons.restaurant,
      'Drink': Icons.local_drink,
      'Shopping': Icons.shopping_bag,
      'House': Icons.house,
      'Clothes': Icons.checkroom,
      'Travel': Icons.airplanemode_active,
      'Health': Icons.health_and_safety,
      'Transport': Icons.directions_car,
      'Entertainment': Icons.movie,
      'Bills': Icons.receipt,
      'Other': Icons.category,
    };

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(categoryIcons[expense.category] ?? Icons.category,
              color: Colors.blue),
        ),
        title: Text(expense.title),
        subtitle: Text(expense.category),
        trailing: Text(
          '-ETB ${expense.amount.toStringAsFixed(0)}',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Expense> _getExpensesForCurrentPeriod(
      ExpenseProvider provider, DateTime now) {
    switch (_currentPeriod) {
      case 'Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return provider.getExpensesForPeriod(startOfWeek, now);
      case 'Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        return provider.getExpensesForPeriod(startOfMonth, now);
      case 'Year':
        final startOfYear = DateTime(now.year, 1, 1);
        return provider.getExpensesForPeriod(startOfYear, now);
      default:
        return [];
    }
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  List<BarChartGroupData> _createBarGroups(
      List<Expense> expenses, String period) {
    final now = DateTime.now();
    final groups = <BarChartGroupData>[];

    switch (period) {
      case 'Week':
        for (int i = 0; i < 7; i++) {
          final day = now.subtract(Duration(days: now.weekday - 1 - i));
          final dayExpenses = expenses
              .where((e) => e.date.day == day.day && e.date.month == day.month)
              .toList();
          groups.add(_createBarGroup(i, dayExpenses));
        }
        break;
      case 'Month':
        for (int i = 0; i < now.day; i++) {
          final day = DateTime(now.year, now.month, i + 1);
          final dayExpenses =
              expenses.where((e) => e.date.day == day.day).toList();
          groups.add(_createBarGroup(i, dayExpenses));
        }
        break;
      case 'Year':
        for (int i = 0; i < 12; i++) {
          final month = DateTime(now.year, i + 1);
          final monthExpenses =
              expenses.where((e) => e.date.month == month.month).toList();
          groups.add(_createBarGroup(i, monthExpenses));
        }
        break;
    }

    return groups;
  }

  BarChartGroupData _createBarGroup(int x, List<Expense> expenses) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: expenses.fold(0, (sum, e) => sum + e.amount),
          color: Theme.of(context).primaryColor,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  String _getBarLabel(int value, String period) {
    final now = DateTime.now();
    switch (period) {
      case 'Week':
        final day = now.subtract(Duration(days: now.weekday - 1 - value));
        return DateFormat('E').format(day);
      case 'Month':
        return (value + 1).toString();
      case 'Year':
        return DateFormat('MMM').format(DateTime(now.year, value + 1));
      default:
        return '';
    }
  }
}
