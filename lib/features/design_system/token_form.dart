import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/color_picker_dialog.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Form for creating or editing design tokens.
class TokenForm extends ConsumerStatefulWidget {
  const TokenForm({
    required this.tokenType,
    required this.onSave,
    required this.onCancel,
    this.existingToken,
    super.key,
  });

  final TokenType tokenType;
  final DesignToken? existingToken;
  final void Function(DesignToken token) onSave;
  final VoidCallback onCancel;

  @override
  ConsumerState<TokenForm> createState() => _TokenFormState();
}

class _TokenFormState extends ConsumerState<TokenForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _lightValueController;
  late TextEditingController _darkValueController;
  late TextEditingController _fontFamilyController;
  late TextEditingController _fontSizeController;
  late TextEditingController _fontWeightController;
  late TextEditingController _lineHeightController;
  late TextEditingController _valueController;

  String? _nameError;
  String? _lightValueError;
  String? _valueError;
  String? _nameSuggestion;
  String? _aliasError;

  bool _isAlias = false;
  String? _aliasTarget;

  bool get _isEditing => widget.existingToken != null;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final existing = widget.existingToken;

    _nameController = TextEditingController(text: existing?.name ?? '');
    _nameController.addListener(_onNameChanged);

    // Check if existing is an alias
    _isAlias = existing?.isAlias ?? false;
    _aliasTarget = existing?.aliasOf;

    // Color fields
    _lightValueController = TextEditingController(
      text: existing?.lightValue != null && !(existing?.isAlias ?? false)
          ? (existing!.lightValue as int)
              .toRadixString(16)
              .toUpperCase()
              .padLeft(8, '0')
          : '',
    );
    _darkValueController = TextEditingController(
      text: existing?.darkValue != null && !(existing?.isAlias ?? false)
          ? (existing!.darkValue as int)
              .toRadixString(16)
              .toUpperCase()
              .padLeft(8, '0')
          : '',
    );

    // Typography fields
    _fontFamilyController = TextEditingController(
      text: existing?.typographyValue?.fontFamily ?? '',
    );
    _fontSizeController = TextEditingController(
      text: existing?.typographyValue?.fontSize.toString() ?? '14',
    );
    _fontWeightController = TextEditingController(
      text: existing?.typographyValue?.fontWeight.toString() ?? '400',
    );
    _lineHeightController = TextEditingController(
      text: existing?.typographyValue?.lineHeight.toString() ?? '1.5',
    );

    // Numeric value fields
    _valueController = TextEditingController(
      text: _getNumericValue(existing)?.toString() ?? '',
    );
  }

  double? _getNumericValue(DesignToken? token) {
    if (token == null || token.isAlias) return null;
    switch (token.type) {
      case TokenType.spacing:
        return token.spacingValue;
      case TokenType.radius:
        return token.radiusValue;
      case TokenType.color:
      case TokenType.typography:
        return null;
    }
  }

  void _onNameChanged() {
    final name = _nameController.text;
    if (name.isNotEmpty && !DesignToken.isValidName(name)) {
      final suggestion = DesignToken.suggestValidName(name);
      if (suggestion != name) {
        setState(() => _nameSuggestion = suggestion);
      }
    } else {
      setState(() => _nameSuggestion = null);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lightValueController.dispose();
    _darkValueController.dispose();
    _fontFamilyController.dispose();
    _fontSizeController.dispose();
    _fontWeightController.dispose();
    _lineHeightController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Token' : 'New Token',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildAliasToggle(),
            const SizedBox(height: 16),
            if (_isAlias) ...[
              _buildAliasTargetSelector(),
              if (_isEditing && (widget.existingToken?.isAlias ?? false)) ...[
                const SizedBox(height: 16),
                _buildAliasChainVisualization(),
                const SizedBox(height: 16),
                _buildConvertToValueButton(),
              ],
            ] else
              ..._buildTypeSpecificFields(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Token Name'),
        const SizedBox(height: 4),
        TextField(
          key: const Key('token_name_field'),
          controller: _nameController,
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: 'e.g., primaryColor',
            errorText: _nameError,
          ),
        ),
        if (_nameSuggestion != null) ...[
          const SizedBox(height: 4),
          Text(
            'Suggestion: $_nameSuggestion',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildAliasToggle() {
    return Row(
      children: [
        Switch(
          key: const Key('alias_toggle'),
          value: _isAlias,
          onChanged: (value) {
            setState(() {
              _isAlias = value;
              _aliasTarget = null;
              _aliasError = null;
            });
          },
        ),
        const SizedBox(width: 8),
        const Text('Create as Alias'),
      ],
    );
  }

  Widget _buildAliasTargetSelector() {
    final notifier = ref.read(designTokensProvider.notifier);
    final tokens = notifier.getTokensByType(widget.tokenType);

    // Filter out the current token (if editing) and circular refs
    final availableTokens = tokens.where((t) {
      if (_isEditing && t.id == widget.existingToken!.id) return false;
      // Check if selecting this would create circular reference
      if (_isEditing &&
          notifier.wouldCreateCircularAlias(
            widget.existingToken!.id,
            t.name,
          )) {
        return false;
      }
      return true;
    }).toList();

    // Check for circular reference warnings
    final circularWarnings = <String, bool>{};
    if (_isEditing) {
      for (final t in tokens) {
        if (t.id != widget.existingToken!.id) {
          circularWarnings[t.name] = notifier.wouldCreateCircularAlias(
            widget.existingToken!.id,
            t.name,
          );
        }
      }
    }

    if (availableTokens.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('No tokens available to alias'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alias Target'),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          key: const Key('alias_target_dropdown'),
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            errorText: _aliasError,
          ),
          initialValue: _aliasTarget,
          hint: const Text('Select token to alias'),
          items: [
            ...availableTokens.map((t) {
              return DropdownMenuItem(
                value: t.name,
                child: Text(t.name),
              );
            }),
            // Show disabled items with warning for circular references
            ...tokens.where((t) {
              if (_isEditing) {
                return t.id != widget.existingToken!.id &&
                    (circularWarnings[t.name] ?? false);
              }
              return false;
            }).map((t) {
              return DropdownMenuItem(
                value: t.name,
                enabled: false,
                child: Row(
                  children: [
                    Text(
                      t.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _aliasTarget = value;
              _aliasError = null;
            });
          },
        ),
        if (_isEditing && circularWarnings.values.any((v) => v)) ...[
          const SizedBox(height: 4),
          Text(
            'Would create circular reference',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildAliasChainVisualization() {
    if (!_isEditing || widget.existingToken == null) return const SizedBox();

    final notifier = ref.read(designTokensProvider.notifier);
    final chain = notifier.getAliasChain(widget.existingToken!.id);
    final isDeepChain = notifier.isDeepAliasChain(widget.existingToken!.id);

    if (chain.isEmpty) return const SizedBox();

    return Container(
      key: const Key('alias_chain_visualization'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: isDeepChain
            ? Border.all(color: Theme.of(context).colorScheme.error)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link, size: 16),
              const SizedBox(width: 8),
              Text(
                'Alias Chain',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (isDeepChain) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.warning,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 4),
                Text(
                  'Deep chain',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (int i = 0; i < chain.length; i++) ...[
                Chip(
                  label: Text(chain[i].name),
                  backgroundColor: chain[i].isAlias
                      ? null
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
                if (i < chain.length - 1)
                  const Icon(Icons.arrow_forward, size: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConvertToValueButton() {
    return OutlinedButton.icon(
      onPressed: _onConvertToValue,
      icon: const Icon(Icons.link_off),
      label: const Text('Convert to Value'),
    );
  }

  void _onConvertToValue() {
    if (widget.existingToken == null || !widget.existingToken!.isAlias) return;

    final notifier = ref.read(designTokensProvider.notifier);
    final resolved = notifier.resolveToken(widget.existingToken!.id);

    if (resolved == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not resolve alias value')),
      );
      return;
    }

    // Create a new token with the resolved value
    final converted = switch (widget.tokenType) {
      TokenType.color => DesignToken.color(
          id: widget.existingToken!.id,
          name: widget.existingToken!.name,
          lightValue: resolved.lightValue as int,
          darkValue: resolved.darkValue as int? ?? resolved.lightValue as int,
        ),
      TokenType.typography => DesignToken.typography(
          id: widget.existingToken!.id,
          name: widget.existingToken!.name,
          fontFamily: resolved.typographyValue!.fontFamily,
          fontSize: resolved.typographyValue!.fontSize,
          fontWeight: resolved.typographyValue!.fontWeight,
          lineHeight: resolved.typographyValue!.lineHeight,
          letterSpacing: resolved.typographyValue!.letterSpacing,
        ),
      TokenType.spacing => DesignToken.spacing(
          id: widget.existingToken!.id,
          name: widget.existingToken!.name,
          value: resolved.spacingValue!,
        ),
      TokenType.radius => DesignToken.radius(
          id: widget.existingToken!.id,
          name: widget.existingToken!.name,
          value: resolved.radiusValue!,
        ),
    };

    widget.onSave(converted);
  }

  List<Widget> _buildTypeSpecificFields() {
    return switch (widget.tokenType) {
      TokenType.color => _buildColorFields(),
      TokenType.typography => _buildTypographyFields(),
      TokenType.spacing => _buildSpacingFields(),
      TokenType.radius => _buildRadiusFields(),
    };
  }

  List<Widget> _buildColorFields() {
    return [
      _buildColorField(
        label: 'Light Value',
        controller: _lightValueController,
        fieldKey: 'light_value_field',
        error: _lightValueError,
      ),
      const SizedBox(height: 16),
      _buildColorField(
        label: 'Dark Value',
        controller: _darkValueController,
        fieldKey: 'dark_value_field',
      ),
      const SizedBox(height: 16),
      _buildColorPicker(),
    ];
  }

  Widget _buildColorField({
    required String label,
    required TextEditingController controller,
    required String fieldKey,
    String? error,
  }) {
    final color = _parseColor(controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              key: fieldKey == 'light_value_field'
                  ? const Key('color_preview')
                  : null,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color ?? Colors.transparent,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: Key(fieldKey),
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  hintText: 'AARRGGBB',
                  errorText: error,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9A-Fa-f]')),
                  LengthLimitingTextInputFormatter(8),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return InkWell(
      key: const Key('color_picker'),
      onTap: _showColorPickerDialog,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.colorize, color: Colors.grey.shade600, size: 18),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Pick Color',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showColorPickerDialog() async {
    final currentColor = _parseColor(_lightValueController.text);

    final result = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(
        key: const Key('color_picker_dialog'),
        initialColor: currentColor ?? Colors.blue,
      ),
    );

    if (result != null) {
      // ignore: use_build_context_synchronously
      setState(() {
        // Using raw uint32 value
        final hexValue = result.toARGB32().toRadixString(16).padLeft(8, '0');
        _lightValueController.text = hexValue.toUpperCase();
      });
    }
  }

  Color? _parseColor(String hex) {
    if (hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '').replaceAll('0x', '');
    if (cleaned.length != 8) return null;
    final value = int.tryParse(cleaned, radix: 16);
    return value != null ? Color(value) : null;
  }

  List<Widget> _buildTypographyFields() {
    return [
      _buildTextField(
        label: 'Font Family',
        controller: _fontFamilyController,
        fieldKey: 'font_family_field',
        hintText: 'e.g., Roboto',
      ),
      const SizedBox(height: 16),
      _buildTextField(
        label: 'Font Size',
        controller: _fontSizeController,
        fieldKey: 'font_size_field',
        hintText: '14',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      _buildFontWeightField(),
      const SizedBox(height: 16),
      _buildTextField(
        label: 'Line Height',
        controller: _lineHeightController,
        fieldKey: 'line_height_field',
        hintText: '1.5',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    ];
  }

  Widget _buildFontWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font Weight'),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          key: const Key('font_weight_field'),
          isExpanded: true, // Prevent overflow
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: '100', child: Text('100')),
            DropdownMenuItem(value: '200', child: Text('200')),
            DropdownMenuItem(value: '300', child: Text('300')),
            DropdownMenuItem(value: '400', child: Text('400')),
            DropdownMenuItem(value: '500', child: Text('500')),
            DropdownMenuItem(value: '600', child: Text('600')),
            DropdownMenuItem(value: '700', child: Text('700')),
            DropdownMenuItem(value: '800', child: Text('800')),
            DropdownMenuItem(value: '900', child: Text('900')),
          ],
          initialValue: _fontWeightController.text.isEmpty
              ? '400'
              : _fontWeightController.text,
          onChanged: (value) {
            if (value != null) {
              _fontWeightController.text = value;
            }
          },
        ),
      ],
    );
  }

  List<Widget> _buildSpacingFields() {
    return [
      _buildTextField(
        label: 'Value',
        controller: _valueController,
        fieldKey: 'value_field',
        hintText: '16',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        error: _valueError,
      ),
      const SizedBox(height: 16),
      _buildSpacingPreview(),
    ];
  }

  Widget _buildSpacingPreview() {
    final value = double.tryParse(_valueController.text) ?? 0;
    final displayValue = value.clamp(0.0, 100.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preview'),
        const SizedBox(height: 8),
        Container(
          key: const Key('spacing_preview'),
          width: double.infinity,
          height: 32,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            width: displayValue,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRadiusFields() {
    return [
      _buildTextField(
        label: 'Value',
        controller: _valueController,
        fieldKey: 'value_field',
        hintText: '8',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        error: _valueError,
      ),
      const SizedBox(height: 16),
      _buildRadiusPreview(),
    ];
  }

  Widget _buildRadiusPreview() {
    final value = double.tryParse(_valueController.text) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preview'),
        const SizedBox(height: 8),
        Container(
          key: const Key('radius_preview'),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(value.clamp(0.0, 32.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String fieldKey,
    String? hintText,
    TextInputType? keyboardType,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextField(
          key: Key(fieldKey),
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: hintText,
            errorText: error,
          ),
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _onSubmit,
          child: Text(_isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  void _onSubmit() {
    // Clear errors
    setState(() {
      _nameError = null;
      _lightValueError = null;
      _valueError = null;
      _aliasError = null;
    });

    // Validate
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Name is required');
      return;
    }
    if (!DesignToken.isValidName(name)) {
      setState(() => _nameError = 'Name must be in camelCase');
      return;
    }

    // Alias validation
    if (_isAlias) {
      if (_aliasTarget == null) {
        setState(() => _aliasError = 'Select a token to alias');
        return;
      }

      // Check for circular reference
      if (_isEditing) {
        final notifier = ref.read(designTokensProvider.notifier);
        if (notifier.wouldCreateCircularAlias(
          widget.existingToken!.id,
          _aliasTarget!,
        )) {
          setState(
            () => _aliasError = 'This would create a circular reference',
          );
          return;
        }
      }

      final token = DesignToken.alias(
        id: widget.existingToken?.id ?? const Uuid().v4(),
        name: name,
        type: widget.tokenType,
        aliasOf: _aliasTarget!,
      );
      widget.onSave(token);
      return;
    }

    // Type-specific validation and token creation
    DesignToken? token;
    try {
      token = _createToken(name);
    } catch (e) {
      return; // Validation error already set
    }

    if (token != null) {
      widget.onSave(token);
    }
  }

  DesignToken? _createToken(String name) {
    final id = widget.existingToken?.id ?? const Uuid().v4();

    return switch (widget.tokenType) {
      TokenType.color => _createColorToken(id, name),
      TokenType.typography => _createTypographyToken(id, name),
      TokenType.spacing => _createSpacingToken(id, name),
      TokenType.radius => _createRadiusToken(id, name),
    };
  }

  DesignToken _createColorToken(String id, String name) {
    final lightHex = _lightValueController.text.trim();
    if (lightHex.isEmpty) {
      setState(() => _lightValueError = 'Light value is required');
      throw Exception('Validation failed');
    }
    final lightValue = int.tryParse(lightHex, radix: 16);
    if (lightValue == null) {
      setState(() => _lightValueError = 'Invalid color value');
      throw Exception('Validation failed');
    }

    final darkHex = _darkValueController.text.trim();
    final darkValue =
        darkHex.isNotEmpty ? int.tryParse(darkHex, radix: 16) : lightValue;

    return DesignToken.color(
      id: id,
      name: name,
      lightValue: lightValue,
      darkValue: darkValue,
    );
  }

  DesignToken _createTypographyToken(String id, String name) {
    final fontSize = double.tryParse(_fontSizeController.text) ?? 14.0;
    final fontWeight = int.tryParse(_fontWeightController.text) ?? 400;
    final lineHeight = double.tryParse(_lineHeightController.text) ?? 1.5;

    return DesignToken.typography(
      id: id,
      name: name,
      fontFamily: _fontFamilyController.text.isNotEmpty
          ? _fontFamilyController.text
          : null,
      fontSize: fontSize,
      fontWeight: fontWeight,
      lineHeight: lineHeight,
    );
  }

  DesignToken _createSpacingToken(String id, String name) {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _valueError = 'Value is required');
      throw Exception('Validation failed');
    }
    if (value < 0) {
      setState(() => _valueError = 'Value must be positive');
      throw Exception('Validation failed');
    }

    return DesignToken.spacing(
      id: id,
      name: name,
      value: value,
    );
  }

  DesignToken _createRadiusToken(String id, String name) {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      setState(() => _valueError = 'Value is required');
      throw Exception('Validation failed');
    }
    if (value < 0) {
      setState(() => _valueError = 'Value must be positive');
      throw Exception('Validation failed');
    }

    return DesignToken.radius(
      id: id,
      name: name,
      value: value,
    );
  }
}
