import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/utility.dart';
import '../services/utility_service.dart';
import '../constants/utility_constants.dart';
import 'package:intl/intl.dart';

class UtilityScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const UtilityScreen({Key? key, required this.notificationsPlugin})
      : super(key: key);

  @override
  _UtilityScreenState createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {
  late final UtilityService _utilityService;
  List<Utility> _utilities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _utilityService = UtilityService(widget.notificationsPlugin);
    _initializeAndLoadUtilities();
  }

  Future<void> _initializeAndLoadUtilities() async {
    await _utilityService.initializeDefaultUtilities();
    await _loadUtilities();
  }

  Future<void> _loadUtilities() async {
    setState(() => _isLoading = true);
    final utilities = await _utilityService.getUtilities();
    setState(() {
      _utilities = utilities;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
            onPressed: _loadUtilities,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _utilities.length + 1, // +1 for the add new button
              itemBuilder: (context, index) {
                if (index == _utilities.length) {
                  return _buildAddNewButton();
                }
                return _buildUtilityItem(_utilities[index]);
              },
            ),
    );
  }

  Widget _buildUtilityItem(Utility utility) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            UtilityConstants.availableIcons[utility.iconName] ?? Icons.help_outline,
            color: Colors.purple,
          ),
        ),
        title: Text(
          utility.name,
          style: const TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          utility.description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.purple),
        onTap: () => _showUtilityDialog(utility),
      ),
    );
  }

  Widget _buildAddNewButton() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add, color: Colors.purple),
        ),
        title: const Text(
          'Add New Utility',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.purple),
        onTap: () => _showUtilityDialog(null),
      ),
    );
  }

  Future<void> _showUtilityDialog(Utility? utility) async {
    final isEditing = utility != null;
    final nameController = TextEditingController(text: utility?.name ?? '');
    final descriptionController = TextEditingController(text: utility?.description ?? '');
    final amountController = TextEditingController(text: utility?.amount.toString() ?? '');
    DateTime startDate = utility?.startDate ?? DateTime.now();
    DateTime endDate = utility?.endDate ?? DateTime.now().add(const Duration(days: 30));
    String selectedIcon = utility?.iconName ?? 'electric_bolt';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Utility' : 'Add New Utility'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                      child: Text('Start: ${DateFormat('MM-dd').format(startDate)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => endDate = picked);
                        }
                      },
                      child: Text('End: ${DateFormat('MM-dd').format(endDate)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                decoration: const InputDecoration(labelText: 'Icon'),
                items: UtilityConstants.availableIcons.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(entry.value),
                        const SizedBox(width: 8),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text;
              final description = descriptionController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              
              if (name.isNotEmpty && description.isNotEmpty && amount > 0) {
                if (isEditing) {
                  utility!.name = name;
                  utility.description = description;
                  utility.amount = amount;
                  utility.startDate = startDate;
                  utility.endDate = endDate;
                  utility.iconName = selectedIcon;
                  await _utilityService.updateUtility(utility);
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
                }
                Navigator.pop(context);
                _loadUtilities();
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}

