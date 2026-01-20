import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/color_picker_dialog.dart';
import 'package:uuid/uuid.dart';

/// Form for creating or editing design tokens.
class TokenForm extends StatefulWidget {
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
  State<TokenForm> createState() => _TokenFormState();
}

class _TokenFormState extends State<TokenForm> {
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

    // Color fields
    _lightValueController = TextEditingController(
      text: existing?.lightValue != null
          ? (existing!.lightValue as int)
              .toRadixString(16)
              .toUpperCase()
              .padLeft(8, '0')
          : '',
    );
    _darkValueController = TextEditingController(
      text: existing?.darkValue != null
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
    if (token == null) return null;
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

  List<Widget> _buildTypeSpecificFields() {
    switch (widget.tokenType) {
      case TokenType.color:
        return _buildColorFields();
      case TokenType.typography:
        return _buildTypographyFields();
      case TokenType.spacing:
        return _buildSpacingFields();
      case TokenType.radius:
        return _buildRadiusFields();
    }
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
          children: [
            Icon(Icons.colorize, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              'Open Color Picker',
              style: TextStyle(color: Colors.grey.shade600),
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
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: '100', child: Text('100 - Thin')),
            DropdownMenuItem(value: '200', child: Text('200 - Extra Light')),
            DropdownMenuItem(value: '300', child: Text('300 - Light')),
            DropdownMenuItem(value: '400', child: Text('400 - Regular')),
            DropdownMenuItem(value: '500', child: Text('500 - Medium')),
            DropdownMenuItem(value: '600', child: Text('600 - Semi Bold')),
            DropdownMenuItem(value: '700', child: Text('700 - Bold')),
            DropdownMenuItem(value: '800', child: Text('800 - Extra Bold')),
            DropdownMenuItem(value: '900', child: Text('900 - Black')),
          ],
          initialValue: _fontWeightController.text,
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

    switch (widget.tokenType) {
      case TokenType.color:
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

      case TokenType.typography:
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

      case TokenType.spacing:
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

      case TokenType.radius:
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
}
