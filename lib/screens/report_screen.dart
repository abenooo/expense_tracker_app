// // report_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../providers/expense_provider.dart';
// import '../models/expense.dart';
// class ReportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final expenseProvider = Provider.of<ExpenseProvider>(context);
//     final now = DateTime.now();
//     final monthlyExpenses = expenseProvider.getExpensesForPeriod(
//       DateTime(now.year, now.month, 1),
//       now,
//     );

//     final categoryTotals = _calculateCategoryTotals(monthlyExpenses);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Financial Report'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildMonthSelector(),
//             SizedBox(height: 20),
//             _buildTotalCard('Expense', _calculateTotal(monthlyExpenses)),
//             SizedBox(height: 20),
//             Text('Category Breakdown', style: Theme.of(context).textTheme.titleLarge),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: categoryTotals.length,
//                 itemBuilder: (context, index) {
//                   final category = categoryTotals.keys.elementAt(index);
//                   final total = categoryTotals[category]!;
//                   return _buildCategoryItem(category, total);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMonthSelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           DateFormat('MMMM y').format(DateTime.now()),
//           style: const  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const Icon(Icons.arrow_drop_down),
//       ],
//     );
//   }

//   Widget _buildTotalCard(String label, double amount) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
//             SizedBox(height: 8),
//             Text(
//               NumberFormat.currency(symbol: 'ETB ').format(amount),
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryItem(String category, double amount) {
//     final categoryIcons = {
//       'Food': Icons.restaurant,
//       'Transport': Icons.directions_car,
//       'Entertainment': Icons.movie,
//       'Bills': Icons.receipt,
//       'Other': Icons.category,
//     };

//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(categoryIcons[category] ?? Icons.category, color: Colors.blue),
//       ),
//       title: Text(category),
//       trailing: Text(
//         '-${NumberFormat.currency(symbol: 'ETB ').format(amount)}',
//         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Map<String, double> _calculateCategoryTotals(List<Expense> expenses) {
//     final Map<String, double> totals = {};
//     for (var expense in expenses) {
//       totals.update(
//         expense.category,
//         (value) => value + expense.amount,
//         ifAbsent: () => expense.amount,
//       );
//     }
//     return totals;
//   }

//   double _calculateTotal(List<Expense> expenses) {
//     return expenses.fold(0, (sum, expense) => sum + expense.amount);
//   }
// }
// report_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _currentPeriod = 'Monthly';

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final now = DateTime.now();
    List<Expense> periodExpenses;

    switch (_currentPeriod) {
      case 'Daily':
        periodExpenses = expenseProvider.getExpensesForPeriod(now, now);
        break;
      case 'Weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        periodExpenses = expenseProvider.getExpensesForPeriod(startOfWeek, now);
        break;
      case 'Monthly':
        final startOfMonth = DateTime(now.year, now.month, 1);
        periodExpenses = expenseProvider.getExpensesForPeriod(startOfMonth, now);
        break;
      case 'Yearly':
        final startOfYear = DateTime(now.year, 1, 1);
        periodExpenses = expenseProvider.getExpensesForPeriod(startOfYear, now);
        break;
      default:
        periodExpenses = [];
    }

    final categoryTotals = _calculateCategoryTotals(periodExpenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            SizedBox(height: 20),
            _buildTotalCard('Expense', _calculateTotal(periodExpenses)),
            SizedBox(height: 20),
            Text('Category Breakdown', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: categoryTotals.length,
                itemBuilder: (context, index) {
                  final category = categoryTotals.keys.elementAt(index);
                  final total = categoryTotals[category]!;
                  return _buildCategoryItem(category, total);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM y').format(DateTime.now()),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: _currentPeriod,
          onChanged: (String? newValue) {
            setState(() {
              _currentPeriod = newValue!;
            });
          },
          items: <String>['Daily', 'Weekly', 'Monthly', 'Yearly']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTotalCard(String label, double amount) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Text(
              NumberFormat.currency(symbol: 'ETB ').format(amount),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category, double amount) {
    final categoryIcons = {
      'Food': Icons.restaurant,
      'Transport': Icons.directions_car,
      'Entertainment': Icons.movie,
      'Bills': Icons.receipt,
      'Other': Icons.category,
    };

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(categoryIcons[category] ?? Icons.category, color: Colors.blue),
      ),
      title: Text(category),
      trailing: Text(
        '-${NumberFormat.currency(symbol: 'ETB ').format(amount)}',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  Map<String, double> _calculateCategoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (var expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}