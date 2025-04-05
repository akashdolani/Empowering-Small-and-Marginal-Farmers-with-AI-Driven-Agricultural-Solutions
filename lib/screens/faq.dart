import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQTab extends StatelessWidget {
  const FAQTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 99, 194, 104),
      ),
      // Apply the background color to the entire Scaffold
      backgroundColor: Color.fromARGB(255, 99, 194, 104),
      body: Container(
        // This container now covers the entire body with the gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 99, 194, 104), const Color.fromARGB(255, 152, 175, 153)],
          ),
        ),
        // Make container fill the entire available space
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/final_applogo.PNG',
                    height: 40,
                    width: 175,
                  ),
                ),
                const SizedBox(height: 24),
                _buildFaqItem(
                  question: 'How to use soil moisture sensors?',
                  answer:
                  'Install the sensor probe in soil at root level. Connect to the receiver and calibrate according to soil type. Monitor readings through the app.',
                ),
                _buildFaqItem(
                  question: 'What crops are suitable for my region?',
                  answer:
                  'The app analyzes your location, soil type, and climate data to recommend suitable crops. Go to My Crop section and use the Crop Advisor feature.',
                ),
                _buildFaqItem(
                  question: 'How to troubleshoot hardware issues?',
                  answer:
                  'Check power supply and connections. Ensure devices are within network range. Clean sensors regularly. For persistent issues, contact customer support.',
                ),
                _buildFaqItem(
                  question: 'When is the best time to harvest?',
                  answer:
                  'Optimal harvest time varies by crop. The app provides notifications based on crop maturity, weather forecasts, and market conditions.',
                ),
                _buildFaqItem(
                  question: 'How do I update my device firmware?',
                  answer:
                  'Go to Hardware section, select your device, and check for available updates. Ensure your device is charged above 50% before updating.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}