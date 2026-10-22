import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast.dart';
import '../theme/app_colors.dart';
import '../utils/text_utils.dart';
import 'weather_icon.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> days;

  const DailyForecastList({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    // Haftanın en düşük ve en yüksek sıcaklığını bul
    double weekMin = days.first.minTemp;
    double weekMax = days.first.maxTemp;
    for (final day in days) {
      if (day.minTemp < weekMin) weekMin = day.minTemp;
      if (day.maxTemp > weekMax) weekMax = day.maxTemp;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '5 Günlük Tahmin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            Text(
              '5 gün',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < days.length; i++)
                _DayRow(
                  day: days[i],
                  weekMin: weekMin,
                  weekMax: weekMax,
                  showDivider: i < days.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final DailyForecast day;
  final double weekMin;
  final double weekMax;
  final bool showDivider;

  const _DayRow({
    required this.day,
    required this.weekMin,
    required this.weekMax,
    required this.showDivider,
  });

  String _dayLabel() {
    final now = DateTime.now();
    final isToday =
        day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
    if (isToday) return 'Bugün';
    return DateFormat('EEE', 'tr_TR').format(day.date); // Pzt, Sal, Çar...
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFFE4DCCD)))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              _dayLabel(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
          WeatherIcon(code: day.iconCode, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              capitalizeTr(day.description),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              '${day.minTemp.round()}°',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(width: 8),
          _TempBar(
            dayMin: day.minTemp,
            dayMax: day.maxTemp,
            weekMin: weekMin,
            weekMax: weekMax,
          ),
          SizedBox(
            width: 34,
            child: Text(
              '${day.maxTemp.round()}°',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TempBar extends StatelessWidget {
  final double dayMin;
  final double dayMax;
  final double weekMin;
  final double weekMax;

  const _TempBar({
    required this.dayMin,
    required this.dayMax,
    required this.weekMin,
    required this.weekMax,
  });

  static const double _width = 56;

  @override
  Widget build(BuildContext context) {
    double range = weekMax - weekMin;
    if (range == 0) range = 1; // sıfıra bölmeyi önle

    final start = (dayMin - weekMin) / range;
    final length = (dayMax - dayMin) / range;

    return SizedBox(
      width: _width,
      height: 5,
      child: Stack(
        children: [
          // Gri arka plan
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE4DCCD),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Renkli kısım
          Positioned(
            left: _width * start,
            width: _width * length,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  colors: [AppColors.rain, AppColors.sun],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
