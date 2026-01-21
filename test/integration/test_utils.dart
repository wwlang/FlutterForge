import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/palette/widget_palette.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared E2E test utilities for FlutterForge integration tests.
///
/// Provides common helper functions for:
/// - Widget drag and drop operations
/// - Widget selection
/// - Keyboard shortcut simulation
/// - Panel/tab switching

/// Drags a widget from the palette to the canvas.
///
/// [tester] - The WidgetTester instance.
/// [widgetName] - The name of the widget to drag (e.g., 'Container', 'Row').
/// [targetOffset] - Optional offset from canvas center to drop at.
Future<void> dragWidgetToCanvas(
  WidgetTester tester,
  String widgetName, {
  Offset? targetOffset,
}) async {
  // Find widget specifically within the palette to avoid finding labels elsewhere
  final palette = find.byType(WidgetPalette);
  Finder widgetItem;

  // Check if there's a WidgetPalette - if so, search within it
  if (palette.evaluate().isNotEmpty) {
    widgetItem = find.descendant(
      of: palette,
      matching: find.text(widgetName),
    );
  } else {
    // Fallback to the first match
    widgetItem = find.text(widgetName).first;
  }

  final canvas = find.byType(DesignCanvas);

  expect(widgetItem, findsOneWidget, reason: 'Widget "$widgetName" not found');
  expect(canvas, findsOneWidget, reason: 'DesignCanvas not found');

  final gesture = await tester.startGesture(tester.getCenter(widgetItem));
  await tester.pump(const Duration(milliseconds: 50));

  final dropTarget = targetOffset != null
      ? tester.getCenter(canvas) + targetOffset
      : tester.getCenter(canvas);

  await gesture.moveTo(dropTarget);
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.up();
  await tester.pumpAndSettle();
}

/// Drags a widget from the palette into an existing widget on the canvas.
///
/// [tester] - The WidgetTester instance.
/// [widgetName] - The name of the widget to drag.
/// [parentFinder] - Finder for the parent widget on the canvas.
Future<void> dragWidgetToParent(
  WidgetTester tester,
  String widgetName,
  Finder parentFinder,
) async {
  // Find widget specifically within the palette
  final palette = find.byType(WidgetPalette);
  Finder widgetItem;

  if (palette.evaluate().isNotEmpty) {
    widgetItem = find.descendant(
      of: palette,
      matching: find.text(widgetName),
    );
  } else {
    widgetItem = find.text(widgetName).first;
  }

  expect(widgetItem, findsOneWidget);
  expect(parentFinder, findsOneWidget);

  final gesture = await tester.startGesture(tester.getCenter(widgetItem));
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.moveTo(tester.getCenter(parentFinder));
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.up();
  await tester.pumpAndSettle();
}

/// Selects a widget on the canvas by tapping it.
///
/// [tester] - The WidgetTester instance.
/// [widgetFinder] - Finder for the widget to select.
Future<void> selectWidgetOnCanvas(
  WidgetTester tester,
  Finder widgetFinder,
) async {
  expect(widgetFinder, findsOneWidget, reason: 'Widget to select not found');
  await tester.tap(widgetFinder);
  await tester.pumpAndSettle();
}

/// Selects the first widget of a given type on the canvas.
///
/// [tester] - The WidgetTester instance.
/// [widgetLabel] - The label/type of the widget to select (e.g., 'Container').
Future<void> selectWidgetByLabel(
  WidgetTester tester,
  String widgetLabel,
) async {
  final canvas = find.byType(DesignCanvas);
  final widgetOnCanvas = find.descendant(
    of: canvas,
    matching: find.text(widgetLabel),
  );

  if (widgetOnCanvas.evaluate().isNotEmpty) {
    await tester.tap(widgetOnCanvas.first);
    await tester.pumpAndSettle();
  }
}

/// Sends a keyboard shortcut that works across platforms.
///
/// Sends both meta (macOS) and control (Windows/Linux) versions to ensure
/// the shortcut works regardless of the test platform detection.
///
/// [tester] - The WidgetTester instance.
/// [key] - The main key to press.
/// [withModifier] - Whether to send with platform modifier (Cmd/Ctrl).
/// [shift] - Whether to hold Shift.
/// [alt] - Whether to hold Alt/Option.
Future<void> sendShortcut(
  WidgetTester tester,
  LogicalKeyboardKey key, {
  bool meta = false,
  bool shift = false,
  bool alt = false,
}) async {
  // Try meta key first (macOS), then control key (Windows/Linux)
  // This ensures the shortcut works in test environments where
  // the platform detection might differ from actual runtime.

  if (meta) {
    // Try meta key (macOS)
    await tester.sendKeyDownEvent(LogicalKeyboardKey.meta);
    if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
    if (alt) await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);

    await tester.sendKeyEvent(key);

    if (alt) await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.meta);

    await tester.pump();

    // Also try control key as fallback for cross-platform support
    await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
    if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
    if (alt) await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);

    await tester.sendKeyEvent(key);

    if (alt) await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.control);
  } else {
    // No modifier
    if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
    if (alt) await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);

    await tester.sendKeyEvent(key);

    if (alt) await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
  }

  await tester.pumpAndSettle();
}

/// Sends Cmd+Z (undo) shortcut.
Future<void> sendUndo(WidgetTester tester) async {
  // Tap the undo button directly for reliability in tests
  final undoButton = find.byIcon(Icons.undo);
  if (undoButton.evaluate().isNotEmpty) {
    await tester.tap(undoButton);
    await tester.pumpAndSettle();
    return;
  }
  // Fallback to keyboard shortcut
  await sendShortcut(tester, LogicalKeyboardKey.keyZ, meta: true);
}

/// Sends Cmd+Shift+Z (redo) shortcut.
Future<void> sendRedo(WidgetTester tester) async {
  // Tap the redo button directly for reliability in tests
  final redoButton = find.byIcon(Icons.redo);
  if (redoButton.evaluate().isNotEmpty) {
    await tester.tap(redoButton);
    await tester.pumpAndSettle();
    return;
  }
  // Fallback to keyboard shortcut
  await sendShortcut(tester, LogicalKeyboardKey.keyZ, meta: true, shift: true);
}

/// Sends Cmd+C (copy) shortcut.
Future<void> sendCopy(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyC, meta: true);
}

/// Sends Cmd+V (paste) shortcut.
Future<void> sendPaste(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyV, meta: true);
}

/// Sends Cmd+X (cut) shortcut.
Future<void> sendCut(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyX, meta: true);
}

/// Sends Cmd+D (duplicate) shortcut.
Future<void> sendDuplicate(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyD, meta: true);
}

/// Sends Delete key.
Future<void> sendDelete(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.delete);
  await tester.pumpAndSettle();
}

/// Sends Backspace key.
Future<void> sendBackspace(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
  await tester.pumpAndSettle();
}

/// Sends Cmd+S (save) shortcut.
Future<void> sendSave(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyS, meta: true);
}

/// Sends Cmd+Shift+S (save as) shortcut.
Future<void> sendSaveAs(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyS, meta: true, shift: true);
}

/// Sends Cmd+N (new project) shortcut.
Future<void> sendNewProject(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyN, meta: true);
}

/// Sends Cmd+O (open project) shortcut.
Future<void> sendOpenProject(WidgetTester tester) async {
  await sendShortcut(tester, LogicalKeyboardKey.keyO, meta: true);
}

/// Opens a specific panel tab in the right panel.
///
/// [tester] - The WidgetTester instance.
/// [tabName] - The name of the tab (e.g., 'Properties', 'Design System').
Future<void> openPanel(
  WidgetTester tester,
  String tabName,
) async {
  final tab = find.text(tabName);
  if (tab.evaluate().isNotEmpty) {
    await tester.tap(tab.first);
    await tester.pumpAndSettle();
  }
}

/// Opens the Properties panel.
Future<void> openPropertiesPanel(WidgetTester tester) async {
  await openPanel(tester, 'Properties');
}

/// Opens the Design System panel.
Future<void> openDesignSystemPanel(WidgetTester tester) async {
  await openPanel(tester, 'Design System');
}

/// Opens the Animation panel.
Future<void> openAnimationPanel(WidgetTester tester) async {
  await openPanel(tester, 'Animation');
}

/// Opens the Code panel.
Future<void> openCodePanel(WidgetTester tester) async {
  await openPanel(tester, 'Code');
}

/// Enters text into a text field.
///
/// [tester] - The WidgetTester instance.
/// [finder] - Finder for the text field.
/// [text] - The text to enter.
Future<void> enterText(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Taps a button by its text.
///
/// [tester] - The WidgetTester instance.
/// [buttonText] - The text of the button to tap.
Future<void> tapButton(
  WidgetTester tester,
  String buttonText,
) async {
  final button = find.text(buttonText);
  if (button.evaluate().isNotEmpty) {
    await tester.tap(button.first);
    await tester.pumpAndSettle();
  }
}

/// Taps a button by icon.
///
/// [tester] - The WidgetTester instance.
/// [icon] - The icon of the button to tap.
Future<void> tapIconButton(
  WidgetTester tester,
  IconData icon,
) async {
  final button = find.byIcon(icon);
  if (button.evaluate().isNotEmpty) {
    await tester.tap(button.first);
    await tester.pumpAndSettle();
  }
}

/// Verifies that the canvas is empty (shows "Drop widgets here").
Future<void> verifyCanvasEmpty(WidgetTester tester) async {
  expect(find.text('Drop widgets here'), findsOneWidget);
}

/// Verifies that the canvas is not empty.
Future<void> verifyCanvasNotEmpty(WidgetTester tester) async {
  expect(find.text('Drop widgets here'), findsNothing);
}

/// Counts widgets of a specific type on the canvas.
int countWidgetsOnCanvas(WidgetTester tester, String widgetLabel) {
  final canvas = find.byType(DesignCanvas);
  final widgets = find.descendant(
    of: canvas,
    matching: find.text(widgetLabel),
  );
  return widgets.evaluate().length;
}

/// Waits for animations and UI to settle with a longer timeout.
Future<void> pumpAndSettleLong(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

/// Opens a context menu on a widget.
///
/// [tester] - The WidgetTester instance.
/// [widgetFinder] - Finder for the widget to right-click.
Future<void> openContextMenu(
  WidgetTester tester,
  Finder widgetFinder,
) async {
  expect(widgetFinder, findsOneWidget);
  await tester.tap(widgetFinder, buttons: kSecondaryButton);
  await tester.pumpAndSettle();
}

/// Taps a menu item in a context menu or popup.
Future<void> tapMenuItem(
  WidgetTester tester,
  String menuItemText,
) async {
  final menuItem = find.text(menuItemText);
  expect(
    menuItem,
    findsOneWidget,
    reason: 'Menu item "$menuItemText" not found',
  );
  await tester.tap(menuItem);
  await tester.pumpAndSettle();
}

/// Dismisses any open dialogs by tapping outside or pressing Escape.
Future<void> dismissDialog(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
}

/// Finds a widget on the canvas by its type label.
Finder findWidgetOnCanvas(String widgetLabel) {
  final canvas = find.byType(DesignCanvas);
  return find.descendant(
    of: canvas,
    matching: find.text(widgetLabel),
  );
}

/// Verifies a property field has a specific value.
///
/// [tester] - The WidgetTester instance.
/// [propertyName] - Name of the property to check.
/// [expectedValue] - Expected value as a string.
bool verifyPropertyValue(
  WidgetTester tester,
  String propertyName,
  String expectedValue,
) {
  final propertyLabel = find.text(propertyName);
  if (propertyLabel.evaluate().isEmpty) {
    return false;
  }
  // Property values are typically shown near their labels
  final valueText = find.text(expectedValue);
  return valueText.evaluate().isNotEmpty;
}

/// Changes a numeric property value in the properties panel.
Future<void> changePropertyValue(
  WidgetTester tester, {
  required String propertyKey,
  required String value,
}) async {
  final field = find.byKey(Key(propertyKey));
  if (field.evaluate().isNotEmpty) {
    await tester.enterText(field, value);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }
}

/// Gets the play button finder for animation preview.
Finder findPlayButton() {
  return find.byIcon(Icons.play_arrow);
}

/// Gets the pause button finder for animation preview.
Finder findPauseButton() {
  return find.byIcon(Icons.pause);
}

/// Toggles the theme mode (light/dark).
Future<void> toggleThemeMode(WidgetTester tester) async {
  await sendShortcut(
    tester,
    LogicalKeyboardKey.keyT,
    meta: true,
    shift: true,
  );
}
