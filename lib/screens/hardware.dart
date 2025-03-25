import 'package:flutter/material.dart';

class HardwareTab extends StatelessWidget {
  const HardwareTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hardware'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              '/api/placeholder/400/320',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agricultural Tools',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildToolItem(
                    name: 'Hand Tools',
                    description: 'Basic farming tools for manual work',
                    price: '₹500 - ₹2000',
                  ),
                  _buildToolItem(
                    name: 'Power Tools',
                    description: 'Efficient tools for faster work',
                    price: '₹2000 - ₹15000',
                  ),
                  _buildToolItem(
                    name: 'IoT Sensors',
                    description: 'Smart monitoring for your farm',
                    price: '₹1500 - ₹5000',
                  ),
                  _buildToolItem(
                    name: 'Irrigation Systems',
                    description: 'Water management solutions',
                    price: '₹3000 - ₹25000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolItem({
    required String name,
    required String description,
    required String price,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.hardware,
            color: Colors.blue,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('View'),
        ),
      ),
    );
  }
}