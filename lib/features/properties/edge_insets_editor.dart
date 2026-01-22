import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editing modes for EdgeInsets.
enum EdgeInsetsMode {
  /// Edit all sides at once.
  all,

  /// Edit horizontal and vertical pairs.
  symmetric,

  /// Edit each side individually.
  individual,
}

/// Editor widget for EdgeInsets properties.
///
/// Provides three modes:
/// - All: Sets all sides to the same value
/// - Symmetric: Sets horizontal (left/right) and vertical (top/bottom) pairs
/// - Individual: Sets each side independently
///
/// Journey: properties-panel.md Stage 4
class EdgeInsetsEditor extends StatefulWidget {
  /// Creates an EdgeInsets editor.
  const EdgeInsetsEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  /// Property key name.
  final String propertyName;

  /// Display label for the property.
  final String displayName;

  /// Current EdgeInsets value.
  final EdgeInsets? value;

  /// Callback when value changes.
  final void Function(EdgeInsets?) onChanged;

  /// Optional description/tooltip.
  final String? description;

  @override
  State<EdgeInsetsEditor> createState() => _EdgeInsetsEditorState();
}

class _EdgeInsetsEditorState extends State<EdgeInsetsEditor> {
  EdgeInsetsMode _mode = EdgeInsetsMode.individual;

  late TextEditingController _topController;
  late TextEditingController _rightController;
  late TextEditingController _bottomController;
  late TextEditingController _leftController;

  // For All mode
  late TextEditingController _allController;

  // For Symmetric mode
  late TextEditingController _horizontalController;
  late TextEditingController _verticalController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final value = widget.value ?? EdgeInsets.zero;

    _topController = TextEditingController(text: _formatValue(value.top));
    _rightController = TextEditingController(text: _formatValue(value.right));
    _bottomController = TextEditingController(text: _formatValue(value.bottom));
    _leftController = TextEditingController(text: _formatValue(value.left));

    // For All mode - use first value if all same, otherwise empty
    final allSame = value.top == value.right &&
        value.right == value.bottom &&
        value.bottom == value.left;
    _allController =
        TextEditingController(text: allSame ? _formatValue(value.top) : '');

    // For Symmetric mode
    _horizontalController =
        TextEditingController(text: _formatValue(value.left));
    _verticalController = TextEditingController(text: _formatValue(value.top));
  }

  @override
  void didUpdateWidget(EdgeInsetsEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    final value = widget.value ?? EdgeInsets.zero;

    _topController.text = _formatValue(value.top);
    _rightController.text = _formatValue(value.right);
    _bottomController.text = _formatValue(value.bottom);
    _leftController.text = _formatValue(value.left);

    final allSame = value.top == value.right &&
        value.right == value.bottom &&
        value.bottom == value.left;
    _allController.text = allSame ? _formatValue(value.top) : '';

    _horizontalController.text = _formatValue(value.left);
    _verticalController.text = _formatValue(value.top);
  }

  @override
  void dispose() {
    _topController.dispose();
    _rightController.dispose();
    _bottomController.dispose();
    _leftController.dispose();
    _allController.dispose();
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  double? _parseValue(String text) {
    if (text.isEmpty) return 0;
    return double.tryParse(text);
  }

  void _onAllChanged(String text) {
    final value = _parseValue(text);
    if (value != null) {
      widget.onChanged(EdgeInsets.all(value));
    }
  }

  void _onSymmetricChanged() {
    final horizontal = _parseValue(_horizontalController.text) ?? 0;
    final vertical = _parseValue(_verticalController.text) ?? 0;
    widget.onChanged(
      EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
    );
  }

  void _onIndividualChanged() {
    final top = _parseValue(_topController.text) ?? 0;
    final right = _parseValue(_rightController.text) ?? 0;
    final bottom = _parseValue(_bottomController.text) ?? 0;
    final left = _parseValue(_leftController.text) ?? 0;
    widget.onChanged(EdgeInsets.fromLTRB(left, top, right, bottom));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.displayName,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Mode toggle
        _buildModeToggle(theme),
        const SizedBox(height: 8),

        // Input fields based on mode
        _buildInputsForMode(),

        // Description
        if (widget.description != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.description!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModeToggle(ThemeData theme) {
    return SegmentedButton<EdgeInsetsMode>(
      segments: const [
        ButtonSegment(
          value: EdgeInsetsMode.all,
          label: Text('All'),
        ),
        ButtonSegment(
          value: EdgeInsetsMode.symmetric,
          label: Text('Symmetric'),
        ),
        ButtonSegment(
          value: EdgeInsetsMode.individual,
          label: Text('Individual'),
        ),
      ],
      selected: {_mode},
      onSelectionChanged: (selection) {
        setState(() {
          _mode = selection.first;
        });
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(theme.textTheme.labelSmall),
      ),
    );
  }

  Widget _buildInputsForMode() {
    switch (_mode) {
      case EdgeInsetsMode.all:
        return _buildAllModeInput();
      case EdgeInsetsMode.symmetric:
        return _buildSymmetricModeInputs();
      case EdgeInsetsMode.individual:
        return _buildIndividualModeInputs();
    }
  }

  Widget _buildAllModeInput() {
    return _buildSingleInput(
      controller: _allController,
      label: 'All',
      onSubmitted: _onAllChanged,
    );
  }

  Widget _buildSymmetricModeInputs() {
    return Row(
      children: [
        Expanded(
          child: _buildLabeledInput(
            controller: _horizontalController,
            label: 'H',
            onSubmitted: (_) => _onSymmetricChanged(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildLabeledInput(
            controller: _verticalController,
            label: 'V',
            onSubmitted: (_) => _onSymmetricChanged(),
          ),
        ),
      ],
    );
  }

  Widget _buildIndividualModeInputs() {
    return Column(
      children: [
        // Top
        _buildLabeledInput(
          controller: _topController,
          label: 'T',
          onSubmitted: (_) => _onIndividualChanged(),
        ),
        const SizedBox(height: 8),
        // Left and Right in row
        Row(
          children: [
            Expanded(
              child: _buildLabeledInput(
                controller: _leftController,
                label: 'L',
                onSubmitted: (_) => _onIndividualChanged(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLabeledInput(
                controller: _rightController,
                label: 'R',
                onSubmitted: (_) => _onIndividualChanged(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Bottom
        _buildLabeledInput(
          controller: _bottomController,
          label: 'B',
          onSubmitted: (_) => _onIndividualChanged(),
        ),
      ],
    );
  }

  Widget _buildSingleInput({
    required TextEditingController controller,
    required String label,
    required void Function(String) onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelText: label,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
      ],
      onSubmitted: onSubmitted,
      onEditingComplete: () => onSubmitted(controller.text),
    );
  }

  Widget _buildLabeledInput({
    required TextEditingController controller,
    required String label,
    required void Function(String) onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
          ],
          onSubmitted: onSubmitted,
          onEditingComplete: () => onSubmitted(controller.text),
        ),
      ],
    );
  }
}
