import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for canvas navigation (pan and zoom).
class CanvasNavigationState {
  const CanvasNavigationState({
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
  });

  /// Current zoom level (1.0 = 100%).
  final double zoomLevel;

  /// Current pan offset from origin.
  final Offset panOffset;

  CanvasNavigationState copyWith({
    double? zoomLevel,
    Offset? panOffset,
  }) {
    return CanvasNavigationState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
    );
  }
}

/// Provider for canvas navigation state.
final canvasNavigationProvider =
    StateNotifierProvider<CanvasNavigationNotifier, CanvasNavigationState>(
  (ref) => CanvasNavigationNotifier(),
);

/// Notifier for canvas navigation state.
class CanvasNavigationNotifier extends StateNotifier<CanvasNavigationState> {
  CanvasNavigationNotifier() : super(const CanvasNavigationState());

  /// Minimum zoom level (10%).
  static const minZoom = 0.1;

  /// Maximum zoom level (400%).
  static const maxZoom = 4.0;

  /// Zoom step for increment/decrement.
  static const zoomStep = 0.25;

  /// Zooms in by one step.
  void zoomIn() {
    final newZoom = (state.zoomLevel + zoomStep).clamp(minZoom, maxZoom);
    state = state.copyWith(zoomLevel: newZoom);
  }

  /// Zooms out by one step.
  void zoomOut() {
    final newZoom = (state.zoomLevel - zoomStep).clamp(minZoom, maxZoom);
    state = state.copyWith(zoomLevel: newZoom);
  }

  /// Sets a specific zoom level.
  void setZoom(double level) {
    state = state.copyWith(zoomLevel: level.clamp(minZoom, maxZoom));
  }

  /// Resets zoom to 100%.
  void resetZoom() {
    state = state.copyWith(zoomLevel: 1);
  }

  /// Pans the canvas by a delta.
  void pan(Offset delta) {
    state = state.copyWith(panOffset: state.panOffset + delta);
  }

  /// Sets a specific pan offset.
  void setPanOffset(Offset offset) {
    state = state.copyWith(panOffset: offset);
  }

  /// Resets pan to origin.
  void resetPan() {
    state = state.copyWith(panOffset: Offset.zero);
  }

  /// Resets both zoom and pan.
  void resetAll() {
    state = const CanvasNavigationState();
  }

  /// Fits content to screen.
  void fitToScreen({
    required Size screenSize,
    required Size contentSize,
  }) {
    if (contentSize.isEmpty) {
      resetAll();
      return;
    }

    // Calculate zoom to fit content with padding
    const padding = 40.0;
    final availableWidth = screenSize.width - padding * 2;
    final availableHeight = screenSize.height - padding * 2;

    final scaleX = availableWidth / contentSize.width;
    final scaleY = availableHeight / contentSize.height;

    final fitZoom = (scaleX < scaleY ? scaleX : scaleY).clamp(minZoom, maxZoom);

    // Center content
    final scaledWidth = contentSize.width * fitZoom;
    final scaledHeight = contentSize.height * fitZoom;

    final centerX = (screenSize.width - scaledWidth) / 2;
    final centerY = (screenSize.height - scaledHeight) / 2;

    state = CanvasNavigationState(
      zoomLevel: fitZoom,
      panOffset: Offset(centerX, centerY),
    );
  }
}

/// Provider for zoom display string.
final zoomDisplayProvider = Provider<String>((ref) {
  final zoom = ref.watch(canvasNavigationProvider).zoomLevel;
  return '${(zoom * 100).round()}%';
});
