import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryFilter extends StatelessWidget {
  final Set<String> selectedCategories;
  final void Function(String id) onCategoryToggle;

  const CategoryFilter({
    super.key,
    required this.selectedCategories,
    required this.onCategoryToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategories.contains(cat.id);

          return OutlinedButton(
            onPressed: () => onCategoryToggle(cat.id),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              backgroundColor: isSelected ? Colors.blue.shade100 : Colors.transparent,
              side: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey.shade400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              cat.nameKey,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade800 : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }
}
