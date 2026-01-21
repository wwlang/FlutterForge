import 'package:flutter/material.dart';
import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds an image widget from an asset path.
///
/// Returns a placeholder if the asset is not found or path is null.
Widget buildImageFromAsset({
  required String? assetPath,
  required AssetManager assetManager,
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
}) {
  final effectiveWidth = width ?? 100.0;
  final effectiveHeight = height ?? 100.0;

  if (assetPath == null) {
    return _buildPlaceholder(
      width: effectiveWidth,
      height: effectiveHeight,
      icon: Icons.image,
    );
  }

  final asset = assetManager.getAssetByPath(assetPath);
  if (asset == null) {
    return _buildMissingPlaceholder(
      width: effectiveWidth,
      height: effectiveHeight,
    );
  }

  return SizedBox(
    width: effectiveWidth,
    height: effectiveHeight,
    child: Image.memory(
      asset.bytes,
      fit: fit,
      width: effectiveWidth,
      height: effectiveHeight,
      errorBuilder: (context, error, stackTrace) {
        return _buildMissingPlaceholder(
          width: effectiveWidth,
          height: effectiveHeight,
        );
      },
    ),
  );
}

Widget _buildPlaceholder({
  required double width,
  required double height,
  required IconData icon,
}) {
  return _ImagePlaceholder(
    width: width,
    height: height,
    icon: icon,
  );
}

Widget _buildMissingPlaceholder({
  required double width,
  required double height,
}) {
  return _ImagePlaceholder(
    width: width,
    height: height,
    icon: Icons.broken_image,
    isMissing: true,
  );
}

/// A preview widget that displays an image from the asset manager.
///
/// Shows:
/// - The actual image if asset exists
/// - A placeholder icon if no asset path is set
/// - A broken image icon if the asset is not found
class ImagePreview extends ConsumerWidget {
  /// Creates an image preview widget.
  const ImagePreview({
    required this.assetPath,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    super.key,
  });

  /// Path to the asset in the project.
  final String? assetPath;

  /// Width of the image preview.
  final double? width;

  /// Height of the image preview.
  final double? height;

  /// How the image should fit within its bounds.
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetManager = ref.watch(assetManagerProvider);
    final effectiveWidth = width ?? 100.0;
    final effectiveHeight = height ?? 100.0;

    if (assetPath == null) {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: _ImagePlaceholder(
          width: effectiveWidth,
          height: effectiveHeight,
          icon: Icons.image,
        ),
      );
    }

    final asset = assetManager.getAssetByPath(assetPath!);
    if (asset == null) {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: _ImagePlaceholder(
          width: effectiveWidth,
          height: effectiveHeight,
          icon: Icons.broken_image,
          isMissing: true,
        ),
      );
    }

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Image.memory(
        asset.bytes,
        fit: fit,
        width: effectiveWidth,
        height: effectiveHeight,
        errorBuilder: (context, error, stackTrace) {
          return _ImagePlaceholder(
            width: effectiveWidth,
            height: effectiveHeight,
            icon: Icons.broken_image,
            isMissing: true,
          );
        },
      ),
    );
  }
}

/// A placeholder widget shown when no image is available.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({
    required this.width,
    required this.height,
    required this.icon,
    this.isMissing = false,
  });

  final double width;
  final double height;
  final IconData icon;
  final bool isMissing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = (width < height ? width : height) * 0.5;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isMissing
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isMissing
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize.clamp(16, 48),
          color: isMissing
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
