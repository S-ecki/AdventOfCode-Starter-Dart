import 'solutions/index.dart';
import 'utils/generic_day.dart';

/// Const to switch between showing the results for each day in [days], or only
/// the latest.
const ONLY_SHOW_LAST = false;

/// List holding all the solution classes.
final days = <GenericDay>[
  Day01(),
];

void main() {
  ONLY_SHOW_LAST
      ? days.last.printSolutions()
      : days.forEach((day) => day.printSolutions());
}
