import 'package:flutter/material.dart';

class Fibonacci {
  int index;
  int fiboValue;
  FiboType fiboType;

  Fibonacci({
    required this.index,
    required this.fiboValue,
    required this.fiboType,
  });

  static List<Fibonacci> getFibo(int numberValue) {
    List<int> fiboValueList = getFiboValueList(numberValue);
    return List.generate(
      fiboValueList.length,
      (index) {
        return Fibonacci(
          index: index,
          fiboValue: fiboValueList[index],
          fiboType: getType(fiboValueList[index]),
        );
      },
    );
  }

  static List<int> getFiboValueList(int numberValue) {
    List<int> valueList = [0, 1];
    if (numberValue == 1) return valueList;
    List.generate(
      numberValue,
      (index) {
        valueList.add(
            valueList[valueList.length - 1] + valueList[valueList.length - 2]);
      },
    );
    return valueList;
  }

  static FiboType getType(int fiboType) {
    int result = fiboType % 3;
    switch (result) {
      case 0:
        return FiboType.circle;
      case 1:
        return FiboType.square;
      case 2:
        return FiboType.cros;
      default:
        return FiboType.unknown;
    }
  }

  static Icon getIcon(FiboType fiboType) {
    switch (fiboType) {
      case FiboType.circle:
        return const Icon(Icons.circle);
      case FiboType.square:
        return const Icon(Icons.crop_square);
      case FiboType.cros:
        return const Icon(Icons.close);
      default:
        return const Icon(Icons.error);
    }
  }
}

enum FiboType {
  circle,
  square,
  cros,
  unknown,
}
