// [file name]: reports_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/income_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/saving_goals_provider.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _currentPeriod = 'Month';
  final List<Color> _chartColors = [
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Report', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
    body: Consumer<IncomeProvider>(
  builder: (context, incomeProvider, _) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, _) {
        return Consumer<SavingGoalsProvider>(
          builder: (context, savingsProvider, _) {
            // Add these:
            final income = _calculateTotal(incomeProvider.incomes);
            final expenses = _calculateTotal(expenseProvider.expenses);
            final savings = 10000;
            final loans = 4000; // Update this to get from your LoansProvider
            final debts = 1000; // Update this to get from your DebtsProvider
            final netIncome = income - expenses - loans - debts;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 20),
                  _buildSummaryGrid(
                    netIncome.toDouble(), 
                    income.toDouble(), 
                    expenses.toDouble(), 
                    loans.toDouble(), 
                    debts.toDouble(), 
                    savings.toDouble()
                  ),
                  // const SizedBox(height: 20),
                  _buildFinancialChart(income, expenses),
                ],
              ),
            );
          },
        );
      },
    );
  },
    ));

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
        children: ['Week', 'Month', 'Year'].map((period) {
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
                  color: _currentPeriod == period ? Colors.purple : Colors.black,
                  fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryGrid(double net, double income, double expenses, double loans, double debts, double savings) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildSummaryCard('Net Income', net, Colors.purple),
        _buildSummaryCard('Total Income', income, Colors.green),
        _buildSummaryCard('Total Expenses', expenses, Colors.red),
        _buildSummaryCard('Total Savings', savings, Colors.blue),
        _buildSummaryCard('Total Loans', loans, Colors.orange),
        _buildSummaryCard('Total Debts', debts, Colors.red),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('ETB ${value.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialChart(double income, double expenses) {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: income,
              color: Colors.green,
              title: 'Income\n${_percentage(income, income + expenses)}%',
              radius: 60,
              titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: expenses,
              color: Colors.red,
              title: 'Expenses\n${_percentage(expenses, income + expenses)}%',
              radius: 50,
              titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
           
          ],
          centerSpaceRadius: 40,
          sectionsSpace: 4,
        ),
      ),
    );
  }

  
  double _calculateTotal(List<dynamic> items) {
    return items.fold(0.0, (sum, item) => sum + item.amount);
  }

  String _percentage(double value, double total) {
    if (total == 0) return '0';
    return ((value / total) * 100).toStringAsFixed(1);
  }
}