// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../providers/income_provider.dart';
// import '../models/income.dart';

// class AddIncomeScreen extends StatefulWidget {
//   @override
//   _AddIncomeScreenState createState() => _AddIncomeScreenState();
// }

// class _AddIncomeScreenState extends State<AddIncomeScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   String _selectedCategory = 'Salary';

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       final newIncome = Income(
//         title: _titleController.text,
//         amount: double.parse(_amountController.text),
//         date: _selectedDate,
//         category: _selectedCategory,
//       );

//       Provider.of<IncomeProvider>(context, listen: false).addIncome(newIncome);
//       Navigator.of(context).pop();
//     }
//   }

//   void _presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     ).then((pickedDate) {
//       if (pickedDate != null) {
//         setState(() {
//           _selectedDate = pickedDate;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Income'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Title'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _amountController,
//                 decoration: InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter an amount';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               DropdownButtonFormField(
//                 value: _selectedCategory,
//                 items: ['Salary', 'Bonus', 'Investment', 'Other']
//                     .map((category) => DropdownMenuItem(
//                           value: category,
//                           child: Text(category),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value.toString();
//                   });
//                 },
//                 decoration: InputDecoration(labelText: 'Category'),
//               ),
//               Row(
//                 children: [
//                   Text('Date: ${DateFormat.yMd().format(_selectedDate)}'),
//                   TextButton(
//                     onPressed: _presentDatePicker,
//                     child: Text('Choose Date'),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: Text('Add Income'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/income_provider.dart';
import '../models/income.dart';

class AddIncomeScreen extends StatefulWidget {
  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Salary';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newIncome = Income(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
      );

      Provider.of<IncomeProvider>(context, listen: false).addIncome(newIncome);
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Income', style: TextStyle(color: Colors.white)),
        // backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (ETB)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField(
                value: _selectedCategory,
                items: ['Salary', 'Bonus', 'Investment', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              Row(
                children: [
                  Text(
                    'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child:const Text(
                      'Choose Date',
                      style:  TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Income',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}