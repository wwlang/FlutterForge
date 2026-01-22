import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Utilities for accessibility and WCAG compliance.
class AccessibilityUtils {
  const AccessibilityUtils._();

  /// Minimum touch target size (WCAG 2.5.5 Level AAA).
  static const double minTouchTargetSize = 44;

  /// Minimum text contrast ratio (WCAG 2.1 Level AA).
  static const double minContrastRatioAA = 4.5;

  /// Minimum large text contrast ratio (WCAG 2.1 Level AA).
  static const double minLargeTextContrastRatioAA = 3;

  /// Enhanced contrast ratio (WCAG 2.1 Level AAA).
  static const double minContrastRatioAAA = 7;

  /// Large text threshold in logical pixels.
  static const double largeTextThreshold = 18;

  /// Bold large text threshold in logical pixels.
  static const double boldLargeTextThreshold = 14;

  /// Calculates the relative luminance of a color.
  ///
  /// Based on WCAG 2.1 formula for relative luminance.
  static double relativeLuminance(Color color) {
    double transformComponent(double normalized) {
      return normalized <= 0.03928
          ? normalized / 12.92
          : math.pow((normalized + 0.055) / 1.055, 2.4).toDouble();
    }

    final r = transformComponent(color.r);
    final g = transformComponent(color.g);
    final b = transformComponent(color.b);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculates the contrast ratio between two colors.
  ///
  /// Returns a value between 1 (no contrast) and 21 (maximum contrast).
  static double contrastRatio(Color foreground, Color background) {
    final l1 = relativeLuminance(foreground);
    final l2 = relativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Checks if the contrast ratio meets WCAG AA requirements.
  static bool meetsContrastAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = contrastRatio(foreground, background);
    final threshold =
        isLargeText ? minLargeTextContrastRatioAA : minContrastRatioAA;
    return ratio >= threshold;
  }

  /// Checks if the contrast ratio meets WCAG AAA requirements.
  static bool meetsContrastAAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = contrastRatio(foreground, background);
    final threshold = isLargeText ? minContrastRatioAA : minContrastRatioAAA;
    return ratio >= threshold;
  }

  /// Determines if text at a given size is considered "large text" for WCAG.
  static bool isLargeText(double fontSize, {bool isBold = false}) {
    if (isBold) {
      return fontSize >= boldLargeTextThreshold;
    }
    return fontSize >= largeTextThreshold;
  }

  /// Creates semantics properties for a button.
  static SemanticsProperties buttonSemantics({
    required String label,
    String? hint,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return SemanticsProperties(
      label: label,
      hint: hint,
      enabled: enabled,
      button: true,
      onTap: onTap,
    );
  }

  /// Creates semantics properties for a text field.
  static SemanticsProperties textFieldSemantics({
    required String label,
    String? value,
    String? hint,
    bool enabled = true,
  }) {
    return SemanticsProperties(
      label: label,
      value: value,
      hint: hint,
      enabled: enabled,
      textField: true,
    );
  }

  /// Creates semantics properties for a slider.
  static SemanticsProperties sliderSemantics({
    required String label,
    required double value,
    required double minValue,
    required double maxValue,
    String? hint,
    bool enabled = true,
  }) {
    return SemanticsProperties(
      label: label,
      value: '${(value * 100).round()}%',
      hint: hint,
      enabled: enabled,
      slider: true,
    );
  }

  /// Creates semantics properties for a tree item.
  static SemanticsProperties treeItemSemantics({
    required String label,
    required int level,
    required bool expanded,
    bool selected = false,
  }) {
    return SemanticsProperties(
      label: label,
      expanded: expanded,
      selected: selected,
      customSemanticsActions: {
        CustomSemanticsAction(label: expanded ? 'Collapse' : 'Expand'): () {},
      },
    );
  }

  /// Wraps a widget with proper focus handling for keyboard navigation.
  static Widget focusable({
    required Widget child,
    required String semanticLabel,
    VoidCallback? onActivate,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return Semantics(
      label: semanticLabel,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        onKeyEvent: onActivate != null
            ? (node, event) {
                if (event is KeyDownEvent &&
                    (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space)) {
                  onActivate();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              }
            : null,
        child: child,
      ),
    );
  }
}

/// Extension methods for accessibility checks.
extension ColorAccessibility on Color {
  /// Calculates the relative luminance of this color.
  double get relativeLuminance => AccessibilityUtils.relativeLuminance(this);

  /// Calculates the contrast ratio with another color.
  double contrastWith(Color other) =>
      AccessibilityUtils.contrastRatio(this, other);

  /// Checks if this color has sufficient contrast against the background.
  bool hasContrastAA(Color background, {bool isLargeText = false}) =>
      AccessibilityUtils.meetsContrastAA(
        this,
        background,
        isLargeText: isLargeText,
      );

  /// Checks if this color has sufficient contrast for AAA.
  bool hasContrastAAA(Color background, {bool isLargeText = false}) =>
      AccessibilityUtils.meetsContrastAAA(
        this,
        background,
        isLargeText: isLargeText,
      );
}
