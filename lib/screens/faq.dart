import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solutionchallenge/models/language_model.dart';
import '../utils/app_localizations.dart';
import 'package:provider/provider.dart';

class FAQTab extends StatelessWidget {
  const FAQTab({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations(
      languageProvider.currentLanguage.code,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('faq')),
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
                  question: appLocalizations.translate('faq1'),
                  answer:
                  appLocalizations.translate('faq1A'),
                ),
                _buildFaqItem(
                  question: appLocalizations.translate('faq2'),
                  answer:
                  appLocalizations.translate('faq2A'),
                ),
                _buildFaqItem(
                  question: appLocalizations.translate('faq3'),
                  answer:
                  appLocalizations.translate('faq3A'),
                ),
                _buildFaqItem(
                  question: appLocalizations.translate('faq4'),
                  answer:
                  appLocalizations.translate('faq4A'),
                ),
                _buildFaqItem(
                  question: appLocalizations.translate('faq5'),
                  answer:
                  appLocalizations.translate('faq5A'),
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