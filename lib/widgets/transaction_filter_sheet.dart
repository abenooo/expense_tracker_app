import 'package:flutter/material.dart';

enum FilterType { income, expense, transfer }
enum SortType { highest, lowest, newest, oldest }

class TransactionFilterSheet extends StatefulWidget {
  final Function(FilterType?) onFilterChanged;
  final Function(SortType?) onSortChanged;
  final Function() onReset;
  final Function() onApply;

  const TransactionFilterSheet({
    Key? key,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onReset,
    required this.onApply,
  }) : super(key: key);

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  FilterType? _selectedFilter;
  SortType? _selectedSort;
  int _selectedCategories = 0;

  Widget _buildFilterChip(FilterType type) {
    final isSelected = _selectedFilter == type;
    return FilterChip(
      label: Text(
        type.name[0].toUpperCase() + type.name.substring(1),
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? type : null;
        });
        widget.onFilterChanged(_selectedFilter);
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.purple,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.purple : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildSortChip(SortType type) {
    final isSelected = _selectedSort == type;
    return FilterChip(
      label: Text(
        type.name[0].toUpperCase() + type.name.substring(1),
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedSort = selected ? type : null;
        });
        widget.onSortChanged(_selectedSort);
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.purple,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.purple : Colors.grey.shade300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = null;
                    _selectedSort = null;
                    _selectedCategories = 0;
                  });
                  widget.onReset();
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.purple.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Filter By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: FilterType.values.map(_buildFilterChip).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SortType.values.map(_buildSortChip).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              // TODO: Implement category selection
              setState(() {
                _selectedCategories = (_selectedCategories + 1) % 5;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Category',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$_selectedCategories Selected',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

