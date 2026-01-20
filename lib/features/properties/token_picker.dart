import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for selecting a design token from available tokens.
///
/// Filters tokens by [compatibleType] to show only applicable tokens.
class TokenPicker extends ConsumerWidget {
  /// Creates a token picker.
  const TokenPicker({
    required this.compatibleType,
    required this.onTokenSelected,
    this.selectedTokenName,
    super.key,
  });

  /// The type of tokens to show (only matching tokens are displayed).
  final TokenType compatibleType;

  /// Callback when a token is selected.
  final void Function(DesignToken token) onTokenSelected;

  /// Currently selected token name (for highlighting).
  final String? selectedTokenName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(designTokensProvider);
    final filteredTokens =
        tokens.where((t) => t.type == compatibleType).toList();

    if (filteredTokens.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredTokens.length,
      itemBuilder: (context, index) {
        final token = filteredTokens[index];
        final isSelected = token.name == selectedTokenName;

        return _TokenListTile(
          token: token,
          isSelected: isSelected,
          onTap: () => onTokenSelected(token),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final typeLabel = _getTypeLabel(compatibleType);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'No $typeLabel tokens',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Create tokens in the Design System panel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(TokenType type) {
    switch (type) {
      case TokenType.color:
        return 'color';
      case TokenType.typography:
        return 'typography';
      case TokenType.spacing:
        return 'spacing';
      case TokenType.radius:
        return 'radius';
    }
  }
}

/// List tile displaying a single token option.
class _TokenListTile extends StatelessWidget {
  const _TokenListTile({
    required this.token,
    required this.isSelected,
    required this.onTap,
  });

  final DesignToken token;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      selected: isSelected,
      leading: _buildPreview(context),
      title: Text(
        token.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: _buildSubtitle(context),
      onTap: onTap,
      trailing: isSelected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
    );
  }

  Widget _buildPreview(BuildContext context) {
    switch (token.type) {
      case TokenType.color:
        final colorValue = token.lightValue as int?;
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colorValue != null ? Color(colorValue) : Colors.transparent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
        );

      case TokenType.typography:
        return const Icon(Icons.text_fields, size: 24);

      case TokenType.spacing:
        return const Icon(Icons.space_bar, size: 24);

      case TokenType.radius:
        return const Icon(Icons.rounded_corner, size: 24);
    }
  }

  Widget? _buildSubtitle(BuildContext context) {
    final theme = Theme.of(context);
    String? text;

    switch (token.type) {
      case TokenType.color:
        final colorValue = token.lightValue as int?;
        if (colorValue != null) {
          final hex =
              colorValue.toRadixString(16).toUpperCase().padLeft(8, '0');
          text = '#$hex';
        }

      case TokenType.typography:
        final typography = token.typographyValue;
        if (typography != null) {
          text = '${typography.fontSize}px, ${typography.fontWeight}';
        }

      case TokenType.spacing:
        final value = token.spacingValue;
        if (value != null) {
          text = '${value}px';
        }

      case TokenType.radius:
        final value = token.radiusValue;
        if (value != null) {
          text = '${value}px';
        }
    }

    if (text == null) return null;

    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontFamily: 'monospace',
      ),
    );
  }
}

/// Dialog for selecting a token.
class TokenPickerDialog extends StatelessWidget {
  /// Creates a token picker dialog.
  const TokenPickerDialog({
    required this.compatibleType,
    this.selectedTokenName,
    super.key,
  });

  /// The type of tokens to show.
  final TokenType compatibleType;

  /// Currently selected token name.
  final String? selectedTokenName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,
          maxHeight: 400,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Token',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Divider(),
              Expanded(
                child: TokenPicker(
                  compatibleType: compatibleType,
                  selectedTokenName: selectedTokenName,
                  onTokenSelected: (token) => Navigator.of(context).pop(token),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the token picker dialog and returns the selected token.
  static Future<DesignToken?> show(
    BuildContext context, {
    required TokenType compatibleType,
    String? selectedTokenName,
  }) {
    return showDialog<DesignToken>(
      context: context,
      builder: (context) => TokenPickerDialog(
        compatibleType: compatibleType,
        selectedTokenName: selectedTokenName,
      ),
    );
  }
}
