import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/income_provider.dart';
import '../models/income.dart';
import 'add_income_screen.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String _currentPeriod = 'Week'; // Default period

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Income Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {
              // Navigate to report screen if needed
            },
          ),
        ],
      ),
      body: Consumer<IncomeProvider>(
        builder: (context, incomeProvider, child) {
          final now = DateTime.now();
          final periodIncomes =
              _getIncomesForCurrentPeriod(incomeProvider, now);

          return Column(
            children: [
              // Sticky Section: Income Card and Graph
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    // Period Selector
                    _buildPeriodSelector(),
                    const SizedBox(height: 10),

                    // Income Metric Card
                    _buildMetricCard('Total Income',
                        'ETB ${_calculateTotal(periodIncomes).toStringAsFixed(0)}'),
                    // const SizedBox(height: -5),

                    // Income Frequency Graph
                    _buildSectionTitle('Income Frequency'),
                    const SizedBox(height: 10),
                    _buildIncomeChart(periodIncomes),
                  ],
                ),
              ),

              // Scrollable Section: All Incomes List
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSectionTitle('All Incomes'),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _buildRecentTransactions(incomeProvider.incomes),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIncomeScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // Period Selector
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

  // Period Button
  Widget _buildPeriodButton(String period) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _currentPeriod == period ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: _currentPeriod == period ? Colors.deepPurple : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Income Metric Card
  Widget _buildMetricCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        // height: 200,
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Colors.purple, Color.fromARGB(255, 146, 143, 97)],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // const  Icon(Icons.attach_money, size: 40, color: Colors.red),
            // const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
        ),
      ],
    );
  }

  // Income Chart
  Widget _buildIncomeChart(List<Income> incomes) {
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
          barGroups: _createBarGroups(incomes, _currentPeriod),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _getBarLabel(value.toInt(), _currentPeriod),
                    style:
                        const TextStyle(fontSize: 12, color: Colors.deepPurple),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style:
                        const TextStyle(fontSize: 12, color: Colors.deepPurple),
                  );
                },
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

  // Recent Incomes List
  Widget _buildRecentTransactions(List<Income> incomes) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: incomes.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final income = incomes[index];
        return _buildTransactionItem(income);
      },
    );
  }

  // Transaction Item
  Widget _buildTransactionItem(Income income) {
    final categoryIcons = {
      'Salary': Icons.work,
      'Bonus': Icons.attach_money,
      'Investment': Icons.trending_up,
      'Other': Icons.category,
    };

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            categoryIcons[income.category] ?? Icons.category,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(income.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(income.category),
        trailing: Text(
          '+ETB ${income.amount.toStringAsFixed(0)}',
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Get Incomes for the Selected Period
  List<Income> _getIncomesForCurrentPeriod(
      IncomeProvider provider, DateTime now) {
    switch (_currentPeriod) {
      case 'Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return provider.getIncomesForPeriod(startOfWeek, now);
      case 'Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        return provider.getIncomesForPeriod(startOfMonth, now);
      case 'Year':
        final startOfYear = DateTime(now.year, 1, 1);
        return provider.getIncomesForPeriod(startOfYear, now);
      default:
        return [];
    }
  }

  // Calculate Total Income for the Period
  double _calculateTotal(List<Income> incomes) {
    return incomes.fold(0, (sum, income) => sum + income.amount);
  }

  // Create Bar Groups for the Graph
  List<BarChartGroupData> _createBarGroups(
      List<Income> incomes, String period) {
    final now = DateTime.now();
    final groups = <BarChartGroupData>[];

    switch (period) {
      case 'Week':
        for (int i = 0; i < 7; i++) {
          final day = now.subtract(Duration(days: now.weekday - 1 - i));
          final dayIncomes = incomes
              .where((e) => e.date.day == day.day && e.date.month == day.month)
              .toList();
          groups.add(_createBarGroup(i, dayIncomes));
        }
        break;
      case 'Month':
        for (int i = 0; i < now.day; i++) {
          final day = DateTime(now.year, now.month, i + 1);
          final dayIncomes =
              incomes.where((e) => e.date.day == day.day).toList();
          groups.add(_createBarGroup(i, dayIncomes));
        }
        break;
      case 'Year':
        for (int i = 0; i < 12; i++) {
          final month = DateTime(now.year, i + 1);
          final monthIncomes =
              incomes.where((e) => e.date.month == month.month).toList();
          groups.add(_createBarGroup(i, monthIncomes));
        }
        break;
    }

    return groups;
  }

  // Create a Single Bar Group
  BarChartGroupData _createBarGroup(int x, List<Income> incomes) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: incomes.fold(0, (sum, e) => sum + e.amount),
          color: Colors.deepPurple,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Get Bar Label for the X-Axis
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
