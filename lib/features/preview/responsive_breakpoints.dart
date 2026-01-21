import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Material Design 3 responsive breakpoints.
///
/// Based on Material Design 3 window size classes.
enum ResponsiveBreakpoint {
  /// Compact window size (0-599dp) - phones in portrait
  compact(name: 'Compact', minWidth: 0, maxWidth: 599),

  /// Medium window size (600-839dp) - tablets in portrait, foldables
  medium(name: 'Medium', minWidth: 600, maxWidth: 839),

  /// Expanded window size (840-1199dp) - tablets in landscape
  expanded(name: 'Expanded', minWidth: 840, maxWidth: 1199),

  /// Large window size (1200-1599dp) - laptops, desktops
  large(name: 'Large', minWidth: 1200, maxWidth: 1599),

  /// Extra large window size (1600+dp) - large desktops, TVs
  extraLarge(name: 'Extra Large', minWidth: 1600, maxWidth: double.infinity);

  const ResponsiveBreakpoint({
    required this.name,
    required this.minWidth,
    required this.maxWidth,
  });

  /// Human-readable name for this breakpoint.
  final String name;

  /// Minimum width for this breakpoint (inclusive).
  final double minWidth;

  /// Maximum width for this breakpoint (inclusive).
  final double maxWidth;

  /// Whether this breakpoint represents mobile phone sizes.
  bool get isMobile => this == compact;

  /// Whether this breakpoint represents tablet sizes.
  bool get isTablet => this == medium || this == expanded;

  /// Whether this breakpoint represents desktop sizes.
  bool get isDesktop => this == large || this == extraLarge;

  /// Returns the breakpoint for the given width.
  static ResponsiveBreakpoint fromWidth(double width) {
    if (width < 600) return compact;
    if (width < 840) return medium;
    if (width < 1200) return expanded;
    if (width < 1600) return large;
    return extraLarge;
  }
}

/// State for the responsive breakpoint simulator.
@immutable
class ResponsiveBreakpointState {
  /// Creates a new responsive breakpoint state.
  const ResponsiveBreakpointState({
    this.viewportWidth = 375,
    this.viewportHeight = 812,
    this.devicePixelRatio = 2,
    this.padding = EdgeInsets.zero,
    this.textScaleFactor = 1.0,
  });

  /// Current viewport width in logical pixels.
  final double viewportWidth;

  /// Current viewport height in logical pixels.
  final double viewportHeight;

  /// Device pixel ratio for the simulation.
  final double devicePixelRatio;

  /// Simulated padding (safe areas).
  final EdgeInsets padding;

  /// Text scale factor for accessibility simulation.
  final double textScaleFactor;

  /// The current breakpoint based on viewport width.
  ResponsiveBreakpoint get currentBreakpoint =>
      ResponsiveBreakpoint.fromWidth(viewportWidth);

  /// Creates a copy with the given fields replaced.
  ResponsiveBreakpointState copyWith({
    double? viewportWidth,
    double? viewportHeight,
    double? devicePixelRatio,
    EdgeInsets? padding,
    double? textScaleFactor,
  }) {
    return ResponsiveBreakpointState(
      viewportWidth: viewportWidth ?? this.viewportWidth,
      viewportHeight: viewportHeight ?? this.viewportHeight,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      padding: padding ?? this.padding,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}

/// Notifier for managing responsive breakpoint state.
class ResponsiveBreakpointNotifier extends Notifier<ResponsiveBreakpointState> {
  @override
  ResponsiveBreakpointState build() {
    return const ResponsiveBreakpointState();
  }

  /// Sets the viewport width.
  void setViewportWidth(double width) {
    state = state.copyWith(viewportWidth: width);
  }

  /// Sets the viewport height.
  void setViewportHeight(double height) {
    state = state.copyWith(viewportHeight: height);
  }

  /// Sets both viewport dimensions.
  void setViewportSize(double width, double height) {
    state = state.copyWith(viewportWidth: width, viewportHeight: height);
  }

  /// Sets the device pixel ratio.
  void setDevicePixelRatio(double ratio) {
    state = state.copyWith(devicePixelRatio: ratio);
  }

  /// Sets the simulated padding (safe areas).
  void setPadding(EdgeInsets padding) {
    state = state.copyWith(padding: padding);
  }

  /// Sets the text scale factor.
  void setTextScaleFactor(double factor) {
    state = state.copyWith(textScaleFactor: factor);
  }

  /// Resets all values to defaults.
  void reset() {
    state = const ResponsiveBreakpointState();
  }
}

/// Provider for the responsive breakpoint state.
final responsiveBreakpointProvider =
    NotifierProvider<ResponsiveBreakpointNotifier, ResponsiveBreakpointState>(
  ResponsiveBreakpointNotifier.new,
);

/// A widget that simulates MediaQuery data for its child.
///
/// This allows previewing designs at different device sizes and configurations
/// without needing an actual device.
class MediaQuerySimulator extends ConsumerWidget {
  /// Creates a new MediaQuery simulator.
  const MediaQuerySimulator({
    required this.child,
    super.key,
  });

  /// The child widget to wrap with simulated MediaQuery.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(responsiveBreakpointProvider);

    // Get the parent MediaQuery as a base
    final parentMediaQuery = MediaQuery.of(context);

    // Create simulated MediaQuery data
    final simulatedData = parentMediaQuery.copyWith(
      size: Size(state.viewportWidth, state.viewportHeight),
      devicePixelRatio: state.devicePixelRatio,
      padding: state.padding,
      textScaler: TextScaler.linear(state.textScaleFactor),
    );

    return MediaQuery(
      data: simulatedData,
      child: child,
    );
  }
}

/// A widget that displays the current breakpoint information.
class BreakpointIndicator extends ConsumerWidget {
  /// Creates a new breakpoint indicator.
  const BreakpointIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(responsiveBreakpointProvider);
    final breakpoint = state.currentBreakpoint;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getBreakpointColor(breakpoint).withValues(alpha: 0.1),
        border: Border.all(color: _getBreakpointColor(breakpoint)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getBreakpointIcon(breakpoint),
            size: 16,
            color: _getBreakpointColor(breakpoint),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breakpoint.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getBreakpointColor(breakpoint),
                ),
              ),
              Text(
                '${state.viewportWidth.toInt()} x '
                '${state.viewportHeight.toInt()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBreakpointColor(ResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.compact:
        return Colors.blue;
      case ResponsiveBreakpoint.medium:
        return Colors.green;
      case ResponsiveBreakpoint.expanded:
        return Colors.orange;
      case ResponsiveBreakpoint.large:
        return Colors.purple;
      case ResponsiveBreakpoint.extraLarge:
        return Colors.red;
    }
  }

  IconData _getBreakpointIcon(ResponsiveBreakpoint breakpoint) {
    switch (breakpoint) {
      case ResponsiveBreakpoint.compact:
        return Icons.phone_android;
      case ResponsiveBreakpoint.medium:
        return Icons.tablet_android;
      case ResponsiveBreakpoint.expanded:
        return Icons.tablet;
      case ResponsiveBreakpoint.large:
        return Icons.laptop;
      case ResponsiveBreakpoint.extraLarge:
        return Icons.desktop_windows;
    }
  }
}
