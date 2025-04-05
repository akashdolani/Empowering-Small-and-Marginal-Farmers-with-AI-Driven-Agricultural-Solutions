import 'package:flutter/material.dart';

// Add this to a new file: lib/utils/app_localizations.dart
class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'KisanSahayak',
      'login': 'Login',
      'register': 'Register',
      'forgotPassword': 'Forgot Password?',
      'mobileOrEmail': 'Mobile Number / Email',
      'password': 'Password',
      'dontHaveAccount': "Don't have an account?",
      'or': 'OR',
      'chooseLanguage': 'Choose Language',
      'continue': 'Continue',
      'home': 'Home',
      'hardware': 'Hardware',
      'faq': 'FAQ',
      'myCrop': 'My Crop',
      'krishiGyan': 'Krishi Gyan',
      'changeLanguage': 'Change Language',
    },
    'hi': {
      'appTitle': 'किसानसहायक',
      'login': 'लॉगिन',
      'register': 'रजिस्टर',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'mobileOrEmail': 'मोबाइल नंबर / ईमेल',
      'password': 'पासवर्ड',
      'dontHaveAccount': "खाता नहीं है?",
      'or': 'या',
      'chooseLanguage': 'भाषा चुनें',
      'continue': 'जारी रखें',
      'home': 'होम',
      'hardware': 'हार्डवेयर',
      'faq': 'अक्सर पूछे जाने वाले प्रश्न',
      'myCrop': 'मेरी फसल',
      'krishiGyan': 'कृषि ज्ञान',
      'changeLanguage': 'भाषा बदलें',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations('en');
  }
}