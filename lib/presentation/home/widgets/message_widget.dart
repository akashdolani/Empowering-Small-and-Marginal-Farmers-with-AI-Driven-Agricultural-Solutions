import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/chat/message.dart';
import '../../widgets/logo.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = message.isResponse ? null : AppTheme.geminiGradient;

    return Row(
      mainAxisAlignment:
          message.isResponse ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isResponse) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AppLogo(size: 24),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            gradient: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.all(10),
          child: Text(message.text),
        ),
      ],
    );
  }
}
