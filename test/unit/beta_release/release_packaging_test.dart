import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/core/platform/platform_info.dart';

void main() {
  group('Release Packaging (Task 5.8)', () {
    group('Project Configuration', () {
      test('pubspec.yaml exists', () {
        final file = File('pubspec.yaml');
        expect(file.existsSync(), isTrue);
      });

      test('pubspec.yaml has project name', () {
        final content = File('pubspec.yaml').readAsStringSync();
        expect(content, contains('name: flutter_forge'));
      });

      test('pubspec.yaml has version', () {
        final content = File('pubspec.yaml').readAsStringSync();
        expect(content, contains('version:'));
      });

      test('pubspec.yaml has description', () {
        final content = File('pubspec.yaml').readAsStringSync();
        expect(content, contains('description:'));
      });

      test('pubspec.yaml specifies macOS support', () {
        final content = File('pubspec.yaml').readAsStringSync();
        expect(content, contains('platforms:'));
        expect(content, contains('macos'));
      });
    });

    group('macOS Configuration', () {
      test('macos directory exists', () {
        final dir = Directory('macos');
        expect(dir.existsSync(), isTrue, reason: 'macos directory must exist');
      });

      test('Release.entitlements exists', () {
        final file = File('macos/Runner/Release.entitlements');
        expect(file.existsSync(), isTrue);
      });

      test('Release.entitlements has app-sandbox', () {
        final content =
            File('macos/Runner/Release.entitlements').readAsStringSync();
        expect(content, contains('com.apple.security.app-sandbox'));
      });

      test('Release.entitlements has file access', () {
        final content =
            File('macos/Runner/Release.entitlements').readAsStringSync();
        expect(
          content,
          contains('com.apple.security.files.user-selected.read-write'),
        );
      });

      test('Info.plist exists', () {
        final file = File('macos/Runner/Info.plist');
        expect(file.existsSync(), isTrue);
      });

      test('Info.plist has bundle identifier', () {
        final content = File('macos/Runner/Info.plist').readAsStringSync();
        expect(content, contains('CFBundleIdentifier'));
      });

      test('Info.plist has minimum system version', () {
        final content = File('macos/Runner/Info.plist').readAsStringSync();
        expect(content, contains('LSMinimumSystemVersion'));
      });
    });

    group('Platform Info', () {
      test('project file extension is .forge', () {
        expect(PlatformInfo.projectFileExtension, equals('.forge'));
      });

      test('project MIME type is correct', () {
        expect(
          PlatformInfo.projectFileMimeType,
          equals('application/x-flutter-forge'),
        );
      });

      test('minimum window size is reasonable', () {
        final minSize = PlatformInfo.minimumWindowSize;
        expect(minSize.width, greaterThanOrEqualTo(800));
        expect(minSize.height, greaterThanOrEqualTo(600));
      });

      test('default window size is larger than minimum', () {
        final minSize = PlatformInfo.minimumWindowSize;
        final defaultSize = PlatformInfo.defaultWindowSize;
        expect(defaultSize.width, greaterThanOrEqualTo(minSize.width));
        expect(defaultSize.height, greaterThanOrEqualTo(minSize.height));
      });
    });
  });
}
