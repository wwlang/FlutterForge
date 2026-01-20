import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('CI/CD Pipeline (Task 5.7)', () {
    late String ciContent;
    late String releaseContent;

    setUpAll(() {
      ciContent = File('.github/workflows/ci.yml').readAsStringSync();
      releaseContent = File('.github/workflows/release.yml').readAsStringSync();
    });

    group('CI Workflow', () {
      test('ci.yml exists', () {
        final file = File('.github/workflows/ci.yml');
        expect(file.existsSync(), isTrue, reason: 'ci.yml must exist');
      });

      test('ci.yml is valid YAML', () {
        expect(() => loadYaml(ciContent), returnsNormally);
      });

      test('ci.yml triggers on push to main', () {
        expect(ciContent, contains('push:'));
        expect(ciContent, contains('main'));
      });

      test('ci.yml triggers on pull request', () {
        expect(ciContent, contains('pull_request:'));
      });

      test('ci.yml has analyze job', () {
        expect(ciContent, contains('analyze:'));
        expect(ciContent, contains('flutter analyze'));
      });

      test('ci.yml has test job', () {
        expect(ciContent, contains('test:'));
        expect(ciContent, contains('flutter test'));
      });

      test('ci.yml has build-macos job', () {
        expect(ciContent, contains('build-macos:'));
        expect(ciContent, contains('flutter build macos'));
      });

      test('ci.yml uses Flutter action', () {
        expect(ciContent, contains('subosito/flutter-action'));
      });

      test('ci.yml has format check', () {
        expect(ciContent, contains('dart format'));
      });

      test('ci.yml uploads coverage', () {
        expect(ciContent, contains('--coverage'));
        expect(ciContent, contains('codecov'));
      });
    });

    group('Release Workflow', () {
      test('release.yml exists', () {
        final file = File('.github/workflows/release.yml');
        expect(file.existsSync(), isTrue, reason: 'release.yml must exist');
      });

      test('release.yml is valid YAML', () {
        expect(() => loadYaml(releaseContent), returnsNormally);
      });

      test('release.yml triggers on tag push', () {
        expect(releaseContent, contains('tags:'));
        expect(releaseContent, contains("'v*.*.*'"));
      });

      test('release.yml has manual trigger', () {
        expect(releaseContent, contains('workflow_dispatch:'));
      });

      test('release.yml creates DMG', () {
        expect(releaseContent, contains('create-dmg'));
      });

      test('release.yml creates GitHub release', () {
        expect(releaseContent, contains('action-gh-release'));
      });

      test('release.yml runs tests before release', () {
        expect(releaseContent, contains('flutter test'));
      });
    });
  });
}
