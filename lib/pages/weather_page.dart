import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
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
  // For API Key, create secrets.dart in the lib directory,
  // with this line: const String apiKey = "YOUR_API_KEY";
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
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/loading.json';

    return switch (mainCondition) {
      "clouds" => 'assets/cloud.json',
      "mist" => 'assets/cloud.json',
      "smoke" => 'assets/cloud.json',
      "haze" => 'assets/cloud.json',
      "dust" => 'assets/cloud.json',
      "fog" => 'assets/cloud.json',
      "rain" => 'assets/rain.json',
      "drizzle" => 'assets/rain.json',
      "shower rain" => 'assets/rain.json',
      "thunderstorm" => 'assets/thunder.json',
      "clear" => 'assets/sunny.json',
      _ => 'assets/cloud.json',
    };
  }

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
      backgroundColor: Color.fromARGB(255, 191, 195, 209),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City Name
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Text(
                  _weather?.cityName ?? "Loading City...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
            ),

            // Animated Weather Icon
            Center(
              child: Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition),
                height: 400,
              ),
            ),

            // Temperature and Main Condition
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_weather?.temperature.round() ?? "??"}°F",
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                    Text(
                      _weather?.mainCondition ?? "Unknown",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
