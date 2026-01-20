import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/core/platform/platform_info.dart';

void main() {
  group('Cross-Platform Validation (Task 5.1)', () {
    group('PlatformInfo', () {
      test('platformName returns valid platform string', () {
        final name = PlatformInfo.platformName;
        expect(
          ['macOS', 'Windows', 'Linux', 'Web'],
          contains(name),
        );
      });

      test('osVersion returns non-empty string', () {
        final version = PlatformInfo.osVersion;
        expect(version, isNotEmpty);
      });

      test('isDesktop returns true on desktop platforms', () {
        // This test will pass on any desktop platform
        if (PlatformInfo.isMacOS ||
            PlatformInfo.isWindows ||
            PlatformInfo.isLinux) {
          expect(PlatformInfo.isDesktop, isTrue);
        }
      });

      test('modifierKeyName returns Cmd on macOS, Ctrl elsewhere', () {
        final modKey = PlatformInfo.modifierKeyName;
        expect(['Cmd', 'Ctrl'], contains(modKey));
        if (PlatformInfo.isMacOS) {
          expect(modKey, equals('Cmd'));
        } else {
          expect(modKey, equals('Ctrl'));
        }
      });

      test('defaultWindowSize returns positive dimensions', () {
        final size = PlatformInfo.defaultWindowSize;
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
        expect(size.width, greaterThanOrEqualTo(960));
        expect(size.height, greaterThanOrEqualTo(640));
      });

      test('minimumWindowSize is smaller than default', () {
        final minSize = PlatformInfo.minimumWindowSize;
        final defaultSize = PlatformInfo.defaultWindowSize;
        expect(minSize.width, lessThanOrEqualTo(defaultSize.width));
        expect(minSize.height, lessThanOrEqualTo(defaultSize.height));
      });

      test('projectFileExtension is .forge', () {
        expect(PlatformInfo.projectFileExtension, equals('.forge'));
      });

      test('projectFileMimeType is correct', () {
        expect(
          PlatformInfo.projectFileMimeType,
          equals('application/x-flutter-forge'),
        );
      });

      test('useNativeFileDialogs true on desktop', () {
        if (PlatformInfo.isDesktop) {
          expect(PlatformInfo.useNativeFileDialogs, isTrue);
        }
      });

      test('supportsDragFromOS true on desktop', () {
        if (PlatformInfo.isDesktop) {
          expect(PlatformInfo.supportsDragFromOS, isTrue);
        }
      });

      test('supportsWindowTitle true on desktop', () {
        if (PlatformInfo.isDesktop) {
          expect(PlatformInfo.supportsWindowTitle, isTrue);
        }
      });
    });

    group('PlatformUI', () {
      test('panelPadding returns positive value', () {
        expect(PlatformUI.panelPadding, greaterThan(0));
        expect(PlatformUI.panelPadding, lessThanOrEqualTo(20));
      });

      test('itemSpacing returns positive value', () {
        expect(PlatformUI.itemSpacing, greaterThan(0));
        expect(PlatformUI.itemSpacing, lessThanOrEqualTo(12));
      });

      test('borderRadius returns non-negative value', () {
        expect(PlatformUI.borderRadius, greaterThanOrEqualTo(0));
        expect(PlatformUI.borderRadius, lessThanOrEqualTo(16));
      });

      test('iconSize returns reasonable value', () {
        expect(PlatformUI.iconSize, greaterThanOrEqualTo(14));
        expect(PlatformUI.iconSize, lessThanOrEqualTo(24));
      });

      test('labelFontSize returns reasonable value', () {
        expect(PlatformUI.labelFontSize, greaterThanOrEqualTo(10));
        expect(PlatformUI.labelFontSize, lessThanOrEqualTo(16));
      });

      test('bodyFontSize returns reasonable value', () {
        expect(PlatformUI.bodyFontSize, greaterThanOrEqualTo(12));
        expect(PlatformUI.bodyFontSize, lessThanOrEqualTo(18));
      });

      test('titleBarHeight returns positive value', () {
        expect(PlatformUI.titleBarHeight, greaterThan(0));
        expect(PlatformUI.titleBarHeight, lessThanOrEqualTo(40));
      });

      test('showCustomWindowControls correct per platform', () {
        // macOS uses native controls
        if (PlatformInfo.isMacOS) {
          expect(PlatformUI.showCustomWindowControls, isFalse);
        }
        // Windows/Linux need custom controls
        if (PlatformInfo.isWindows || PlatformInfo.isLinux) {
          expect(PlatformUI.showCustomWindowControls, isTrue);
        }
      });
    });
  });
}
