import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Converts EasingType enum to Flutter Curve.
Curve easingTypeToCurve(EasingType easing) {
  switch (easing) {
    case EasingType.linear:
      return Curves.linear;
    case EasingType.easeIn:
      return Curves.easeIn;
    case EasingType.easeOut:
      return Curves.easeOut;
    case EasingType.easeInOut:
      return Curves.easeInOut;
    case EasingType.bounce:
      return Curves.bounceOut;
    case EasingType.elastic:
      return Curves.elasticOut;
  }
}

/// Cubic bezier curve representation.
class CubicBezier {
  const CubicBezier(this.x1, this.y1, this.x2, this.y2);

  final double x1;
  final double y1;
  final double x2;
  final double y2;

  /// Evaluate the bezier curve at time t (0-1).
  double evaluate(double t) {
    // Simplified cubic bezier evaluation
    // For accurate evaluation, we'd need to solve for t given x
    // This is a linear approximation for demo purposes
    final t2 = t * t;
    final t3 = t2 * t;
    final mt = 1 - t;
    final mt2 = mt * mt;

    // Bezier formula for y coordinate
    return 3 * mt2 * t * y1 + 3 * mt * t2 * y2 + t3;
  }

  /// Creates a copy with modified values.
  CubicBezier copyWith({
    double? x1,
    double? y1,
    double? x2,
    double? y2,
  }) {
    return CubicBezier(
      x1 ?? this.x1,
      y1 ?? this.y1,
      x2 ?? this.x2,
      y2 ?? this.y2,
    );
  }

  // Preset curves
  static const easeIn = CubicBezier(0.42, 0, 1, 1);
  static const easeOut = CubicBezier(0, 0, 0.58, 1);
  static const easeInOut = CubicBezier(0.42, 0, 0.58, 1);
  static const linear = CubicBezier(0, 0, 1, 1);
}

/// Editor for selecting and customizing easing curves.
class EasingEditor extends ConsumerStatefulWidget {
  const EasingEditor({
    required this.selectedEasing,
    required this.onEasingChanged,
    this.showCustomBezier = false,
    this.customBezier,
    this.onCustomBezierChanged,
    this.showAnimationPreview = false,
    super.key,
  });

  final EasingType selectedEasing;
  final void Function(EasingType easing) onEasingChanged;
  final bool showCustomBezier;
  final CubicBezier? customBezier;
  final void Function(CubicBezier bezier)? onCustomBezierChanged;
  final bool showAnimationPreview;

  @override
  ConsumerState<EasingEditor> createState() => _EasingEditorState();
}

class _EasingEditorState extends ConsumerState<EasingEditor>
    with SingleTickerProviderStateMixin {
  bool _showBezierEditor = false;
  late CubicBezier _bezier;
  late AnimationController _previewController;

  @override
  void initState() {
    super.initState();
    _bezier = widget.customBezier ?? const CubicBezier(0.25, 0.1, 0.25, 1);
    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  String _easingDisplayName(EasingType easing) {
    switch (easing) {
      case EasingType.linear:
        return 'Linear';
      case EasingType.easeIn:
        return 'Ease In';
      case EasingType.easeOut:
        return 'Ease Out';
      case EasingType.easeInOut:
        return 'Ease In Out';
      case EasingType.bounce:
        return 'Bounce';
      case EasingType.elastic:
        return 'Elastic';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPresetSelector(theme),
        const SizedBox(height: 16),
        _buildCurvePreview(theme),
        if (widget.showAnimationPreview) ...[
          const SizedBox(height: 16),
          _buildAnimationPreview(theme),
        ],
        if (_showBezierEditor && widget.showCustomBezier) ...[
          const SizedBox(height: 16),
          _buildBezierEditor(theme),
        ],
      ],
    );
  }

  Widget _buildPresetSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...EasingType.values.map((easing) {
          final isSelected = widget.selectedEasing == easing;
          return FilterChip(
            key: Key('preset-${easing.name}'),
            label: Text(_easingDisplayName(easing)),
            selected: isSelected,
            onSelected: (_) => widget.onEasingChanged(easing),
          );
        }),
        if (widget.showCustomBezier)
          FilterChip(
            key: const Key('preset-custom'),
            label: const Text('Custom'),
            selected: _showBezierEditor,
            onSelected: (_) {
              setState(() => _showBezierEditor = !_showBezierEditor);
            },
          ),
      ],
    );
  }

  Widget _buildCurvePreview(ThemeData theme) {
    return Container(
      key: const Key('curve-preview'),
      height: 150,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: CustomPaint(
        painter: _CurvePreviewPainter(
          curve: easingTypeToCurve(widget.selectedEasing),
          lineColor: theme.colorScheme.primary,
          gridColor: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildAnimationPreview(ThemeData theme) {
    return Container(
      key: const Key('animation-preview'),
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          IconButton(
            key: const Key('play-preview'),
            icon: AnimatedBuilder(
              animation: _previewController,
              builder: (context, child) {
                return Icon(
                  _previewController.isAnimating
                      ? Icons.pause
                      : Icons.play_arrow,
                );
              },
            ),
            onPressed: () {
              if (_previewController.isAnimating) {
                _previewController.stop();
              } else {
                _previewController
                  ..reset()
                  ..forward();
              }
              setState(() {});
            },
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _previewController,
              builder: (context, child) {
                final curve = easingTypeToCurve(widget.selectedEasing);
                final curvedValue = curve.transform(_previewController.value);
                return Stack(
                  children: [
                    // Track line
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 25,
                      child: Container(
                        height: 2,
                        color: theme.dividerColor,
                      ),
                    ),
                    // Moving dot
                    Positioned(
                      left: 16 + curvedValue * (300 - 32),
                      top: 18,
                      child: Container(
                        key: const Key('preview-dot'),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBezierEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          key: const Key('bezier-editor'),
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Bezier curve preview
                  CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _BezierEditorPainter(
                      bezier: _bezier,
                      lineColor: theme.colorScheme.primary,
                      handleColor: theme.colorScheme.secondary,
                      gridColor:
                          theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  // Control point 1
                  Positioned(
                    left: _bezier.x1 * constraints.maxWidth - 10,
                    bottom: _bezier.y1 * constraints.maxHeight - 10,
                    child: GestureDetector(
                      key: const Key('control-point-1'),
                      onPanUpdate: (details) {
                        final newX = (_bezier.x1 +
                                details.delta.dx / constraints.maxWidth)
                            .clamp(0.0, 1.0);
                        final newY = (_bezier.y1 -
                                details.delta.dy / constraints.maxHeight)
                            .clamp(0.0, 1.5);
                        setState(() {
                          _bezier = _bezier.copyWith(x1: newX, y1: newY);
                        });
                        widget.onCustomBezierChanged?.call(_bezier);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                  // Control point 2
                  Positioned(
                    left: _bezier.x2 * constraints.maxWidth - 10,
                    bottom: _bezier.y2 * constraints.maxHeight - 10,
                    child: GestureDetector(
                      key: const Key('control-point-2'),
                      onPanUpdate: (details) {
                        final newX = (_bezier.x2 +
                                details.delta.dx / constraints.maxWidth)
                            .clamp(0.0, 1.0);
                        final newY = (_bezier.y2 -
                                details.delta.dy / constraints.maxHeight)
                            .clamp(-0.5, 1.0);
                        setState(() {
                          _bezier = _bezier.copyWith(x2: newX, y2: newY);
                        });
                        widget.onCustomBezierChanged?.call(_bezier);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildBezierInputFields(theme),
      ],
    );
  }

  Widget _buildBezierInputFields(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            key: const Key('bezier-x1'),
            controller:
                TextEditingController(text: _bezier.x1.toStringAsFixed(2)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'X1',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) {
              final x1 = double.tryParse(value);
              if (x1 != null) {
                setState(() {
                  _bezier = _bezier.copyWith(x1: x1.clamp(0.0, 1.0));
                });
                widget.onCustomBezierChanged?.call(_bezier);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: const Key('bezier-y1'),
            controller:
                TextEditingController(text: _bezier.y1.toStringAsFixed(2)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Y1',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) {
              final y1 = double.tryParse(value);
              if (y1 != null) {
                setState(() {
                  _bezier = _bezier.copyWith(y1: y1);
                });
                widget.onCustomBezierChanged?.call(_bezier);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: const Key('bezier-x2'),
            controller:
                TextEditingController(text: _bezier.x2.toStringAsFixed(2)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'X2',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) {
              final x2 = double.tryParse(value);
              if (x2 != null) {
                setState(() {
                  _bezier = _bezier.copyWith(x2: x2.clamp(0.0, 1.0));
                });
                widget.onCustomBezierChanged?.call(_bezier);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            key: const Key('bezier-y2'),
            controller:
                TextEditingController(text: _bezier.y2.toStringAsFixed(2)),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Y2',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) {
              final y2 = double.tryParse(value);
              if (y2 != null) {
                setState(() {
                  _bezier = _bezier.copyWith(y2: y2);
                });
                widget.onCustomBezierChanged?.call(_bezier);
              }
            },
          ),
        ),
      ],
    );
  }
}

/// Painter for the curve preview.
class _CurvePreviewPainter extends CustomPainter {
  _CurvePreviewPainter({
    required this.curve,
    required this.lineColor,
    required this.gridColor,
  });

  final Curve curve;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Draw grid
    for (var i = 0; i <= 4; i++) {
      final x = size.width * i / 4;
      final y = size.height * i / 4;
      canvas
        ..drawLine(Offset(x, 0), Offset(x, size.height), gridPaint)
        ..drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw curve
    final curvePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(0, size.height);

    for (var i = 0; i <= 100; i++) {
      final t = i / 100;
      final curvedT = curve.transform(t);
      final x = t * size.width;
      final y = size.height - curvedT * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(_CurvePreviewPainter oldDelegate) {
    return curve != oldDelegate.curve ||
        lineColor != oldDelegate.lineColor ||
        gridColor != oldDelegate.gridColor;
  }
}

/// Painter for the bezier editor.
class _BezierEditorPainter extends CustomPainter {
  _BezierEditorPainter({
    required this.bezier,
    required this.lineColor,
    required this.handleColor,
    required this.gridColor,
  });

  final CubicBezier bezier;
  final Color lineColor;
  final Color handleColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Draw grid
    for (var i = 0; i <= 4; i++) {
      final x = size.width * i / 4;
      final y = size.height * i / 4;
      canvas
        ..drawLine(Offset(x, 0), Offset(x, size.height), gridPaint)
        ..drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Control point lines
    final handleLinePaint = Paint()
      ..color = handleColor.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    // Line from start to control point 1
    canvas
      ..drawLine(
        Offset(0, size.height),
        Offset(bezier.x1 * size.width, size.height - bezier.y1 * size.height),
        handleLinePaint,
      )
      // Line from end to control point 2
      ..drawLine(
        Offset(size.width, 0),
        Offset(bezier.x2 * size.width, size.height - bezier.y2 * size.height),
        handleLinePaint,
      );

    // Draw bezier curve
    final curvePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        bezier.x1 * size.width,
        size.height - bezier.y1 * size.height,
        bezier.x2 * size.width,
        size.height - bezier.y2 * size.height,
        size.width,
        0,
      );

    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(_BezierEditorPainter oldDelegate) {
    return bezier.x1 != oldDelegate.bezier.x1 ||
        bezier.y1 != oldDelegate.bezier.y1 ||
        bezier.x2 != oldDelegate.bezier.x2 ||
        bezier.y2 != oldDelegate.bezier.y2 ||
        lineColor != oldDelegate.lineColor ||
        handleColor != oldDelegate.handleColor ||
        gridColor != oldDelegate.gridColor;
  }
}
