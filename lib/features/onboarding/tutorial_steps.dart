import 'package:flutter/material.dart';

/// The type of action required for a tutorial step.
enum TutorialAction {
  /// User must drag an element.
  drag,

  /// User must tap/click an element.
  tap,

  /// User must type or edit a value.
  edit,

  /// User must complete a menu action.
  menu,
}

/// A single step in the interactive tutorial.
///
/// Each step targets a specific UI element and requires
/// a specific action to complete.
@immutable
class TutorialStep {
  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetKey,
    required this.action,
    this.targetArea,
    this.hint,
  });

  /// Unique identifier for this step.
  final String id;

  /// Short title displayed in the tutorial overlay.
  final String title;

  /// Detailed description of what to do.
  final String description;

  /// The key of the target widget to highlight.
  final Key targetKey;

  /// The type of action required.
  final TutorialAction action;

  /// Optional area name for grouping (e.g., 'palette', 'canvas', 'properties').
  final String? targetArea;

  /// Optional hint text for additional guidance.
  final String? hint;
}

/// Registry of all tutorial steps.
///
/// Based on J18 S2 acceptance criteria:
/// 1. Drag a Container to canvas
/// 2. Select the Container
/// 3. Change the color property
/// 4. Add a Text widget as child
/// 5. Edit the text content
/// 6. Export the code
/// 7. Save the project
class TutorialSteps {
  TutorialSteps._();

  static const List<TutorialStep> allSteps = [
    // Step 1: Drag Container
    TutorialStep(
      id: 'drag-container',
      title: 'Drag a Container',
      description:
          'Find the Container widget in the Widget Palette on the left '
          'and drag it onto the canvas.',
      targetKey: Key('widget-palette-container'),
      action: TutorialAction.drag,
      targetArea: 'palette',
      hint: 'Containers are in the Layout category',
    ),

    // Step 2: Select Widget
    TutorialStep(
      id: 'select-widget',
      title: 'Select the Container',
      description: 'Click on the Container you just added to select it. '
          "You'll see a blue selection border appear.",
      targetKey: Key('canvas-widget'),
      action: TutorialAction.tap,
      targetArea: 'canvas',
    ),

    // Step 3: Change Property
    TutorialStep(
      id: 'change-property',
      title: 'Change a Property',
      description: 'In the Properties panel on the right, find the '
          '"color" property and click to change it.',
      targetKey: Key('property-color'),
      action: TutorialAction.tap,
      targetArea: 'properties',
      hint: 'Try picking a nice blue color!',
    ),

    // Step 4: Add Child Widget
    TutorialStep(
      id: 'add-child',
      title: 'Add a Text Widget',
      description: 'Drag a Text widget from the palette and drop it '
          'inside the Container to add it as a child.',
      targetKey: Key('widget-palette-text'),
      action: TutorialAction.drag,
      targetArea: 'palette',
    ),

    // Step 5: Edit Text Content
    TutorialStep(
      id: 'edit-text',
      title: 'Edit the Text',
      description: 'With the Text widget selected, find the "data" '
          'property and type your own message.',
      targetKey: Key('property-data'),
      action: TutorialAction.edit,
      targetArea: 'properties',
      hint: 'Try "Hello, FlutterForge!"',
    ),

    // Step 6: Export Code
    TutorialStep(
      id: 'export-code',
      title: 'View the Code',
      description: 'Click on the "Code" tab to see the Flutter code '
          'generated from your design.',
      targetKey: Key('tab-code'),
      action: TutorialAction.tap,
      targetArea: 'code',
    ),

    // Step 7: Save Project
    TutorialStep(
      id: 'save-project',
      title: 'Save Your Project',
      description: 'Use File > Save or press Cmd+S (Ctrl+S on Windows) '
          'to save your project.',
      targetKey: Key('menu-file-save'),
      action: TutorialAction.menu,
      targetArea: 'menu',
    ),
  ];

  /// Gets a step by its ID.
  static TutorialStep? findById(String id) {
    try {
      return allSteps.firstWhere((step) => step.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets the index of a step by ID.
  static int indexOf(String id) {
    return allSteps.indexWhere((step) => step.id == id);
  }
}
