import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/utility.dart';
import '../services/utility_service.dart';
import '../constants/utility_constants.dart';
import 'utility_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UtilityScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const UtilityScreen({Key? key, required this.notificationsPlugin})
      : super(key: key);

  @override
  _UtilityScreenState createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {
  late final UtilityService _utilityService;
  late Future<List<Utility>> _utilitiesFuture;

  @override
  void initState() {
    super.initState();
    _utilityService = UtilityService(widget.notificationsPlugin);
    _utilitiesFuture = _initializeAndLoadUtilities();
  }

  Future<List<Utility>> _initializeAndLoadUtilities() async {
    await _utilityService.initializeDefaultUtilities();
    return _utilityService.getUtilities();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Select'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _utilitiesFuture = _initializeAndLoadUtilities();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Utility>>(
        future: _utilitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No utilities found.'));
          } else {
            final utilities = snapshot.data!;
            return ListView.separated(
              itemCount: utilities.length + 1,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == utilities.length) {
                  return _buildAddNewButton();
                }
                return _buildUtilityItem(utilities[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildUtilityItem(Utility utility) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UtilityDetailScreen(
                utility: utility,
                notificationsPlugin: widget.notificationsPlugin,
                onUpdate: () {
                  setState(() {
                    _utilitiesFuture = _initializeAndLoadUtilities();
                  });
                },
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  UtilityConstants.availableIcons[utility.iconName] ??
                      Icons.help_outline,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      utility.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      utility.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewButton() {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => _showUtilityDialog(null),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 16),
              const Text(
                'Add New Utility',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUtilityDialog(Utility? utility) async {
    final isEditing = utility != null;
    final nameController = TextEditingController(text: utility?.name ?? '');
    final descriptionController =
        TextEditingController(text: utility?.description ?? '');
    final amountController =
        TextEditingController(text: utility?.amount.toString() ?? '');
    DateTime startDate = utility?.startDate ?? DateTime.now();
    DateTime endDate =
        utility?.endDate ?? DateTime.now().add(const Duration(days: 30));
    String selectedIcon = utility?.iconName ?? 'electric_bolt';

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Utility' : 'Add New Utility',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                          'Start: ${startDate.toString().substring(0, 10)}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => endDate = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label:
                          Text('End: ${endDate.toString().substring(0, 10)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                decoration: InputDecoration(
                  labelText: 'Icon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: UtilityConstants.availableIcons.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(entry.value, color: Colors.purple),
                        const SizedBox(width: 12),
                        Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedIcon = value;
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      final name = nameController.text;
                      final description = descriptionController.text;
                      final amount =
                          double.tryParse(amountController.text) ?? 0.0;

                      if (name.isNotEmpty &&
                          description.isNotEmpty &&
                          amount > 0) {
                        if (isEditing) {
                          utility!.name = name;
                          utility.description = description;
                          utility.amount = amount;
                          utility.startDate = startDate;
                          utility.endDate = endDate;
                          utility.iconName = selectedIcon;
                          await _utilityService.updateUtility(utility);
                          _showToast('${utility.name} updated successfully');
                        } else {
                          final newUtility = Utility(
                            id: '',
                            name: name,
                            description: description,
                            startDate: startDate,
                            endDate: endDate,
                            amount: amount,
                            iconName: selectedIcon,
                          );
                          await _utilityService.addUtility(newUtility);
                          _showToast('$name added successfully');
                        }
                        Navigator.pop(context);
                        setState(() {
                          _utilitiesFuture = _initializeAndLoadUtilities();
                        });
                      }
                    },
                    child: Text(isEditing ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
