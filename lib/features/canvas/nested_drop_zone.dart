import 'package:flutter/material.dart';

/// Minimum hit area size for drop zones.
///
/// Ensures drop zones are large enough to be easily targeted
/// even when the child widget is small or invisible.
const double kMinDropZoneSize = 60;

/// A drop zone for accepting nested widget drops.
///
/// Wraps child widgets in containers that accept children,
/// showing visual feedback when a drag is hovering.
class NestedDropZone extends StatelessWidget {
  /// Creates a nested drop zone.
  const NestedDropZone({
    required this.parentId,
    required this.acceptsChildren,
    required this.hasChild,
    required this.onWidgetDropped,
    required this.child,
    this.maxChildren,
    this.childCount = 0,
    super.key,
  });

  /// The ID of the parent widget that will receive dropped children.
  final String parentId;

  /// Whether the parent widget accepts children.
  final bool acceptsChildren;

  /// Whether the parent already has a child (for single-child containers).
  final bool hasChild;

  /// Maximum number of children allowed (null = unlimited).
  final int? maxChildren;

  /// Current number of children.
  final int childCount;

  /// Callback when a widget is dropped.
  final void Function(String widgetType, String parentId) onWidgetDropped;

  /// The child widget to wrap.
  final Widget child;

  /// Whether this drop zone can accept more children.
  bool get _canAcceptMore {
    if (!acceptsChildren) return false;
    if (maxChildren == null) return true; // Unlimited
    if (maxChildren == 1) return !hasChild;
    return childCount < maxChildren!;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: kMinDropZoneSize,
        minHeight: kMinDropZoneSize,
      ),
      child: DragTarget<String>(
        onWillAcceptWithDetails: (details) => _canAcceptMore,
        onAcceptWithDetails: (details) {
          if (_canAcceptMore) {
            onWidgetDropped(details.data, parentId);
          }
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty && _canAcceptMore;

          return Stack(
            children: [
              child,
              if (isHovering)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
