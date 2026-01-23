/// Preview annotation generator for Flutter widget previews.
///
/// Generates @Preview annotations for IDE widget preview support.
///
/// Flutter version requirements:
/// - @Preview annotation: Flutter 3.32+
/// - Theme/brightness support: Flutter 3.35+
/// - Locale support: Flutter 3.35+
/// - @MultiPreview: Flutter 3.38+
library;

/// Brightness setting for preview annotation.
enum PreviewBrightness {
  /// Light theme brightness.
  light,

  /// Dark theme brightness.
  dark,
}

/// Text direction for preview annotation.
enum PreviewTextDirection {
  /// Left-to-right text direction.
  ltr,

  /// Right-to-left text direction.
  rtl,
}

/// Locale configuration for preview annotation.
class PreviewLocale {
  /// Creates a preview locale.
  const PreviewLocale({
    required this.languageCode,
    this.countryCode,
  });

  /// The ISO 639-1 language code.
  final String languageCode;

  /// The ISO 3166-1 alpha-2 country code (optional).
  final String? countryCode;

  /// Generates the Dart Locale constructor call.
  String toDartCode() {
    if (countryCode != null) {
      return "Locale('$languageCode', '$countryCode')";
    }
    return "Locale('$languageCode')";
  }

  /// Gets the display name for this locale.
  String get displayName {
    final base = languageCode.toUpperCase();
    if (countryCode != null) {
      return '$base-${countryCode!.toUpperCase()}';
    }
    return base;
  }
}

/// Configuration for a single @Preview annotation.
class PreviewConfig {
  /// Creates a preview configuration.
  ///
  /// Throws [ArgumentError] if [widgetName] is empty.
  PreviewConfig({
    required this.widgetName,
    this.name,
    this.width,
    this.height,
    this.brightness,
    this.locale,
    this.textDirection,
    this.textScaleFactor,
    this.customClassName,
  }) {
    if (widgetName.isEmpty) {
      throw ArgumentError.value(widgetName, 'widgetName', 'Cannot be empty');
    }
  }

  /// The widget class name to preview.
  final String widgetName;

  /// Optional display name for the preview.
  final String? name;

  /// Preview viewport width in logical pixels.
  final double? width;

  /// Preview viewport height in logical pixels.
  final double? height;

  /// Theme brightness for the preview.
  final PreviewBrightness? brightness;

  /// Locale for the preview.
  final PreviewLocale? locale;

  /// Text direction for the preview.
  final PreviewTextDirection? textDirection;

  /// Text scale factor for the preview.
  final double? textScaleFactor;

  /// Custom preview class name (instead of @Preview).
  final String? customClassName;

  /// Whether this configuration has any parameters.
  bool get hasParameters =>
      name != null ||
      _hasValidDimension(width) ||
      _hasValidDimension(height) ||
      brightness != null ||
      locale != null ||
      textDirection != null ||
      textScaleFactor != null;

  bool _hasValidDimension(double? value) => value != null && value > 0;

  /// Generates a valid Dart method name from the widget name.
  String get methodName => '_preview$widgetName';
}

/// Configuration for a custom preview annotation class.
class CustomPreviewClass {
  /// Creates a custom preview class configuration.
  const CustomPreviewClass({
    required this.className,
    this.width,
    this.height,
    this.brightness,
    this.locale,
    this.textScaleFactor,
  });

  /// The class name for the custom preview.
  final String className;

  /// Default preview width.
  final double? width;

  /// Default preview height.
  final double? height;

  /// Default brightness.
  final PreviewBrightness? brightness;

  /// Default locale.
  final PreviewLocale? locale;

  /// Default text scale factor.
  final double? textScaleFactor;
}

/// Generator for @Preview annotations and custom preview classes.
///
/// Supports Flutter 3.32+ @Preview annotation syntax with extensions
/// for theme/brightness (3.35+), localization (3.35+), and custom
/// preview classes.
class PreviewAnnotationGenerator {
  /// Creates a preview annotation generator.
  const PreviewAnnotationGenerator();

  /// Generates a @Preview annotation with function for a widget.
  ///
  /// Example output:
  /// ```dart
  /// @Preview(name: 'Default State')
  /// Widget _previewMyWidget() => const MyWidget();
  /// ```
  String generate(PreviewConfig config) {
    final buffer = StringBuffer()
      ..write(
        config.customClassName != null
            ? _generateCustomAnnotation(config)
            : _generateStandardAnnotation(config),
      )
      ..writeln()
      ..write(
        'Widget ${config.methodName}() => const ${config.widgetName}();',
      );

    return buffer.toString();
  }

  String _generateStandardAnnotation(PreviewConfig config) {
    if (!config.hasParameters) {
      return '@Preview()';
    }

    final params = <String>[];

    if (config.name != null) {
      params.add("name: '${config.name}'");
    }

    if (config.width != null && config.width! > 0) {
      params.add('width: ${_formatNumber(config.width!)}');
    }

    if (config.height != null && config.height! > 0) {
      params.add('height: ${_formatNumber(config.height!)}');
    }

    if (config.brightness != null) {
      final brightnessValue = switch (config.brightness!) {
        PreviewBrightness.light => 'Brightness.light',
        PreviewBrightness.dark => 'Brightness.dark',
      };
      params.add('brightness: $brightnessValue');
    }

    if (config.locale != null) {
      params.add('locale: ${config.locale!.toDartCode()}');
    }

    if (config.textDirection != null) {
      final directionValue = switch (config.textDirection!) {
        PreviewTextDirection.ltr => 'TextDirection.ltr',
        PreviewTextDirection.rtl => 'TextDirection.rtl',
      };
      params.add('textDirection: $directionValue');
    }

    if (config.textScaleFactor != null) {
      params.add('textScaleFactor: ${_formatNumber(config.textScaleFactor!)}');
    }

    if (params.length == 1) {
      return '@Preview(${params.first})';
    }

    // Multi-line format for multiple parameters
    final buffer = StringBuffer('@Preview(\n');
    for (var i = 0; i < params.length; i++) {
      buffer.write('  ${params[i]}');
      if (i < params.length - 1) {
        buffer.write(',');
      }
      buffer.writeln();
    }
    buffer.write(')');
    return buffer.toString();
  }

  String _generateCustomAnnotation(PreviewConfig config) {
    if (config.name != null) {
      return "@${config.customClassName}(name: '${config.name}')";
    }
    return '@${config.customClassName}()';
  }

  /// Generates preview annotations for both light and dark themes.
  ///
  /// Creates two preview functions, one for each brightness value.
  String generateThemeMatrix({required String widgetName}) {
    final lightConfig = PreviewConfig(
      widgetName: widgetName,
      name: 'Light',
      brightness: PreviewBrightness.light,
    );
    final darkConfig = PreviewConfig(
      widgetName: widgetName,
      name: 'Dark',
      brightness: PreviewBrightness.dark,
    );

    final buffer = StringBuffer()
      ..writeln(_generateStandardAnnotation(lightConfig))
      ..writeln('Widget _preview${widgetName}Light() => '
          'const $widgetName();')
      ..writeln()
      ..writeln(_generateStandardAnnotation(darkConfig))
      ..write('Widget _preview${widgetName}Dark() => const $widgetName();');

    return buffer.toString();
  }

  /// Generates preview annotations for multiple locales.
  ///
  /// Creates a preview function for each locale in the list.
  String generateLocaleMatrix({
    required String widgetName,
    required List<PreviewLocale> locales,
  }) {
    final buffer = StringBuffer();

    for (var i = 0; i < locales.length; i++) {
      final locale = locales[i];
      final suffix = locale.languageCode[0].toUpperCase() +
          locale.languageCode.substring(1);

      final config = PreviewConfig(
        widgetName: widgetName,
        name: locale.displayName,
        locale: locale,
      );

      buffer
        ..writeln(_generateStandardAnnotation(config))
        ..write('Widget _preview$widgetName$suffix() => '
            'const $widgetName();');

      if (i < locales.length - 1) {
        buffer
          ..writeln()
          ..writeln();
      }
    }

    return buffer.toString();
  }

  /// Generates a custom preview class that extends Preview.
  ///
  /// Example output:
  /// ```dart
  /// class IPhoneDarkPreview extends Preview {
  ///   const IPhoneDarkPreview({super.name}) : super(
  ///     width: 390,
  ///     height: 844,
  ///     brightness: Brightness.dark,
  ///   );
  /// }
  /// ```
  String generateCustomClass(CustomPreviewClass config) {
    final buffer = StringBuffer()
      ..writeln('class ${config.className} extends Preview {')
      ..write('  const ${config.className}({super.name}) : super(');

    final params = <String>[];

    if (config.width != null) {
      params.add('width: ${_formatNumber(config.width!)}');
    }

    if (config.height != null) {
      params.add('height: ${_formatNumber(config.height!)}');
    }

    if (config.brightness != null) {
      final brightnessValue = switch (config.brightness!) {
        PreviewBrightness.light => 'Brightness.light',
        PreviewBrightness.dark => 'Brightness.dark',
      };
      params.add('brightness: $brightnessValue');
    }

    if (config.locale != null) {
      params.add('locale: ${config.locale!.toDartCode()}');
    }

    if (config.textScaleFactor != null) {
      params.add('textScaleFactor: ${_formatNumber(config.textScaleFactor!)}');
    }

    if (params.isEmpty) {
      buffer.writeln(');');
    } else if (params.length == 1) {
      buffer.writeln('${params.first});');
    } else {
      buffer.writeln();
      for (var i = 0; i < params.length; i++) {
        buffer.write('    ${params[i]}');
        if (i < params.length - 1) {
          buffer.write(',');
        }
        buffer.writeln();
      }
      buffer.writeln('  );');
    }

    buffer.write('}');

    return buffer.toString();
  }

  /// Formats a number for code output, removing unnecessary decimals.
  String _formatNumber(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
