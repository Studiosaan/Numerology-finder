import 'package:flutter/material.dart';
import 'dart:math';

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

  // ⭐️ 인생 여정 수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculateLifePathNumber(DateTime birthDate) {
    int month = birthDate.month;
    int day = birthDate.day;
    int year = birthDate.year;

    int totalSum = _sumDigits(month) + _sumDigits(day) + _sumDigits(year);
    return totalSum;
  }

  // ⭐️ 운명수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculateDestinyNumber(String name) {
    int totalValue = 0;
    for (int i = 0; i < name.length; i++) {
      totalValue += _getKoreanCharValue(name[i]);
    }
    return totalValue;
  }

  // ⭐️ 혼의수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculateSoulUrgeNumber(String name) {
    int totalVowelValue = 0;
    for (int i = 0; i < name.length; i++) {
      String char = name[i];
      if (_isKoreanVowel(char)) {
        totalVowelValue += _getKoreanCharValue(char);
      }
    }
    return totalVowelValue;
  }

  // ⭐️ 성격수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculatePersonalityNumber(String name) {
    int totalConsonantValue = 0;
    for (int i = 0; i < name.length; i++) {
      String char = name[i];
      if (_isKoreanConsonant(char)) {
        totalConsonantValue += _getKoreanCharValue(char);
      }
    }
    return totalConsonantValue;
  }

  // ⭐️ 완성수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculateMaturityNumber(int lifePathNumber, int destinyNumber) {
    return lifePathNumber + destinyNumber;
  }

  // ⭐️ 생일수 계산 함수
  // 최종 합산된 값을 그대로 반환합니다.
  int calculateBirthdayNumber(DateTime birthDate) {
    return birthDate.day;
  }

  // ⭐️ 수정된 getNumberText 함수
  String getNumberText(int originalNumber) {
    int reducedNumber = reduceNumber(originalNumber);
    if (originalNumber == 11 || originalNumber == 22 || originalNumber == 33) {
      return '$originalNumber/${reduceNumber(originalNumber)}';
    } else if (originalNumber != reducedNumber && reducedNumber != 0) {
      return '$originalNumber/$reducedNumber';
    } else {
      return '$originalNumber';
    }
  }

  Color getNumberColor(int number) {
    if (number == 11 || number == 22 || number == 33) {
      return Colors.amber;
    }
    return Colors.white;
  }
}