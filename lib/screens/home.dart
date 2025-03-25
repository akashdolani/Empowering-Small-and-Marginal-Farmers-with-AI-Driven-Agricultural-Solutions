import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
}