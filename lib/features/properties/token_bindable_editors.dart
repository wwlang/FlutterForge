import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/properties/token_binding.dart';
import 'package:flutter_forge/features/properties/token_picker.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Editor for color properties that supports token binding.
class TokenBindableColorEditor extends ConsumerStatefulWidget {
  /// Creates a token-bindable color editor.
  const TokenBindableColorEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    required this.onTokenBound,
    this.description,
    super.key,
  });

  /// Property name for identification.
  final String propertyName;

  /// Display label for the property.
  final String displayName;

  /// Current value (int color value or {"\$token": "name"} binding).
  final dynamic value;

  /// Callback when value changes to a literal.
  final void Function(int?) onChanged;

  /// Callback when a token is bound.
  final void Function(String tokenName) onTokenBound;

  /// Optional description text.
  final String? description;

  @override
  ConsumerState<TokenBindableColorEditor> createState() =>
      _TokenBindableColorEditorState();
}

class _TokenBindableColorEditorState
    extends ConsumerState<TokenBindableColorEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _getHexText());
  }

  @override
  void didUpdateWidget(TokenBindableColorEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = _getHexText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getHexText() {
    if (TokenBinding.isTokenBound(widget.value)) {
      return '';
    }
    final intValue = widget.value as int?;
    if (intValue == null) return '';
    return intValue.toRadixString(16).toUpperCase().padLeft(8, '0');
  }

  bool get _isTokenBound => TokenBinding.isTokenBound(widget.value);

  String? get _boundTokenName => TokenBinding.getTokenName(widget.value);

  int? get _resolvedValue {
    if (!_isTokenBound) {
      return widget.value as int?;
    }

    final tokenName = _boundTokenName;
    if (tokenName == null) return null;

    final notifier = ref.read(designTokensProvider.notifier);
    return resolveColorTokenValue(tokenName, notifier, isDarkMode: false);
  }

  void _onSubmitted(String text) {
    if (text.isEmpty) {
      widget.onChanged(null);
      return;
    }

    final cleaned = text.replaceAll('#', '').replaceAll('0x', '');
    final value = int.tryParse(cleaned, radix: 16);
    widget.onChanged(value);
  }

  Future<void> _openTokenPicker() async {
    final token = await TokenPickerDialog.show(
      context,
      compatibleType: TokenType.color,
      selectedTokenName: _boundTokenName,
    );

    if (token != null) {
      widget.onTokenBound(token.name);
    }
  }

  void _clearToken() {
    // Convert to the resolved literal value
    final resolvedValue = _resolvedValue;
    widget.onChanged(resolvedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child:
          _isTokenBound ? _buildBoundState(theme) : _buildLiteralState(theme),
    );
  }

  Widget _buildBoundState(ThemeData theme) {
    final tokenName = _boundTokenName ?? 'Unknown';
    final resolvedColor =
        _resolvedValue != null ? Color(_resolvedValue!) : Colors.transparent;
    final hexValue =
        _resolvedValue?.toRadixString(16).toUpperCase().padLeft(8, '0');

    return Tooltip(
      message: 'Resolved: #${hexValue ?? 'N/A'}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            // Color preview
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: resolvedColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            // Token name
            Expanded(
              child: Text(
                tokenName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            // Clear button
            IconButton(
              icon: Icon(
                Icons.link_off,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: _clearToken,
              tooltip: 'Clear token binding',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiteralState(ThemeData theme) {
    final color = widget.value != null ? Color(widget.value as int) : null;

    return Row(
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
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        const SizedBox(width: 8),
        // Token picker button
        IconButton(
          icon: Icon(
            Icons.palette_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          onPressed: _openTokenPicker,
          tooltip: 'Use design token',
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

/// Editor for double properties that supports token binding.
class TokenBindableDoubleEditor extends ConsumerStatefulWidget {
  /// Creates a token-bindable double editor.
  const TokenBindableDoubleEditor({
    required this.propertyName,
    required this.displayName,
    required this.tokenType,
    required this.value,
    required this.onChanged,
    required this.onTokenBound,
    this.min,
    this.max,
    this.description,
    super.key,
  });

  /// Property name for identification.
  final String propertyName;

  /// Display label for the property.
  final String displayName;

  /// Token type for filtering (spacing or radius).
  final TokenType tokenType;

  /// Current value (double or {"\$token": "name"} binding).
  final dynamic value;

  /// Callback when value changes to a literal.
  final void Function(double?) onChanged;

  /// Callback when a token is bound.
  final void Function(String tokenName) onTokenBound;

  /// Minimum allowed value.
  final double? min;

  /// Maximum allowed value.
  final double? max;

  /// Optional description text.
  final String? description;

  @override
  ConsumerState<TokenBindableDoubleEditor> createState() =>
      _TokenBindableDoubleEditorState();
}

class _TokenBindableDoubleEditorState
    extends ConsumerState<TokenBindableDoubleEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _getValueText());
  }

  @override
  void didUpdateWidget(TokenBindableDoubleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = _getValueText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getValueText() {
    if (TokenBinding.isTokenBound(widget.value)) {
      return '';
    }
    final doubleValue = widget.value as double?;
    return doubleValue?.toString() ?? '';
  }

  bool get _isTokenBound => TokenBinding.isTokenBound(widget.value);

  String? get _boundTokenName => TokenBinding.getTokenName(widget.value);

  double? get _resolvedValue {
    if (!_isTokenBound) {
      return widget.value as double?;
    }

    final tokenName = _boundTokenName;
    if (tokenName == null) return null;

    final notifier = ref.read(designTokensProvider.notifier);
    return resolveDoubleTokenValue(tokenName, widget.tokenType, notifier);
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

  Future<void> _openTokenPicker() async {
    final token = await TokenPickerDialog.show(
      context,
      compatibleType: widget.tokenType,
      selectedTokenName: _boundTokenName,
    );

    if (token != null) {
      widget.onTokenBound(token.name);
    }
  }

  void _clearToken() {
    final resolvedValue = _resolvedValue;
    widget.onChanged(resolvedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PropertyRow(
      label: widget.displayName,
      description: widget.description,
      child:
          _isTokenBound ? _buildBoundState(theme) : _buildLiteralState(theme),
    );
  }

  Widget _buildBoundState(ThemeData theme) {
    final tokenName = _boundTokenName ?? 'Unknown';

    return Tooltip(
      message: 'Resolved: ${_resolvedValue ?? 'N/A'}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          children: [
            Icon(
              _getIconForType(),
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tokenName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.link_off,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: _clearToken,
              tooltip: 'Clear token binding',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiteralState(ThemeData theme) {
    return Row(
      children: [
        Expanded(
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
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.palette_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          onPressed: _openTokenPicker,
          tooltip: 'Use design token',
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  IconData _getIconForType() {
    switch (widget.tokenType) {
      case TokenType.spacing:
        return Icons.space_bar;
      case TokenType.radius:
        return Icons.rounded_corner;
      case TokenType.color:
      case TokenType.typography:
        return Icons.palette_outlined;
    }
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
