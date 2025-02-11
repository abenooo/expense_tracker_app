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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          final now = DateTime.now();
          final periodExpenses = _getExpensesForCurrentPeriod(expenseProvider, now);

          return Column(
            children: [
              // Sticky Header Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red,
                child: Column(
                  children: [
                    _buildPeriodSelector(),
                    const SizedBox(height: 20),
                    _buildMetricCard(
                      'Total Expenses',
                      'ETB ${_calculateTotal(periodExpenses).toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Expense Frequency'),
                    const SizedBox(height: 10),
                    _buildExpenseChart(periodExpenses),
                  ],
                ),
              ),

              // Scrollable List Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSectionTitle('Recent Transactions'),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _buildRecentTransactions(expenseProvider.expenses),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
        ),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPeriodButton('Week'),
          _buildPeriodButton('Month'),
          _buildPeriodButton('Year'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    return GestureDetector(
      onTap: () => setState(() => _currentPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _currentPeriod == period ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: _currentPeriod == period ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                )),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ],
    );
  }

  Widget _buildExpenseChart(List<Expense> expenses) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          barGroups: _createBarGroups(expenses, _currentPeriod),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  _getBarLabel(value.toInt(), _currentPeriod),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List<Expense> expenses) {
    return ListView.separated(
      itemCount: expenses.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
      itemBuilder: (context, index) => _buildTransactionItem(expenses[index]),
    );
  }

  Widget _buildTransactionItem(Expense expense) {
    final categoryIcons = {
      'Food': Icons.restaurant,
      'Transport': Icons.directions_car,
      'Bills': Icons.receipt,
      'Other': Icons.category,
    };

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            categoryIcons[expense.category] ?? Icons.category,
            color: Colors.red,
          ),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(expense.category),
        trailing: Text('-ETB ${expense.amount.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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

  double _getMaxExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return 100;
    return expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.2;
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
