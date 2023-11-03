class GeocodeCity {
  final GeocodeAddress address;
  final GeocodePosition position;

  GeocodeCity({
    required this.address,
    required this.position,
  });

  factory GeocodeCity.fromJson(Map<String, dynamic> json) {
    final addressJson = json['address'] as Map<String, dynamic>;
    final positionJson = json['position'] as Map<String, dynamic>;

    return GeocodeCity(
      address: GeocodeAddress.fromJson(addressJson),
      position: GeocodePosition.fromJson(positionJson),
    );
  }
}

class GeocodeAddress {
  final String? label;
  final String? countryCode;
  final String? countryName;
  final String? state;
  final String? county;
  final String? city;
  final String? postalCode;

  GeocodeAddress({
    required this.label,
    required this.countryCode,
    required this.countryName,
    required this.state,
    required this.county,
    required this.city,
    required this.postalCode,
  });

  factory GeocodeAddress.fromJson(Map<String, dynamic> json) {
    return GeocodeAddress(
      label: json['label'],
      countryCode: json['countryCode'],
      countryName: json['countryName'],
      state: json['state'],
      county: json['county'],
      city: json['city'],
      postalCode: json['postalCode'],
    );
  }
}

class GeocodePosition {
  final double lat;
  final double lng;

  GeocodePosition({
    required this.lat,
    required this.lng,
  });

  factory GeocodePosition.fromJson(Map<String, dynamic> json) {
    return GeocodePosition(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}
