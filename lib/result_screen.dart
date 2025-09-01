import 'package:flutter/material.dart';
import 'package:numerology/numerology_calc.dart';

class ResultScreen extends StatelessWidget {
  final String name;
  final DateTime birthDate;

  const ResultScreen({super.key, required this.name, required this.birthDate});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Numerology'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
                        Text('Birth Date: ${birthDate.toLocal().toString().split(' ')[0]}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text(
              'Your Numerology Result:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}