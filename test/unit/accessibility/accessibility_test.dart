import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/core/accessibility/accessibility_utils.dart';
import 'package:flutter_forge/core/accessibility/semantic_labels.dart';

void main() {
  group('Accessibility (Task 5.3)', () {
    group('SemanticLabels', () {
      test('widgetPalette returns correct label', () {
        expect(SemanticLabels.widgetPalette, equals('Widget palette'));
      });

      test('widgetDraggable includes widget name', () {
        final label = SemanticLabels.widgetDraggable('Container');
        expect(label, contains('Container'));
        expect(label, contains('Drag'));
      });

      test('widgetTreeNode includes type and depth', () {
        final label = SemanticLabels.widgetTreeNode('Row', 2);
        expect(label, contains('Row'));
        expect(label, contains('2'));
      });

      test('canvasZoomLevel includes percentage', () {
        final label = SemanticLabels.canvasZoomLevel(150);
        expect(label, contains('150'));
        expect(label, contains('percent'));
      });

      test('propertyValue includes name and value', () {
        final label = SemanticLabels.propertyValue('padding', '16.0');
        expect(label, contains('padding'));
        expect(label, contains('16.0'));
      });

      test('designToken includes name and type', () {
        final label = SemanticLabels.designToken('primary', 'color');
        expect(label, contains('primary'));
        expect(label, contains('color'));
      });

      test('animationKeyframe includes property and time', () {
        final label = SemanticLabels.animationKeyframe('opacity', 0.5);
        expect(label, contains('opacity'));
        expect(label, contains('0.5'));
      });

      test('errorMessage includes error text', () {
        final label = SemanticLabels.errorMessage('File not found');
        expect(label, contains('Error'));
        expect(label, contains('File not found'));
      });

      test('all file operation labels are non-empty', () {
        expect(SemanticLabels.newProject, isNotEmpty);
        expect(SemanticLabels.openProject, isNotEmpty);
        expect(SemanticLabels.saveProject, isNotEmpty);
        expect(SemanticLabels.saveProjectAs, isNotEmpty);
      });

      test('all edit operation labels are non-empty', () {
        expect(SemanticLabels.undo, isNotEmpty);
        expect(SemanticLabels.redo, isNotEmpty);
        expect(SemanticLabels.cut, isNotEmpty);
        expect(SemanticLabels.copy, isNotEmpty);
        expect(SemanticLabels.paste, isNotEmpty);
        expect(SemanticLabels.delete, isNotEmpty);
      });

      test('all view toggle labels are non-empty', () {
        expect(SemanticLabels.togglePalette, isNotEmpty);
        expect(SemanticLabels.toggleTree, isNotEmpty);
        expect(SemanticLabels.toggleProperties, isNotEmpty);
        expect(SemanticLabels.toggleDesignSystem, isNotEmpty);
        expect(SemanticLabels.toggleAnimation, isNotEmpty);
      });

      test('theme labels are non-empty', () {
        expect(SemanticLabels.lightTheme, isNotEmpty);
        expect(SemanticLabels.darkTheme, isNotEmpty);
        expect(SemanticLabels.systemTheme, isNotEmpty);
      });
    });

    group('AccessibilityUtils Constants', () {
      test('minTouchTargetSize is 44', () {
        expect(AccessibilityUtils.minTouchTargetSize, equals(44.0));
      });

      test('minContrastRatioAA is 4.5', () {
        expect(AccessibilityUtils.minContrastRatioAA, equals(4.5));
      });

      test('minLargeTextContrastRatioAA is 3.0', () {
        expect(AccessibilityUtils.minLargeTextContrastRatioAA, equals(3.0));
      });

      test('minContrastRatioAAA is 7.0', () {
        expect(AccessibilityUtils.minContrastRatioAAA, equals(7.0));
      });

      test('largeTextThreshold is 18.0', () {
        expect(AccessibilityUtils.largeTextThreshold, equals(18.0));
      });

      test('boldLargeTextThreshold is 14.0', () {
        expect(AccessibilityUtils.boldLargeTextThreshold, equals(14.0));
      });
    });

    group('AccessibilityUtils Contrast', () {
      test('relativeLuminance of white is close to 1', () {
        final luminance = AccessibilityUtils.relativeLuminance(Colors.white);
        expect(luminance, closeTo(1.0, 0.01));
      });

      test('relativeLuminance of black is close to 0', () {
        final luminance = AccessibilityUtils.relativeLuminance(Colors.black);
        expect(luminance, closeTo(0.0, 0.01));
      });

      test('contrastRatio of black on white is close to 21', () {
        final ratio =
            AccessibilityUtils.contrastRatio(Colors.black, Colors.white);
        expect(ratio, closeTo(21.0, 0.5));
      });

      test('contrastRatio of white on white is 1', () {
        final ratio =
            AccessibilityUtils.contrastRatio(Colors.white, Colors.white);
        expect(ratio, closeTo(1.0, 0.01));
      });

      test('contrastRatio is symmetric', () {
        final ratio1 =
            AccessibilityUtils.contrastRatio(Colors.blue, Colors.white);
        final ratio2 =
            AccessibilityUtils.contrastRatio(Colors.white, Colors.blue);
        expect(ratio1, closeTo(ratio2, 0.01));
      });

      test('meetsContrastAA returns true for black on white', () {
        expect(
          AccessibilityUtils.meetsContrastAA(Colors.black, Colors.white),
          isTrue,
        );
      });

      test('meetsContrastAA returns false for light gray on white', () {
        const lightGray = Color(0xFFCCCCCC);
        expect(
          AccessibilityUtils.meetsContrastAA(lightGray, Colors.white),
          isFalse,
        );
      });

      test('meetsContrastAA large text has lower threshold', () {
        // Gray that passes large text but fails normal AA
        const gray = Color(0xFF767676);
        final largeResult = AccessibilityUtils.meetsContrastAA(
          gray,
          Colors.white,
          isLargeText: true,
        );
        expect(largeResult, isTrue);
      });

      test('meetsContrastAAA returns true for black on white', () {
        expect(
          AccessibilityUtils.meetsContrastAAA(Colors.black, Colors.white),
          isTrue,
        );
      });
    });

    group('AccessibilityUtils isLargeText', () {
      test('returns true for text >= 18', () {
        expect(AccessibilityUtils.isLargeText(18), isTrue);
        expect(AccessibilityUtils.isLargeText(24), isTrue);
      });

      test('returns false for text < 18', () {
        expect(AccessibilityUtils.isLargeText(14), isFalse);
        expect(AccessibilityUtils.isLargeText(16), isFalse);
      });

      test('bold text threshold is 14', () {
        expect(AccessibilityUtils.isLargeText(14, isBold: true), isTrue);
        expect(AccessibilityUtils.isLargeText(12, isBold: true), isFalse);
      });
    });

    group('AccessibilityUtils Semantics Helpers', () {
      test('buttonSemantics creates valid properties', () {
        final props = AccessibilityUtils.buttonSemantics(
          label: 'Submit',
          hint: 'Submit the form',
          enabled: true,
        );
        expect(props.label, equals('Submit'));
        expect(props.hint, equals('Submit the form'));
        expect(props.enabled, isTrue);
        expect(props.button, isTrue);
      });

      test('textFieldSemantics creates valid properties', () {
        final props = AccessibilityUtils.textFieldSemantics(
          label: 'Username',
          value: 'john',
          hint: 'Enter your username',
        );
        expect(props.label, equals('Username'));
        expect(props.value, equals('john'));
        expect(props.textField, isTrue);
      });

      test('sliderSemantics creates valid properties', () {
        final props = AccessibilityUtils.sliderSemantics(
          label: 'Volume',
          value: 0.5,
          minValue: 0,
          maxValue: 1,
        );
        expect(props.label, equals('Volume'));
        expect(props.value, contains('50'));
        expect(props.slider, isTrue);
      });

      test('treeItemSemantics creates valid properties', () {
        final props = AccessibilityUtils.treeItemSemantics(
          label: 'Container',
          level: 1,
          expanded: true,
          selected: false,
        );
        expect(props.label, equals('Container'));
        expect(props.expanded, isTrue);
        expect(props.selected, isFalse);
      });
    });

    group('ColorAccessibility Extension', () {
      test('relativeLuminance extension works', () {
        expect(Colors.white.relativeLuminance, closeTo(1.0, 0.01));
        expect(Colors.black.relativeLuminance, closeTo(0.0, 0.01));
      });

      test('contrastWith extension works', () {
        expect(Colors.black.contrastWith(Colors.white), closeTo(21.0, 0.5));
      });

      test('hasContrastAA extension works', () {
        expect(Colors.black.hasContrastAA(Colors.white), isTrue);
      });

      test('hasContrastAAA extension works', () {
        expect(Colors.black.hasContrastAAA(Colors.white), isTrue);
      });
    });

    group('Focusable Widget', () {
      testWidgets('focusable creates widget with child', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccessibilityUtils.focusable(
                semanticLabel: 'Test button',
                child: const Text('Click me'),
              ),
            ),
          ),
        );

        expect(find.text('Click me'), findsOneWidget);
        // Verify Semantics exists (multiple in tree from MaterialApp)
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}
