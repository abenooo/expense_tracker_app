import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'saving_goal.g.dart';

@HiveType(typeId: 2)
class SavingGoal extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double targetAmount;
  
  @HiveField(4)
  double currentAmount;
  
  @HiveField(5)
  final DateTime targetDate;
  
  @HiveField(6)
  final DateTime createdAt;

  SavingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.description = '',
  }) : createdAt = DateTime.now();

  double get progress => currentAmount / targetAmount;
  double get remainingAmount => targetAmount - currentAmount;
  
  String get formattedTargetAmount =>
      NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2).format(targetAmount);
  
  String get formattedCurrentAmount =>
      NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2).format(currentAmount);
  
  String get formattedRemainingAmount =>
      NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2).format(remainingAmount);
  
  String get formattedTargetDate => DateFormat.yMMMd().format(targetDate);

  SavingGoal copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}