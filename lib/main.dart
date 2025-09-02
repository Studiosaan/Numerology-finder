import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:numerology/screens/result_screen.dart';
import 'package:numerology/themes.dart';
import 'package:numerology/widgets/custom_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:numerology/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Numerology',
          theme: numerologyTheme,
          darkTheme: numerologyDarkTheme, // Define this in themes.dart
          themeMode: themeProvider.themeMode,
          home: const InputScreen(),
        );
      },
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _showResults = false;
  List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getStringList('history') ?? [];
    setState(() {
      _history = historyString
          .map((item) => Map<String, String>.from(json.decode(item)))
          .toList();
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final newEntry = {
      'name': _nameController.text,
      'date': _selectedDate!.toIso8601String(),
    };

    // Avoid duplicates
    _history.removeWhere((item) => item['name'] == newEntry['name'] && item['date'] == newEntry['date']);
    _history.insert(0, newEntry);

    // Keep only the last 20 entries
    if (_history.length > 20) {
      _history = _history.sublist(0, 20);
    }

    final historyString = _history.map((item) => json.encode(item)).toList();
    await prefs.setStringList('history', historyString);
    _loadHistory(); // Reload to ensure UI is in sync
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _calculate() {
    if (_nameController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _showResults = true;
      });
      _saveHistory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name and birth date.'),
        ),
      );
    }
  }

  void _showInputScreen() {
    setState(() {
      _showResults = false;
    });
  }

  void _clearInput() {
    setState(() {
      _nameController.clear();
      _selectedDate = null;
    });
  }

  void _applyHistory(Map<String, String> entry) {
    setState(() {
      _nameController.text = entry['name']!;
      _selectedDate = DateTime.parse(entry['date']!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_showResults) {
      bodyContent = Column(
        children: [
          ResultScreen(
            name: _nameController.text,
            birthDate: _selectedDate!,
          ),
          ElevatedButton(
            onPressed: _showInputScreen,
            child: const Text('Back'),
          ),
        ],
      );
    } else {
      bodyContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date chosen!'
                        : _selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Choose Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  child: const Text('Calculate'),
                ),
                ElevatedButton(
                  onPressed: _clearInput,
                  child: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final entry = _history[index];
                  return ListTile(
                    title: Text(entry['name']!),
                    subtitle: Text(entry['date']!.split('T')[0]),
                    onTap: () => _applyHistory(entry),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return CustomAppScreen(
      title: 'Numerology Finder',
      icon: Icons.calculate,
      body: bodyContent,
    );
  }
}
