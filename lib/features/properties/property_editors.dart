import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editor for String properties.
class StringEditor extends StatefulWidget {
  const StringEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final String? value;
  final void Function(String) onChanged;
  final String? description;

  @override
  State<StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<StringEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(StringEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onSubmitted: widget.onChanged,
        onEditingComplete: () => widget.onChanged(_controller.text),
      ),
    );
  }
}

/// Editor for double properties.
class DoubleEditor extends StatefulWidget {
  const DoubleEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final double? value;
  final void Function(double?) onChanged;
  final double? min;
  final double? max;
  final String? description;

  @override
  State<DoubleEditor> createState() => _DoubleEditorState();
}

class _DoubleEditorState extends State<DoubleEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(DoubleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    if (text.isEmpty) {
      widget.onChanged(null);
      return;
    }

    final parsed = double.tryParse(text);
    if (parsed == null) {
      widget.onChanged(null);
      return;
    }

    var value = parsed;
    if (widget.min != null && value < widget.min!) {
      value = widget.min!;
    }
    if (widget.max != null && value > widget.max!) {
      value = widget.max!;
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
        ],
        onSubmitted: _onSubmitted,
        onEditingComplete: () => _onSubmitted(_controller.text),
      ),
    );
  }
}

/// Editor for int properties.
class IntEditor extends StatefulWidget {
  const IntEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final int? value;
  final void Function(int?) onChanged;
  final int? min;
  final int? max;
  final String? description;

  @override
  State<IntEditor> createState() => _IntEditorState();
}

class _IntEditorState extends State<IntEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(IntEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    if (text.isEmpty) {
      widget.onChanged(null);
      return;
    }

    final parsed = int.tryParse(text);
    if (parsed == null) {
      widget.onChanged(null);
      return;
    }

    var value = parsed;
    if (widget.min != null && value < widget.min!) {
      value = widget.min!;
    }
    if (widget.max != null && value > widget.max!) {
      value = widget.max!;
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
        ],
        onSubmitted: _onSubmitted,
        onEditingComplete: () => _onSubmitted(_controller.text),
      ),
    );
  }
}

/// Editor for bool properties.
class BoolEditor extends StatelessWidget {
  const BoolEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final bool? value;
  // Using ValueChanged to match Flutter's Checkbox API
  final ValueChanged<bool?> onChanged;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      label: displayName,
      description: description,
      child: Checkbox(
        value: value ?? false,
        onChanged: onChanged,
      ),
    );
  }
}

/// Editor for Color properties.
class ColorEditor extends StatefulWidget {
  const ColorEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final int? value;
  final void Function(int?) onChanged;
  final String? description;

  @override
  State<ColorEditor> createState() => _ColorEditorState();
}

class _ColorEditorState extends State<ColorEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null
          ? widget.value!.toRadixString(16).toUpperCase().padLeft(8, '0')
          : '',
    );
  }

  @override
  void didUpdateWidget(ColorEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value != null
          ? widget.value!.toRadixString(16).toUpperCase().padLeft(8, '0')
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    if (text.isEmpty) {
      widget.onChanged(null);
      return;
    }

    // Try to parse hex color
    final cleaned = text.replaceAll('#', '').replaceAll('0x', '');
    final value = int.tryParse(cleaned, radix: 16);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.value != null ? Color(widget.value!) : null;

    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child: Row(
        children: [
          // Color preview
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color ?? Colors.transparent,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          // Hex input
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'AARRGGBB',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(8),
              ],
              onSubmitted: _onSubmitted,
              onEditingComplete: () => _onSubmitted(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

/// Editor for enum properties (dropdown).
class EnumEditor extends StatelessWidget {
  const EnumEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.enumValues,
    required this.onChanged,
    this.description,
    super.key,
  });

  final String propertyName;
  final String displayName;
  final String? value;
  final List<String> enumValues;
  final void Function(String?) onChanged;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return _PropertyRow(
      label: displayName,
      description: description,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem<String>(child: Text('None')),
          ...enumValues.map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(_formatEnumValue(e)),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }

  String _formatEnumValue(String value) {
    // Convert MainAxisAlignment.center to center
    final parts = value.split('.');
    return parts.length > 1 ? parts.last : value;
  }
}

/// Reusable property row layout.
class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.label,
    required this.child,
    this.description,
  });

  final String label;
  final Widget child;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          child,
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
