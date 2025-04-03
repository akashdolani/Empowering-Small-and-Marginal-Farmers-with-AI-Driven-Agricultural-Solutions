import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  void _analyzeImage(File imageFile) {
    // This is where you would call your disease detection function
    // For now, we'll just navigate to a results screen with dummy data

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseResultScreen(
          imagePath: imageFile.path,
          diseaseName: "Leaf Spot",
          confidence: 0.87,
          treatment: "Apply fungicide and ensure proper spacing between plants.",
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
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
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
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cloudy',
                      style: TextStyle(
                        color: Colors.white,
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
    Key? key,
    required this.imagePath,
    required this.diseaseName,
    required this.confidence,
    required this.treatment,
  }) : super(key: key);

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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