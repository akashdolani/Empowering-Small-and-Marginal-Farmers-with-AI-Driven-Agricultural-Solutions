import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solutionchallenge/models/language_model.dart';
import 'utils/app_localizations.dart';
import 'screens/cropmanagement.dart';
import 'screens/home.dart';
import 'screens/faq.dart';
import 'screens/hardware.dart';
import 'screens/profile.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => LanguageProvider(),
        child: const BhoomiApp(),
    )
  );
}

class BhoomiApp extends StatelessWidget {
  const BhoomiApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bhoomi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(languageProvider.currentLanguage.code);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('/api/placeholder/400/320'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bhoomi App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appLocalizations.translate('chooseLanguage'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: languageProvider.availableLanguages.length,
                      itemBuilder: (context, index) {
                        final language = languageProvider.availableLanguages[index];
                        final isSelected = language.code == languageProvider.currentLanguage.code;

                        return Card(
                          color: isSelected ? Colors.green.shade50 : null,
                          child: ListTile(
                            title: Text(language.name),
                            subtitle: Text(language.nativeName),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : null,
                            onTap: () {
                              languageProvider.setLanguage(language);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      appLocalizations.translate('continue'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Modify your LoginScreen to include translations
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(languageProvider.currentLanguage.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: appLocalizations.translate('changeLanguage'),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('/api/placeholder/400/320'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          appLocalizations.translate('appTitle'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Agriculture Assistant',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: appLocalizations.translate('mobileOrEmail'),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number or email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: appLocalizations.translate('password'),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot password functionality
                            },
                            child: Text(appLocalizations.translate('forgotPassword')),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            appLocalizations.translate('login'),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(appLocalizations.translate('dontHaveAccount')),
                            TextButton(
                              onPressed: () {
                                // Register functionality
                              },
                              child: Text(appLocalizations.translate('register')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                appLocalizations.translate('or'),
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        // Rest of your login screen remains the same
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final appLocalizations = AppLocalizations(languageProvider.currentLanguage.code);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('chooseLanguage')),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageProvider.availableLanguages.length,
              itemBuilder: (context, index) {
                final language = languageProvider.availableLanguages[index];
                final isSelected = language.code == languageProvider.currentLanguage.code;

                return ListTile(
                  title: Text(language.name),
                  subtitle: Text(language.nativeName),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    languageProvider.setLanguage(language);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(appLocalizations.translate('continue')),
            ),
          ],
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const HardwareTab(),
    const FAQTab(),
    const CropManagementTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hardware),
            label: 'Hardware',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'My Crop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}









