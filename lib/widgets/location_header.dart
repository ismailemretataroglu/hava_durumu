import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LocationHeader extends StatelessWidget {
  final String cityName;
  final String subtitle;
  final bool isDeviceLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onSettingsTap;

  const LocationHeader({
    super.key,
    required this.cityName,
    required this.subtitle,
    required this.isDeviceLocation,
    required this.onLocationTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: isDeviceLocation ? null : onLocationTap,
          tooltip: isDeviceLocation ? 'Konumundasın' : 'Konumuma dön',
          icon: Icon(
            isDeviceLocation ? Icons.location_on : Icons.location_on_outlined,
            size: 24,
          ),
          color: AppColors.terracotta,
          disabledColor: AppColors.terracotta,
          style: IconButton.styleFrom(
            fixedSize: const Size(44, 44),
            backgroundColor: isDeviceLocation ? null : AppColors.surface,
            side: isDeviceLocation
                ? null
                : const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(Icons.settings_outlined, color: AppColors.text),
          tooltip: 'Ayarlar',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            fixedSize: const Size(44, 44),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
