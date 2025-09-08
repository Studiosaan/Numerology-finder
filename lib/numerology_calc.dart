import 'package:flutter/material.dart';

// 한글 자음을 숫자로 변환하는 맵
const Map<String, int> _koreanConsonantToNumberMap = {
  'ㄱ': 1, 'ㄲ': 1,
  'ㄴ': 2,
  'ㄷ': 3, 'ㄸ': 3,
  'ㄹ': 4,
  'ㅁ': 5,
  'ㅂ': 6, 'ㅃ': 6,
  'ㅅ': 7, 'ㅆ': 7,
  'ㅇ': 8,
  'ㅈ': 9, 'ㅉ': 9,
  'ㅊ': 10,
  'ㅋ': 11,
  'ㅌ': 12,
  'ㅍ': 13,
  'ㅎ': 14,
};

// 한글 모음을 숫자로 변환하는 맵
const Map<String, int> _koreanVowelToNumberMap = {
  'ㅏ': 1, 'ㅐ': 11, 'ㅑ': 2, 'ㅒ': 12, 'ㅓ': 3, 'ㅔ': 13, 'ㅕ': 4, 'ㅖ': 14, 'ㅗ': 5, 'ㅘ': 15, 'ㅙ': 16, 'ㅚ': 17,
  'ㅛ': 6, 'ㅜ': 7, 'ㅝ': 18, 'ㅞ': 19, 'ㅟ': 20, 'ㅠ': 8, 'ㅡ': 9, 'ㅢ': 21, 'ㅣ': 10,
};

// 한글 음절 분해를 위한 자모 배열
const List<String> _choseong = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
const List<String> _jungseong = ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'];
const List<String> _jongseong = ['', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

// 복합 자모 분해 맵
const Map<String, List<String>> _compositeVowels = {
  'ㅘ': ['ㅗ', 'ㅏ'], 'ㅙ': ['ㅗ', 'ㅐ'], 'ㅚ': ['ㅗ', 'ㅣ'],
  'ㅝ': ['ㅜ', 'ㅓ'], 'ㅞ': ['ㅜ', 'ㅔ'], 'ㅟ': ['ㅜ', 'ㅣ'],
  'ㅢ': ['ㅡ', 'ㅣ'],
};
const Map<String, List<String>> _compositeConsonants = {
  'ㄳ': ['ㄱ', 'ㅅ'], 'ㄵ': ['ㄴ', 'ㅈ'], 'ㄶ': ['ㄴ', 'ㅎ'],
  'ㄺ': ['ㄹ', 'ㄱ'], 'ㄻ': ['ㄹ', 'ㅁ'], 'ㄼ': ['ㄹ', 'ㅂ'],
  'ㄽ': ['ㄹ', 'ㅅ'], 'ㄾ': ['ㄹ', 'ㅌ'], 'ㄿ': ['ㄹ', 'ㅍ'],
  'ㅀ': ['ㄹ', 'ㅎ'], 'ㅄ': ['ㅂ', 'ㅅ'],
};


class NumerologyCalculator {
  // 숫자를 한 자리로 줄이는 핵심 함수 (마스터 수는 예외 처리)
  int reduceNumber(int number) {
    if (number == 11 || number == 22 || number == 33) {
      return number;
    }
    int sum = 0;
    String numStr = number.toString();
    while (numStr.length > 1) {
      sum = 0;
      for (int i = 0; i < numStr.length; i++) {
        sum += int.parse(numStr[i]);
      }
      numStr = sum.toString();
    }
    return int.parse(numStr);
  }
  
  // 생년월일의 각 자리를 더하는 함수
  int _sumDigits(int number) {
    int sum = 0;
    String numStr = number.toString();
    for (int i = 0; i < numStr.length; i++) {
      sum += int.parse(numStr[i]);
    }
    return sum;
  }

  // 한글 음절의 숫자 값을 반환하는 헬퍼 함수
  int _getKoreanCharValue(String char) {
    if (_koreanConsonantToNumberMap.containsKey(char)) {
      return _koreanConsonantToNumberMap[char] ?? 0;
    } else if (_koreanVowelToNumberMap.containsKey(char)) {
      return _koreanVowelToNumberMap[char] ?? 0;
    }
    return 0; // 한글이 아닌 문자
  }

  // 복합 자모를 분해하여 숫자 값을 합산하는 헬퍼 함수
  int _getDecomposedCharValue(String char) {
    if (_compositeVowels.containsKey(char)) {
      int sum = 0;
      for (String c in _compositeVowels[char]!) {
        sum += _getKoreanCharValue(c);
      }
      return sum;
    }
    if (_compositeConsonants.containsKey(char)) {
      int sum = 0;
      for (String c in _compositeConsonants[char]!) {
        sum += _getKoreanCharValue(c);
      }
      return sum;
    }
    return _getKoreanCharValue(char);
  }

  // Helper function to check if a character is a Korean vowel
  bool _isKoreanVowel(String char) {
    if (_koreanVowelToNumberMap.containsKey(char)) return true;
    return false;
  }

  // Helper function to check if a character is a Korean consonant
  bool _isKoreanConsonant(String char) {
    if (_koreanConsonantToNumberMap.containsKey(char)) return true;
    return false;
  }
  
  // 한글 음절을 분해하여 각 자모의 숫자 값을 합산하는 헬퍼 함수
  int _getHangulSyllableValue(String syllable) {
    if (syllable.length != 1) {
      return 0;
    }
    int charCode = syllable.runes.first;

    if (charCode < 0xAC00 || charCode > 0xD7A3) {
      return _getDecomposedCharValue(syllable);
    }

    int base = charCode - 0xAC00;
    int jongseongIndex = base % 28;
    int jungseongIndex = ((base - jongseongIndex) / 28).floor() % 21;
    int choseongIndex = ((base - jongseongIndex) / 28 / 21).floor();

    int sum = 0;
    sum += _getDecomposedCharValue(_choseong[choseongIndex]);
    sum += _getDecomposedCharValue(_jungseong[jungseongIndex]);
    if (jongseongIndex > 0) {
      sum += _getDecomposedCharValue(_jongseong[jongseongIndex]);
    }
    return sum;
  }

  // 인생 여정 수 계산 함수
  int calculateLifePathNumber(DateTime birthDate) {
    int month = birthDate.month;
    int day = birthDate.day;
    int year = birthDate.year;

    int totalSum = month + day + _sumDigits(year);
    return totalSum;
  }

  // 운명수 계산 함수 (이름의 모든 글자 합)
  int calculateDestinyNumber(String name) {
    int totalValue = 0;
    for (int i = 0; i < name.length; i++) {
      totalValue += _getHangulSyllableValue(name[i]);
    }
    return totalValue;
  }
 
  // 혼의수 계산 함수 (이름의 모음 합)
  int calculateSoulUrgeNumber(String name) {
    int totalVowelValue = 0;
    for (int i = 0; i < name.length; i++) {
      String syllable = name[i];
      
      if (syllable.length != 1) continue;

      int charCode = syllable.runes.first;

      // 한글 음절이 아닌 경우 (단일 자모 등)
      if (charCode < 0xAC00 || charCode > 0xD7A3) {
        // 모음인지 확인하고 값 더하기
        if (_isKoreanVowel(syllable)) {
            totalVowelValue += _getDecomposedCharValue(syllable);
        }
        continue;
      }

      int base = charCode - 0xAC00;
      int jongseongIndex = base % 28;
      int jungseongIndex = ((base - jongseongIndex) / 28).floor() % 21;
      
      String vowel = _jungseong[jungseongIndex];
      totalVowelValue += _getDecomposedCharValue(vowel);
    }
    return totalVowelValue;
  }

    // 성격수 계산 함수 (이름의 자음 합)
  int calculatePersonalityNumber(String name) {
    int totalConsonantValue = 0;
    for (int i = 0; i < name.length; i++) {
      String syllable = name[i];

      if (syllable.length != 1) continue;

      int charCode = syllable.runes.first;

      // 한글 음절이 아닌 경우 (단일 자모 등)
      if (charCode < 0xAC00 || charCode > 0xD7A3) {
        // 자음인지 확인하고 값 더하기
        if (_isKoreanConsonant(syllable)) {
          totalConsonantValue += _getDecomposedCharValue(syllable);
        }
        continue;
      }

      int base = charCode - 0xAC00;
      int jongseongIndex = base % 28;
      int choseongIndex = ((base - jongseongIndex) / 28 / 21).floor();

      // 초성(자음) 값 더하기
      String choseong = _choseong[choseongIndex];
      totalConsonantValue += _getDecomposedCharValue(choseong);

      // 종성(자음)이 있으면 값 더하기
      if (jongseongIndex > 0) {
        String jongseong = _jongseong[jongseongIndex];
        totalConsonantValue += _getDecomposedCharValue(jongseong);
      }
    }
    return totalConsonantValue;
  }

        // 완성수 계산 함수 (인생 여정 수 + 운명수)
      int calculateMaturityNumber(int lifePathNumber, int destinyNumber) {
        final reducedLifePath = reduceNumber(lifePathNumber);
        final reducedDestiny = reduceNumber(destinyNumber);
        return reducedLifePath + reducedDestiny;
      }

      // 1년수 계산 함수 (생월 + 생일 + 금년)
      int calculatePersonalYearNumber(DateTime birthDate) {
        final int currentYear = DateTime.now().year;
        return birthDate.month + birthDate.day + _sumDigits(currentYear);
      }

      // 생일수 계산 함수 (생일의 일자)
      int calculateBirthdayNumber(DateTime birthDate) {
        return birthDate.day;
      }

  // 숫자의 전체 축소 경로를 반환하는 헬퍼 함수
  List<int> _getReductionPath(int number) {
    List<int> path = [number];
    String numStr = number.toString();

    while (numStr.length > 1) {
      int sum = 0;
      for (int i = 0; i < numStr.length; i++) {
        sum += int.parse(numStr[i]);
      }
      path.add(sum);
      numStr = sum.toString();
    }
    return path;
  }

  // 마스터 수를 고려한 텍스트 및 색상 처리 함수
  String getNumberText(int originalNumber) {
    List<int> path = _getReductionPath(originalNumber);
    if (path.length <= 1) {
      return originalNumber.toString();
    }

    // 경로가 3개 이상일 경우(예: 38 -> 11 -> 2), 첫 숫자를 제외하고 보여줍니다. (11/2)
    if (path.length >= 3) {
      return path.sublist(1).join('/');
    }

    // 경로가 2개일 경우(예: 23 -> 5), 전체 경로를 그대로 보여줍니다. (23/5)
    return path.join('/');
  }

  Color getNumberColor(int number) {
    if (number == 11 || number == 22 || number == 33) {
      return Colors.amber;
    }
    return Colors.white;
  }
}