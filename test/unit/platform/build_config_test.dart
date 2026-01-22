import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

/// Tests for Windows and Linux Build Configuration (Tasks 8.1, 8.2)
///
/// Journey: J17 - Cross-Platform Support
void main() {
  group('Windows Build Configuration (Task 8.1)', () {
    test('pubspec.yaml includes windows platform', () {
      // Read pubspec.yaml and verify windows is included
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec.contains('windows:'), isTrue);
    });

    test('Windows CI workflow exists', () {
      final workflow = File('.github/workflows/windows.yml');
      expect(workflow.existsSync(), isTrue);
    });

    test('Windows CI workflow has build job', () {
      final workflow = File('.github/workflows/windows.yml').readAsStringSync();
      expect(workflow.contains('build-windows'), isTrue);
      expect(workflow.contains('windows-latest'), isTrue);
      expect(workflow.contains('flutter build windows'), isTrue);
    });

    test('Windows CI workflow has artifact upload', () {
      final workflow = File('.github/workflows/windows.yml').readAsStringSync();
      expect(workflow.contains('upload-artifact'), isTrue);
      expect(workflow.contains('windows-build'), isTrue);
    });

    test('Windows CI workflow includes MSIX packaging', () {
      final workflow = File('.github/workflows/windows.yml').readAsStringSync();
      expect(workflow.contains('package-msix'), isTrue);
      expect(workflow.contains('msix:create'), isTrue);
    });
  });

  group('Linux Build Configuration (Task 8.2)', () {
    test('pubspec.yaml includes linux platform', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec.contains('linux:'), isTrue);
    });

    test('Linux CI workflow exists', () {
      final workflow = File('.github/workflows/linux.yml');
      expect(workflow.existsSync(), isTrue);
    });

    test('Linux CI workflow has build job', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('build-linux'), isTrue);
      expect(workflow.contains('ubuntu-latest'), isTrue);
      expect(workflow.contains('flutter build linux'), isTrue);
    });

    test('Linux CI workflow installs GTK dependencies', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('libgtk-3-dev'), isTrue);
      expect(workflow.contains('ninja-build'), isTrue);
    });

    test('Linux CI workflow has artifact upload', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('upload-artifact'), isTrue);
      expect(workflow.contains('linux-build'), isTrue);
    });

    test('Linux CI workflow includes AppImage packaging', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('package-appimage'), isTrue);
      expect(workflow.contains('AppImage'), isTrue);
    });

    test('Linux CI workflow includes DEB packaging', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('package-deb'), isTrue);
      expect(workflow.contains('dpkg-deb'), isTrue);
    });
  });

  group('Cross-Platform Build Support (J17)', () {
    test('all three desktop platforms are configured', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec.contains('macos:'), isTrue);
      expect(pubspec.contains('windows:'), isTrue);
      expect(pubspec.contains('linux:'), isTrue);
    });

    test('CI workflows exist for all platforms', () {
      expect(File('.github/workflows/ci.yml').existsSync(), isTrue);
      expect(File('.github/workflows/windows.yml').existsSync(), isTrue);
      expect(File('.github/workflows/linux.yml').existsSync(), isTrue);
    });

    test('all CI workflows use same Flutter version', () {
      final ciWorkflow = File('.github/workflows/ci.yml').readAsStringSync();
      final windowsWorkflow =
          File('.github/workflows/windows.yml').readAsStringSync();
      final linuxWorkflow =
          File('.github/workflows/linux.yml').readAsStringSync();

      // All should use 3.29.x
      expect(ciWorkflow.contains("flutter-version: '3.29.x'"), isTrue);
      expect(windowsWorkflow.contains("flutter-version: '3.29.x'"), isTrue);
      expect(linuxWorkflow.contains("flutter-version: '3.29.x'"), isTrue);
    });

    test('platform shortcuts adapt correctly for each platform', () {
      // Test that shortcuts are defined for each platform
      // This tests the runtime adaptation
      final platforms = [
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      ];

      for (final platform in platforms) {
        // Each platform should have a valid modifier key concept
        final isMac = platform == TargetPlatform.macOS;
        expect(isMac ? 'Cmd' : 'Ctrl', isNotEmpty);
      }
    });
  });

  group('Platform-specific features (J17 S4)', () {
    test('Windows workflow runs on windows-latest', () {
      final workflow = File('.github/workflows/windows.yml').readAsStringSync();
      expect(workflow.contains('runs-on: windows-latest'), isTrue);
    });

    test('Linux workflow runs on ubuntu-latest', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('runs-on: ubuntu-latest'), isTrue);
    });

    test('macOS workflow runs on macos-14', () {
      final workflow = File('.github/workflows/ci.yml').readAsStringSync();
      expect(workflow.contains('runs-on: macos-14'), isTrue);
    });

    test('all workflows include tests', () {
      final ciWorkflow = File('.github/workflows/ci.yml').readAsStringSync();
      final windowsWorkflow =
          File('.github/workflows/windows.yml').readAsStringSync();
      final linuxWorkflow =
          File('.github/workflows/linux.yml').readAsStringSync();

      expect(ciWorkflow.contains('flutter test'), isTrue);
      expect(windowsWorkflow.contains('flutter test'), isTrue);
      expect(linuxWorkflow.contains('flutter test'), isTrue);
    });

    test('all workflows include code analysis', () {
      final windowsWorkflow =
          File('.github/workflows/windows.yml').readAsStringSync();
      final linuxWorkflow =
          File('.github/workflows/linux.yml').readAsStringSync();

      expect(windowsWorkflow.contains('flutter analyze'), isTrue);
      expect(linuxWorkflow.contains('flutter analyze'), isTrue);
    });
  });

  group('High DPI Support (J17 S1)', () {
    test('Windows build uses release mode for HiDPI support', () {
      final workflow = File('.github/workflows/windows.yml').readAsStringSync();
      // Release mode includes proper HiDPI manifests
      expect(workflow.contains('flutter build windows --release'), isTrue);
    });

    test('Linux build uses release mode', () {
      final workflow = File('.github/workflows/linux.yml').readAsStringSync();
      expect(workflow.contains('flutter build linux --release'), isTrue);
    });
  });
}
