import 'package:flutter/material.dart';

// 알파벳을 숫자로 변환하는 맵
const Map<String, int> _letterToNumberMap = {
  'A': 1, 'J': 1, 'S': 1,
  'B': 2, 'K': 2, 'T': 2,
  'C': 3, 'L': 3, 'U': 3,
  'D': 4, 'M': 4, 'V': 4,
  'E': 5, 'N': 5, 'W': 5,
  'F': 6, 'O': 6, 'X': 6,
  'G': 7, 'P': 7, 'Y': 7,
  'H': 8, 'Q': 8, 'Z': 8,
  'I': 9, 'R': 9,
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

  // 인생 여정 수 계산 함수
  // 이 함수는 계산된 '인생 여정 수'를 반환합니다.
  int calculateLifePathNumber(DateTime birthDate) {
    int month = reduceNumber(birthDate.month);
    int day = reduceNumber(birthDate.day);
    int year = reduceNumber(birthDate.year);

    int totalSum = reduceNumber(month + day + year);
    
    return totalSum;
  }

  // ⭐️ 마스터 수를 고려한 텍스트 및 색상 처리 함수
  // 이 함수는 최종 숫자를 받아서 텍스트와 색상을 반환할것
  String getNumberText(int number) {
    if (number == 11) return '11/2';
    if (number == 22) return '22/4';
    if (number == 33) return '33/6';
    return '$number';
  }

  Color getNumberColor(int number) {
    if (number == 11 || number == 22 || number == 33) {
      return Colors.amber; // 마스터 수는 노란색으로 구분
    }
    return Colors.white; // 일반 수는 흰색으로 표시
  }

  // 생년월일을 초기 숫자 형태로 계산하는 함수
  String calculateInitialNumbers(DateTime birthDate) {
    int year = birthDate.year;
    int month = birthDate.month;
    int day = birthDate.day;

    int yearSum = 0;
    String yearStr = year.toString();
    for (int i = 0; i < yearStr.length; i++) {
      yearSum += int.parse(yearStr[i]);
    }

    return '$yearSum / $month / $day';
  }

  // ⭐️ 이름을 숫자로 변환하는 함수를 추가합니다.
  String calculateNameNumbers(String name) {
    String formattedName = name.toUpperCase().replaceAll(' ', '');
    String numberString = '';
    
    for (int i = 0; i < formattedName.length; i++) {
      String letter = formattedName[i];
      if (_letterToNumberMap.containsKey(letter)) {
        numberString += _letterToNumberMap[letter].toString();
      }
    }
    return numberString;
  }
}