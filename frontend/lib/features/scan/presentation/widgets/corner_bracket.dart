import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const CornerBracket({
    super.key,
    required this.isTop,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
