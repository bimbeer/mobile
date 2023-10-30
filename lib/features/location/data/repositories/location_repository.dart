import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/geocode_city.dart';

class LocationRepository {
  Future<List<GeocodeCity>> fetchCityData(String input) async {
    final response = await http.get(Uri.parse(
        'https://geocode.search.hereapi.com/v1/geocode?q=$input&apiKey=${dotenv.env['GEOLOCATION_API_KEY']}'));
    if (response.statusCode == 200) {
      final jsonResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final jsonItems = jsonResponse['items'] as List<dynamic>;
      return jsonItems.map((item) => GeocodeCity.fromJson(item)).toList();
    } else {
      return [];
    }
  }
}
