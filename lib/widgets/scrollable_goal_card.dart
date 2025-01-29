import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/saving_goal.dart';

class ScrollableGoalCard extends StatelessWidget {
  final SavingGoal goal;
  final Function(String) onDelete;
  final Function(String) onAddFunds;

  const ScrollableGoalCard({
    Key? key,
    required this.goal,
    required this.onDelete,
    required this.onAddFunds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    goal.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(goal.id),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                  const SizedBox(width: 16),
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
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onAddFunds(goal.id),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Funds'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

