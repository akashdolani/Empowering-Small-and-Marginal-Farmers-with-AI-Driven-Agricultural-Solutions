import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import '../presentation/home/home2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

// 1. Define a data model for carousel items
class CarouselItem {
  final String imagePath;
  final String title;
  final String description;

  CarouselItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

// 2. Create a list of carousel items with unique data
final List<CarouselItem> carouselItems = [
  CarouselItem(
    imagePath: 'assets/images/images1.jpg', // Path to local asset
    title: 'Crop Rotation Benefits',
    description: 'Learn about sustainable farming techniques',
  ),
  CarouselItem(
    imagePath: 'assets/images/images2.jpg',
    title: 'New Irrigation System',
    description: 'Save water with modern technology',
  ),
  CarouselItem(
    imagePath: 'assets/images/images3.jpg',
    title: 'Organic Fertilizers',
    description: 'Boost yields naturally',
  ),
];

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchCityName();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // Process the image for disease detection
      File imageFile = File(image.path);
      _analyzeImage(imageFile);
    }
  }


  String _cityName = "Fetching location..."; // Initial text

  
     // Fetch location when screen loads


  // Handle location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _cityName = "Location disabled";
      });
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _cityName = "Permission denied";
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _cityName = "Permission denied forever";
      });
      return false;
    }
    return true;
  }

  // Fetch city name from location
  Future<void> _fetchCityName() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String? city = placemarks[0].locality;

      setState(() {
        _cityName = city != null && city.isNotEmpty ? city : "Unknown city";
      });
    } catch (e) {
      setState(() {
        _cityName = "Error: $e";
      });
    }
  }

  String cleanPrediction(String rawPrediction) {
    // Split the string by '___' to separate class and disease
    List<String> parts = rawPrediction.split('___');

    // Join the parts (usually crop and disease) with a space
    String combined = parts.join(' ');

    // Replace underscores with spaces
    return combined.replaceAll('_', ' ');
  }

  void _analyzeImage(File imageFile) async {
    // Initialize the detector
    PlantDiseaseDetector detector = PlantDiseaseDetector();
    await detector.loadModel();

    // Process the image and get the prediction
    String? prediction = await detector.processImage(imageFile.path);

    if (prediction != null) {
      String readablePrediction = cleanPrediction(prediction);
      print('Prediction: $readablePrediction');
      prediction = readablePrediction;
    }

    // Set a default confidence value (since TFLite models usually return probabilities)
    double confidence =
        0.90; // Modify this based on actual model output if needed

    // Define treatment suggestions (you can extend this logic)
    Map<String, String> treatments = {
      "Apple___Apple_scab": "Use fungicides like captan or mancozeb.",
      "Apple___Black_rot":
          "Remove infected fruit and apply copper-based sprays.",
      "Corn_(maize)___Common_rust_":
          "Use resistant hybrids and fungicides if needed.",
      "Tomato___Early_blight":
          "Apply fungicides and ensure good air circulation.",
      "Tomato___Late_blight":
          "Use copper-based fungicides and remove affected leaves.",
      "Tomato___healthy": "No treatment needed, the plant is healthy!",
    };

    String treatment =
        treatments[prediction] ?? "Consult an expert for treatment advice.";

    // Navigate to the result screen with real prediction data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DiseaseResultScreen(
              imagePath: imageFile.path,
              diseaseName: prediction ?? "Unknown Disease",
              confidence: confidence,
              treatment: treatment,
            ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with Logo and Name
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Replace with your actual logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/final_applogo.PNG',
                        height: 40,
                        width: 175,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          _cityName, // Location
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      radius: 18,
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carousel for Latest News
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latest Updates',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 3. Update your SizedBox with asset images
                            SizedBox(
                              height: 160,
                              child: PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.9,
                                ),
                                itemCount: carouselItems.length,
                                itemBuilder: (context, index) {
                                  final item = carouselItems[index];
                                  return Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          item.imagePath,
                                        ), // Use AssetImage instead of NetworkImage
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.description,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                              fontSize: 12,
                                            ),
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

                      const SizedBox(height: 16),

                      // Schedule Window
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Tasks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
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
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 3,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                itemBuilder: (context, index) {
                                  final tasks = [
                                    {
                                      'title': 'Water wheat field',
                                      'icon': Icons.water_drop,
                                      'color': Colors.blue,
                                    },
                                    {
                                      'title': 'Apply pesticides',
                                      'icon': Icons.pest_control,
                                      'color': Colors.orange,
                                    },
                                    {
                                      'title': 'Harvest corn',
                                      'icon': Icons.agriculture,
                                      'color': Colors.green,
                                    },
                                  ];

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          tasks[index]['color'] as Color,
                                      child: Icon(
                                        tasks[index]['icon'] as IconData,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      tasks[index]['title'] as String,
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Crop Disease Detection and Field Scanning in a Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildFeatureCard(
                                title: 'Crop Disease',
                                description: 'Analyze plant health',
                                icon: Icons.camera_alt,
                                color: Colors.redAccent,
                                onTap: () {
                                  _showImageSourceDialog();
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFeatureCard(
                                title: 'Field Scanning',
                                description: 'Monitor your fields',
                                icon: Icons.landscape,
                                color: Colors.green,
                                onTap: () {
                                  // Navigate to field scanning
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ask Our AI Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildFeatureCard(
                          title: 'Ask Our AI',
                          description: 'Get personalized farming advice',
                          icon: Icons.chat,
                          color: Colors.purple,
                          onTap: () {
                            // Navigate to AI chat screen
                            // Navigate to AI chat screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GeminiScreen(),
                              ),
                            );
                          },
                          fullWidth: true,
                        ),
                      ),

                      const SizedBox(height: 16),
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

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Result screen that shows the analysis output
class DiseaseResultScreen extends StatelessWidget {
  final String imagePath;
  final String diseaseName;
  final double confidence;
  final String treatment;

  const DiseaseResultScreen({
    super.key,
    required this.imagePath,
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection Results'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Analysis Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              title: 'Detected Disease',
              content: diseaseName,
              icon: Icons.bug_report,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Confidence',
              content: '${(confidence * 100).toStringAsFixed(1)}%',
              icon: Icons.analytics,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildResultCard(
              title: 'Recommended Treatment',
              content: treatment,
              icon: Icons.healing,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Here you could add functionality to save the result
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Result saved to history')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save To History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlantDiseaseDetector {
  late tfl.Interpreter _interpreter;
  final List<String> classNames = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Blueberry___healthy',
    'Cherry_(including_sour)___Powdery_mildew',
    'Cherry_(including_sour)___healthy',
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn_(maize)___Common_rust_',
    'Corn_(maize)___Northern_Leaf_Blight',
    'Corn_(maize)___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Pepper,_bell___Bacterial_spot',
    'Pepper,_bell___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Raspberry___healthy',
    'Soybean___healthy',
    'Squash___Powdery_mildew',
    'Strawberry___Leaf_scorch',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy',
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset(
        'assets/plant_disease_detection.tflite',
      );
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<String?> processImage(String imagePath) async {
    try {
      // Load the image
      File imageFile = File(imagePath);
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        print("Error: Unable to process image.");
        return null;
      }

      // Resize image to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Prepare input tensor [1, 224, 224, 3]
      var input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            var pixel = resizedImage.getPixel(x, y);
            // Convert pixel values to float and normalize
            return [
              img.getRed(pixel) / 255.0,
              img.getGreen(pixel) / 255.0,
              img.getBlue(pixel) / 255.0,
            ];
          }),
        ),
      );

      // Prepare output tensor [1, num_classes]
      var output = List.filled(
        1 * classNames.length,
        0.0,
      ).reshape([1, classNames.length]);

      // Run inference
      _interpreter.run(input, output);

      // Find the index of maximum probability
      int maxIndex = 0;
      double maxValue = output[0][0];
      for (int i = 1; i < classNames.length; i++) {
        if (output[0][i] > maxValue) {
          maxIndex = i;
          maxValue = output[0][i];
        }
      }

      return classNames[maxIndex];
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }
}
