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
    final int maturityNumber =
        calculator.calculateMaturityNumber(lifePathNumber, destinyNumber);
    final int birthdayNumber = calculator.calculateBirthdayNumber(birthDate);

    // --- 월수 계산을 위한 로직 추가 ---
    // 현재 언어 코드 가져오기 (ko, en 등)
    final String languageCode = Localizations.localeOf(context).languageCode;

    // 월별 텍스트를 생성하는 함수
    String getMonthText(int month) {
      if (languageCode == 'ko') {
        return '$month월수';
      } else {
        const monthAbbreviations = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        // month는 1부터 시작하므로 인덱스로 사용하기 위해 1을 뺍니다.
        return monthAbbreviations[month - 1];
      }
    }
    final int personalYearNumber =
        calculator.calculatePersonalYearNumber(birthDate);
    // 1. 개인 년수를 먼저 축약합니다 (예: 1)
    final int reducedPersonalYear = calculator.reduceNumber(personalYearNumber);
    // 2. 현재 년도를 가져옵니다 (예: 2025)
    final int currentYear = DateTime.now().year;

    // 3. 12개월의 월수를 계산합니다.
    // ✨ [수정됨] 사용자의 요청(예: 11 -> 1+1 = 2)에 따라,
    // 마스터 넘버(11, 22)를 포함한 모든 두 자리 수를 한 자리로 축약합니다.
    final List<int> monthNumbers = [];
    for (int month = 1; month <= 12; month++) {
      int sum = reducedPersonalYear + month;

      // 수가 9보다 클 경우 (즉, 두 자리 수 이상일 경우)
      // 한 자리가 될 때까지 각 자리수를 계속 더합니다.
      while (sum > 9) {
        int newSum = 0;
        int tempNum = sum;
        while (tempNum > 0) {
          newSum += tempNum % 10; // 1의 자리 숫자 더하기
          tempNum = tempNum ~/ 10; // 10의 자리 숫자를 1의 자리로 만들기
        }
        sum = newSum;
        // 예: sum = 19 -> newSum = 1+9=10 -> sum=10
        // (바깥쪽 while문) sum = 10 > 9 이므로 다시 반복
        // 예: sum = 10 -> newSum = 1+0=1 -> sum=1
        // (바깥쪽 while문) sum = 1 <= 9 이므로 종료.
      }

      monthNumbers.add(sum);
    }
    // ---------------------------------

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // 내용이 길어질 수 있으므로 스크롤 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${AppLocalizations.of(context)!.name} : $name',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text(
                '${AppLocalizations.of(context)!.birthDate} : ${birthDate.toLocal().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.yourNumerologyResult,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10), // Add some space

            Text(
                '${AppLocalizations.of(context)!.lifePathNumber} ${calculator.getNumberText(lifePathNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                '${AppLocalizations.of(context)!.destinyNumber} ${calculator.getNumberText(destinyNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                '${AppLocalizations.of(context)!.soulUrgeNumber} ${calculator.getNumberText(soulUrgeNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                '${AppLocalizations.of(context)!.personalityNumber} ${calculator.getNumberText(personalityNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                '${AppLocalizations.of(context)!.maturityNumber} ${calculator.getNumberText(maturityNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
            Text(
                '${AppLocalizations.of(context)!.birthdayNumber} ${calculator.getNumberText(birthdayNumber)}',
                style: Theme.of(context).textTheme.bodyLarge),
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
                      Text('${getMonthText(1)} : ${monthNumbers[0]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3), // 항목 간 여백 추가
                      Text('${getMonthText(2)} : ${monthNumbers[1]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
                      Text('${getMonthText(3)} : ${monthNumbers[2]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
                      Text('${getMonthText(4)} : ${monthNumbers[3]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
                      Text('${getMonthText(5)} : ${monthNumbers[4]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
                      Text('${getMonthText(6)} : ${monthNumbers[5]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                // 오른쪽 열 (7월 ~ 12월)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${getMonthText(7)} : ${monthNumbers[6]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
                      Text('${getMonthText(8)} : ${monthNumbers[7]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
      
                      Text('${getMonthText(9)} : ${monthNumbers[8]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
      
                      Text('${getMonthText(10)} : ${monthNumbers[9]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
      
                      Text('${getMonthText(11)} : ${monthNumbers[10]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 3),
      
                      Text('${getMonthText(12)} : ${monthNumbers[11]}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
