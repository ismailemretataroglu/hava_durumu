import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SearchBarButton extends StatelessWidget {
  final VoidCallback onTap;

  const SearchBarButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: AppColors.textMuted, size: 20),
              SizedBox(width: 12),
              Text(
                'Başka bir şehir ara…',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
