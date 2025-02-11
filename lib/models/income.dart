import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 4)
class Income {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String category;

  Income({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}