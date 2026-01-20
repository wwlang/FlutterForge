import 'package:flutter/material.dart';

/// Visual overlay shown around the selected widget in the design canvas.
///
/// Displays a highlight border to indicate selection state.
class WidgetSelectionOverlay extends StatelessWidget {
  /// Creates a widget selection overlay.
  const WidgetSelectionOverlay({
    required this.child,
    this.borderColor,
    this.borderWidth = 2.0,
    super.key,
  });

  /// The child widget to wrap with selection border.
  final Widget child;

  /// Color of the selection border.
  final Color? borderColor;

  /// Width of the selection border.
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: borderWidth),
      ),
      position: DecorationPosition.foreground,
      child: child,
    );
  }
}
