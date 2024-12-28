import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
    );
  }
}
