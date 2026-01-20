import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Categories for grouping keyboard shortcuts.
enum ShortcutCategory {
  file('File'),
  edit('Edit'),
  widget('Widget'),
  view('View'),
  animation('Animation');

  const ShortcutCategory(this.displayName);
  final String displayName;
}

/// A keyboard shortcut definition with platform variants.
class ShortcutDefinition {
  const ShortcutDefinition({
    required this.id,
    required this.label,
    required this.category,
    required this.macShortcut,
    required this.windowsShortcut,
    this.description,
  });

  /// Unique identifier for this shortcut.
  final String id;

  /// Display label for the shortcut.
  final String label;

  /// Category for grouping.
  final ShortcutCategory category;

  /// Shortcut for macOS (uses Command).
  final SingleActivator macShortcut;

  /// Shortcut for Windows/Linux (uses Control).
  final SingleActivator windowsShortcut;

  /// Optional description of what the shortcut does.
  final String? description;

  /// Gets the appropriate shortcut for the current platform.
  SingleActivator getShortcutForPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return macShortcut;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return windowsShortcut;
    }
  }

  /// Gets a display string for the shortcut.
  String getDisplayString(TargetPlatform platform) {
    final shortcut = getShortcutForPlatform(platform);
    final parts = <String>[];

    if (shortcut.control) {
      parts.add(platform == TargetPlatform.macOS ? '^' : 'Ctrl');
    }
    if (shortcut.alt) {
      parts.add(platform == TargetPlatform.macOS ? '\u2325' : 'Alt');
    }
    if (shortcut.shift) {
      parts.add(platform == TargetPlatform.macOS ? '\u21E7' : 'Shift');
    }
    if (shortcut.meta) {
      parts.add(platform == TargetPlatform.macOS ? '\u2318' : 'Win');
    }

    // Get key label
    final keyLabel = _getKeyLabel(shortcut.trigger);
    parts.add(keyLabel);

    return parts.join(platform == TargetPlatform.macOS ? '' : '+');
  }

  String _getKeyLabel(LogicalKeyboardKey key) {
    // Map common keys to display labels
    final keyLabels = {
      LogicalKeyboardKey.keyA: 'A',
      LogicalKeyboardKey.keyB: 'B',
      LogicalKeyboardKey.keyC: 'C',
      LogicalKeyboardKey.keyD: 'D',
      LogicalKeyboardKey.keyE: 'E',
      LogicalKeyboardKey.keyF: 'F',
      LogicalKeyboardKey.keyG: 'G',
      LogicalKeyboardKey.keyH: 'H',
      LogicalKeyboardKey.keyI: 'I',
      LogicalKeyboardKey.keyJ: 'J',
      LogicalKeyboardKey.keyK: 'K',
      LogicalKeyboardKey.keyL: 'L',
      LogicalKeyboardKey.keyM: 'M',
      LogicalKeyboardKey.keyN: 'N',
      LogicalKeyboardKey.keyO: 'O',
      LogicalKeyboardKey.keyP: 'P',
      LogicalKeyboardKey.keyQ: 'Q',
      LogicalKeyboardKey.keyR: 'R',
      LogicalKeyboardKey.keyS: 'S',
      LogicalKeyboardKey.keyT: 'T',
      LogicalKeyboardKey.keyU: 'U',
      LogicalKeyboardKey.keyV: 'V',
      LogicalKeyboardKey.keyW: 'W',
      LogicalKeyboardKey.keyX: 'X',
      LogicalKeyboardKey.keyY: 'Y',
      LogicalKeyboardKey.keyZ: 'Z',
      LogicalKeyboardKey.digit1: '1',
      LogicalKeyboardKey.digit2: '2',
      LogicalKeyboardKey.digit3: '3',
      LogicalKeyboardKey.digit4: '4',
      LogicalKeyboardKey.digit5: '5',
      LogicalKeyboardKey.space: 'Space',
      LogicalKeyboardKey.delete: 'Delete',
      LogicalKeyboardKey.backspace: 'Backspace',
      LogicalKeyboardKey.slash: '/',
      LogicalKeyboardKey.escape: 'Esc',
    };

    return keyLabels[key] ?? key.keyLabel;
  }
}

/// Registry of all keyboard shortcuts.
class ShortcutsRegistry {
  ShortcutsRegistry._();

  static final _shortcuts = <ShortcutDefinition>[
    // File shortcuts
    const ShortcutDefinition(
      id: 'new-project',
      label: 'New Project',
      category: ShortcutCategory.file,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyN, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyN, control: true),
    ),
    const ShortcutDefinition(
      id: 'open',
      label: 'Open Project',
      category: ShortcutCategory.file,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyO, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyO, control: true),
    ),
    const ShortcutDefinition(
      id: 'save',
      label: 'Save',
      category: ShortcutCategory.file,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyS, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyS, control: true),
    ),
    const ShortcutDefinition(
      id: 'save-as',
      label: 'Save As',
      category: ShortcutCategory.file,
      macShortcut: SingleActivator(
        LogicalKeyboardKey.keyS,
        meta: true,
        shift: true,
      ),
      windowsShortcut: SingleActivator(
        LogicalKeyboardKey.keyS,
        control: true,
        shift: true,
      ),
    ),

    // Edit shortcuts
    const ShortcutDefinition(
      id: 'undo',
      label: 'Undo',
      category: ShortcutCategory.edit,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
    ),
    const ShortcutDefinition(
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
    ),

    // Widget shortcuts
    const ShortcutDefinition(
      id: 'copy-widget',
      label: 'Copy Widget',
      category: ShortcutCategory.widget,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyC, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyC, control: true),
    ),
    const ShortcutDefinition(
      id: 'paste-widget',
      label: 'Paste Widget',
      category: ShortcutCategory.widget,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyV, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyV, control: true),
    ),
    const ShortcutDefinition(
      id: 'cut-widget',
      label: 'Cut Widget',
      category: ShortcutCategory.widget,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyX, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyX, control: true),
    ),
    const ShortcutDefinition(
      id: 'duplicate-widget',
      label: 'Duplicate Widget',
      category: ShortcutCategory.widget,
      macShortcut: SingleActivator(LogicalKeyboardKey.keyD, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.keyD, control: true),
    ),
    const ShortcutDefinition(
      id: 'delete-widget',
      label: 'Delete Widget',
      category: ShortcutCategory.widget,
      macShortcut: SingleActivator(LogicalKeyboardKey.delete),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.delete),
    ),

    // View shortcuts
    const ShortcutDefinition(
      id: 'show-palette',
      label: 'Widget Palette',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.digit1, meta: true),
      windowsShortcut:
          SingleActivator(LogicalKeyboardKey.digit1, control: true),
    ),
    const ShortcutDefinition(
      id: 'show-properties',
      label: 'Properties Panel',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.digit2, meta: true),
      windowsShortcut:
          SingleActivator(LogicalKeyboardKey.digit2, control: true),
    ),
    const ShortcutDefinition(
      id: 'show-tree',
      label: 'Widget Tree',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.digit3, meta: true),
      windowsShortcut:
          SingleActivator(LogicalKeyboardKey.digit3, control: true),
    ),
    const ShortcutDefinition(
      id: 'show-design-system',
      label: 'Design System',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.digit4, meta: true),
      windowsShortcut:
          SingleActivator(LogicalKeyboardKey.digit4, control: true),
    ),
    const ShortcutDefinition(
      id: 'show-animation',
      label: 'Animation Panel',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.digit5, meta: true),
      windowsShortcut:
          SingleActivator(LogicalKeyboardKey.digit5, control: true),
    ),
    const ShortcutDefinition(
      id: 'cycle-theme',
      label: 'Cycle Theme Mode',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(
        LogicalKeyboardKey.keyT,
        meta: true,
        shift: true,
      ),
      windowsShortcut: SingleActivator(
        LogicalKeyboardKey.keyT,
        control: true,
        shift: true,
      ),
    ),
    const ShortcutDefinition(
      id: 'show-shortcuts',
      label: 'Keyboard Shortcuts',
      category: ShortcutCategory.view,
      macShortcut: SingleActivator(LogicalKeyboardKey.slash, meta: true),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.slash, control: true),
    ),

    // Animation shortcuts
    const ShortcutDefinition(
      id: 'play-animation',
      label: 'Play/Pause Animation',
      category: ShortcutCategory.animation,
      macShortcut: SingleActivator(LogicalKeyboardKey.space),
      windowsShortcut: SingleActivator(LogicalKeyboardKey.space),
    ),
  ];

  /// Gets all registered shortcuts.
  static List<ShortcutDefinition> get allShortcuts =>
      List.unmodifiable(_shortcuts);

  /// Gets shortcuts by category.
  static List<ShortcutDefinition> getByCategory(ShortcutCategory category) =>
      _shortcuts.where((s) => s.category == category).toList();

  /// Finds a shortcut by ID.
  static ShortcutDefinition? findById(String id) {
    try {
      return _shortcuts.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
