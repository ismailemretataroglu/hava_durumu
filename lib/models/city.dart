class City {
  final String name;
  final String? state;
  final String country;
  final double lat;
  final double lon;

  const City({
    required this.name,
    required this.state,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    final localNames = json['local_names'] as Map<String, dynamic>?;
    return City(
      name: (localNames?['tr'] ?? json['name']) as String,
      state: json['state'] as String?,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  String get subtitle {
    if (state == null) return country;
    return '$state · $country';
  }
}
