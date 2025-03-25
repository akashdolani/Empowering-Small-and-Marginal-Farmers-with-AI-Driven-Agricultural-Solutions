// Add this to a new file: lib/providers/language_provider.dart
import 'package:flutter/material.dart';

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName
  });
}

class LanguageProvider with ChangeNotifier {
  LanguageModel _currentLanguage = LanguageModel(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );

  LanguageModel get currentLanguage => _currentLanguage;

  List<LanguageModel> get availableLanguages => [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageModel(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    LanguageModel(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    LanguageModel(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    LanguageModel(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
  ];

  void setLanguage(LanguageModel language) {
    _currentLanguage = language;
    notifyListeners();
  }
}