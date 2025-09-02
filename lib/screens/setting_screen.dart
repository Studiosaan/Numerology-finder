import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numerology/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          // Language settings (commented out as per user request)
          /*
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'), // Replace with actual selected language
            onTap: () {
              // TODO: Implement language selection
            },
          ),
          */
        ],
      ),
    );
  }
}
