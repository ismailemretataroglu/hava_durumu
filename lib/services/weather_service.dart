import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/forecast.dart';
import '../models/weather.dart';
import '../utils/app_exception.dart';

class WeatherService {
  static const String _apiKey = String.fromEnvironment('OWM_API_KEY');
  static const String _host = 'api.openweathermap.org';

  Future<Weather> getCurrentWeather(double lat, double lon) async {
    final json = await _getJson('/data/2.5/weather', _weatherParams(lat, lon));
    return Weather.fromJson(json);
  }

  Future<List<HourlyForecast>> getForecast(double lat, double lon) async {
    final json = await _getJson('/data/2.5/forecast', _weatherParams(lat, lon));
    final List<dynamic> items = json['list'];

    final List<HourlyForecast> result = [];
    for (final item in items) {
      result.add(HourlyForecast.fromJson(item));
    }
    return result;
  }

  Future<List<City>> searchCities(String query) async {
    final List<dynamic> items = await _getJson('/geo/1.0/direct', {
      'q': query,
      'limit': '5',
    });

    final List<City> result = [];
    for (final item in items) {
      result.add(City.fromJson(item));
    }
    return result;
  }

  // Hava durumu ve tahmin isteklerinin ortak parametreleri
  Map<String, String> _weatherParams(double lat, double lon) {
    return {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': 'metric',
      'lang': 'tr',
    };
  }

  // Tüm istekler buradan geçer: anahtar eklenir, hatalar anlaşılır mesajlara çevrilir
  Future<dynamic> _getJson(String path, Map<String, String> params) async {
    final uri = Uri.https(_host, path, {...params, 'appid': _apiKey});

    http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const AppException(
        'Sunucu yanıt vermedi. Biraz sonra tekrar dene.',
      );
    } catch (e) {
      // Bu hatanın mesajı URL'yi (ve anahtarı) içerir, bu yüzden ASLA dışarı vermiyoruz
      throw const AppException(
        'İnternet bağlantısı yok. Bağlantını kontrol edip tekrar dene.',
      );
    }

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 401:
        throw const AppException(
          'API anahtarı geçersiz ya da henüz aktif değil.',
        );
      case 404:
        throw const AppException('Bu konum için veri bulunamadı.');
      case 429:
        throw const AppException(
          'Çok fazla istek atıldı. Bir dakika sonra tekrar dene.',
        );
      default:
        throw AppException(
          'Sunucu hatası (${response.statusCode}). Daha sonra tekrar dene.',
        );
    }
  }
}
