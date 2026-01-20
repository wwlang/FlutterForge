import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Interpolates keyframe values at a given time.
double? interpolateKeyframes(
  List<Keyframe> keyframes,
  String property,
  int timeMs,
) {
  final propertyKeyframes =
      keyframes.where((k) => k.property == property).toList();

  if (propertyKeyframes.isEmpty) return null;

  // Sort by time
  propertyKeyframes.sort((a, b) => a.timeMs.compareTo(b.timeMs));

  // Before first keyframe
  if (timeMs <= propertyKeyframes.first.timeMs) {
    final value = propertyKeyframes.first.value;
    return value is num ? value.toDouble() : null;
  }

  // After last keyframe
  if (timeMs >= propertyKeyframes.last.timeMs) {
    final value = propertyKeyframes.last.value;
    return value is num ? value.toDouble() : null;
  }

  // Find surrounding keyframes
  Keyframe? before;
  Keyframe? after;

  for (var i = 0; i < propertyKeyframes.length - 1; i++) {
    if (propertyKeyframes[i].timeMs <= timeMs &&
        propertyKeyframes[i + 1].timeMs >= timeMs) {
      before = propertyKeyframes[i];
      after = propertyKeyframes[i + 1];
      break;
    }
  }

  if (before == null || after == null) return null;

  final beforeValue = before.value;
  final afterValue = after.value;

  if (beforeValue is! num || afterValue is! num) return null;

  // Linear interpolation
  final t = (timeMs - before.timeMs) / (after.timeMs - before.timeMs);
  return beforeValue.toDouble() +
      (afterValue.toDouble() - beforeValue.toDouble()) * t;
}

/// Editor for keyframes in an animation.
class KeyframeEditor extends ConsumerStatefulWidget {
  const KeyframeEditor({
    required this.animation,
    required this.onKeyframeAdded,
    required this.onKeyframeUpdated,
    required this.onKeyframeDeleted,
    this.playheadMs = 0,
    super.key,
  });

  final WidgetAnimation animation;
  final void Function(Keyframe keyframe) onKeyframeAdded;
  final void Function(Keyframe keyframe) onKeyframeUpdated;
  final void Function(String keyframeId) onKeyframeDeleted;
  final int playheadMs;

  @override
  ConsumerState<KeyframeEditor> createState() => _KeyframeEditorState();
}

class _KeyframeEditorState extends ConsumerState<KeyframeEditor> {
  String? _selectedKeyframeId;

  Keyframe? get _selectedKeyframe {
    if (_selectedKeyframeId == null) return null;
    try {
      return widget.animation.keyframes
          .firstWhere((k) => k.id == _selectedKeyframeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildKeyframeList(theme),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 3,
                child: _buildPropertyEditor(theme),
              ),
            ],
          ),
        ),
        if (widget.animation.keyframes.isNotEmpty)
          _buildInterpolationPreview(theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text('Keyframes', style: theme.textTheme.titleMedium),
          const Spacer(),
          FilledButton.icon(
            onPressed: _showAddKeyframeDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Keyframe'),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyframeList(ThemeData theme) {
    if (widget.animation.keyframes.isEmpty) {
      return Center(
        child: Text(
          'No keyframes',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      );
    }

    final sortedKeyframes = List<Keyframe>.from(widget.animation.keyframes)
      ..sort((a, b) => a.timeMs.compareTo(b.timeMs));

    return ListView.builder(
      itemCount: sortedKeyframes.length,
      itemBuilder: (context, index) {
        final keyframe = sortedKeyframes[index];
        final isSelected = keyframe.id == _selectedKeyframeId;

        return InkWell(
          key: Key('keyframe-item-${keyframe.id}'),
          onTap: () => setState(() => _selectedKeyframeId = keyframe.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${keyframe.timeMs}ms',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  keyframe.property,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const Spacer(),
                Text(
                  '${keyframe.value}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPropertyEditor(ThemeData theme) {
    final keyframe = _selectedKeyframe;

    if (keyframe == null) {
      return Center(
        child: Text(
          'Select a keyframe to edit',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Editing Keyframe', style: theme.textTheme.titleSmall),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.onKeyframeDeleted(keyframe.id);
                  setState(() => _selectedKeyframeId = null);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Time (ms)', style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          TextFormField(
            key: const Key('edit-time-input'),
            initialValue: keyframe.timeMs.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onFieldSubmitted: (value) {
              final time = int.tryParse(value);
              if (time != null) {
                widget.onKeyframeUpdated(
                  Keyframe(
                    id: keyframe.id,
                    timeMs: time,
                    property: keyframe.property,
                    value: keyframe.value,
                    easing: keyframe.easing,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Text('Property', style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: keyframe.property,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onFieldSubmitted: (value) {
              widget.onKeyframeUpdated(
                Keyframe(
                  id: keyframe.id,
                  timeMs: keyframe.timeMs,
                  property: value,
                  value: keyframe.value,
                  easing: keyframe.easing,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('Value', style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          TextFormField(
            key: const Key('edit-value-input'),
            initialValue: keyframe.value.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onFieldSubmitted: (value) {
              final numValue = double.tryParse(value);
              if (numValue != null) {
                widget.onKeyframeUpdated(
                  Keyframe(
                    id: keyframe.id,
                    timeMs: keyframe.timeMs,
                    property: keyframe.property,
                    value: numValue,
                    easing: keyframe.easing,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Text('Easing', style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          DropdownButtonFormField<EasingType?>(
            key: const Key('easing-dropdown'),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: [
              const DropdownMenuItem<EasingType?>(
                child: Text('Inherit'),
              ),
              ...EasingType.values.map(
                (e) => DropdownMenuItem<EasingType?>(
                  value: e,
                  child: Text(e.name),
                ),
              ),
            ],
            onChanged: (easing) {
              widget.onKeyframeUpdated(
                Keyframe(
                  id: keyframe.id,
                  timeMs: keyframe.timeMs,
                  property: keyframe.property,
                  value: keyframe.value,
                  easing: easing,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterpolationPreview(ThemeData theme) {
    // Get unique properties
    final properties =
        widget.animation.keyframes.map((k) => k.property).toSet();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          for (final property in properties) ...[
            Builder(
              builder: (context) {
                final value = interpolateKeyframes(
                  widget.animation.keyframes,
                  property,
                  widget.playheadMs,
                );
                if (value == null) return const SizedBox.shrink();
                final isWholeNumber = value.truncateToDouble() == value;
                final formatted = value.toStringAsFixed(isWholeNumber ? 0 : 1);
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Current: $formatted',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showAddKeyframeDialog() {
    final timeController = TextEditingController();
    final propertyController = TextEditingController();
    final valueController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Keyframe'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('keyframe-time-input'),
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Time (ms)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('keyframe-property-input'),
                  controller: propertyController,
                  decoration: const InputDecoration(
                    labelText: 'Property',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('keyframe-value-input'),
                  controller: valueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final time = int.tryParse(timeController.text);
                final property = propertyController.text;
                final value = double.tryParse(valueController.text);

                if (time != null && property.isNotEmpty && value != null) {
                  widget.onKeyframeAdded(
                    Keyframe(
                      id: const Uuid().v4(),
                      timeMs: time,
                      property: property,
                      value: value,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
