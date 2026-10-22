import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast.dart';
import '../models/weather.dart';
import '../theme/app_colors.dart';
import '../utils/text_utils.dart';
import 'weather_icon.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;
  final DailyForecast today;
  final double rainChance;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.today,
    required this.rainChance,
  });

  static const _mutedOnDark = Color(0xFFC9D6CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          const SizedBox(height: 16),
          _buildMainRow(),
          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bugün',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              DateFormat('d MMMM, EEEE', 'tr_TR').format(weather.date),
              style: const TextStyle(color: _mutedOnDark, fontSize: 13),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Son güncelleme ${DateFormat('HH:mm').format(weather.date)}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMainRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '°C',
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                capitalizeTr(weather.description),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hissedilen ${weather.feelsLike.round()}° · '
                'En yük. ${today.maxTemp.round()}° / En düş. ${today.minTemp.round()}°',
                style: const TextStyle(color: _mutedOnDark, fontSize: 13),
              ),
            ],
          ),
        ),
        WeatherIcon(code: weather.iconCode, size: 88),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.water_drop_outlined,
            value: '%${weather.humidity}',
            label: 'Nem',
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: Icons.air,
            value: '${weather.windSpeedKmh.round()} km/s',
            label: 'Rüzgar',
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: Icons.umbrella_outlined,
            value: '%${(rainChance * 100).round()}',
            label: 'Yağış',
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE4ECE7)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: CurrentWeatherCard._mutedOnDark,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
