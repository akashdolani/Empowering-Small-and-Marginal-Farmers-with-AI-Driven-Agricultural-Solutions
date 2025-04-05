import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../models/chat/message.dart';
import '../widgets/loading_spinner.dart';
import 'widgets/bottom_navbar.dart';
import 'widgets/message_widget.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  bool _isLoading = false;
  final _controller = TextEditingController();
  final _messages = <Message>[];

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? 'DEFAULT_API_KEY',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final input = _controller.text.trim();
      if (input.isEmpty) {
        return;
      }

      _controller.clear();
      setState(() {
        _messages.insert(0, Message(text: input));
      });

      final response = await model.generateContent([Content.text(input)]);

      _messages.insert(
        0,
        Message(
          text: response.text ?? 'Something went wrong.',
          isResponse: true,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _messages.insert(
        0,
        const Message(
          text: 'Something went wrong.',
          isResponse: true,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageWidget(message: _messages[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RotatingSpinner(),
              ),
            ),
          ],
          BottomBarWidget(onSubmit: _onSubmit, controller: _controller),
        ],
      ),
    );
  }
}
