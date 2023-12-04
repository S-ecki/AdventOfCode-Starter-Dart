import 'dart:collection';

import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final engineField = Field<String>(lines);
    var sum = 0;
    final numberPattern = RegExp(r'\d');
    final symbolPattern = RegExp('[^0-9.]');

    var y = 0;
    while (y < engineField.height) {
      var x = 0;
      while (x < engineField.width) {
        if (engineField.getValueAt(x, y).contains(numberPattern)) {
          var number = int.parse(engineField.getValueAt(x, y));
          var isPartNumber = engineField.checkNeighboursForPattern(
            x,
            y,
            symbolPattern,
          );

          x++;
          while (x < engineField.width &&
              engineField.getValueAt(x, y).contains(numberPattern)) {
            isPartNumber = isPartNumber ||
                engineField.checkNeighboursForPattern(
                  x,
                  y,
                  symbolPattern,
                );

            number = number * 10 + int.parse(engineField.getValueAt(x, y));
            x++;
          }

          if (isPartNumber) {
            sum += number;
          }
        } else {
          x++;
        }
      }
      y++;
    }

    return sum;
  }

  @override
  int solvePart2() {
    final lines = input.getPerLine().map((line) => line.split('')).toList();
    final engineField = Field<String>(lines);
    final numberPattern = RegExp(r'\d');
    final symbolPattern = RegExp('[^0-9.]');

    final partNumbersPositions =
        HashMap<({int number, (int, int) start}), List<(int, int)>>();

    var y = 0;
    while (y < engineField.height) {
      var x = 0;
      while (x < engineField.width) {
        if (engineField.getValueAt(x, y).contains(numberPattern)) {
          var number = int.parse(engineField.getValueAt(x, y));
          var isPartNumber = engineField.checkNeighboursForPattern(
            x,
            y,
            symbolPattern,
          );
          final positions = <(int, int)>[(x, y)];
          final start = (x, y);

          x++;
          while (x < engineField.width &&
              engineField.getValueAt(x, y).contains(numberPattern)) {
            isPartNumber = isPartNumber ||
                engineField.checkNeighboursForPattern(
                  x,
                  y,
                  symbolPattern,
                );

            positions.add((x, y));
            number = number * 10 + int.parse(engineField.getValueAt(x, y));
            x++;
          }

          if (isPartNumber) {
            partNumbersPositions[(number: number, start: start)] = positions;
          }
        } else {
          x++;
        }
      }
      y++;
    }

    var sum = 0;
    for (var y = 0; y < engineField.height; y++) {
      for (var x = 0; x < engineField.width; x++) {
        if (engineField.getValueAt(x, y).contains('*')) {
          final overlappingPartNumbers = _getPartNumbersAdjacentToPosition(
            engineField,
            x,
            y,
            partNumbersPositions,
          );

          if (overlappingPartNumbers.length == 2) {
            sum += overlappingPartNumbers.first * overlappingPartNumbers.last;
          }
        }
      }
    }

    return sum;
  }

  List<int> _getPartNumbersAdjacentToPosition(
    Field<String> field,
    int x,
    int y,
    HashMap<({int number, Position start}), List<Position>>
        partNumbersPositions,
  ) {
    final partNumbers = <int>[];
    final neighbours = field.neighbours(x, y);
    final partNumberGearWeight =
        HashMap<({int number, Position start}), bool>();

    for (final neighbour in neighbours) {
      final overlappingNumbers = partNumbersPositions.keys.where((partNumber) {
        return partNumbersPositions[partNumber]!.contains(neighbour);
      }).toList();

      for (final partNumber in overlappingNumbers) {
        if (!partNumberGearWeight.containsKey(partNumber)) {
          partNumberGearWeight[partNumber] = true;
        }
      }
    }

    partNumberGearWeight.forEach((partNumber, weight) {
      partNumbers.add(partNumber.number);
    });

    return partNumbers;
  }
}
