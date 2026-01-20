import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';

/// List item widget displaying a design token.
class TokenListItem extends StatelessWidget {
  const TokenListItem({
    required this.token,
    required this.onTap,
    required this.onDelete,
    this.isDeepChain = false,
    super.key,
  });

  final DesignToken token;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  /// Whether this token has a deep alias chain (>3 levels).
  final bool isDeepChain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildPreview(theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDeepChain)
                Padding(
                  key: Key('deep_chain_warning_${token.name}'),
                  padding: const EdgeInsets.only(right: 8),
                  child: Tooltip(
                    message: 'Deep alias chain (>3 levels)',
                    child: Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              if (token.isAlias)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.link,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                onPressed: onDelete,
                tooltip: 'Delete token',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    switch (token.type) {
      case TokenType.color:
        return _buildColorPreview();
      case TokenType.typography:
        return _buildTypographyPreview(theme);
      case TokenType.spacing:
        return _buildSpacingPreview(theme);
      case TokenType.radius:
        return _buildRadiusPreview(theme);
    }
  }

  Widget _buildColorPreview() {
    final lightColor = token.lightValue != null
        ? Color(token.lightValue as int)
        : Colors.transparent;

    return Container(
      key: Key('token_preview_${token.id}'),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildTypographyPreview(ThemeData theme) {
    final typo = token.typographyValue;
    return Container(
      key: Key('token_preview_${token.id}'),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Aa',
        style: TextStyle(
          fontFamily: typo?.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.values[(typo?.fontWeight ?? 400) ~/ 100 - 1],
        ),
      ),
    );
  }

  Widget _buildSpacingPreview(ThemeData theme) {
    final value = token.spacingValue ?? 0;
    final normalizedWidth = (value / 48).clamp(0.1, 1.0) * 24;

    return Container(
      key: Key('token_preview_${token.id}'),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: normalizedWidth,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildRadiusPreview(ThemeData theme) {
    final value = token.radiusValue ?? 0;

    return Container(
      key: Key('token_preview_${token.id}'),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(value.clamp(0, 10)),
        ),
      ),
    );
  }

  String _getSubtitle() {
    if (token.isAlias) {
      return 'Alias of ${token.aliasOf}';
    }

    switch (token.type) {
      case TokenType.color:
        final hex = (token.lightValue as int?)
                ?.toRadixString(16)
                .toUpperCase()
                .padLeft(8, '0') ??
            'N/A';
        return '#$hex';
      case TokenType.typography:
        final typo = token.typographyValue;
        if (typo == null) return 'N/A';
        final family = typo.fontFamily ?? 'System';
        return '$family, ${typo.fontSize.toInt()}px';
      case TokenType.spacing:
        return '${token.spacingValue?.toInt() ?? 0}';
      case TokenType.radius:
        return '${token.radiusValue?.toInt() ?? 0}';
    }
  }
}
