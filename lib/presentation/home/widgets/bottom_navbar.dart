import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
    required this.onSubmit,
    required this.controller,
  });

  final VoidCallback onSubmit;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: AppTheme.foregroundColor,
                filled: true,
              ),
              style: const TextStyle(color: AppTheme.backgroundColor),
              cursorColor: AppTheme.backgroundColor,
              controller: controller,
              onSubmitted: (value) => onSubmit(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSubmit,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.foregroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(15),
              child: const Icon(
                Icons.send,
                color: AppTheme.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
