import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

typedef Position = Tuple2<int, int>;
typedef VoidFieldCallback = void Function(int, int);

/// A helper class for easier work with 2D data.
class Field<T> {
  Field(List<List<T>> field)
      : assert(field.length > 0),
        assert(field[0].length > 0),
        // creates a deep copy by value from given field to prevent unwarranted overrides
        field = List<List<T>>.generate(
          field.length,
          (y) => List<T>.generate(field[0].length, (x) => field[y][x]),
        ),
        height = field.length,
        width = field[0].length;

  final List<List<T>> field;
  int height;
  int width;

  /// Returns the value at the given position.
  T getValueAtPosition(Position position) => field[position.y][position.x];

  /// Returns the value at the given coordinates.
  T getValueAt(int x, int y) => getValueAtPosition(Position(x, y));

  /// Sets the value at the given Position.
  setValueAtPosition(Position position, T value) =>
      field[position.y][position.x] = value;

  /// Sets the value at the given coordinates.
  setValueAt(int x, int y, T value) =>
      setValueAtPosition(Position(x, y), value);

  /// Returns whether the given position is inside of this field.
  bool isOnField(Position position) =>
      position.x >= 0 &&
      position.y >= 0 &&
      position.x < width &&
      position.y < height;

  /// Returns the whole row with given row index.
  Iterable<T> getRow(int row) => field[row];

  /// Returns the whole column with given column index.
  Iterable<T> getColumn(int column) => field.map((row) => row[column]);

  /// Returns the minimum value in this field.
  T get minValue => min<T>(field.expand((element) => element))!;

  /// Returns the maximum value in this field.
  T get maxValue => max<T>(field.expand((element) => element))!;

  /// Executes the given callback for every position on this field.
  forEach(VoidFieldCallback callback) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        callback(x, y);
      }
    }
  }

  /// Returns the number of occurances of given object in this field.
  int count(T searched) => field
      .expand((element) => element)
      .fold<int>(0, (acc, elem) => elem == searched ? acc + 1 : acc);

  /// Executes the given callback for all given positions.
  forPositions(
    Iterable<Position> positions,
    VoidFieldCallback callback,
  ) {
    positions.forEach((position) => callback(position.x, position.y));
  }

  /// Returns all adjacent cells to the given position. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Position> adjacent(int x, int y) {
    return <Position>{
      Position(x, y - 1),
      Position(x, y + 1),
      Position(x - 1, y),
      Position(x + 1, y),
    }..removeWhere(
        (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height);
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Position> neighbours(int x, int y) {
    return <Position>{
      // positions are added in a circle, starting at the top middle
      Position(x, y - 1),
      Position(x + 1, y - 1),
      Position(x + 1, y),
      Position(x + 1, y + 1),
      Position(x, y + 1),
      Position(x - 1, y + 1),
      Position(x - 1, y),
      Position(x - 1, y - 1),
    }..removeWhere(
        (pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height);
  }

  /// Returns a deep copy by value of this [Field].
  Field<T> copy() {
    final newField = List<List<T>>.generate(
      height,
      (y) => List<T>.generate(width, (x) => field[y][x]),
    );
    return Field<T>(newField);
  }

  @override
  String toString() {
    String result = '';
    for (final row in field) {
      for (final elem in row) {
        result += elem.toString();
      }
      result += '\n';
    }
    return result;
  }
}

/// Extension for [Field]s where [T] is of type [int].
extension IntegerField on Field<int> {
  /// Increments the values of Position `x` `y`.
  increment(int x, int y) => this.setValueAt(x, y, this.getValueAt(x, y) + 1);

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of integers.
  static Field<int> fromString(String string) {
    final lines = string
        .split('\n')
        .map((line) => line.trim().split('').map(int.parse).toList())
        .toList();
    return Field(lines);
  }
}

extension CoordinateLocator on Position {
  int get x => item1;
  int get y => item2;
}
