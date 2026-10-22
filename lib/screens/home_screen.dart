import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_exception.dart';
import '../models/city.dart';
import '../models/forecast.dart';
import '../models/weather.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/hourly_strip.dart';
import '../widgets/location_header.dart';
import '../widgets/search_bar_button.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _locationService = LocationService();
  final _weatherService = WeatherService();

  // Ekranın durumu
  bool _isLoading = true;
  String? _error;
  Weather? _weather;
  List<HourlyForecast> _hourly = [];
  List<DailyForecast> _daily = [];
  City? _selectedCity; // null = cihaz konumu

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather({City? city}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedCity = city;
    });

    try {
      double targetLat;
      double targetLon;

      if (city != null) {
        // Aramadan gelen şehir
        targetLat = city.lat;
        targetLon = city.lon;
      } else {
        // Cihazın konumu
        final position = await _locationService.getCurrentPosition();
        targetLat = position.latitude;
        targetLon = position.longitude;
      }

      // İki isteği aynı anda başlat
      final weatherFuture = _weatherService.getCurrentWeather(
        targetLat,
        targetLon,
      );
      final forecastFuture = _weatherService.getForecast(targetLat, targetLon);

      // Sonra ikisini de bekle
      final weather = await weatherFuture;
      final hourly = await forecastFuture;

      if (hourly.isEmpty) {
        throw Exception('Tahmin verisi boş geldi');
      }

      if (!mounted) return;
      setState(() {
        _weather = weather;
        _hourly = hourly.take(8).toList();
        _daily = DailyForecast.groupByDay(hourly);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (e is AppException) {
          _error = e.message;
        } else {
          _error = 'Beklenmeyen bir hata oluştu. Tekrar dene.';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _openSearch() async {
    final city = await Navigator.push<City>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SearchScreen();
        },
      ),
    );

    if (city == null) return;
    _loadWeather(city: city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _loadWeather(city: _selectedCity);
              },
              child: const Text('Tekrar dene'),
            ),
          ],
        ),
      );
    }

    final weather = _weather!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LocationHeader(
          cityName: _selectedCity?.name ?? weather.cityName,
          subtitle:
              '${weather.country} · '
              '${DateFormat('EEEE, d MMMM', 'tr_TR').format(weather.date)}',
          isDeviceLocation: _selectedCity == null,
          onLocationTap: () {
            _loadWeather();
          },
          onSettingsTap: () {},
        ),
        const SizedBox(height: 16),
        SearchBarButton(onTap: _openSearch),
        const SizedBox(height: 20),
        CurrentWeatherCard(
          weather: weather,
          today: _daily.first,
          rainChance: _hourly.first.rainChance,
        ),

        const SizedBox(height: 24),
        HourlyStrip(current: weather, items: _hourly),

        const SizedBox(height: 24),
        DailyForecastList(days: _daily),
      ],
    );
  }
}
