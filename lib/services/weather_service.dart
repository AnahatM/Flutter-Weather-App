import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

// Service class to fetch weather data from the OpenWeatherMap API
class WeatherService {
  static const baseURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  // Asynchronous Function to Fetch Weather Data
  Future<Weather> getWeather(String cityName) async {
    // Form URL String and Send Request
    final url = '$baseURL?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    // Check if weather data loaded sucessfully
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Asynchronous Function to Fetch Current City
  Future<String> getCurrentCity() async {
    // Get location permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? 'Unknown City';
  }
}
