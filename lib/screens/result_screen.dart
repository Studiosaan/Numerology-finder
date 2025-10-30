import 'package:flutter/material.dart';
import 'package:numerology/numerology_calc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final int personalYearNumber = calculator.calculatePersonalYearNumber(birthDate);
    final int personalMonthNumber = calculator.calculatePersonalMonthNumber(personalYearNumber);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${AppLocalizations.of(context)!.name} : $name', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('${AppLocalizations.of(context)!.birthDate} : ${birthDate.toLocal().toString().split(' ')[0]}', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.yourNumerologyResult,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10), // Add some space
          Text('${AppLocalizations.of(context)!.lifePathNumber} ${calculator.getNumberText(lifePathNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.destinyNumber} ${calculator.getNumberText(destinyNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.soulUrgeNumber} ${calculator.getNumberText(soulUrgeNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.personalityNumber} ${calculator.getNumberText(personalityNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.maturityNumber} ${calculator.getNumberText(maturityNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.birthdayNumber} ${calculator.getNumberText(birthdayNumber)}',style : Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Text('${AppLocalizations.of(context)!.personalYearNumber} ${calculator.reduceNumber(personalYearNumber)}', style: Theme.of(context).textTheme.bodyLarge),
          Text('${AppLocalizations.of(context)!.personalMonthNumber} ${calculator.reduceNumber(personalYearNumber)}', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}