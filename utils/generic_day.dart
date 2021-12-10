import 'input_util.dart';

/// Provides the [InputUtil] for given day and a [printSolution] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  final int day;
  final InputUtil input;

  GenericDay(int day)
      : day = day,
        input = InputUtil(day);

  dynamic parseInput();
  int solvePart1();
  int solvePart2();

  void printSolutions() {
    print("-------------------------");
    print("         Day $day        ");
    print("Solution for puzzle one: ${solvePart1()}");
    print("Solution for puzzle two: ${solvePart2()}");
    print("\n");
  }
}
