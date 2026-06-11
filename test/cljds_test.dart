import 'package:test/test.dart';
import 'package:cljds/cljd-out/cljds/generators/core.dart' as gen_core;
import 'package:cljds/cljd-out/cljds/consts.dart' as consts;
import 'package:cljds/cljd-out/cljds/utils/names.dart' as names;
import 'package:cljds/cljd-out/cljds/templates.dart' as templates;
import 'package:cljds/cljd-out/cljds/cli.dart' as cli;
import 'package:cljds/cljd-out/cljd/core.dart' as cljd;

/// Helper to check if a ClojureDart value is truthy (not null and not false).
bool isTruthy(dynamic value) => value != null && value != false;

/// Helper to check if a ClojureDart value is falsy (null or false).
bool isFalsy(dynamic value) => value == null || value == false;

/// Helper to get a value from a ClojureDart map by keyword name.
dynamic getKey(dynamic map, String key) {
  return cljd.$get_.$_invoke$2(map, cljd.keyword.$_invoke$1(key));
}

void main() {
  // ============================================================
  // Name Validation (cljds/utils/names.dart)
  // ============================================================
  group('validation_error', () {
    test('returns null for valid names', () {
      expect(names.validation_error('hello'), isNull);
      expect(names.validation_error('my_app'), isNull);
      expect(names.validation_error('foo-bar'), isNull);
      expect(names.validation_error('app2'), isNull);
      expect(names.validation_error('MyApp'), isNull);
    });

    test('returns error for null', () {
      expect(names.validation_error(null), isA<String>());
    });

    test('returns error for empty string', () {
      expect(names.validation_error(''), isA<String>());
      expect(names.validation_error('') as String, contains('empty'));
    });

    test('returns error for too-long name (65+ chars)', () {
      final longName = 'a' * 65;
      final result = names.validation_error(longName);
      expect(result, isA<String>());
      expect(result as String, contains('too long'));
    });

    test('returns null for name at max length (64 chars)', () {
      final maxName = 'a' * 64;
      expect(names.validation_error(maxName), isNull);
    });

    test('returns error when starting with a digit', () {
      final result = names.validation_error('2app');
      expect(result, isA<String>());
      expect(result as String, contains('start with a letter'));
    });

    test('returns error when starting with underscore', () {
      final result = names.validation_error('_app');
      expect(result, isA<String>());
      expect(result as String, contains('start with a letter'));
    });

    test('returns error for invalid characters', () {
      expect(names.validation_error('hello world'), isA<String>());
      expect(names.validation_error('foo@bar'), isA<String>());
      expect(names.validation_error('my.app'), isA<String>());
      expect(names.validation_error('app!'), isA<String>());
    });

    test('returns error for reserved words', () {
      expect(names.validation_error('test'), isA<String>());
      expect(names.validation_error('class'), isA<String>());
      expect(names.validation_error('void'), isA<String>());
      expect(
          names.validation_error('test') as String, contains('reserved word'));
    });
  });

  group('valid?', () {
    test('returns truthy for valid names', () {
      expect(isTruthy(names.valid$QMARK_('hello')), isTrue);
      expect(isTruthy(names.valid$QMARK_('my_app')), isTrue);
      expect(isTruthy(names.valid$QMARK_('foo-bar')), isTrue);
    });

    test('returns falsy for invalid names', () {
      expect(isFalsy(names.valid$QMARK_('')), isTrue);
      expect(isFalsy(names.valid$QMARK_(null)), isTrue);
      expect(isFalsy(names.valid$QMARK_('2bad')), isTrue);
      expect(isFalsy(names.valid$QMARK_('test')), isTrue);
    });
  });

  group('names', () {
    test('converts underscores to hyphens for name, hyphens to underscores for dir',
        () {
      final result = names.names('hello_world');
      expect(getKey(result, 'name'), equals('hello-world'));
      expect(getKey(result, 'dir'), equals('hello_world'));
    });

    test('converts hyphens to underscores for dir, keeps hyphens for name',
        () {
      final result = names.names('my-app');
      expect(getKey(result, 'name'), equals('my-app'));
      expect(getKey(result, 'dir'), equals('my_app'));
    });

    test('returns same value for both when no hyphens/underscores', () {
      final result = names.names('simple');
      expect(getKey(result, 'name'), equals('simple'));
      expect(getKey(result, 'dir'), equals('simple'));
    });
  });

  group('resolve_dir', () {
    test('returns dir name when output is null', () {
      expect(names.resolve_dir('hello-world', null), equals('hello_world'));
    });

    test('joins output and dir name with slash', () {
      expect(names.resolve_dir('hello-world', '/tmp'), equals('/tmp/hello_world'));
    });

    test('uses dir-form (underscores) of project name', () {
      expect(names.resolve_dir('my-app', '/x'), equals('/x/my_app'));
      expect(names.resolve_dir('my_app', '/x'), equals('/x/my_app'));
    });
  });

  group('source_path', () {
    test('places core.cljd under src/<dir> without output', () {
      expect(names.source_path('hello-world', null),
          equals('hello_world/src/hello_world/core.cljd'));
    });

    test('output dir does not leak into the src namespace path', () {
      expect(names.source_path('hello-world', 'apps'),
          equals('apps/hello_world/src/hello_world/core.cljd'));
      expect(names.source_path('my_app', '/tmp/out'),
          equals('/tmp/out/my_app/src/my_app/core.cljd'));
    });
  });

  group('required_tools', () {
    test('flutter projects need clj and flutter', () {
      final flutterKw = const cljd.Keyword(null, 'flutter', 2471731111);
      final result = gen_core.required_tools(flutterKw);
      expect(result.toString(), contains('clj'));
      expect(result.toString(), contains('flutter'));
    });

    test('dart projects need only clj', () {
      final dartKw = const cljd.Keyword(null, 'dart', 2238625648);
      final result = gen_core.required_tools(dartKw);
      expect(result.toString(), contains('clj'));
      expect(result.toString(), isNot(contains('flutter')));
    });
  });

  // ============================================================
  // Template Rendering (cljds/templates.dart)
  // ============================================================
  group('render_deps_edn', () {
    test('renders dart deps.edn correctly', () {
      final dartKw = const cljd.Keyword(null, 'dart', 2238625648);
      final result = templates.render_deps_edn(
              dartKw, 'abc123def456abc123def456abc123def456abc1', 'my-app.core')
          as String;
      expect(result, contains(':kind :dart'));
      expect(result, contains('abc123def456abc123def456abc123def456abc1'));
      expect(result, contains('my-app.core'));
      expect(result,
          contains('https://github.com/tensegritics/ClojureDart.git'));
      expect(result, isNot(contains('{{')));
    });

    test('renders flutter deps.edn correctly', () {
      final flutterKw = const cljd.Keyword(null, 'flutter', 2471731111);
      final result = templates.render_deps_edn(flutterKw,
          'abc123def456abc123def456abc123def456abc1', 'test-app.core') as String;
      expect(result, contains(':kind :flutter'));
      expect(result, contains('abc123def456abc123def456abc123def456abc1'));
      expect(result, contains('test-app.core'));
      expect(result, isNot(contains('{{')));
    });
  });

  group('render_main', () {
    test('renders dart main correctly', () {
      final dartKw = const cljd.Keyword(null, 'dart', 2238625648);
      final result = templates.render_main(dartKw, 'my-app.core') as String;
      expect(result, contains('my-app.core'));
      expect(result, contains('defn main'));
      expect(result, contains('print'));
      expect(result, contains('hello, world'));
      expect(result, isNot(contains('{{')));
    });

    test('renders flutter main correctly', () {
      final flutterKw = const cljd.Keyword(null, 'flutter', 2471731111);
      final result =
          templates.render_main(flutterKw, 'test-app.core') as String;
      expect(result, contains('test-app.core'));
      expect(result, contains('flutter/material.dart'));
      expect(result, contains('cljd.flutter'));
      expect(result, contains('MaterialApp'));
      expect(result, isNot(contains('{{')));
    });
  });

  // ============================================================
  // CLI Argument Parsing (cljds/cli.dart)
  // ============================================================
  group('parse_args', () {
    test('parses --help flag', () {
      final result = cli.parse_args(<String>['--help']);
      expect(isTruthy(getKey(result, 'help?')), isTrue);
    });

    test('parses -h flag', () {
      final result = cli.parse_args(<String>['-h']);
      expect(isTruthy(getKey(result, 'help?')), isTrue);
    });

    test('parses --version flag', () {
      final result = cli.parse_args(<String>['--version']);
      expect(isTruthy(getKey(result, 'version?')), isTrue);
    });

    test('parses dart command with name', () {
      final result = cli.parse_args(<String>['dart', 'my_app']);
      final typeKw = getKey(result, 'type');
      expect(typeKw, isNotNull);
      expect(cljd.name(typeKw), equals('dart'));
      expect(getKey(result, 'name'), equals('my_app'));
    });

    test('parses flutter command with name', () {
      final result = cli.parse_args(<String>['flutter', 'my_app']);
      final typeKw = getKey(result, 'type');
      expect(typeKw, isNotNull);
      expect(cljd.name(typeKw), equals('flutter'));
      expect(getKey(result, 'name'), equals('my_app'));
    });

    test('parses dart command without name', () {
      final result = cli.parse_args(<String>['dart']);
      final typeKw = getKey(result, 'type');
      expect(typeKw, isNotNull);
      expect(cljd.name(typeKw), equals('dart'));
      expect(getKey(result, 'name'), isNull);
    });

    test('parses empty args as interactive mode', () {
      final result = cli.parse_args(<String>[]);
      expect(isTruthy(getKey(result, 'interactive?')), isTrue);
    });

    test('parses -o / --output option', () {
      final result = cli.parse_args(<String>['dart', 'my_app', '-o', '/tmp']);
      expect(getKey(result, 'output'), equals('/tmp'));
    });

    test('returns error for unknown command', () {
      final result = cli.parse_args(<String>['unknown']);
      final error = getKey(result, 'error');
      expect(error, isNotNull);
      expect(error as String, contains('Unknown command'));
    });

    test('returns error for too many arguments', () {
      final result = cli.parse_args(<String>['dart', 'name', 'extra']);
      final error = getKey(result, 'error');
      expect(error, isNotNull);
    });

    test('parses --sha with value', () {
      final result = cli.parse_args(<String>[
        'dart',
        'my_app',
        '--sha',
        'abcdef1234567890abcdef1234567890abcdef12'
      ]);
      expect(getKey(result, 'sha'),
          equals('abcdef1234567890abcdef1234567890abcdef12'));
      expect(getKey(result, 'name'), equals('my_app'));
    });

    test('parses --sha with short value (parser does not validate)', () {
      final result =
          cli.parse_args(<String>['dart', 'my_app', '--sha', 'abc123']);
      expect(getKey(result, 'sha'), equals('abc123'));
    });

    test('--sha is null when not provided', () {
      final result = cli.parse_args(<String>['dart', 'my_app']);
      expect(getKey(result, 'sha'), isNull);
    });

    test('parses --sha combined with --output', () {
      final result = cli.parse_args(<String>[
        'dart',
        'my_app',
        '--sha',
        'abcdef1234567890abcdef1234567890abcdef12',
        '-o',
        '/tmp'
      ]);
      expect(getKey(result, 'sha'),
          equals('abcdef1234567890abcdef1234567890abcdef12'));
      expect(getKey(result, 'output'), equals('/tmp'));
    });

    test('parses --sha in interactive mode', () {
      final result = cli.parse_args(<String>[
        '--sha',
        'abcdef1234567890abcdef1234567890abcdef12'
      ]);
      expect(getKey(result, 'sha'),
          equals('abcdef1234567890abcdef1234567890abcdef12'));
      expect(isTruthy(getKey(result, 'interactive?')), isTrue);
    });
  });

  group('usage_text', () {
    test('is a non-empty string', () {
      final text = cli.usage_text$v1 as String;
      expect(text.isNotEmpty, isTrue);
    });

    test('contains expected keywords', () {
      final text = cli.usage_text$v1 as String;
      expect(text, contains('cljds'));
      expect(text, contains('dart'));
      expect(text, contains('flutter'));
    });

    test('mentions --sha option', () {
      final text = cli.usage_text$v1 as String;
      expect(text, contains('sha'));
    });
  });

  group('version_text', () {
    test('contains cljds and version number', () {
      final text = cli.version_text$v1 as String;
      expect(text, contains('cljds'));
      expect(text, contains('2.2.3'));
    });
  });

  // ============================================================
  // SHA Validation & Constants
  // ============================================================
  group('valid_sha?', () {
    test('accepts valid 40-character hex SHA', () {
      expect(
          gen_core.valid_sha$QMARK_(
              '8d5916c0dc87146dc2e8921aaa7fd5dc3c6c3401'),
          isNotNull);
      expect(
          gen_core.valid_sha$QMARK_(
              '0000000000000000000000000000000000000000'),
          isNotNull);
      expect(
          gen_core.valid_sha$QMARK_(
              'abcdef1234567890abcdef1234567890abcdef12'),
          isNotNull);
    });

    test('rejects null', () {
      expect(gen_core.valid_sha$QMARK_(null), anyOf(isNull, isFalse));
    });

    test('rejects empty string', () {
      expect(gen_core.valid_sha$QMARK_(''), anyOf(isNull, isFalse));
    });

    test('rejects too-short hex strings', () {
      expect(gen_core.valid_sha$QMARK_('abc123'), anyOf(isNull, isFalse));
      expect(
          gen_core
              .valid_sha$QMARK_('8d5916c0dc87146dc2e8921aaa7fd5dc3c6c340'),
          anyOf(isNull, isFalse));
    });

    test('rejects too-long hex strings', () {
      expect(
          gen_core
              .valid_sha$QMARK_('8d5916c0dc87146dc2e8921aaa7fd5dc3c6c34011'),
          anyOf(isNull, isFalse));
    });

    test('rejects uppercase hex characters', () {
      expect(
          gen_core
              .valid_sha$QMARK_('8D5916C0DC87146DC2E8921AAA7FD5DC3C6C3401'),
          anyOf(isNull, isFalse));
    });

    test('rejects non-hex characters', () {
      expect(
          gen_core
              .valid_sha$QMARK_('zd5916c0dc87146dc2e8921aaa7fd5dc3c6c3401'),
          anyOf(isNull, isFalse));
    });

    test('rejects strings with spaces', () {
      expect(
          gen_core
              .valid_sha$QMARK_('8d5916c0dc87146dc2e8921aaa7fd5dc3c6c340 '),
          anyOf(isNull, isFalse));
      expect(
          gen_core
              .valid_sha$QMARK_(' 8d5916c0dc87146dc2e8921aaa7fd5dc3c6c340'),
          anyOf(isNull, isFalse));
    });
  });

  group('version', () {
    test('equals current version', () {
      expect(consts.version$v1, equals('2.2.3'));
    });

    test('matches semver pattern', () {
      expect(consts.version$v1 as String,
          matches(RegExp(r'^\d+\.\d+\.\d+$')));
    });
  });

  group('fallback-sha', () {
    test('is defined and non-empty', () {
      expect(consts.fallback_sha$v1, isNotNull);
      expect((consts.fallback_sha$v1 as String).isNotEmpty, isTrue);
    });

    test('is 40 characters long', () {
      expect((consts.fallback_sha$v1 as String).length, equals(40));
    });

    test('contains only lowercase hex characters', () {
      expect(consts.fallback_sha$v1, matches(RegExp(r'^[0-9a-f]{40}$')));
    });

    test('is a valid SHA according to valid_sha?', () {
      expect(gen_core.valid_sha$QMARK_(consts.fallback_sha$v1), isNotNull);
    });
  });

  group('sha-url', () {
    test('is a valid URI with https scheme', () {
      expect(consts.sha_url$v1, isNotNull);
      final uri = consts.sha_url$v1 as Uri;
      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('raw.githubusercontent.com'));
    });

    test('points to ClojureDart .hashes file', () {
      final uri = consts.sha_url$v1 as Uri;
      expect(uri.path, contains('ClojureDart'));
      expect(uri.path, endsWith('.hashes'));
    });
  });
}
