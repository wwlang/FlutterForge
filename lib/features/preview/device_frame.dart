import 'package:flutter/material.dart';
import 'package:flutter_forge/features/preview/device_specs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the device frame selector.
class DeviceFrameState {
  /// Creates a new device frame state.
  const DeviceFrameState({
    this.selectedDevice,
    this.customWidth = 375,
    this.customHeight = 812,
    this.isPortrait = true,
    this.showSafeAreas = true,
  });

  /// The selected device specification, or null for custom size.
  final DeviceSpec? selectedDevice;

  /// Custom width when no device is selected.
  final double customWidth;

  /// Custom height when no device is selected.
  final double customHeight;

  /// Whether the device is in portrait orientation.
  final bool isPortrait;

  /// Whether to show safe area indicators.
  final bool showSafeAreas;

  /// Whether using custom size (no device selected).
  bool get isCustom => selectedDevice == null;

  /// The current viewport size based on device or custom settings.
  Size get viewportSize {
    if (selectedDevice != null) {
      return isPortrait ? selectedDevice!.size : selectedDevice!.landscapeSize;
    }
    return isPortrait
        ? Size(customWidth, customHeight)
        : Size(customHeight, customWidth);
  }

  /// The current safe area insets.
  EdgeInsets get currentSafeAreaInsets {
    if (selectedDevice == null) return EdgeInsets.zero;
    return isPortrait
        ? selectedDevice!.safeAreaInsets
        : selectedDevice!.landscapeSafeAreaInsets;
  }

  /// Creates a copy with the given fields replaced.
  DeviceFrameState copyWith({
    DeviceSpec? selectedDevice,
    double? customWidth,
    double? customHeight,
    bool? isPortrait,
    bool? showSafeAreas,
    bool clearDevice = false,
  }) {
    return DeviceFrameState(
      selectedDevice:
          clearDevice ? null : (selectedDevice ?? this.selectedDevice),
      customWidth: customWidth ?? this.customWidth,
      customHeight: customHeight ?? this.customHeight,
      isPortrait: isPortrait ?? this.isPortrait,
      showSafeAreas: showSafeAreas ?? this.showSafeAreas,
    );
  }
}

/// Notifier for managing device frame state.
class DeviceFrameNotifier extends Notifier<DeviceFrameState> {
  @override
  DeviceFrameState build() {
    return const DeviceFrameState();
  }

  /// Selects a device specification.
  void selectDevice(DeviceSpec device) {
    state = state.copyWith(selectedDevice: device);
  }

  /// Clears the device selection and uses custom size.
  void clearDevice() {
    state = state.copyWith(clearDevice: true);
  }

  /// Sets a custom viewport size.
  void setCustomSize(double width, double height) {
    state = state.copyWith(
      clearDevice: true,
      customWidth: width,
      customHeight: height,
    );
  }

  /// Toggles between portrait and landscape orientation.
  void toggleOrientation() {
    state = state.copyWith(isPortrait: !state.isPortrait);
  }

  /// Toggles safe area visibility.
  void toggleSafeAreaVisibility() {
    state = state.copyWith(showSafeAreas: !state.showSafeAreas);
  }
}

/// Provider for the device frame state.
final deviceFrameProvider =
    NotifierProvider<DeviceFrameNotifier, DeviceFrameState>(
  DeviceFrameNotifier.new,
);

/// A widget that wraps its child in a device frame.
class DeviceFrame extends ConsumerWidget {
  /// Creates a new device frame.
  const DeviceFrame({
    required this.child,
    super.key,
  });

  /// The child widget to display inside the frame.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceFrameProvider);
    final viewportSize = state.viewportSize;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.selectedDevice != null)
            Stack(
              children: [
                // The device frame overlay
                DeviceFrameOverlay(
                  device: state.selectedDevice!,
                  isPortrait: state.isPortrait,
                  child: SizedBox(
                    width: viewportSize.width,
                    height: viewportSize.height,
                    child: child,
                  ),
                ),
                // Safe area indicators
                if (state.showSafeAreas)
                  Positioned.fill(
                    child: SafeAreaIndicator(
                      insets: state.currentSafeAreaInsets,
                    ),
                  ),
              ],
            )
          else
            SizedBox(
              width: viewportSize.width,
              height: viewportSize.height,
              child: child,
            ),
        ],
      ),
    );
  }
}

/// Overlay that renders the device frame decoration.
class DeviceFrameOverlay extends StatelessWidget {
  /// Creates a new device frame overlay.
  const DeviceFrameOverlay({
    required this.device,
    required this.child,
    this.isPortrait = true,
    super.key,
  });

  /// The device specification.
  final DeviceSpec device;

  /// The child widget to display inside.
  final Widget child;

  /// Whether the device is in portrait orientation.
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final frameColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final borderColor = isDark ? Colors.grey[600]! : Colors.grey[400]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(device.cornerRadius + 8),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(device.cornerRadius),
        child: child,
      ),
    );
  }
}

/// Indicator for safe areas within the device frame.
class SafeAreaIndicator extends StatelessWidget {
  /// Creates a new safe area indicator.
  const SafeAreaIndicator({
    required this.insets,
    super.key,
  });

  /// The safe area insets to display.
  final EdgeInsets insets;

  @override
  Widget build(BuildContext context) {
    final safeAreaColor = Colors.red.withValues(alpha: 0.15);
    final textColor = Colors.red.withValues(alpha: 0.8);
    const textStyle = TextStyle(fontSize: 10);

    return Stack(
      children: [
        // Top safe area
        if (insets.top > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: insets.top,
            child: ColoredBox(
              color: safeAreaColor,
              child: Center(
                child: Text(
                  '${insets.top.toInt()}pt',
                  style: textStyle.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        // Bottom safe area
        if (insets.bottom > 0)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: insets.bottom,
            child: ColoredBox(
              color: safeAreaColor,
              child: Center(
                child: Text(
                  '${insets.bottom.toInt()}pt',
                  style: textStyle.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        // Left safe area
        if (insets.left > 0)
          Positioned(
            top: insets.top,
            bottom: insets.bottom,
            left: 0,
            width: insets.left,
            child: ColoredBox(color: safeAreaColor),
          ),
        // Right safe area
        if (insets.right > 0)
          Positioned(
            top: insets.top,
            bottom: insets.bottom,
            right: 0,
            width: insets.right,
            child: ColoredBox(color: safeAreaColor),
          ),
      ],
    );
  }
}

/// A selector widget for choosing device frames.
class DeviceFrameSelector extends ConsumerWidget {
  /// Creates a new device frame selector.
  const DeviceFrameSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceFrameProvider);
    final notifier = ref.read(deviceFrameProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Device dropdown
        PopupMenuButton<DeviceSpec?>(
          initialValue: state.selectedDevice,
          onSelected: (device) {
            if (device == null) {
              notifier.clearDevice();
            } else {
              notifier.selectDevice(device);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<DeviceSpec?>(
              child: Text('Custom'),
            ),
            const PopupMenuDivider(),
            _buildCategoryHeader('iOS'),
            ...DeviceSpecs.iosDevices.map(
              (device) => PopupMenuItem<DeviceSpec>(
                value: device,
                child: Text(device.name),
              ),
            ),
            const PopupMenuDivider(),
            _buildCategoryHeader('Android'),
            ...DeviceSpecs.androidDevices.map(
              (device) => PopupMenuItem<DeviceSpec>(
                value: device,
                child: Text(device.name),
              ),
            ),
            const PopupMenuDivider(),
            _buildCategoryHeader('Desktop'),
            ...DeviceSpecs.desktopDevices.map(
              (device) => PopupMenuItem<DeviceSpec>(
                value: device,
                child: Text(device.name),
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.selectedDevice?.name ?? 'Custom'),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Orientation toggle
        if (state.selectedDevice != null)
          IconButton(
            onPressed: notifier.toggleOrientation,
            icon: const Icon(Icons.screen_rotation),
            tooltip:
                state.isPortrait ? 'Switch to landscape' : 'Switch to portrait',
          ),

        // Safe area toggle
        if (state.selectedDevice != null)
          IconButton(
            onPressed: notifier.toggleSafeAreaVisibility,
            icon: Icon(
              state.showSafeAreas
                  ? Icons.safety_check
                  : Icons.safety_check_outlined,
            ),
            tooltip:
                state.showSafeAreas ? 'Hide safe areas' : 'Show safe areas',
          ),
      ],
    );
  }

  PopupMenuItem<DeviceSpec?> _buildCategoryHeader(String title) {
    return PopupMenuItem<DeviceSpec?>(
      enabled: false,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
