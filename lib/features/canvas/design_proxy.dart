import 'package:flutter/material.dart';

/// Wrapper widget that intercepts events for design-time interaction.
///
/// Wraps rendered widgets to enable click-to-select and other design-time
/// interactions without affecting the widget's normal behavior.
class DesignProxy extends StatelessWidget {
  /// Creates a design proxy.
  const DesignProxy({
    required this.nodeId,
    required this.onTap,
    required this.child,
    super.key,
  });

  /// The node ID this proxy wraps.
  final String nodeId;

  /// Callback when the widget is tapped.
  final VoidCallback onTap;

  /// The child widget to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
