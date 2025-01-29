import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/saving_goal.dart';
import '../providers/saving_goals_provider.dart';
import '../widgets/scrollable_goal_card.dart';
class SavingScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin? notificationsPlugin;
  
  const SavingScreen({
    super.key,
    required this.notificationsPlugin,
  });

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Savings Goal'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Name',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _targetAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount (ETB)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Target Date'),
                  subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                  onTap: () => _selectDate(context),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _createNewGoal,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createNewGoal() {
    if (_formKey.currentState!.validate()) {
      final newGoal = SavingGoal(
        id: const Uuid().v4(),
        name: _nameController.text,
        targetAmount: double.parse(_targetAmountController.text),
        currentAmount: 0,
        targetDate: _selectedDate,
        description: _descriptionController.text,
      );
      
      context.read<SavingGoalsProvider>().addGoal(newGoal);
      Navigator.pop(context);
      _clearForm();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _targetAmountController.clear();
    _descriptionController.clear();
    setState(() => _selectedDate = DateTime.now().add(const Duration(days: 30)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavingGoalsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Savings Goals'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddGoalDialog,
                tooltip: 'Add New Goal',
              ),
            ],
          ),
          body: provider.goals.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.goals.length,
                  itemBuilder: (context, index) => ScrollableGoalCard(
                    goal: provider.goals[index],
                    onDelete: _confirmDelete,
                    onAddFunds: _showAddFundsDialog,
                  ),
                ),
        );
      },
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.savings, size: 80, color: Colors.purple.shade200),
          const SizedBox(height: 20),
          Text(
            'No Savings Goals Yet!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.purple.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Start by creating your first savings goal'),
        ],
      ),
    );
  }

  Widget _buildGoalCard(SavingGoal goal) {
    final progress = goal.progress.clamp(0.0, 1.0);
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(goal.id),
                ),
              ],
            ),
            if (goal.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(goal.description),
              ),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}% Completed',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${daysRemaining}d remaining',
                      style: TextStyle(
                        color: daysRemaining < 30 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${goal.formattedCurrentAmount} / ${goal.formattedTargetAmount}',
                    ),
                    Text(
                      '${goal.formattedRemainingAmount} to go',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddFundsDialog(goal.id),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Funds'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFundsDialog(String goalId) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Funds'),
        content: TextFormField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (ETB)',
            prefixIcon: Icon(Icons.attach_money),
          ),
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                final amount = double.parse(amountController.text);
                context.read<SavingGoalsProvider>().addToGoal(goalId, amount);
                Navigator.pop(context);
                _showSuccessNotification(amount);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSuccessNotification(double amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ETB ${amount.toStringAsFixed(2)} to your goal'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _confirmDelete(String goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: const Text('This action cannot be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SavingGoalsProvider>().deleteGoal(goalId);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}