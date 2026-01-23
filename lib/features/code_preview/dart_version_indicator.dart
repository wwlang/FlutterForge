import 'package:flutter/material.dart';
import 'package:flutter_forge/features/code_preview/code_preview_settings.dart';
import 'package:flutter_forge/providers/code_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Indicator showing current Dart version target (J19 S3).
///
/// Displays the target Dart version in the code preview panel
/// and provides a dropdown to change it.
class DartVersionIndicator extends ConsumerWidget {
  /// Creates a Dart version indicator.
  const DartVersionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(codeSettingsProvider);
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showVersionMenu(context, ref, settings),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.code,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              settings.dartVersion.shortName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showVersionMenu(
    BuildContext context,
    WidgetRef ref,
    CodeSettings settings,
  ) {
    final theme = Theme.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      constraints: const BoxConstraints(minWidth: 280),
      items: [
        // Version options
        for (final version in DartVersion.values)
          PopupMenuItem<void>(
            onTap: () =>
                ref.read(codeSettingsProvider.notifier).setDartVersion(version),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.dartVersion == version)
                  const Icon(Icons.check, size: 16)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    version.displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        const PopupMenuDivider(),
        // Shorthand toggle (only for 3.10+)
        PopupMenuItem<void>(
          enabled: settings.dartVersion.supportsShorthand,
          onTap: settings.dartVersion.supportsShorthand
              ? () => ref
                  .read(codeSettingsProvider.notifier)
                  .setDotShorthand(enabled: !settings.useDotShorthand)
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 24),
              Flexible(
                child: Text(
                  'Use dot shorthand',
                  style: settings.dartVersion.supportsShorthand
                      ? null
                      : TextStyle(color: theme.colorScheme.outline),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 24,
                child: FittedBox(
                  child: Switch(
                    value: settings.useDotShorthand,
                    onChanged: settings.dartVersion.supportsShorthand
                        ? (value) => ref
                            .read(codeSettingsProvider.notifier)
                            .setDotShorthand(enabled: value)
                        : null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
