import 'package:flutter/material.dart';

// Main ShopTab class
class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
        backgroundColor:  Color.fromARGB(255, 99, 194, 104),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 99, 194, 104), const Color.fromARGB(255, 152, 175, 153)],
          ),
        ),
        child: SingleChildScrollView(
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
                      context: context,
                      name: 'Hand Tools',
                      description: 'Basic farming tools for manual work',
                      price: '₹500 - ₹2000',
                      imageAsset: 'assets/hand_tools.png',
                      details: 'Hand tools include shovels, hoes, pruning shears, and other manual implements essential for basic farming tasks.',
                    ),
                    _buildToolItem(
                      context: context,
                      name: 'Power Tools',
                      description: 'Efficient tools for faster work',
                      price: '₹2000 - ₹15000',
                      imageAsset: 'assets/power_tools.png',
                      details: 'Power tools include tillers, chainsaws, and trimmers that increase efficiency and reduce manual labor.',
                    ),
                    _buildToolItem(
                      context: context,
                      name: 'IoT Sensors',
                      description: 'Smart monitoring for your farm',
                      price: '₹1500 - ₹5000',
                      imageAsset: 'assets/iot_sensors.png',
                      details: 'IoT sensors monitor soil moisture, temperature, and other important parameters to optimize crop growth.',
                    ),
                    _buildToolItem(
                      context: context,
                      name: 'Irrigation Systems',
                      description: 'Water management solutions',
                      price: '₹3000 - ₹25000',
                      imageAsset: 'assets/irrigation.png',
                      details: 'Irrigation systems include drip, sprinkler, and other water distribution technologies for efficient water usage.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolItem({
    required BuildContext context,
    required String name,
    required String description,
    required String price,
    required String imageAsset,
    required String details,
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
            Icons.shopping_bag,
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToolDetailPage(
                  name: name,
                  description: description,
                  price: price,
                  imageAsset: imageAsset,
                  details: details,
                ),
              ),
            );
          },
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

// Detail page for each tool
class ToolDetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageAsset;
  final String details;

  const ToolDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tool image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageAsset,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Tool name and price
              Text(
                name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Tool description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              
              // Detailed information
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              // Buy or Rent options
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showPurchaseDialog(context, name, price, 'buy');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showPurchaseDialog(context, name, price, 'rent');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Rent',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showPurchaseDialog(context, name, price, 'sell');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 215, 41, 28),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Sell',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String name, String price, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(type == 'buy' ? 'Purchase Confirmation' : 'Rental Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to ${type == 'buy' ? 'purchase' : 'rent'} $name'),
            const SizedBox(height: 8),
            if (type == 'rent')
              const Text('Rental period: 7 days'),
            const SizedBox(height: 8),
            Text('Amount: ${type == 'rent' ? _calculateRentalPrice(price) : price}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(context, type);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Text(type == 'buy' 
          ? 'Your purchase was successful. The item will be delivered soon.' 
          : 'Your rental was successful. The item will be available for pickup soon.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  String _calculateRentalPrice(String price) {
    // Extract the lower price from the range (e.g., "₹500 - ₹2000" → "₹500")
    final lowerPrice = price.split(' - ')[0];
    // Parse the number
    final priceValue = int.parse(lowerPrice.replaceAll('₹', '').trim());
    // Calculate rental price (30% of purchase price for 7 days)
    final rentalPrice = (priceValue * 0.3).round();
    return '₹$rentalPrice for 7 days';
  }
}