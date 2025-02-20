import "package:flutter/material.dart";
import "package:minimalist_weather/models/weather_model.dart";
import "package:minimalist_weather/services/weather_service.dart";
import '../secrets.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Get Data using OpenWeatherMap API
  final _weatherService = WeatherService(apiKey: apiKey);
  Weather? _weather;

  // Fetch weather data for the current city
  _fetchWeather() async {
    // Get current city using Geolocator
    String cityName = await _weatherService.getCurrentCity();

    // Fetch Weather
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // Temporary Error Handling
    catch (e) {
      print(e);
    }
  }

  // Weather Animations

  // Initial State
  @override
  void initState() {
    super.initState();

    // Fetch Weather Data on Startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text('City Name', style: TextStyle(fontSize: 24)),
            Text(
              _weather?.cityName ?? "Loading City...",
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 20),

            // Temperature
            Text('Temperature', style: TextStyle(fontSize: 24)),
            Text(
              "${_weather?.temperature.round() ?? "??"}°C",
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 20),

            // Main Condition
            Text('Main Condition', style: TextStyle(fontSize: 24)),
            Text(
              _weather?.mainCondition ?? "Unknown",
              style: TextStyle(fontSize: 36),
            ),
          ],
        ),
      ),
    );
  }
}
