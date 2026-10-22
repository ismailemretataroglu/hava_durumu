import 'dart:async';

import 'package:flutter/material.dart';

import '../models/city.dart';
import '../services/weather_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_exception.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _weatherService = WeatherService();
  Timer? _debounce;

  List<City> _results = [];
  bool _isSearching = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {}); // temizle (X) butonunu göster/gizle
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(text);
    });
  }

  Future<void> _search(String text) async {
    final query = text.trim();
    if (query.length < 2) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final cities = await _weatherService.searchCities(query);
      if (!mounted) return;
      setState(() {
        _results = cities;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (e is AppException) {
          _error = e.message;
        } else {
          _error = 'Arama yapılamadı. Tekrar dene.';
        }
        _isSearching = false;
      });
    }
  }

  void _clear() {
    _controller.clear();
    _onTextChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left, color: AppColors.text),
                    tooltip: 'Geri',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      fixedSize: const Size(44, 44),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Şehir Ara',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onTextChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  hintText: 'Şehir adı yaz…',
                  prefixIcon: const Icon(Icons.search, color: AppColors.text),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clear,
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Temizle',
                        ),
                  filled: true,
                  fillColor: AppColors.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, textAlign: TextAlign.center));
    }
    if (_controller.text.trim().length < 2) {
      return const Center(
        child: Text(
          'Aramak için en az 2 harf yaz',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }
    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'Sonuç bulunamadı',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: _results.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFE4DCCD),
          );
        },
        itemBuilder: (context, index) {
          final city = _results[index];
          return ListTile(
            leading: const Icon(
              Icons.location_city_outlined,
              color: AppColors.textMuted,
            ),
            title: _buildHighlightedName(city.name),
            subtitle: Text(
              city.subtitle,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            onTap: () {
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }

  // Yazılan kısmı turuncu göster: "An" + "kara"
  Widget _buildHighlightedName(String name) {
    final query = _controller.text.trim();
    const baseStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
    );

    if (!name.toLowerCase().startsWith(query.toLowerCase())) {
      return Text(name, style: baseStyle);
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: name.substring(0, query.length),
            style: const TextStyle(
              color: AppColors.terracotta,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: name.substring(query.length)),
        ],
      ),
    );
  }
}
