import 'package:flutter_test/flutter_test.dart';
import 'package:hava_durumu/models/forecast.dart';

// Test verisi oluşturmayı kısaltan yardımcı fonksiyon
HourlyForecast hour(int day, int hour, double temp, {String icon = '01d'}) {
  return HourlyForecast(
    time: DateTime(2026, 10, day, hour),
    temperature: temp,
    description: 'test',
    iconCode: icon,
    rainChance: 0,
  );
}

void main() {
  group('DailyForecast.groupByDay', () {
    test('kayıtları günlere ayırır', () {
      final hourly = [
        hour(22, 9, 15),
        hour(22, 15, 20),
        hour(23, 9, 12),
        hour(23, 15, 18),
      ];

      final days = DailyForecast.groupByDay(hourly);

      expect(days.length, 2);
      expect(days[0].date, DateTime(2026, 10, 22));
      expect(days[1].date, DateTime(2026, 10, 23));
    });

    test('her günün en düşük ve en yüksek sıcaklığını bulur', () {
      final hourly = [hour(22, 3, 11), hour(22, 12, 21), hour(22, 21, 14)];

      final day = DailyForecast.groupByDay(hourly).first;

      expect(day.minTemp, 11);
      expect(day.maxTemp, 21);
    });

    test('ikonu öğlene en yakın kayıttan alır', () {
      final hourly = [
        hour(22, 0, 10, icon: '01n'),
        hour(22, 12, 20, icon: '10d'),
        hour(22, 21, 15, icon: '03n'),
      ];

      final day = DailyForecast.groupByDay(hourly).first;

      expect(day.iconCode, '10d');
    });

    test('en fazla 5 gün döndürür', () {
      final hourly = [for (int d = 20; d <= 26; d++) hour(d, 12, 20)];

      final days = DailyForecast.groupByDay(hourly);

      expect(days.length, 5);
    });
  });
}
