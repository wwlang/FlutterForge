import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/features/shortcuts/keyboard_shortcuts.dart';

/// Tests for Platform-Adaptive Shortcuts (Task 8.3)
///
/// Journey: J17 S2 - Platform-Adaptive Keyboard Shortcuts
void main() {
  group('Platform-Adaptive Shortcuts (Task 8.3)', () {
    group('ShortcutDefinition', () {
      test('returns correct shortcut for macOS', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final shortcut = def.getShortcutForPlatform(TargetPlatform.macOS);
        expect(shortcut.meta, isTrue);
        expect(shortcut.control, isFalse);
        expect(shortcut.trigger, LogicalKeyboardKey.keyS);
      });

      test('returns correct shortcut for Windows', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final shortcut = def.getShortcutForPlatform(TargetPlatform.windows);
        expect(shortcut.meta, isFalse);
        expect(shortcut.control, isTrue);
        expect(shortcut.trigger, LogicalKeyboardKey.keyS);
      });

      test('returns correct shortcut for Linux', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final shortcut = def.getShortcutForPlatform(TargetPlatform.linux);
        expect(shortcut.meta, isFalse);
        expect(shortcut.control, isTrue);
        expect(shortcut.trigger, LogicalKeyboardKey.keyS);
      });

      test('displays macOS shortcuts with correct symbols', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final display = def.getDisplayString(TargetPlatform.macOS);
        // macOS uses Command symbol followed by letter (no separator)
        expect(display, contains('\u2318')); // Command symbol
        expect(display, contains('S'));
      });

      test('displays Windows shortcuts with Ctrl notation', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final display = def.getDisplayString(TargetPlatform.windows);
        expect(display, contains('Ctrl'));
        expect(display, contains('+'));
        expect(display, contains('S'));
      });

      test('displays Linux shortcuts with Ctrl notation', () {
        const def = ShortcutDefinition(
          id: 'save',
          label: 'Save',
          category: ShortcutCategory.file,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyS, control: true),
        );

        final display = def.getDisplayString(TargetPlatform.linux);
        expect(display, contains('Ctrl'));
        expect(display, contains('+'));
        expect(display, contains('S'));
      });

      test('displays complex shortcut with Shift modifier', () {
        const def = ShortcutDefinition(
          id: 'redo',
          label: 'Redo',
          category: ShortcutCategory.edit,
          macShortcut: SingleActivator(
            LogicalKeyboardKey.keyZ,
            meta: true,
            shift: true,
          ),
          windowsShortcut: SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: true,
            shift: true,
          ),
        );

        final macDisplay = def.getDisplayString(TargetPlatform.macOS);
        expect(macDisplay, contains('\u21E7')); // Shift symbol
        expect(macDisplay, contains('\u2318')); // Command symbol

        final winDisplay = def.getDisplayString(TargetPlatform.windows);
        expect(winDisplay, contains('Ctrl'));
        expect(winDisplay, contains('Shift'));
        expect(winDisplay, contains('Z'));
      });
    });

    group('ShortcutsRegistry', () {
      test('contains all required file shortcuts', () {
        final fileShortcuts =
            ShortcutsRegistry.getByCategory(ShortcutCategory.file);
        final ids = fileShortcuts.map((s) => s.id).toList();

        expect(ids, contains('new-project'));
        expect(ids, contains('open'));
        expect(ids, contains('save'));
        expect(ids, contains('save-as'));
      });

      test('contains all required edit shortcuts', () {
        final editShortcuts =
            ShortcutsRegistry.getByCategory(ShortcutCategory.edit);
        final ids = editShortcuts.map((s) => s.id).toList();

        expect(ids, contains('undo'));
        expect(ids, contains('redo'));
      });

      test('contains all required widget shortcuts', () {
        final widgetShortcuts =
            ShortcutsRegistry.getByCategory(ShortcutCategory.widget);
        final ids = widgetShortcuts.map((s) => s.id).toList();

        expect(ids, contains('copy-widget'));
        expect(ids, contains('paste-widget'));
        expect(ids, contains('cut-widget'));
        expect(ids, contains('delete-widget'));
      });

      test('findById returns correct shortcut', () {
        final shortcut = ShortcutsRegistry.findById('save');
        expect(shortcut, isNotNull);
        expect(shortcut!.label, equals('Save'));
        expect(shortcut.category, equals(ShortcutCategory.file));
      });

      test('findById returns null for unknown ID', () {
        final shortcut = ShortcutsRegistry.findById('unknown-shortcut');
        expect(shortcut, isNull);
      });

      test('allShortcuts returns all registered shortcuts', () {
        final all = ShortcutsRegistry.allShortcuts;
        expect(all.length, greaterThanOrEqualTo(15));
      });
    });

    group('Platform key mapping (J17 S2)', () {
      test('Save uses Cmd+S on macOS, Ctrl+S on Windows', () {
        final save = ShortcutsRegistry.findById('save')!;

        final macShortcut = save.getShortcutForPlatform(TargetPlatform.macOS);
        expect(macShortcut.meta, isTrue);
        expect(macShortcut.control, isFalse);

        final winShortcut = save.getShortcutForPlatform(TargetPlatform.windows);
        expect(winShortcut.meta, isFalse);
        expect(winShortcut.control, isTrue);
      });

      test('Undo uses Cmd+Z on macOS, Ctrl+Z on Windows', () {
        final undo = ShortcutsRegistry.findById('undo')!;

        final macShortcut = undo.getShortcutForPlatform(TargetPlatform.macOS);
        expect(macShortcut.meta, isTrue);
        expect(macShortcut.trigger, LogicalKeyboardKey.keyZ);

        final winShortcut = undo.getShortcutForPlatform(TargetPlatform.windows);
        expect(winShortcut.control, isTrue);
        expect(winShortcut.trigger, LogicalKeyboardKey.keyZ);
      });

      test('Copy uses Cmd+C on macOS, Ctrl+C on Windows', () {
        final copy = ShortcutsRegistry.findById('copy-widget')!;

        final macShortcut = copy.getShortcutForPlatform(TargetPlatform.macOS);
        expect(macShortcut.meta, isTrue);
        expect(macShortcut.trigger, LogicalKeyboardKey.keyC);

        final winShortcut = copy.getShortcutForPlatform(TargetPlatform.windows);
        expect(winShortcut.control, isTrue);
        expect(winShortcut.trigger, LogicalKeyboardKey.keyC);
      });
    });
  });
}
