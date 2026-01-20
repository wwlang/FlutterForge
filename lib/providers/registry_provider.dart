import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the widget registry.
final widgetRegistryProvider = Provider<WidgetRegistry>((ref) {
  return DefaultWidgetRegistry();
});
