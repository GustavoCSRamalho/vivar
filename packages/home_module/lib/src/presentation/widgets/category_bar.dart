// screens/home/widgets/category_bar.dart
import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategoryBar({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // ← REDUZIDO de 56 para 48
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ), // ← PADDING VERTICAL ADICIONADO
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8), // ← SIMPLIFICADO
            child: CategoryChip(
              label: categories[index],
              isSelected: isSelected,
              onTap: () => onCategorySelected(index),
            ),
          );
        },
      ),
    );
  }
}
