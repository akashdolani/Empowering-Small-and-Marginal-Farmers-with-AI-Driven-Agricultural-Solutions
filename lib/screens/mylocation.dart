import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:solutionchallenge/screens/demoscreen.dart';
import 'dart:math';
import 'home.dart';
import '../utils/weather_services.dart';
import 'package:solutionchallenge/models/language_model.dart';
import '../utils/app_localizations.dart';
import 'package:provider/provider.dart';



class MyLocationTab extends StatefulWidget {
  const MyLocationTab({super.key});

  @override
  _MyLocationTabState createState() => _MyLocationTabState();
}

class _MyLocationTabState extends State<MyLocationTab> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  final CropSuggestionService _cropService = CropSuggestionService();
  String _cityName = "Fetching location...";
  String _temperature = "Loading...";
  double? _tempValue;
  double? _humidityValue;
  double? _rainfallValue;
  String _weatherDescription = "";
  List<CropSuggestion> _suggestedCrops = [];
  bool _isLoadingCrops = false;

  @override
  void initState() {
    super.initState();
    _loadLocationAndWeather();
    _loadCropData();
  }

  Future<void> _loadCropData() async {
    try {
      await _cropService.loadCropData();
    } catch (e) {
      print('Error loading crop data: $e');
    }
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

        // Store numeric values for crop suggestions
        _tempValue = weatherData['temperature'];
        _humidityValue = weatherData['humidity']; // New data point
        _rainfallValue = weatherData['rainfall']; // New data point

        setState(() {
          _temperature = "${_tempValue}°C";
          _weatherDescription = weatherData['description'];
        });

        // Now that we have complete weather data, get crop suggestions
        await _suggestCrops();
      }
    } catch (e) {
      setState(() {
        _cityName = "Error fetching data";
        _temperature = "N/A";
      });
    }
  }

  Future<void> _suggestCrops() async {
    if (_tempValue == null ||
        _humidityValue == null ||
        _rainfallValue == null) {
      return;
    }

    setState(() {
      _isLoadingCrops = true;
    });

    try {
      final suggestions = await _cropService.suggestTopCrops(
        temperature: _tempValue!,
        humidity: _humidityValue!,
        rainfall: _rainfallValue!,
      );

      setState(() {
        _suggestedCrops = suggestions;
        _isLoadingCrops = false;
      });
    } catch (e) {
      print('Error suggesting crops: $e');
      setState(() {
        _isLoadingCrops = false;
      });
    }
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 99, 194, 104),
              const Color.fromARGB(255, 152, 175, 153),
            ],
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
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
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
                              _weatherDescription.isNotEmpty
                                  ? _weatherDescription
                                  : 'Loading...',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                      _buildMyCropCard(),
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
              // Ask Our AI Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildFeatureCard(
                  title: 'My Field',
                  description: 'View Your Field',
                  icon: Icons.video_camera_back,
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to AI chat screen
                    // Navigate to AI chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const demoApp(),
                      ),
                    );
                  },
                  fullWidth: true,
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyCropCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CropSuggestionScreen(
                  suggestedCrops: _suggestedCrops,
                  temperature: _tempValue ?? 0,
                  humidity: _humidityValue ?? 0,
                  rainfall: _rainfallValue ?? 0,
                ),
          ),
        );
      },
      child: Container(
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
            const Icon(Icons.spa, size: 36, color: Colors.green),
            const SizedBox(height: 8),
            const Text(
              'My Crop',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            _isLoadingCrops
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.green,
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _suggestedCrops.isNotEmpty
                        ? 'Top suggestion: ${_suggestedCrops.first.cropName}'
                        : 'Get crop suggestions',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
          ],
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
          Icon(icon, size: 40, color: color),
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
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for crop suggestions
class CropSuggestion {
  final String cropName;
  final double matchScore;
  final Map<String, dynamic> conditions;

  CropSuggestion({
    required this.cropName,
    required this.matchScore,
    required this.conditions,
  });
}

// Service to handle crop suggestions
class CropSuggestionService {
  List<Map<String, dynamic>> _cropData = [];
  bool _isLoaded = false;

  Future<void> loadCropData() async {
    if (_isLoaded) return;

    try {
      // Load the JSON file from assets (preferred over CSV for easier parsing)
      final String jsonString = await rootBundle.loadString(
        'assets/crop_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      // Convert each item to a map
      _cropData =
          jsonData
              .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item),
              )
              .toList();

      _isLoaded = true;
    } catch (e) {
      print('Error loading crop data from JSON: $e');
      // Fallback to CSV if JSON fails
      try {
        await _loadFromCSV();
      } catch (csvError) {
        print('Error loading from CSV: $csvError');
        rethrow;
      }
    }
  }

  Future<void> _loadFromCSV() async {
    // This is a fallback method in case JSON loading fails
    final String csvString = await rootBundle.loadString(
      'assets/crop_data.csv',
    );

    // Basic CSV parsing (consider using a proper CSV package in production)
    List<String> lines = csvString.split('\n');
    List<String> headers = lines[0].split(',');

    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) continue;

      List<String> values = lines[i].split(',');
      Map<String, dynamic> row = {};

      for (int j = 0; j < headers.length; j++) {
        if (j < values.length) {
          row[headers[j].trim()] = values[j].trim();
        }
      }

      _cropData.add(row);
    }

    _isLoaded = true;
  }

  // Calculate the similarity between input conditions and crop requirements
  double _calculateSimilarity(
    double temp1,
    double temp2,
    double humidity1,
    double humidity2,
    double rainfall1,
    double rainfall2,
  ) {
    // Calculate Euclidean distance
    double distance = sqrt(
      pow(temp1 - temp2, 2) +
          pow(humidity1 - humidity2, 2) +
          pow(rainfall1 - rainfall2, 2),
    );

    // Convert distance to similarity score (lower distance = higher similarity)
    return 100 / (1 + distance);
  }

  // Find top N crops that best match the given conditions
  Future<List<CropSuggestion>> suggestTopCrops({
    required double temperature,
    required double humidity,
    required double rainfall,
    int limit = 3,
  }) async {
    if (!_isLoaded) {
      await loadCropData();
    }

    // Step 1: Group crops by name and store all variants
    Map<String, List<CropSuggestion>> groupedCrops = {};

    for (var crop in _cropData) {
      try {
        double cropTemp = double.parse(crop['temperature'].toString());
        double cropHumidity = double.parse(crop['humidity'].toString());
        double cropRainfall = double.parse(crop['rainfall'].toString());
        String cropName = crop['label'].toString();

        double similarity = _calculateSimilarity(
          temperature,
          cropTemp,
          humidity,
          cropHumidity,
          rainfall,
          cropRainfall,
        );

        CropSuggestion suggestion = CropSuggestion(
          cropName: cropName,
          matchScore: similarity,
          conditions: {
            'temperature': cropTemp,
            'humidity': cropHumidity,
            'rainfall': cropRainfall,
          },
        );

        if (!groupedCrops.containsKey(cropName)) {
          groupedCrops[cropName] = [];
        }
        groupedCrops[cropName]!.add(suggestion);
      } catch (e) {
        print('Error processing crop data: $e');
        continue;
      }
    }

    // Step 2: Select the best variant for each crop name
    List<CropSuggestion> uniqueSuggestions = [];

    groupedCrops.forEach((cropName, variants) {
      // Find the variant with the highest match score
      CropSuggestion bestVariant = variants.reduce(
        (a, b) => a.matchScore > b.matchScore ? a : b,
      );
      uniqueSuggestions.add(bestVariant);
    });

    // Step 3: Sort by match score (highest first) and take top N
    uniqueSuggestions.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return uniqueSuggestions.take(limit).toList();
  }
}

// Detailed screen for crop suggestions
class CropSuggestionScreen extends StatelessWidget {
  final List<CropSuggestion> suggestedCrops;
  final double temperature;
  final double humidity;
  final double rainfall;

  const CropSuggestionScreen({
    super.key,
    required this.suggestedCrops,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Suggestions'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 245, 245, 245),
              const Color.fromARGB(255, 230, 240, 230),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Conditions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildConditionIndicator(
                            'Temperature',
                            '${temperature.toStringAsFixed(1)}°C',
                            Icons.thermostat,
                            Colors.orange,
                          ),
                          _buildConditionIndicator(
                            'Humidity',
                            '${humidity.toStringAsFixed(1)}%',
                            Icons.water_drop,
                            Colors.blue,
                          ),
                          _buildConditionIndicator(
                            'Rainfall',
                            '${rainfall.toStringAsFixed(1)} mm',
                            Icons.umbrella,
                            Colors.indigo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Top 3 Recommended Crops',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child:
                      suggestedCrops.isEmpty
                          ? const Center(
                            child: Text('No crop suggestions available'),
                          )
                          : ListView.builder(
                            itemCount: suggestedCrops.length,
                            itemBuilder: (context, index) {
                              final crop = suggestedCrops[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.green
                                                .withOpacity(0.2),
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  crop.cropName,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Match Score: ${crop.matchScore.toStringAsFixed(1)}%',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.eco,
                                            color: Colors.green,
                                            size: 28,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Ideal Growing Conditions:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildConditionDetail(
                                            'Temp',
                                            '${crop.conditions['temperature']}°C',
                                            Icons.thermostat_outlined,
                                          ),
                                          _buildConditionDetail(
                                            'Humidity',
                                            '${crop.conditions['humidity']}%',
                                            Icons.water_drop_outlined,
                                          ),
                                          _buildConditionDetail(
                                            'Rainfall',
                                            '${crop.conditions['rainfall']} mm',
                                            Icons.umbrella_outlined,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionIndicator(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildConditionDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
