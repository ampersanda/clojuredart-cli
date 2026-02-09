import 'package:test/test.dart';
import 'package:cljds/cljd-out/cljds/generators/core.dart' as gen_core;
import 'package:cljds/cljd-out/cljds/consts.dart' as consts;

void main() {
  group('valid_sha?', () {
    test('accepts valid 40-character hex SHA', () {
      expect(gen_core.valid_sha$QMARK_('8d5916c0dc87146dc2e8921aaa7fd5dc3c6c3401'),
          isNotNull);
      expect(gen_core.valid_sha$QMARK_('0000000000000000000000000000000000000000'),
          isNotNull);
      expect(gen_core.valid_sha$QMARK_('abcdef1234567890abcdef1234567890abcdef12'),
          isNotNull);
    });

    test('rejects null', () {
      final result = gen_core.valid_sha$QMARK_(null);
      expect(result, anyOf(isNull, isFalse));
    });

    test('rejects empty string', () {
      final result = gen_core.valid_sha$QMARK_('');
      expect(result, anyOf(isNull, isFalse));
    });

    test('rejects too-short hex strings', () {
      expect(gen_core.valid_sha$QMARK_('abc123'), anyOf(isNull, isFalse));
      expect(
          gen_core.valid_sha$QMARK_('8d5916c0dc87146dc2e8921aaa7fd5dc3c6c340'),
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

  group('fallback-sha', () {
    test('is defined and non-empty', () {
      expect(consts.fallback_sha$v1, isNotNull);
      expect((consts.fallback_sha$v1 as String).isNotEmpty, isTrue);
    });

    test('is 40 characters long', () {
      expect((consts.fallback_sha$v1 as String).length, equals(40));
    });

    test('contains only lowercase hex characters', () {
      expect(consts.fallback_sha$v1,
          matches(RegExp(r'^[0-9a-f]{40}$')));
    });

    test('is a valid SHA according to valid_sha?', () {
      expect(gen_core.valid_sha$QMARK_(consts.fallback_sha$v1), isNotNull);
    });
  });

  group('sha-url', () {
    test('is a valid URI', () {
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
