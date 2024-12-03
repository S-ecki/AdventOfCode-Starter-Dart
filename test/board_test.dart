// Import the test package
import 'package:test/test.dart';
import '../utils/board.dart';

/// Board tests
/// Needs more tests
void main() {
  // Group your tests together
  group('Board Tests', () {
    // Test case for addition of positive numbers
    test('create a board and validate', () {
      final board = Board<String>(
        field: [
          ['00', '01', '02'],
          ['10', '11', '12'],
          ['20', '21', '22'],
        ],
      ); // Assuming Board is a class you want to test

      expect(board.boardWidth, equals(3));
      expect(board.boardHeight, equals(3));
      expect(board.getValueAt(row: 1, col: 1), equals('11'));
      expect(board.getRow(0), equals(['00', '01', '02']));
      expect(board.getColumn(0), equals(['00', '10', '20']));
      expect(
        board.adjacent(const AbsoluteCoordinate(row: 0, col: 0)),
        equals([
          const AbsoluteCoordinate(row: 0, col: 1),
          const AbsoluteCoordinate(row: 1, col: 0),
        ]),
      );
    });

    test('AbsoluteCoordinate', () {
      const coord = AbsoluteCoordinate(row: 2, col: 3);
      expect(coord.row, equals(2));
      expect(coord.col, equals(3));
      const coord2 = AbsoluteCoordinate(row: 2, col: 3);
      expect(coord, equals(coord2));
      const coord3 = AbsoluteCoordinate(row: 3, col: 3);
      expect(coord, isNot(coord3));

      const coord4 = OffsetCoordinate(row: 2, col: 3);
      expect(coord, isNot(coord4));
    });

    test('Offsetoordinate', () {
      const coord = OffsetCoordinate(row: 2, col: 3);
      expect(coord.row, equals(2));
      expect(coord.col, equals(3));
      const coord2 = OffsetCoordinate(row: 2, col: 3);
      expect(coord, equals(coord2));
      const coord3 = OffsetCoordinate(row: 3, col: 3);
      expect(coord, isNot(coord3));

      const coord4 = AbsoluteCoordinate(row: 2, col: 3);
      expect(coord, isNot(coord4));

      expect(
        coord.absoluteFrom(const AbsoluteCoordinate(row: 1, col: 1)),
        equals(const AbsoluteCoordinate(row: 3, col: 4)),
      );
    });
  });

  group('IntegerBoard Tests', () {
    // Test case for addition of positive numbers
    test('create integer board and increment', () {
      final board = Board<int>(
        field: [
          [00, 01, 02],
          [10, 11, 12],
          [20, 21, 22],
        ],
      ); // Assuming Board is a class you want to test

      expect(board.boardWidth, equals(3));
      expect(board.boardHeight, equals(3));
      expect(board.getValueAt(row: 1, col: 1), equals(11));
      board.increment(
        row: 1,
        col: 1,
      );
      expect(board.getValueAt(row: 1, col: 1), equals(12));
    });
  });
}
