import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isActive = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primaryContainer
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                  border: isActive
                      ? null
                      : Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (cat == 'Trending') ...[
                      Icon(Icons.local_fire_department,
                          size: 16,
                          color: isActive
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      cat,
                      style: AppTextStyles.labelMd.copyWith(
                        color: isActive
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
