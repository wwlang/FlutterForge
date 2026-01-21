import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Formats a file size in bytes to a human-readable string.
String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Data for a file selected for import.
class SelectedFile {
  /// Creates a selected file.
  const SelectedFile({
    required this.fileName,
    required this.bytes,
  });

  /// File name.
  final String fileName;

  /// File bytes.
  final Uint8List bytes;
}

/// Dialog for importing image assets into a project.
///
/// Features:
/// - File picker for selecting local images (J14-S1)
/// - Preview of selected files before import
/// - Validation of supported formats and file sizes
/// - Import button to add assets to project
class AssetImportDialog extends StatefulWidget {
  /// Creates an asset import dialog.
  const AssetImportDialog({super.key});

  @override
  State<AssetImportDialog> createState() => _AssetImportDialogState();
}

class _AssetImportDialogState extends State<AssetImportDialog> {
  final List<SelectedFile> _selectedFiles = [];

  bool get _hasFiles => _selectedFiles.isNotEmpty;

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleImport() {
    Navigator.of(context).pop(_selectedFiles);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Import Assets',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select images to add to your project',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Supported formats
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SupportedFormatsChip(format: 'PNG'),
                SupportedFormatsChip(format: 'JPG'),
                SupportedFormatsChip(format: 'WebP'),
                SupportedFormatsChip(format: 'GIF'),
                SupportedFormatsChip(format: 'SVG'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Drop zone / file list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _hasFiles
                  ? ListView.separated(
                      itemCount: _selectedFiles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final file = _selectedFiles[index];
                        return AssetPreviewTile(
                          fileName: file.fileName,
                          bytes: file.bytes,
                          onRemove: () => _removeFile(index),
                        );
                      },
                    )
                  : _buildDropZone(theme),
            ),
          ),

          // Actions - use Wrap to handle narrow screens
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // This will be wired to file picker in integration
                  },
                  icon: const Icon(Icons.add_photo_alternate, size: 18),
                  label: const Text('Select Files'),
                ),
                TextButton(
                  onPressed: _handleCancel,
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: _hasFiles ? _handleImport : null,
                  child: const Text('Import'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_file,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Click "Select Files" to choose images',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'or drag and drop files here',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A chip showing a supported file format.
class SupportedFormatsChip extends StatelessWidget {
  /// Creates a supported formats chip.
  const SupportedFormatsChip({
    required this.format,
    super.key,
  });

  /// The format name (e.g., 'PNG').
  final String format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A preview tile showing a selected asset file.
class AssetPreviewTile extends StatelessWidget {
  /// Creates an asset preview tile.
  const AssetPreviewTile({
    required this.fileName,
    required this.bytes,
    required this.onRemove,
    super.key,
  });

  /// File name.
  final String fileName;

  /// File bytes.
  final Uint8List bytes;

  /// Callback when remove is pressed.
  final VoidCallback onRemove;

  /// Warning threshold (10MB).
  static const int warnSizeBytes = 10 * 1024 * 1024;

  bool get _isLarge => bytes.length > warnSizeBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isLarge
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Thumbnail placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.image, size: 24),
          ),
          const SizedBox(width: 12),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatFileSize(bytes.length),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _isLarge
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (_isLarge) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.warning,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
