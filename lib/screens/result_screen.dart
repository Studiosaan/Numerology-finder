import 'package:flutter/material.dart';
import 'package:numerology/numerology_calc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultScreen extends StatelessWidget {
  final String name;
  final DateTime? birthDate;

  const ResultScreen({super.key, required this.name, this.birthDate});

  @override
  Widget build(BuildContext context) {
    final NumerologyCalculator calculator = NumerologyCalculator();

    // Calculate name-based numbers (Always available)
    final int destinyNumber = calculator.calculateDestinyNumber(name);
    final int soulUrgeNumber = calculator.calculateSoulUrgeNumber(name);
    final int personalityNumber = calculator.calculatePersonalityNumber(name);

    // Calculate date-based numbers (Only if birthDate is provided)
    int? lifePathNumber;
    int? maturityNumber;
    int? birthdayNumber;
    List<int>? monthNumbers;
    int? reducedPersonalYear;

    if (birthDate != null) {
      lifePathNumber = calculator.calculateLifePathNumber(birthDate!);
      maturityNumber = calculator.calculateMaturityNumber(
        lifePathNumber,
        destinyNumber,
      );
      birthdayNumber = calculator.calculateBirthdayNumber(birthDate!);
      monthNumbers = calculator.calculateAllPersonalMonths(birthDate!);
      reducedPersonalYear = calculator.calculatePersonalYearNumber(birthDate!);
    }

    // --- 월수 계산을 위한 로직 추가 ---
    final String languageCode = Localizations.localeOf(context).languageCode;

    String getMonthText(int month) {
      if (languageCode == 'ko') {
        return '$month월수';
      } else {
        const monthAbbreviations = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return monthAbbreviations[month - 1];
      }
    }

    final int currentYear = DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // 내용이 길어질 수 있으므로 스크롤 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${AppLocalizations.of(context)!.name} : $name',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            if (birthDate != null)
              Text(
                '${AppLocalizations.of(context)!.birthDate} : ${birthDate!.toLocal().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.yourNumerologyResult,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10), // Add some space

            if (lifePathNumber != null)
              Text(
                '${AppLocalizations.of(context)!.lifePathNumber} ${calculator.getNumberText(lifePathNumber)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            Text(
              '${AppLocalizations.of(context)!.destinyNumber} ${calculator.getNumberText(destinyNumber)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${AppLocalizations.of(context)!.soulUrgeNumber} ${calculator.getNumberText(soulUrgeNumber)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${AppLocalizations.of(context)!.personalityNumber} ${calculator.getNumberText(personalityNumber)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (maturityNumber != null)
              Text(
                '${AppLocalizations.of(context)!.maturityNumber} ${calculator.getNumberText(maturityNumber)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (birthdayNumber != null)
              Text(
                '${AppLocalizations.of(context)!.birthdayNumber} ${calculator.getNumberText(birthdayNumber)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

            if (birthDate != null) ...[
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              // --- 개인 년수 표시 (수정됨) ---
              Text(
                // 요청하신 형식 (예: 1년수 : 2025 / 1)
                '${AppLocalizations.of(context)!.personalYearNumber} $currentYear / $reducedPersonalYear',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10), // 월수 목록 전에 여백 추가
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 왼쪽 열 (1월 ~ 6월)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 리스트 인덱스는 0부터 시작 (0=1월, 1=2월, ...)
                        Text(
                          '${getMonthText(1)} : ${monthNumbers![0]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3), // 항목 간 여백 추가
                        Text(
                          '${getMonthText(2)} : ${monthNumbers[1]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${getMonthText(3)} : ${monthNumbers[2]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${getMonthText(4)} : ${monthNumbers[3]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${getMonthText(5)} : ${monthNumbers[4]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${getMonthText(6)} : ${monthNumbers[5]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  // 오른쪽 열 (7월 ~ 12월)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${getMonthText(7)} : ${monthNumbers[6]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${getMonthText(8)} : ${monthNumbers[7]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),

                        Text(
                          '${getMonthText(9)} : ${monthNumbers[8]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),

                        Text(
                          '${getMonthText(10)} : ${monthNumbers[9]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),

                        Text(
                          '${getMonthText(11)} : ${monthNumbers[10]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 3),

                        Text(
                          '${getMonthText(12)} : ${monthNumbers[11]}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
