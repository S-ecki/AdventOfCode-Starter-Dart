<img src="https://www.kindpng.com/picc/m/176-1766554_dart-programming-language-logo-hd-png-download.png" width="160" align="right">

# AdventOfCode-Starter-Darts

This is a Starter project for [AdventOfCode](https://adventofcode.com/2023), written in `Dart`. Feel free to use it for your own adventures with the christmas-themed puzzles!

## How to use

Feel free to fork this repository to use it as a starting point for your own solutions.

### Setup

Please visit the [AdventOfCode](https://adventofcode.com) site and log in. 

After that, get your session token from the cookie:
- Open DevTools (F12)
- "Application" -> Cookies -> https://adventofcode.com
- Copy the value of the `session` cookie

Add the value to the `session` variable in the `day_generator.dart` file . This will allow the script to populate your input file.


### Boilerplate Generation

In the root of your directory, run 
```dart
dart run day_generator.dart <day>
```

This will create an input and test file and a solution file with all the needed boilerplate to have a quick start. It also adds the solution to the corresponding index file, so the solution get imported into `main` automatically.

### Main

**To add a new solution, all you have to do is add `DayXX()` to the `day` List.**

Running main automatically prints either all your solutions, or just the last one, depending on your settings.

It also measures the time it takes to run each solution, and prints it to the console.

You can run the main file by running 
```dart
dart run main.dart
```
in the root of your directory.

By default the main file will only show the last solution. If you want to see all of them, you can use the `-a` or `--all` flag.
You can list all the command line arguments by using the `-h` or `--help` flag.

### Tests

A test file is automatically generated for each day. It contains tests for both parts of the example and the real input. 

All you have to do is **fill out the variables given at the top of the test file.**

---

## Class Documentation

Below you can find a short documentation of the classes and methods provided by this starter project.

### Naming conventions

When using the Boilerplate generator, everything is done for you automatically. However, if you create a solution or input file by yourself: make sure it has a 2-digit number. Concretely, pad days 1-9 as `Day01.dart` for solutions and `aoc01.txt` for input.


### Generic Day

The abstract class all individual days subclass from. When constructed with the correct `day`, it automatically ready the corresponding input file and provides it with the `InputUtil`. To access it, just call `input` inside your class.

### Input Util

Automatically reads the input files and provides different methods to parse it.

- `.asString` to get the whole input as a single String
- `.getPerLine()` splits on `\n` characters, returning a List with single lines as elements.
- `.getPerWhitespace()` splits on `\s` and `\n`, essentially returning a List with all the single characters.
- `.getBy(pattern)` lets you define your own split logic. It essentially calls Dart´s native `.split(pattern)`

### Parse Util

A place to store useful parsing operations, like creating a `List<int>` from a `List<String>`. There will be a lot of opportunities during AoC for you to extend this.

### Field Class

A helper class for 2D data, as often present in AoC. Any data can be represented. For Integers specifically, there are convenience methods in `IntegerField`. For all available methods, have a look at the abundantly-documented code.

### Helper Packages

**Tuple** enables operations on pairs/triplets etc of any type. Absolutely needed for most of the puzzles.
**Collection** provides many methods for ...collections... Most importantly, a `groupBy` and a collection equality interface.
**Quiver** is an awesome toolbox of helper methods for Dart. We mostly use `/iterables` (similar to Pythons `itertools`).

## Contributing

Contributing is greatly appreciated, just fork this project and create a Pull Request, or open an Issue!

# Happy Holidays

<img src="https://blogs.sap.com/wp-content/uploads/2020/11/EkaoQQTXEAMA4BN.jpg">
