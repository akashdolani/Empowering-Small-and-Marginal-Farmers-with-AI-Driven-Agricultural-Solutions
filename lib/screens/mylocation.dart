// my_location_tab.dart
import 'package:flutter/material.dart';
import 'home.dart';
import '../utils/weather_services.dart';


class MyLocationTab extends StatefulWidget {
  const MyLocationTab({super.key});

  @override
  _MyLocationTabState createState() => _MyLocationTabState();
}

class _MyLocationTabState extends State<MyLocationTab> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  String _cityName = "Fetching location...";
  String _temperature = "Loading...";
  String _weatherDescription = "";

  @override
  void initState() {
    super.initState();
    _loadLocationAndWeather();
  }

  Future<void> _loadLocationAndWeather() async {
    try {
      // Fetch location
      final locationData = await _locationService.fetchCityNameAndCoordinates();
      setState(() {
        _cityName = locationData['city'];
      });

      // Fetch weather if coordinates are available
      if (locationData['lat'] != null && locationData['lon'] != null) {
        final weatherData = await _weatherService.fetchWeather(
          locationData['lat'],
          locationData['lon'],
        );
        setState(() {
          _temperature = "${weatherData['temperature']}°C";
          _weatherDescription = weatherData['description'];
        });
      }
    } catch (e) {
      setState(() {
        _cityName = "Error fetching data";
        _temperature = "N/A";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 99, 194, 104), const Color.fromARGB(255, 152, 175, 153)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'My Crop Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _cityName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _weatherDescription.isNotEmpty ? _weatherDescription : 'Loading...',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wb_sunny, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              _temperature,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCropCard(
                        title: 'My Crop',
                        subtitle: 'Monitor and track growth',
                        icon: Icons.spa,
                        color: Colors.green,
                      ),
                      _buildCropCard(
                        title: 'Krishi Gyan',
                        subtitle: 'Agricultural knowledge',
                        icon: Icons.menu_book,
                        color: Colors.blue,
                      ),
                      _buildCropCard(
                        title: 'Weather',
                        subtitle: 'Forecasts for farming',
                        icon: Icons.cloud,
                        color: Colors.purple,
                      ),
                      _buildCropCard(
                        title: 'Community',
                        subtitle: 'Connect with farmers',
                        icon: Icons.people,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}