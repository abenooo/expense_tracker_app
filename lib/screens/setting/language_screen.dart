import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en', 'nativeName': 'English'},
    {'name': 'Amharic', 'code': 'am', 'nativeName': 'አማርኛ'},
    {'name': 'Afan Oromo', 'code': 'om', 'nativeName': 'Afaan Oromoo'},
    {'name': 'Somali', 'code': 'so', 'nativeName': 'Soomaali'},
    {'name': 'Tigrinya', 'code': 'ti', 'nativeName': 'ትግርኛ'},
    {'name': 'Afar', 'code': 'aa', 'nativeName': 'Qafar'},
  ];

  Widget _buildLanguageItem(Map<String, String> language) {
    bool isSelected = _selectedLanguage == language['name'];
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple.shade400 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                language['code']!.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            language['name']!,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            language['nativeName']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: isSelected
              ? Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Colors.purple.shade400,
                )
              : null,
          onTap: () {
            setState(() {
              _selectedLanguage = language['name']!;
            });
          },
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                ..._languages.map(_buildLanguageItem).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement language change logic
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

