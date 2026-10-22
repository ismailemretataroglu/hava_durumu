import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WeatherIcon extends StatelessWidget {
  final String code;
  final double size;

  const WeatherIcon({super.key, required this.code, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final type = code.substring(0, 2); // '10d' → '10'
    final isNight = code.endsWith('n');

    IconData icon;
    Color color;

    switch (type) {
      case '01':
        icon = isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
        color = isNight ? AppColors.textMuted : AppColors.sun;
        break;
      case '02':
        icon = Icons.wb_cloudy_outlined;
        color = AppColors.sun;
        break;
      case '03':
      case '04':
        icon = Icons.cloud_rounded;
        color = AppColors.cloud;
        break;
      case '09':
      case '10':
        icon = Icons.umbrella_rounded;
        color = AppColors.rain;
        break;
      case '11':
        icon = Icons.thunderstorm_rounded;
        color = AppColors.sun;
        break;
      case '13':
        icon = Icons.ac_unit_rounded;
        color = AppColors.rain;
        break;
      default:
        icon = Icons.foggy;
        color = AppColors.cloud;
    }

    return Icon(icon, size: size, color: color);
  }
}
