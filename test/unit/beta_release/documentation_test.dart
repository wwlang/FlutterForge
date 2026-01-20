import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Documentation (Task 5.5)', () {
    test('README.md exists', () {
      final file = File('README.md');
      expect(file.existsSync(), isTrue, reason: 'README.md must exist');
    });

    test('README.md contains required sections', () {
      final content = File('README.md').readAsStringSync();

      // Core sections
      expect(content, contains('# Flutter Forge'));
      expect(content, contains('## Features'));
      expect(content, contains('## Requirements'));
      expect(content, contains('## Installation'));
      expect(content, contains('## Getting Started'));
      expect(content, contains('## Keyboard Shortcuts'));
      expect(content, contains('## Widget Support'));
      expect(content, contains('## Accessibility'));
    });

    test('README.md contains installation instructions', () {
      final content = File('README.md').readAsStringSync();

      expect(content, contains('flutter pub get'));
      expect(content, contains('flutter run'));
    });

    test('README.md contains keyboard shortcuts table', () {
      final content = File('README.md').readAsStringSync();

      expect(content, contains('Cmd+N'));
      expect(content, contains('Cmd+S'));
      expect(content, contains('Cmd+Z'));
    });

    test('README.md mentions macOS requirement', () {
      final content = File('README.md').readAsStringSync();

      expect(content, contains('macOS'));
    });
  });

  group('Developer Documentation (Task 5.6)', () {
    test('ARCHITECTURE.md exists', () {
      final file = File('docs/ARCHITECTURE.md');
      expect(file.existsSync(), isTrue, reason: 'ARCHITECTURE.md must exist');
    });

    test('ARCHITECTURE.md contains key sections', () {
      final content = File('docs/ARCHITECTURE.md').readAsStringSync();

      expect(content, contains('Architecture'));
      expect(content, contains('State'));
      expect(content, contains('Provider'));
    });
  });
}
