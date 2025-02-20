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

    return switch (mainCondition.toLowerCase()) {
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

  Color getBackgroundColor(String? mainCondition) {
    if (mainCondition == null) return Color.fromARGB(255, 184, 187, 199);

    return switch (mainCondition.toLowerCase()) {
      "clouds" => Color.fromARGB(255, 184, 187, 199),
      "mist" => Color.fromARGB(255, 184, 187, 199),
      "smoke" => Color.fromARGB(255, 184, 187, 199),
      "haze" => Color.fromARGB(255, 184, 187, 199),
      "dust" => Color.fromARGB(255, 184, 187, 199),
      "fog" => Color.fromARGB(255, 184, 187, 199),
      "rain" => Color.fromARGB(255, 184, 187, 199),
      "drizzle" => Color.fromARGB(255, 184, 187, 199),
      "shower rain" => Color.fromARGB(255, 184, 187, 199),
      "thunderstorm" => Color.fromARGB(255, 184, 187, 199),
      "clear" => Color.fromARGB(255, 255, 245, 218),
      _ => Color.fromARGB(255, 184, 187, 199),
    };
  }

  Color getTextColor(String mainCondition) {
    return switch (mainCondition.toLowerCase()) {
      "clear" => Color.fromARGB(255, 70, 66, 60),
      _ => Color.fromARGB(255, 48, 52, 66),
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
      backgroundColor: getBackgroundColor(_weather?.mainCondition),
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
                  (_weather?.cityName ?? "Loading City...").toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontWeight: FontWeight.w300,
                    fontSize: 24,
                    color: getTextColor(_weather?.mainCondition ?? ""),
                  ),
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
                      "${_weather?.temperature.round() ?? "??"}F",
                      style: TextStyle(
                        fontFamily: "Oswald",
                        fontWeight: FontWeight.w600,
                        fontSize: 72,
                        color: getTextColor(_weather?.mainCondition ?? ""),
                      ),
                    ),
                    Text(
                      (_weather?.mainCondition ?? "Unknown").toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Oswald",
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                        color: getTextColor(_weather?.mainCondition ?? ""),
                      ),
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
