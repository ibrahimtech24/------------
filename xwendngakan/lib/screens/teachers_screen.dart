import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مامۆستاکانم'),
        backgroundColor: AppTheme.navy,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_rounded, size: 80, color: AppTheme.warning),
            SizedBox(height: 20),
            Text(
              'بەشی مامۆستاکانم بەمنزیکانە بەردەست دەبێت',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
