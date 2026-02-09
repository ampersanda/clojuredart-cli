import 'dart:io';

import 'package:test/test.dart';
import 'package:cljds/cljd-out/cljds/utils/io.dart' as io;

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('cljds_io_test_');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('exists?', () {
    test('returns true for an existing directory', () {
      expect(io.exists$QMARK_(tempDir.path), isTrue);
    });

    test('returns false for a nonexistent path', () {
      final result = io.exists$QMARK_('${tempDir.path}/nonexistent');
      expect(result, isFalse);
    });
  });

  group('mkdir', () {
    test('creates a directory', () async {
      final path = '${tempDir.path}/new_dir';
      await io.mkdir.$_invoke$1(path);
      expect(Directory(path).existsSync(), isTrue);
    });
  });

  group('mkfile', () {
    test('creates a file', () async {
      final path = '${tempDir.path}/new_file.txt';
      await io.mkfile.$_invoke$1(path);
      expect(File(path).existsSync(), isTrue);
    });
  });

  group('delete_dir', () {
    test('deletes an existing directory', () async {
      final path = '${tempDir.path}/to_delete';
      Directory(path).createSync();
      expect(Directory(path).existsSync(), isTrue);

      await io.delete_dir(path);
      expect(Directory(path).existsSync(), isFalse);
    });

    test('handles nonexistent directory gracefully', () async {
      final path = '${tempDir.path}/does_not_exist';
      // Should not throw
      await io.delete_dir(path);
    });
  });
}
