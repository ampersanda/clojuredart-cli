import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('CLI integration', () {
    test('--help flag prints usage and exits 0', () async {
      final result = await Process.run('dart', ['run', 'bin/cljds.dart', '--help']);
      expect(result.exitCode, equals(0));
      final stdout = result.stdout as String;
      expect(stdout, contains('Usage'));
      expect(stdout, contains('dart'));
      expect(stdout, contains('flutter'));
    });

    test('-h flag prints usage and exits 0', () async {
      final result = await Process.run('dart', ['run', 'bin/cljds.dart', '-h']);
      expect(result.exitCode, equals(0));
      final stdout = result.stdout as String;
      expect(stdout, contains('Usage'));
    });

    test('--version flag prints version and exits 0', () async {
      final result =
          await Process.run('dart', ['run', 'bin/cljds.dart', '--version']);
      expect(result.exitCode, equals(0));
      final stdout = result.stdout as String;
      expect(stdout, contains('2.2.2'));
    });

    test('unknown command exits with code 64', () async {
      final result =
          await Process.run('dart', ['run', 'bin/cljds.dart', 'invalid']);
      expect(result.exitCode, equals(64));
      final output = '${result.stdout}${result.stderr}';
      expect(output, contains('Unknown command'));
    });

    test('too many arguments exits with code 64', () async {
      final result = await Process.run(
          'dart', ['run', 'bin/cljds.dart', 'dart', 'name', 'extra']);
      expect(result.exitCode, equals(64));
    });

    test('--sha with invalid SHA exits with error', () async {
      final result = await Process.run('dart',
          ['run', 'bin/cljds.dart', 'dart', 'my_project', '--sha', 'abc123']);
      expect(result.exitCode, isNot(equals(0)));
      final output = '${result.stdout}${result.stderr}';
      expect(output, contains('Invalid SHA'));
    });

    test('--help output shows --sha option', () async {
      final result =
          await Process.run('dart', ['run', 'bin/cljds.dart', '--help']);
      expect(result.exitCode, equals(0));
      final stdout = result.stdout as String;
      expect(stdout, contains('sha'));
    });
  });
}
