import '../utils/index.dart';

sealed class Cube {
  static const int redMaxCubes = 12;
  static const int greenMaxCubes = 13;
  static const int blueMaxCubes = 14;

  static Cube parse(String cube) {
    final pattern = RegExp(r'\s*(\d+) (\w+)\s*');

    final matches = pattern.allMatches(cube);
    if (matches.isEmpty) {
      throw Exception('Invalid cube: $cube');
    }

    final count = int.parse(matches.first.group(1)!);
    final color = matches.first.group(2)!;

    return switch (color) {
      'red' => RedCube(count),
      'green' => GreenCube(count),
      'blue' => BlueCube(count),
      _ => throw Exception('Invalid cube color: $color'),
    };
  }
}

class RedCube implements Cube {
  RedCube(this.cubes);
  final int cubes;
}

class GreenCube implements Cube {
  GreenCube(this.cubes);
  final int cubes;
}

class BlueCube implements Cube {
  BlueCube(this.cubes);
  final int cubes;
}

bool isCubeValid(Cube cube) => switch (cube) {
      RedCube(cubes: final count) => count <= Cube.redMaxCubes,
      GreenCube(cubes: final count) => count <= Cube.greenMaxCubes,
      BlueCube(cubes: final count) => count <= Cube.blueMaxCubes,
    };

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    return parseInput()
        .map(
          (line) {
            final parts = line.split(':');
            final gameHeader = parts[0];
            final gameBody = parts.length > 1 ? parts[1] : null;

            final gameId = int.parse(
              RegExp(r'(\w) (\d+)').firstMatch(gameHeader)!.group(2)!,
            );
            final gameCubes = gameBody
                    ?.split(';')
                    .map(
                      (cubeSet) => cubeSet.split(',').map(
                            Cube.parse,
                          ),
                    )
                    .flattened
                    .toList() ??
                [];

            return (gameId: gameId, gameCubes: gameCubes);
          },
        )
        .map(
          (game) => game.gameCubes.every(isCubeValid) ? game.gameId : 0,
        )
        .sum;
  }

  @override
  int solvePart2() {
    return parseInput().map(
      (line) {
        final parts = line.split(':');
        final gameHeader = parts[0];
        final gameBody = parts.length > 1 ? parts[1] : null;

        final gameId = int.parse(
          RegExp(r'(\w) (\d+)').firstMatch(gameHeader)!.group(2)!,
        );
        final gameCubes = gameBody
                ?.split(';')
                .map(
                  (cubeSet) => cubeSet.split(',').map(
                        Cube.parse,
                      ),
                )
                .flattened
                .toList() ??
            [];

        return (gameId: gameId, gameCubes: gameCubes);
      },
    ).map(
      (game) {
        final maxRedCubes = game.gameCubes
            .whereType<RedCube>()
            .map((cube) => cube.cubes)
            .reduce((a, b) => a > b ? a : b);

        final maxGreenCubes = game.gameCubes
            .whereType<GreenCube>()
            .map((cube) => cube.cubes)
            .reduce((a, b) => a > b ? a : b);

        final maxBlueCubes = game.gameCubes
            .whereType<BlueCube>()
            .map((cube) => cube.cubes)
            .reduce((a, b) => a > b ? a : b);

        return maxRedCubes * maxGreenCubes * maxBlueCubes;
      },
    ).sum;
  }
}
