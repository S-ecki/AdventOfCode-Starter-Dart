import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput().map(
      (line) {
        final [winningNumbers, myNumbers] = line
            .split(':')[1]
            .split('|')
            .map(
              (part) =>
                  part.trim().split(RegExp(r'\s+')).map(int.parse).toList(),
            )
            .map((numbers) => numbers.toSet())
            .toList();

        final intersection = winningNumbers.intersection(myNumbers);
        return intersection.isEmpty ? 0 : 1 << (intersection.length - 1);
      },
    ).sum;
  }

  @override
  int solvePart2() {
    final parsedCards = parseInput().map(
      (line) {
        final [cardHeader, numbers] = line.split(':');

        final cardId = int.parse(
          RegExp(r'Card\s+(\d+)').firstMatch(cardHeader)!.group(1)!,
        );
        final [winningNumbers, myNumbers] = numbers
            .split('|')
            .map(
              (part) =>
                  part.trim().split(RegExp(r'\s+')).map(int.parse).toList(),
            )
            .map((numbers) => numbers.toSet())
            .toList();

        final intersection = winningNumbers.intersection(myNumbers);
        return (
          cardId: cardId,
          count: 1,
          score: intersection.length,
        );
      },
    ).toList();

    final cardMap = Map.fromEntries(
      parsedCards.map(
        (card) => MapEntry(
          card.cardId,
          (count: card.count, score: card.score),
        ),
      ),
    );

    for (final MapEntry(
          :key,
          value: (:count, :score),
        ) in cardMap.entries) {
      for (final entry in List.generate(
        score,
        (i) {
          final card = cardMap[key + i + 1]!;

          return MapEntry(
            key + i + 1,
            (count: card.count + count, score: card.score),
          );
        },
      )) {
        cardMap.update(entry.key, (value) => entry.value);
      }
    }

    return cardMap.values
        .map(
          (entry) => entry.count,
        )
        .sum;
  }
}
