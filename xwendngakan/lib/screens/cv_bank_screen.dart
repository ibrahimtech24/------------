import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CvBankScreen extends StatelessWidget {
  const CvBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بانکی سیڤی'),
        backgroundColor: AppTheme.navy,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_rounded, size: 80, color: AppTheme.success),
            SizedBox(height: 20),
            Text(
              'بەشی بانکی سیڤی بەمنزیکانە بەردەست دەبێت',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
