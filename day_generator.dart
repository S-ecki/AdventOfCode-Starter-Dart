import 'dart:io';

import 'tool/session_token.dart';

/// Small Program to be used to generate files and boilerplate for a given day.\
/// Call with `dart run day_generator.dart <day>`
Future<void> main(List<String?> args) async {
  const year = '2023';
  final session = getSessionToken();

  if (args.length > 1) {
    print('Please call with: <dayNumber>');
    return;
  }

  String dayNumber;

  // input through terminal
  if (args.isEmpty) {
    print('Please enter a day for which to generate files');
    final input = stdin.readLineSync();
    if (input == null) {
      print('No input given, exiting');
      return;
    }
    // pad day number to have 2 digits
    dayNumber = int.parse(input).toString().padLeft(2, '0');
    // input from CLI call
  } else {
    dayNumber = int.parse(args[0]!).toString().padLeft(2, '0');
  }

  // Create lib file
  final dayFileName = 'solutions/day$dayNumber.dart';
  final dayFile = File(dayFileName);

  try {
    await dayFile.create(
      recursive: true,
      exclusive: true,
    );
    print('Generating $dayFileName');
    await dayFile.writeAsString(_dayTemplate(dayNumber));
  } on PathExistsException {
    if (_promptForOverwrite(dayFileName)) {
      await dayFile.writeAsString(_dayTemplate(dayNumber));
    }
  }

  // Create test file
  final testFileName = 'test/day${dayNumber}_test.dart';
  final testFile = File(testFileName);
  try {
    await testFile.create(
      recursive: true,
      exclusive: true,
    );
    print('Generating $testFileName');
    await testFile.writeAsString(_testTemplate(dayNumber));
  } on PathExistsException {
    if (_promptForOverwrite(testFileName)) {
      await testFile.writeAsString(_testTemplate(dayNumber));
    }
  }

  final exportFile = File('solutions/index.dart');
  final exports = exportFile.readAsLinesSync();
  final content = "export 'day$dayNumber.dart';\n";
  var found = false;
  // check if line already exists
  for (final line in exports) {
    if (line.contains('day$dayNumber.dart')) {
      found = true;
      break;
    }
  }

  // export new day in index file if not present
  if (!found) {
    await exportFile.writeAsString(
      content,
      mode: FileMode.append,
    );
  }

  // Create input file
  print('Loading input from adventofcode.com...');
  final client = HttpClient();
  try {
    final request = await client.getUrl(
      Uri.parse(
        'https://adventofcode.com/$year/day/${int.parse(dayNumber)}/input',
      ),
    );
    request.cookies.add(Cookie('session', session));
    final response = await request.close();
    if (response.statusCode != 200) {
      print('''
Received status code ${response.statusCode} from server.

You might need to refresh your session token.
You can do so by deleting the file at $sessionTokenPath and restarting the generator.''');
      return;
    }
    final dataPath = 'input/aoc$dayNumber.txt';
    await response.pipe(File(dataPath).openWrite());
  } catch (e) {
    print('Error loading file: $e');
  } finally {
    client.close();
  }

  print('All set, Good luck!');
  return;
}

bool _promptForOverwrite(String fileName) {
  print('$fileName already exists. Overwrite? Defaults to No.');
  stdout.write('Yes(y)/No(n): ');
  final answer = stdin.readLineSync();
  return answer?.toLowerCase().startsWith('y') ?? false;
}

String _dayTemplate(String dayNumber) {
  return '''
import '../utils/index.dart';

class Day$dayNumber extends GenericDay {
  Day$dayNumber() : super(${int.parse(dayNumber)});

  @override
  parseInput() {

  }

  @override
  int solvePart1() {

    return 0;
  }

  @override
  int solvePart2() {

    return 0;
  }
}

''';
}

String _testTemplate(String day) {
  return '''
// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day$day.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated again the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = \'''
\''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
// const _exampleInput2 = _exampleInput1;
const _exampleInput2 = \'''
\''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 0;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 0;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = null;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = null;

void main() {
  group(
    'Day $day - Example Input',
    () {
      test('Part 1', () {
        final day = Day$day()..inputForTesting = _exampleInput1;
        expect(day.solvePart1(), _exampleSolutionPart1);
      });
      test('Part 2', () {
        final day = Day$day()..inputForTesting = _exampleInput2;
        expect(day.solvePart2(), _exampleSolutionPart2);
      });
    },
  );
  group(
    'Day $day - Puzzle Input',
    () {
      final day = Day$day();
      test(
        'Part 1',
        skip: _puzzleSolutionPart1 == null
            ? 'Skipped because _puzzleSolutionPart1 is null'
            : false,
        () => expect(day.solvePart1(), _puzzleSolutionPart1),
      );
      test(
        'Part 2',
        skip: _puzzleSolutionPart2 == null
            ? 'Skipped because _puzzleSolutionPart2 is null'
            : false,
        () => expect(day.solvePart2(), _puzzleSolutionPart2),
      );
    },
  );
}
''';
}
