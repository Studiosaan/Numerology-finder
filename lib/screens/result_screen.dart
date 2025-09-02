import 'package:flutter/material.dart';
import 'package:numerology/numerology_calc.dart';

class ResultScreen extends StatelessWidget {
  final String name;
  final DateTime birthDate;

  const ResultScreen({super.key, required this.name, required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final NumerologyCalculator calculator = NumerologyCalculator();

    // Calculate all numerology numbers
    final int lifePathNumber = calculator.calculateLifePathNumber(birthDate);
    final int destinyNumber = calculator.calculateDestinyNumber(name);
    final int soulUrgeNumber = calculator.calculateSoulUrgeNumber(name);
    final int personalityNumber = calculator.calculatePersonalityNumber(name);
    final int maturityNumber = calculator.calculateMaturityNumber(lifePathNumber, destinyNumber);
    final int birthdayNumber = calculator.calculateBirthdayNumber(birthDate);

    return Padding(
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
          const SizedBox(height: 10), // Add some space
          Text('Life Path Number: ${calculator.getNumberText(lifePathNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('Destiny Number: ${calculator.getNumberText(destinyNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('Soul Urge Number: ${calculator.getNumberText(soulUrgeNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('Personality Number: ${calculator.getNumberText(personalityNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('Maturity Number: ${calculator.getNumberText(maturityNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('Birthday Number: ${calculator.getNumberText(birthdayNumber)}', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}