import 'package:flutter/material.dart';
import 'package:solutionchallenge/models/language_model.dart';
import '../utils/app_localizations.dart';
import 'package:provider/provider.dart';

// Main ShopTab class
class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  // Selected category
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('shop')),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 99, 194, 104),
      ),
      backgroundColor: Color.fromARGB(255, 99, 194, 104),
      body: Container(
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
          child: Column(
            children: [
              // App logo
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/final_applogo.PNG',
                    height: 40,
                    width: 175,
                  ),
                ),
              ),
              
              // Category selection buttons
              if (_selectedCategory.isEmpty)
                _buildCategorySelection(),
              
              // Show farming tools if selected
              if (_selectedCategory == 'Farming Tools')
                _buildFarmingToolsList(context),
              
              // Show crops if selected
              if (_selectedCategory == 'Crops')
                _buildCropsList(context),
            ],
          ),
        ),
      ),
    );
  }

  // Category selection buttons
  Widget _buildCategorySelection() {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            appLocalizations.translate('q1'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              // Farming Tools Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'Farming Tools';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.handyman, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        appLocalizations.translate('option1'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Crops Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'Crops';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.spa, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        appLocalizations.translate('option2'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Farming Tools list
  Widget _buildFarmingToolsList(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedCategory = '';
                  });
                },
              ),
              Text(
                appLocalizations.translate('toolsH'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('tool1T'),
            description: appLocalizations.translate('tool1D'),
            price: '₹500 - ₹2000',
            imageAsset: 'assets/hand_tools.jpg',
            details: appLocalizations.translate('toolDe'),
            isCrop: false,
          ),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('tool2T'),
            description: appLocalizations.translate('tool2D'),
            price: '₹2000 - ₹15000',
            imageAsset: 'assets/power_tools.jpg',
            details: appLocalizations.translate('tool2De'),
            isCrop: false,
          ),
          _buildToolItem(
           context: context,
            name: appLocalizations.translate('tool3T'),
            description: appLocalizations.translate('tool3D'),
            price: '₹1500 - ₹5000',
            imageAsset: 'assets/iot_sensors.jpg',
            details: appLocalizations.translate('tool3De'),
            isCrop: false,
          ),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('tool4T'),
            description: appLocalizations.translate('tool4D'),
            price: '₹3000 - ₹25000',
            imageAsset: 'assets/irrigation.jpg',
            details: appLocalizations.translate('tool4De'),
            isCrop: false,
          ),
        ],
      ),
    );
  }

  // Crops list
  Widget _buildCropsList(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedCategory = '';
                  });
                },
              ),
              Text(
                appLocalizations.translate('cropT'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('crop1T'),
            description: appLocalizations.translate('crop1D'),
            price: '₹200 - ₹500 per kg',
            imageAsset: 'assets/wheat_seeds.jpg',
            details: appLocalizations.translate('crop1De'),
            isCrop: true,
            marketPrice: '₹2200 - ₹2400 per quintal',
            growingPeriod: '100-120 days',
            soilType: 'Loamy soil',
          ),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('crop2T'),
            description: appLocalizations.translate('crop2D'),
            price: '₹300 - ₹700 per kg',
            imageAsset: 'assets/rice_seeds.jpg',
            details: appLocalizations.translate('crop2De'),
            isCrop: true,
            marketPrice: '₹1800 - ₹2100 per quintal',
            growingPeriod: '120-150 days',
            soilType: 'Clay loam',
          ),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('crop3T'),
            description: appLocalizations.translate('crop3D'),
            price: '₹800 - ₹1200 per kg',
            imageAsset: 'assets/cotton_seeds.jpg',
            details: appLocalizations.translate('crop3De'),
            isCrop: true,
            marketPrice: '₹6000 - ₹6500 per quintal',
            growingPeriod: '160-180 days',
            soilType: 'Black soil',
          ),
          _buildToolItem(
            context: context,
            name: appLocalizations.translate('crop4T'),
            description: appLocalizations.translate('crop4D'),
            price: '₹250 - ₹600 per kg',
            imageAsset: 'assets/soybean_seeds.webp',
            details: appLocalizations.translate('crop4De'),
            isCrop: true,
            marketPrice: '₹3800 - ₹4200 per quintal',
            growingPeriod: '90-120 days',
            soilType: 'Well-drained loam',
          ),
        ],
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
    required bool isCrop,
    String marketPrice = '',
    String growingPeriod = '',
    String soilType = '',
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
          child: Icon(
            isCrop ? Icons.spa : Icons.shopping_bag,
            color: isCrop ? Colors.green : Colors.blue,
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
                builder: (context) => isCrop
                    ? CropDetailPage(
                        name: name,
                        description: description,
                        price: price,
                        imageAsset: imageAsset,
                        details: details,
                        marketPrice: marketPrice,
                        growingPeriod: growingPeriod,
                        soilType: soilType,
                      )
                    : ToolDetailPage(
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
            backgroundColor: isCrop ? Colors.green : Colors.blue,
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
                        _showPurchaseDialog(context, name, price, 'Sell');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
      title: Text(
        type == 'buy'
            ? 'Purchase Confirmation'
            : type == 'rent'
                ? 'Rental Confirmation'
                : 'Sell Confirmation',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type == 'buy'
                ? 'You are about to purchase $name'
                : type == 'rent'
                    ? 'You are about to rent $name'
                    : 'You are about to sell $name',
          ),
          const SizedBox(height: 8),
          if (type == 'rent')
            const Text('Rental period: 7 days')
          else if (type == 'sell')
            const Text('Item will be picked up within 24 hours'),
          const SizedBox(height: 8),
          Text(
            'Amount: ${type == 'rent' ? _calculateRentalPrice(price) : price}',
          ),
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
      content: Text(
        type == 'buy'
            ? 'Your purchase was successful. The item will be delivered soon.'
            : type == 'rent'
                ? 'Your rental was successful. The item will be available for pickup soon.'
                : 'Your sell request was successful. The item will be picked up soon.',
      ),
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

// Detail page for crops
class CropDetailPage extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageAsset;
  final String details;
  final String marketPrice;
  final String growingPeriod;
  final String soilType;

  const CropDetailPage({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.details,
    required this.marketPrice,
    required this.growingPeriod,
    required this.soilType,
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
              // Crop image
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

              // Crop name and price
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

              // Market Price Info Card
              Card(
                color: Colors.amber.shade50,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text(
                            'Current Market Price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        marketPrice,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Market rates as of last week)',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Crop description
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
              const SizedBox(height: 16),

              // Growing information
              _buildInfoItem('Growing Period', growingPeriod, Icons.calendar_today),
              _buildInfoItem('Recommended Soil Type', soilType, Icons.landscape),

              const SizedBox(height: 32),

              // Buy option
              ElevatedButton(
                onPressed: () {
                  _showPurchaseDialog(context, name, price, 'buy');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Purchase Seeds',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Sell option
              ElevatedButton(
                onPressed: () {
                  _showPurchaseDialog(context, name, price, 'sell');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sell Seeds',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String name, String price, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          type == 'buy'
              ? 'Purchase Confirmation'
              : 'Sell Confirmation', // No 'rent' here, only buy/sell
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == 'buy'
                  ? 'You are about to purchase seeds for $name'
                  : 'You are about to sell seeds for $name',
            ),
            const SizedBox(height: 8),
            if (type == 'sell')
              const Text('Seeds will be picked up within 24 hours'),
            const SizedBox(height: 8),
            Text('Amount: $price'), // For simplicity, using the same price
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
        content: Text(
          type == 'buy'
              ? 'Your purchase was successful. The seeds will be delivered soon.'
              : 'Your sell request was successful. The seeds will be picked up soon.',
        ),
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
}