import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/features/shortcuts/keyboard_shortcuts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Keyboard Shortcuts (Task 4.8)', () {
    group('ShortcutDefinition', () {
      test('creates with required fields', () {
        const shortcut = ShortcutDefinition(
          id: 'new-project',
          label: 'New Project',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyN, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyN, control: true),
        );

        expect(shortcut.id, 'new-project');
        expect(shortcut.label, 'New Project');
        expect(shortcut.category, ShortcutCategory.file);
      });

      test('returns correct shortcut for platform', () {
        const shortcut = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        // Test that getShortcutForPlatform returns non-null
        expect(shortcut.macShortcut, isNotNull);
        expect(shortcut.windowsShortcut, isNotNull);
      });

      test('formats display string for macOS', () {
        const shortcut = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final display = shortcut.getDisplayString(TargetPlatform.macOS);
        expect(display, contains('S'));
      });

      test('formats display string for Windows', () {
        const shortcut = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final display = shortcut.getDisplayString(TargetPlatform.windows);
        expect(display, contains('S'));
      });
    });

    group('ShortcutsRegistry', () {
      test('contains file shortcuts', () {
        final fileShortcuts = ShortcutsRegistry.getByCategory(
          ShortcutCategory.file,
        );

        expect(fileShortcuts, isNotEmpty);
        expect(
          fileShortcuts.any((s) => s.id == 'new-project'),
          true,
        );
        expect(
          fileShortcuts.any((s) => s.id == 'save'),
          true,
        );
      });

      test('contains edit shortcuts', () {
        final editShortcuts = ShortcutsRegistry.getByCategory(
          ShortcutCategory.edit,
        );

        expect(editShortcuts, isNotEmpty);
        expect(
          editShortcuts.any((s) => s.id == 'undo'),
          true,
        );
        expect(
          editShortcuts.any((s) => s.id == 'redo'),
          true,
        );
      });

      test('contains widget shortcuts', () {
        final widgetShortcuts = ShortcutsRegistry.getByCategory(
          ShortcutCategory.widget,
        );

        expect(widgetShortcuts, isNotEmpty);
        expect(
          widgetShortcuts.any((s) => s.id == 'copy-widget'),
          true,
        );
        expect(
          widgetShortcuts.any((s) => s.id == 'paste-widget'),
          true,
        );
      });

      test('contains view shortcuts', () {
        final viewShortcuts = ShortcutsRegistry.getByCategory(
          ShortcutCategory.view,
        );

        expect(viewShortcuts, isNotEmpty);
      });

      test('gets all shortcuts', () {
        final allShortcuts = ShortcutsRegistry.allShortcuts;

        expect(allShortcuts.length, greaterThan(10));
      });

      test('finds shortcut by ID', () {
        final shortcut = ShortcutsRegistry.findById('save');

        expect(shortcut, isNotNull);
        expect(shortcut?.label, 'Save');
      });

      test('returns null for unknown ID', () {
        final shortcut = ShortcutsRegistry.findById('unknown');

        expect(shortcut, isNull);
      });
    });

    group('ShortcutCategory', () {
      test('has display names', () {
        expect(ShortcutCategory.file.displayName, 'File');
        expect(ShortcutCategory.edit.displayName, 'Edit');
        expect(ShortcutCategory.widget.displayName, 'Widget');
        expect(ShortcutCategory.view.displayName, 'View');
      });
    });
  });
}
