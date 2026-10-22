class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String description;
  final String iconCode;
  final double rainChance; // 0.0 – 1.0

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.rainChance,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      iconCode: json['weather'][0]['icon'] as String,
      rainChance: (json['pop'] as num).toDouble(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String iconCode;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.iconCode,
  });

  // 40 saatlik kaydı günlere ayırıp her günü özetler
  static List<DailyForecast> groupByDay(List<HourlyForecast> hourly) {
    // 1) Grupla
    final Map<DateTime, List<HourlyForecast>> groups = {};
    for (final item in hourly) {
      final day = DateTime(item.time.year, item.time.month, item.time.day);
      if (!groups.containsKey(day)) {
        groups[day] = [];
      }
      groups[day]!.add(item);
    }

    // 2) Her grubu özetle
    final List<DailyForecast> days = [];
    for (final entry in groups.entries) {
      days.add(_summarizeDay(entry.key, entry.value));
    }

    // 3) İlk 5 günü al
    return days.take(5).toList();
  }

  static DailyForecast _summarizeDay(DateTime day, List<HourlyForecast> items) {
    double minTemp = items.first.temperature;
    double maxTemp = items.first.temperature;
    HourlyForecast middayItem = items.first;

    for (final item in items) {
      if (item.temperature < minTemp) {
        minTemp = item.temperature;
      }
      if (item.temperature > maxTemp) {
        maxTemp = item.temperature;
      }
      // Öğlene (12:00) en yakın kaydı bul
      final distance = (item.time.hour - 12).abs();
      final bestDistance = (middayItem.time.hour - 12).abs();
      if (distance < bestDistance) {
        middayItem = item;
      }
    }

    return DailyForecast(
      date: day,
      minTemp: minTemp,
      maxTemp: maxTemp,
      description: middayItem.description,
      iconCode: middayItem.iconCode,
    );
  }
}
