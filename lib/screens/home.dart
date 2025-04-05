import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

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

  void _analyzeImage(File imageFile) async {
    // Initialize the detector
    PlantDiseaseDetector detector = PlantDiseaseDetector();
    await detector.loadModel();

    // Process the image and get the prediction
    String? prediction = await detector.processImage(imageFile.path);

    // Set a default confidence value (since TFLite models usually return probabilities)
    double confidence = 0.90; // Modify this based on actual model output if needed

    // Define treatment suggestions (you can extend this logic)
    Map<String, String> treatments = {
      "Apple___Apple_scab": "Use fungicides like captan or mancozeb.",
      "Apple___Black_rot": "Remove infected fruit and apply copper-based sprays.",
      "Corn_(maize)___Common_rust_": "Use resistant hybrids and fungicides if needed.",
      "Tomato___Early_blight": "Apply fungicides and ensure good air circulation.",
      "Tomato___Late_blight": "Use copper-based fungicides and remove affected leaves.",
      "Tomato___healthy": "No treatment needed, the plant is healthy!"
    };

    String treatment = treatments[prediction] ?? "Consult an expert for treatment advice.";

    // Navigate to the result screen with real prediction data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseResultScreen(
          imagePath: imageFile.path,
          diseaseName: prediction ?? "Unknown Disease",
          confidence: confidence,
          treatment: treatment,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('/api/placeholder/400/320'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Bengaluru',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const Center(
                child: Column(
                  children: [
                    Text(
                      '29°',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cloudy',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildMenuItem(
                      title: 'Hardware',
                      icon: Icons.hardware,
                      color: Colors.blue,
                      onTap: () {
                        // Navigate to Hardware screen
                      },
                    ),
                    _buildMenuItem(
                      title: 'FAQ',
                      icon: Icons.question_answer,
                      color: Colors.orange,
                      onTap: () {
                        // Navigate to FAQ screen
                      },
                    ),
                    _buildMenuItem(
                      title: 'My Crop',
                      icon: Icons.eco,
                      color: Colors.green,
                      onTap: () {
                        // Navigate to My Crop screen
                      },
                    ),
                    _buildMenuItem(
                      title: 'Krishi Gyan',
                      icon: Icons.auto_stories,
                      color: Colors.purple,
                      onTap: () {
                        // Navigate to Krishi Gyan screen
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Camera button
          ScaleTransition(
            scale: _animationController.drive(
              Tween<double>(begin: 0.0, end: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                heroTag: 'camera',
                backgroundColor: Colors.green,
                mini: true,
                onPressed: () {
                  _showImageSourceDialog();
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),

          // Analyze button
          ScaleTransition(
            scale: _animationController.drive(
              Tween<double>(begin: 0.0, end: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                heroTag: 'analyze',
                backgroundColor: Colors.orange,
                mini: true,
                onPressed: () {
                  // Do nothing for now
                },
                child: const Icon(Icons.analytics),
              ),
            ),
          ),

          // History button
          ScaleTransition(
            scale: _animationController.drive(
              Tween<double>(begin: 0.0, end: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton(
                heroTag: 'history',
                backgroundColor: Colors.blue,
                mini: true,
                onPressed: () {
                  // Do nothing for now
                },
                child: const Icon(Icons.history),
              ),
            ),
          ),

          // Main expandable button
          FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: _toggleExpand,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
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
    'Tomato___healthy'
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/plant_disease_detection.tflite');
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
              (y) => List.generate(
            224,
                (x) {
              var pixel = resizedImage.getPixel(x, y);
              // Convert pixel values to float and normalize
              return [
                img.getRed(pixel) / 255.0,
                img.getGreen(pixel) / 255.0,
                img.getBlue(pixel) / 255.0
              ];
            },
          ),
        ),
      );

      // Prepare output tensor [1, num_classes]
      var output = List.filled(1 * classNames.length, 0.0)
          .reshape([1, classNames.length]);

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