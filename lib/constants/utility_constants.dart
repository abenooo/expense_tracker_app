import 'package:flutter/material.dart';
import '../models/utility.dart';

class UtilityConstants {
  static List<Utility> defaultUtilities = [
    Utility(
      id: 'electric',
      name: 'Ethiopian Electric Utility',
      description: 'Ethiopian Electric Utility Bill Payment',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      amount: 0,
      iconName: 'electric_bolt',
      logoPath: 'assets/logos/eeu_logo.png',
    ),
    Utility(
      id: 'telecom',
      name: 'Ethio-Telecom Post-Paid',
      description: 'Ethio-Telecom Post-Paid Bill Payment',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      amount: 0,
      iconName: 'phone_android',
      logoPath: 'assets/logos/ethio_telecom_logo.png',
    ),
    Utility(
      id: 'water',
      name: 'Addis Ababa Water Bill',
      description: 'Pay Addis Ababa Water Bill Payment',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      amount: 0,
      iconName: 'water_drop',
      logoPath: 'assets/logos/aawsa_logo.png',
    ),
    Utility(
      id: 'internet',
      name: 'Internet Service',
      description: 'Internet Service Bill Payment',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      amount: 0,
      iconName: 'wifi',
      logoPath: 'assets/logos/internet_logo.png',
    ),
    Utility(
      id: 'dstv',
      name: 'DSTV Subscription',
      description: 'DSTV Monthly Subscription Payment',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      amount: 0,
      iconName: 'tv',
      logoPath: 'assets/logos/dstv_logo.png',
    ),
  ];

  static Map<String, IconData> availableIcons = {
    'electric_bolt': Icons.electric_bolt,
    'water_drop': Icons.water_drop,
    'wifi': Icons.wifi,
    'phone_android': Icons.phone_android,
    'tv': Icons.tv,
    'house': Icons.house,
    'shopping_cart': Icons.shopping_cart,
    'school': Icons.school,
    'medical_services': Icons.medical_services,
    'directions_car': Icons.directions_car,
  };
}

