import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timeline zoom level provider.
final timelineZoomProvider = StateProvider<double>((ref) => 1.0);

/// Timeline editor widget for animation tracks.
class TimelineEditor extends ConsumerStatefulWidget {
  const TimelineEditor({
    required this.animations,
    required this.onPlayheadChange,
    this.initialPlayheadMs = 0,
    this.onKeyframeSelected,
    super.key,
  });

  /// List of animations to display on timeline.
  final List<WidgetAnimation> animations;

  /// Callback when playhead position changes.
  final void Function(int ms) onPlayheadChange;

  /// Initial playhead position in milliseconds.
  final int initialPlayheadMs;

  /// Callback when a keyframe is selected.
  final void Function(String animationId, String keyframeId)?
      onKeyframeSelected;

  @override
  ConsumerState<TimelineEditor> createState() => _TimelineEditorState();
}

class _TimelineEditorState extends ConsumerState<TimelineEditor> {
  late int _playheadMs;
  final ScrollController _horizontalScrollController = ScrollController();

  /// Pixels per millisecond at zoom 1.0
  static const _basePixelsPerMs = 0.5;

  /// Track height in pixels
  static const _trackHeight = 40.0;

  /// Ruler height in pixels
  static const _rulerHeight = 30.0;

  @override
  void initState() {
    super.initState();
    _playheadMs = widget.initialPlayheadMs;
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  int get _maxDurationMs {
    if (widget.animations.isEmpty) return 1000;
    return widget.animations
        .map((a) => a.durationMs + a.delayMs)
        .reduce((a, b) => a > b ? a : b);
  }

  double get _pixelsPerMs {
    final zoom = ref.watch(timelineZoomProvider);
    return _basePixelsPerMs * zoom;
  }

  double get _timelineWidth => _maxDurationMs * _pixelsPerMs + 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _timelineWidth.clamp(constraints.maxWidth, double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRuler(theme),
                Expanded(
                  child: Stack(
                    children: [
                      _buildTracks(theme),
                      _buildPlayhead(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRuler(ThemeData theme) {
    return Container(
      height: _rulerHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: CustomPaint(
        painter: _RulerPainter(
          maxDurationMs: _maxDurationMs,
          pixelsPerMs: _pixelsPerMs,
          textColor: theme.colorScheme.onSurface,
          lineColor: theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildTracks(ThemeData theme) {
    return Column(
      children: widget.animations.map((animation) {
        return _AnimationTrack(
          animation: animation,
          pixelsPerMs: _pixelsPerMs,
          trackHeight: _trackHeight,
          onKeyframeTap: widget.onKeyframeSelected != null
              ? (kfId) => widget.onKeyframeSelected!(animation.id, kfId)
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildPlayhead(ThemeData theme) {
    return Positioned(
      left: _playheadMs * _pixelsPerMs - 8,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        key: const Key('playhead'),
        onHorizontalDragUpdate: (details) {
          final newMs =
              ((_playheadMs * _pixelsPerMs + details.delta.dx) / _pixelsPerMs)
                  .round()
                  .clamp(0, _maxDurationMs);
          setState(() => _playheadMs = newMs);
          widget.onPlayheadChange(newMs);
        },
        child: SizedBox(
          width: 16,
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the timeline ruler.
class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.maxDurationMs,
    required this.pixelsPerMs,
    required this.textColor,
    required this.lineColor,
  });

  final int maxDurationMs;
  final double pixelsPerMs;
  final Color textColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Determine marker interval based on zoom
    final intervalMs = _calculateInterval();

    for (var ms = 0; ms <= maxDurationMs; ms += intervalMs) {
      final x = ms * pixelsPerMs;
      final isMajor = ms % (intervalMs * 2) == 0;

      // Draw tick mark
      canvas.drawLine(
        Offset(x, isMajor ? 0 : size.height * 0.5),
        Offset(x, size.height),
        linePaint,
      );

      // Draw label for major ticks
      if (isMajor) {
        textPainter
          ..text = TextSpan(
            text: '${ms}ms',
            style: TextStyle(
              color: textColor,
              fontSize: 10,
            ),
          )
          ..layout()
          ..paint(canvas, Offset(x + 4, 2));
      }
    }
  }

  int _calculateInterval() {
    // More zoomed in = smaller intervals
    if (pixelsPerMs > 1.0) return 100;
    if (pixelsPerMs > 0.5) return 250;
    if (pixelsPerMs > 0.25) return 500;
    return 1000;
  }

  @override
  bool shouldRepaint(_RulerPainter oldDelegate) {
    return maxDurationMs != oldDelegate.maxDurationMs ||
        pixelsPerMs != oldDelegate.pixelsPerMs ||
        textColor != oldDelegate.textColor ||
        lineColor != oldDelegate.lineColor;
  }
}

/// Individual animation track in the timeline.
class _AnimationTrack extends StatelessWidget {
  const _AnimationTrack({
    required this.animation,
    required this.pixelsPerMs,
    required this.trackHeight,
    this.onKeyframeTap,
  });

  final WidgetAnimation animation;
  final double pixelsPerMs;
  final double trackHeight;
  final void Function(String keyframeId)? onKeyframeTap;

  Color get _trackColor {
    switch (animation.type) {
      case AnimationType.fade:
        return Colors.purple;
      case AnimationType.slide:
        return Colors.blue;
      case AnimationType.scale:
        return Colors.green;
      case AnimationType.rotate:
        return Colors.orange;
      case AnimationType.custom:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: trackHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Stack(
        children: [
          // Animation duration bar
          Positioned(
            left: animation.delayMs * pixelsPerMs,
            top: 8,
            child: Container(
              width: animation.durationMs * pixelsPerMs,
              height: trackHeight - 16,
              decoration: BoxDecoration(
                color: _trackColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _trackColor),
              ),
            ),
          ),
          // Keyframes
          ...animation.keyframes.map((kf) {
            return Positioned(
              left: (animation.delayMs + kf.timeMs) * pixelsPerMs - 6,
              top: trackHeight / 2 - 6,
              child: GestureDetector(
                key: Key('keyframe-${kf.id}'),
                onTap:
                    onKeyframeTap != null ? () => onKeyframeTap!(kf.id) : null,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _trackColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
