import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/token_form.dart';
import 'package:flutter_forge/features/design_system/token_list_item.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Panel for managing design tokens (colors, typography, spacing, radii).
class DesignSystemPanel extends ConsumerStatefulWidget {
  const DesignSystemPanel({super.key});

  @override
  ConsumerState<DesignSystemPanel> createState() => _DesignSystemPanelState();
}

class _DesignSystemPanelState extends ConsumerState<DesignSystemPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DesignToken? _editingToken;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _showForm = false;
          _editingToken = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TokenType get _currentTokenType {
    switch (_tabController.index) {
      case 0:
        return TokenType.color;
      case 1:
        return TokenType.typography;
      case 2:
        return TokenType.spacing;
      case 3:
        return TokenType.radius;
      default:
        return TokenType.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Colors'),
            Tab(text: 'Typography'),
            Tab(text: 'Spacing'),
            Tab(text: 'Radii'),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _showForm
              ? _buildForm()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTokenList(TokenType.color, 'color_tokens_list'),
                    _buildTokenList(
                      TokenType.typography,
                      'typography_tokens_list',
                    ),
                    _buildTokenList(TokenType.spacing, 'spacing_tokens_list'),
                    _buildTokenList(TokenType.radius, 'radius_tokens_list'),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Text(
        'Design System',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTokenList(TokenType type, String listKey) {
    final tokens = ref.watch(designTokensProvider);
    final filteredTokens = tokens.where((t) => t.type == type).toList();

    if (filteredTokens.isEmpty) {
      return _buildEmptyState(type);
    }

    return Column(
      key: Key(listKey),
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredTokens.length,
            itemBuilder: (context, index) {
              final token = filteredTokens[index];
              return TokenListItem(
                key: Key('token_item_${token.id}'),
                token: token,
                onTap: () => _onEditToken(token),
                onDelete: () => _onDeleteToken(token),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _onAddToken,
            icon: const Icon(Icons.add),
            label: const Text('Add Token'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(TokenType type) {
    final theme = Theme.of(context);
    final (icon, message) = _getEmptyStateContent(type);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onAddToken,
            icon: const Icon(Icons.add),
            label: const Text('Add Token'),
          ),
        ],
      ),
    );
  }

  (IconData, String) _getEmptyStateContent(TokenType type) {
    switch (type) {
      case TokenType.color:
        return (Icons.palette_outlined, 'No color tokens');
      case TokenType.typography:
        return (Icons.text_fields_outlined, 'No typography tokens');
      case TokenType.spacing:
        return (Icons.space_bar_outlined, 'No spacing tokens');
      case TokenType.radius:
        return (Icons.rounded_corner_outlined, 'No radius tokens');
    }
  }

  Widget _buildForm() {
    return TokenForm(
      key: const Key('token_form'),
      tokenType: _currentTokenType,
      existingToken: _editingToken,
      onSave: _onSaveToken,
      onCancel: _onCancelForm,
    );
  }

  void _onAddToken() {
    setState(() {
      _editingToken = null;
      _showForm = true;
    });
  }

  void _onEditToken(DesignToken token) {
    setState(() {
      _editingToken = token;
      _showForm = true;
    });
  }

  void _onDeleteToken(DesignToken token) {
    final tokens = ref.read(designTokensProvider);
    final hasAliases = tokens.any((t) => t.aliasOf == token.name);

    if (hasAliases) {
      _showDeleteConfirmation(token);
    } else {
      ref.read(designTokensProvider.notifier).deleteToken(token.id);
    }
  }

  Future<void> _showDeleteConfirmation(DesignToken token) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Token has aliases'),
        content: Text(
          'The token "${token.name}" is referenced by alias tokens. '
          'Deleting it will break those references. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      ref.read(designTokensProvider.notifier).deleteToken(token.id);
    }
  }

  void _onSaveToken(DesignToken token) {
    final notifier = ref.read(designTokensProvider.notifier);

    if (_editingToken != null) {
      notifier.updateToken(token);
    } else {
      notifier.addToken(token);
    }

    setState(() {
      _showForm = false;
      _editingToken = null;
    });
  }

  void _onCancelForm() {
    setState(() {
      _showForm = false;
      _editingToken = null;
    });
  }
}
