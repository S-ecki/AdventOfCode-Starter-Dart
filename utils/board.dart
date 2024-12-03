import 'package:meta/meta.dart';
import 'package:quiver/iterables.dart';

/// A game board (or playing field) with some helper classes
/// Using model objects instead of Tuples

/// Represents a single fixed location on a [Board]
@immutable
abstract class Coordinate {
  const Coordinate({required this.row, required this.col});
  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.runtimeType == runtimeType &&
      other.row == row &&
      other.col == col;

  @override
  int get hashCode => 'row:$row,col:$col'.hashCode;

  @override
  String toString() {
    return '{ "row": $row , "col": $col}';
  }
}

/// Relative coordinate usually offset from some other location
class AbsoluteCoordinate extends Coordinate {
  const AbsoluteCoordinate({required super.row, required super.col});

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is AbsoluteCoordinate &&
      other.runtimeType == runtimeType &&
      other.row == row &&
      other.col == col;
}

/// Relative coordinate usually offset from some other location
class OffsetCoordinate extends Coordinate {
  const OffsetCoordinate({required super.row, required super.col});

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is OffsetCoordinate &&
      other.runtimeType == runtimeType &&
      other.row == row &&
      other.col == col;

  /// what the offset looks like to the reciever of the offset
  /// Only works because no diagonals
  OffsetCoordinate get invert => OffsetCoordinate(row: row * -1, col: col * -1);

  /// returns a coordinate resulting from this offset applied to the parameter
  Coordinate absoluteFrom(AbsoluteCoordinate relativeTo) =>
      AbsoluteCoordinate(row: relativeTo.row + row, col: relativeTo.col + col);
}

/// defines a transition into or out of a square
/// Can be relative or absolute inbound
@immutable
class Transition<IT extends Coordinate, OT extends Coordinate> {
  const Transition({required this.from, required this.to});
  // relative or absolute originating square
  final IT from;
  // relative or absolute target square
  final OT to;

  @override
  bool operator ==(Object other) =>
      other is Transition<IT, OT> &&
      other.runtimeType == runtimeType &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => 'from:$from,to:$to'.hashCode;

  @override
  String toString() {
    return '{ "from": $from , "to": $to}';
  }
}

/// used for inbound relative transitions to a fixed square
/// (-1,-2) => (3,4)   ===> originated from (2,2)
///
class OffsetInboundTransition extends Transition<OffsetCoordinate, Coordinate> {
  const OffsetInboundTransition({required super.from, required super.to});
}

/// used for oubound transitions relative from a square
/// (3,4) => (-1,-2)  ===> ended on (2,2)
///
class OffsetOutboundTransition
    extends Transition<Coordinate, OffsetCoordinate> {
  const OffsetOutboundTransition({required super.from, required super.to});
}

/// an entry path and the relative exit paths for that entry
/// used to define possible exits based on inbound transition
///
/// @param type used for debugging.
/// @param from the entry vector
/// @param to a list of possible exits
///
@immutable
class EntryExitsTransitionDef {
  const EntryExitsTransitionDef({
    required this.type,
    required this.from,
    required this.to,
  });
  // used for tracking and logging
  final String type;
  // the relative location of the entry into the square
  final OffsetCoordinate from;
  // the relative exit directions - a given entry can have multiple exiting
  final List<OffsetCoordinate> to;

  @override
  String toString() {
    return '{"from": $from , "to": $to}';
  }
}

/// Holds all the entry paths for a single square and the exits for each
/// Used to map possible exits for all possible entries
class SquareTransitionDefs {
  const SquareTransitionDefs({required this.symbol, required this.allDefs});
  final String symbol;
  final List<EntryExitsTransitionDef> allDefs;

  @override
  String toString() {
    return '"$symbol" $allDefs';
  }
}

/// Used when we want to capture a position and an int like
/// an increment or step number that it was created in
@immutable
class StepCoordinate {
  const StepCoordinate({required this.step, required this.location});

  final int step;
  final Coordinate location;

  @override
  bool operator ==(Object other) =>
      other is StepCoordinate &&
      other.runtimeType == runtimeType &&
      other.location.row == location.row &&
      other.location.col == location.col &&
      other.step == step;

  @override
  int get hashCode =>
      'step:$step row:${location.row},col:${location.col}'.hashCode;

  @override
  String toString() {
    return '{ "step": $step, "row": ${location.row} , "col": ${location.col}}';
  }
}

/// A callback that takes a [Coordinate]
typedef VoidFieldCallback = void Function(Coordinate position);

/// A helper class for easier work with 2D data.
/// 1. expects a data structure to be in row major order
/// 1. expects to be rectangular with no missing entries
///
/// The board size is immutable
///
class Board<T> {
  Board({required List<List<T>> field})
      // Future: Validate all rows are same length
      : assert(field.isNotEmpty, 'Field must not be empty'),
        assert(field[0].isNotEmpty, 'First position must not be empty'),
        // creates a deep copy by value from given field to prevent
        // unwanted side effects in the original board
        board = List<List<T>>.generate(
          field.length,
          (row) => List<T>.generate(field[0].length, (col) => field[row][col]),
        );

  final List<List<T>> board;

  int get boardWidth => board.length;
  int get boardHeight => board[0].length;

  /// Returns the value at the given position.
  T getValueAtPosition({required Coordinate position}) {
    return board[position.row][position.col];
  }

  /// Returns the value at the given coordinates.
  T getValueAt({required int row, required int col}) =>
      getValueAtPosition(position: AbsoluteCoordinate(row: row, col: col));

  /// Sets the value at the given Position.
  void setValueAtPosition({required Coordinate position, required T value}) {
    board[position.row][position.col] = value;
  }

  /// Sets the value at the given coordinates.
  void setValueAt({required int row, required int col, required T value}) =>
      setValueAtPosition(
        position: AbsoluteCoordinate(row: row, col: col),
        value: value,
      );

  /// Returns whether the given position is inside of this field.
  bool isOnboard({required Coordinate position}) {
    return position.row >= 0 &&
        position.col >= 0 &&
        position.col < boardWidth &&
        position.row < boardHeight;
  }

  /// Returns the whole row with given row index.
  Iterable<T> getRow(int row) => board[row];

  /// Returns the whole column with given column index.
  Iterable<T> getColumn(int column) => board.map((row) => row[column]);

  /// Returns the minimum value in this field.
  T get minValue => min<T>(board.expand((element) => element))!;

  /// Returns the maximum value in this field.
  T get maxValue => max<T>(board.expand((element) => element))!;

  /// Executes the given callback for every position on this field.
  void forEach(VoidFieldCallback callback) {
    for (var row = 0; row < boardHeight; row++) {
      for (var col = 0; col < boardWidth; col++) {
        callback(AbsoluteCoordinate(row: row, col: col));
      }
    }
  }

  /// Executes the given callback for the passed in positions.
  void forPositions(
    Iterable<Coordinate> positions,
    VoidFieldCallback callback,
  ) {
    for (final position in positions) {
      callback(position);
    }
  }

  /// Returns the number of occurrences of given object in this Board.
  int count(T searched) => board
      .expand((element) => element)
      .fold<int>(0, (acc, elem) => elem == searched ? acc + 1 : acc);

  /// Returns all adjacent cells to the given position.
  /// This does **NOT** include diagonal neighbours.
  Iterable<Coordinate> adjacent(Coordinate target) {
    return <Coordinate>{
      AbsoluteCoordinate(row: target.row - 1, col: target.col),
      AbsoluteCoordinate(row: target.row, col: target.col + 1),
      AbsoluteCoordinate(row: target.row + 1, col: target.col),
      AbsoluteCoordinate(row: target.row, col: target.col - 1),
    }..removeWhere(
        (position) {
          return position.row < 0 ||
              position.col < 0 ||
              position.col >= boardWidth ||
              position.row >= boardHeight;
        },
      );
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// **AND** diagonal neighbours.
  Iterable<Coordinate> neighbours(Coordinate target) {
    return <Coordinate>{
      AbsoluteCoordinate(row: target.row - 1, col: target.col),
      AbsoluteCoordinate(row: target.row - 1, col: target.col + 1),
      AbsoluteCoordinate(row: target.row, col: target.col + 1),
      AbsoluteCoordinate(row: target.row + 1, col: target.col + 1),
      AbsoluteCoordinate(row: target.row + 1, col: target.col),
      AbsoluteCoordinate(row: target.row + 1, col: target.col - 1),
      AbsoluteCoordinate(row: target.row, col: target.col - 1),
      AbsoluteCoordinate(row: target.row - 1, col: target.col - 1),
    }..removeWhere(
        (position) {
          return position.row < 0 ||
              position.col < 0 ||
              position.col >= boardWidth ||
              position.row >= boardHeight;
        },
      );
  }

  /// Returns a deep copy by value of this [Board].
  Board<T> copy() {
    final newField = List<List<T>>.generate(
      boardHeight,
      (row) => List<T>.generate(boardWidth, (col) => board[row][col]),
    );
    return Board<T>(field: newField);
  }

  @override
  String toString() {
    final result = StringBuffer();
    for (final row in board) {
      for (final elem in row) {
        result.write(elem.toString());
      }
      result.write('\n');
    }
    return result.toString();
  }
}

/// Extension for [Board]s where `T` is of type [int].
extension IntegerBoard on Board<int> {
  /// Increments the values of Position `row` and `col`.
  dynamic increment({required int row, required int col}) =>
      setValueAt(row: row, col: col, value: getValueAt(row: row, col: col) + 1);

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of integers.
  static Board<int> fromString(String string) {
    final lines = string
        .split('\n')
        .map((line) => line.trim().split('').map(int.parse).toList())
        .toList();
    return Board(field: lines);
  }
}
