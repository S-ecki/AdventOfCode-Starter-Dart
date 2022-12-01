import 'solutions/index.dart';
import 'utils/generic_day.dart';

/// List holding all the solution classes.
final days = <GenericDay>[
  Day01(),
];

void main(List<String?> args) {
  bool onlyShowLast = false;

  if (args.length == 1 && args[0].isHelperArgument()) {
    printHelper();
    return;
  }

  if (args.length == 1 && args[0].isLastArgument()) {
    onlyShowLast = true;
  }

  onlyShowLast
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}

void printHelper() {
  print(
    '''
Usage: dart main.dart <command>

Global Options:
  -h, --help    Show this help message
  -l, --last    Only show last day
''',
  );
}

extension ArgsMatcher on String? {
  bool isHelperArgument() {
    return this == '-h' || this == '--help';
  }

  bool isLastArgument() {
    return this == '-l' || this == '--last';
  }
}
