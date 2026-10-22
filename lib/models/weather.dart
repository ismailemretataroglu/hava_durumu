class Weather {
  final double temperature;
  final String cityName;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeedKmh;
  final String description;
  final String iconCode;
  final DateTime date;
  final String country;

  const Weather({
    required this.temperature,
    required this.cityName,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeedKmh,
    required this.description,
    required this.iconCode,
    required this.date,
    required this.country,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['main']['temp'] as num).toDouble(),
      cityName: (json['name'] as String),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeedKmh: (json['wind']['speed'] as num).toDouble() * 3.6,
      description: (json['weather'][0]['description'] as String),
      iconCode: (json['weather'][0]['icon'] as String),
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      country: (json['sys']['country'] as String),
    );
  }
}
