import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast.dart';
import '../models/weather.dart';
import '../theme/app_colors.dart';
import 'weather_icon.dart';

class HourlyStrip extends StatelessWidget {
  final Weather current;
  final List<HourlyForecast> items;

  const HourlyStrip({super.key, required this.current, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saatlik Tahmin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            Text(
              '3 saatlik',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + 1, // +1: baştaki "Şimdi" kutusu
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return _HourTile(
                  label: 'Şimdi',
                  iconCode: current.iconCode,
                  temperature: current.temperature,
                  isHighlighted: true,
                );
              }
              final item = items[index - 1];
              return _HourTile(
                label: DateFormat('HH:mm').format(item.time),
                iconCode: item.iconCode,
                temperature: item.temperature,
                isHighlighted: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HourTile extends StatelessWidget {
  final String label;
  final String iconCode;
  final double temperature;
  final bool isHighlighted;

  const _HourTile({
    required this.label,
    required this.iconCode,
    required this.temperature,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.accent : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: isHighlighted ? null : Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isHighlighted
                  ? const Color(0xFFE4ECE7)
                  : AppColors.textMuted,
            ),
          ),
          WeatherIcon(code: iconCode, size: 24),
          Text(
            '${temperature.round()}°',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isHighlighted ? Colors.white : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
