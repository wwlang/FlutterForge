import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shortcuts/keyboard_shortcuts.dart';

/// Overlay showing all keyboard shortcuts organized by category.
///
/// Features:
/// - All shortcuts grouped by category
/// - Search/filter functionality
/// - Platform-appropriate key display
/// - Escape to close
///
/// Journey: J18 S3 - Keyboard Shortcut Reference
class ShortcutReferenceOverlay extends ConsumerStatefulWidget {
  const ShortcutReferenceOverlay({
    super.key,
    this.onClose,
  });

  /// Called when the overlay is closed.
  final VoidCallback? onClose;

  @override
  ConsumerState<ShortcutReferenceOverlay> createState() =>
      _ShortcutReferenceOverlayState();
}

class _ShortcutReferenceOverlayState
    extends ConsumerState<ShortcutReferenceOverlay> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleClose() {
    widget.onClose?.call();
  }

  List<ShortcutDefinition> _getFilteredShortcuts(ShortcutCategory category) {
    final shortcuts = ShortcutsRegistry.getByCategory(category);
    if (_searchQuery.isEmpty) return shortcuts;

    return shortcuts
        .where((s) =>
            s.label.toLowerCase().contains(_searchQuery) ||
            (s.description?.toLowerCase().contains(_searchQuery) ?? false))
        .toList();
  }

  bool _hasCategoryResults(ShortcutCategory category) {
    return _getFilteredShortcuts(category).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final platform = Theme.of(context).platform;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _handleClose();
        }
      },
      child: Material(
        color: colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Keyboard Shortcuts',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _handleClose,
                    icon: const Icon(Icons.close),
                    tooltip: 'Close (Esc)',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search shortcuts...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 24),

              // Shortcut list
              Expanded(
                child: ListView(
                  children: [
                    for (final category in ShortcutCategory.values)
                      if (_hasCategoryResults(category)) ...[
                        _CategoryHeader(category: category),
                        const SizedBox(height: 8),
                        for (final shortcut in _getFilteredShortcuts(category))
                          ShortcutItem(
                            shortcut: shortcut,
                            platform: platform,
                            searchQuery: _searchQuery,
                          ),
                        const SizedBox(height: 24),
                      ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header for a shortcut category.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});

  final ShortcutCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      category.displayName,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
    );
  }
}

/// A single shortcut item in the reference list.
class ShortcutItem extends StatelessWidget {
  const ShortcutItem({
    super.key,
    required this.shortcut,
    this.platform,
    this.searchQuery = '',
  });

  final ShortcutDefinition shortcut;
  final TargetPlatform? platform;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectivePlatform = platform ?? Theme.of(context).platform;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortcut.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (shortcut.description != null)
                  Text(
                    shortcut.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              shortcut.getDisplayString(effectivePlatform),
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tooltip showing property help information.
///
/// Journey: J18 S4 - Contextual Help
class PropertyHelpTooltip extends StatelessWidget {
  const PropertyHelpTooltip({
    super.key,
    required this.propertyName,
    required this.description,
    required this.type,
    this.learnMoreUrl,
  });

  final String propertyName;
  final String description;
  final String type;
  final String? learnMoreUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            propertyName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onInverseSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onInverseSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.onInverseSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onInverseSurface.withOpacity(0.8),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              if (learnMoreUrl != null) ...[
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onInverseSurface,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Learn more',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Tooltip showing widget help information.
///
/// Journey: J18 S4 - Contextual Help
class WidgetHelpTooltip extends StatelessWidget {
  const WidgetHelpTooltip({
    super.key,
    required this.widgetName,
    required this.description,
    required this.category,
  });

  final String widgetName;
  final String description;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widgetName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onInverseSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onInverseSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.onInverseSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              category,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onInverseSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Links to external documentation.
///
/// Journey: J18 S5 - Documentation Links
class HelpLinks {
  HelpLinks._();

  /// Main FlutterForge documentation URL.
  static const String documentation = 'https://flutterforge.dev/docs';

  /// GitHub issues URL for reporting problems.
  static const String reportIssue =
      'https://github.com/flutterforge/flutterforge/issues/new';

  /// Builds a URL to widget-specific documentation.
  static String widgetDocumentation(String widgetType) =>
      'https://flutterforge.dev/docs/widgets/$widgetType';

  /// Builds a URL to Flutter API docs for a widget.
  static String flutterApiDocs(String widgetClass) =>
      'https://api.flutter.dev/flutter/widgets/$widgetClass-class.html';
}
