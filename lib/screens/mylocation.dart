import 'package:flutter/material.dart';


class MyLocationTab extends StatelessWidget {
  const MyLocationTab({super.key});

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
              const SizedBox(height: 40),
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
                        title: 'Crop Calendar',
                        subtitle: 'Schedule farm activities',
                        icon: Icons.calendar_today,
                        color: Colors.orange,
                      ),
                      _buildCropCard(
                        title: 'Market Prices',
                        subtitle: 'Current crop rates',
                        icon: Icons.trending_up,
                        color: Colors.red,
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