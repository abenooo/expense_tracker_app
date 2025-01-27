import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';

part 'utility.g.dart';

@HiveType(typeId: 1)
class Utility extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late DateTime startDate;

  @HiveField(4)
  late DateTime endDate;

  @HiveField(5)
  late double amount;

  @HiveField(6)
  late bool isPaid;

  @HiveField(7)
  late String iconName;

  @HiveField(8)
  late String logoPath;

  Utility({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.iconName,
    this.logoPath = '',
    this.isPaid = false,
  });
}

