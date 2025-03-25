import 'package:flutter/material.dart';

class FAQTab extends StatelessWidget {
  const FAQTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                '/api/placeholder/400/320',
                width: 150,
                height: 150,
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