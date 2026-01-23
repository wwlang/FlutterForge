import 'package:flutter_forge/generators/preview_annotation_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for Preview Annotation Generator (J24: Preview & Dev Tools)
///
/// Task 9.2.1: @Preview Annotation Export (3.32)
/// Task 9.2.2: Theme/Brightness Preview Export (3.35)
/// Task 9.2.3: Localization Preview Export (3.35)
/// Task 9.2.4: Custom Preview Configurations
void main() {
  group('@Preview Annotation Export (Task 9.2.1)', () {
    late PreviewAnnotationGenerator generator;

    setUp(() {
      generator = const PreviewAnnotationGenerator();
    });

    group('Basic @Preview Generation (J24 S1)', () {
      test('generates basic @Preview annotation', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
        );

        final result = generator.generate(config);

        expect(result, contains('@Preview()'));
        expect(result, contains('Widget _previewMyWidget()'));
        expect(result, contains('const MyWidget()'));
      });

      test('generates named preview', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Default State',
        );

        final result = generator.generate(config);

        expect(result, contains("@Preview(name: 'Default State')"));
      });

      test('generates sized preview with width and height', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Mobile',
          width: 390,
          height: 844,
        );

        final result = generator.generate(config);

        expect(result, contains('@Preview('));
        expect(result, contains("name: 'Mobile'"));
        expect(result, contains('width: 390'));
        expect(result, contains('height: 844'));
      });

      test('generates preview with only width', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          width: 400,
        );

        final result = generator.generate(config);

        expect(result, contains('width: 400'));
        expect(result, isNot(contains('height:')));
      });

      test('generates preview with only height', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          height: 600,
        );

        final result = generator.generate(config);

        expect(result, contains('height: 600'));
        expect(result, isNot(contains('width:')));
      });
    });

    group('Theme/Brightness Preview Export (J24 S2)', () {
      test('generates light theme preview', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Light Mode',
          brightness: PreviewBrightness.light,
        );

        final result = generator.generate(config);

        expect(result, contains('@Preview('));
        expect(result, contains("name: 'Light Mode'"));
        expect(result, contains('brightness: Brightness.light'));
      });

      test('generates dark theme preview', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Dark Mode',
          brightness: PreviewBrightness.dark,
        );

        final result = generator.generate(config);

        expect(result, contains('@Preview('));
        expect(result, contains("name: 'Dark Mode'"));
        expect(result, contains('brightness: Brightness.dark'));
      });

      test('generates theme matrix with both light and dark', () {
        final result = generator.generateThemeMatrix(
          widgetName: 'MyWidget',
        );

        // Light preview
        expect(result, contains('@Preview('));
        expect(result, contains("name: 'Light'"));
        expect(result, contains('brightness: Brightness.light'));
        expect(result, contains('Widget _previewMyWidgetLight()'));

        // Dark preview
        expect(result, contains("name: 'Dark'"));
        expect(result, contains('brightness: Brightness.dark'));
        expect(result, contains('Widget _previewMyWidgetDark()'));
      });

      test('combines brightness with size', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'iPhone Dark',
          width: 390,
          height: 844,
          brightness: PreviewBrightness.dark,
        );

        final result = generator.generate(config);

        expect(result, contains("name: 'iPhone Dark'"));
        expect(result, contains('width: 390'));
        expect(result, contains('height: 844'));
        expect(result, contains('brightness: Brightness.dark'));
      });
    });

    group('Localization Preview Export (J24 S3)', () {
      test('generates locale-specific preview', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Vietnamese',
          locale: const PreviewLocale(languageCode: 'vi'),
        );

        final result = generator.generate(config);

        expect(result, contains("name: 'Vietnamese'"));
        expect(result, contains("locale: Locale('vi')"));
      });

      test('generates locale with country code', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Brazilian Portuguese',
          locale: const PreviewLocale(languageCode: 'pt', countryCode: 'BR'),
        );

        final result = generator.generate(config);

        expect(result, contains("locale: Locale('pt', 'BR')"));
      });

      test('generates RTL locale preview with text direction', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Arabic (RTL)',
          locale: const PreviewLocale(languageCode: 'ar'),
          textDirection: PreviewTextDirection.rtl,
        );

        final result = generator.generate(config);

        expect(result, contains("name: 'Arabic (RTL)'"));
        expect(result, contains("locale: Locale('ar')"));
        expect(result, contains('textDirection: TextDirection.rtl'));
      });

      test('generates locale matrix for multiple locales', () {
        final locales = [
          const PreviewLocale(languageCode: 'en'),
          const PreviewLocale(languageCode: 'vi'),
          const PreviewLocale(languageCode: 'es'),
        ];

        final result = generator.generateLocaleMatrix(
          widgetName: 'MyWidget',
          locales: locales,
        );

        expect(result, contains("locale: Locale('en')"));
        expect(result, contains("locale: Locale('vi')"));
        expect(result, contains("locale: Locale('es')"));
        expect(result, contains('Widget _previewMyWidgetEn()'));
        expect(result, contains('Widget _previewMyWidgetVi()'));
        expect(result, contains('Widget _previewMyWidgetEs()'));
      });

      test('combines locale with brightness', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Vietnamese Dark',
          locale: const PreviewLocale(languageCode: 'vi'),
          brightness: PreviewBrightness.dark,
        );

        final result = generator.generate(config);

        expect(result, contains("locale: Locale('vi')"));
        expect(result, contains('brightness: Brightness.dark'));
      });
    });

    group('Custom Preview Configurations (J24 S5)', () {
      test('generates custom preview class', () {
        const customConfig = CustomPreviewClass(
          className: 'IPhoneDarkPreview',
          width: 390,
          height: 844,
          brightness: PreviewBrightness.dark,
        );

        final result = generator.generateCustomClass(customConfig);

        expect(result, contains('class IPhoneDarkPreview extends Preview'));
        expect(result, contains('const IPhoneDarkPreview({super.name})'));
        expect(result, contains('width: 390'));
        expect(result, contains('height: 844'));
        expect(result, contains('brightness: Brightness.dark'));
      });

      test('generates custom preview class with locale', () {
        const customConfig = CustomPreviewClass(
          className: 'VietnamesePreview',
          locale: PreviewLocale(languageCode: 'vi'),
        );

        final result = generator.generateCustomClass(customConfig);

        expect(result, contains('class VietnamesePreview extends Preview'));
        expect(result, contains("locale: Locale('vi')"));
      });

      test('generates custom preview class with text scale', () {
        const customConfig = CustomPreviewClass(
          className: 'LargeTextPreview',
          textScaleFactor: 1.5,
        );

        final result = generator.generateCustomClass(customConfig);

        expect(result, contains('class LargeTextPreview extends Preview'));
        expect(result, contains('textScaleFactor: 1.5'));
      });

      test('generates annotation using custom preview class', () {
        final config = PreviewConfig(
          widgetName: 'LoginScreen',
          name: 'Login Screen',
          customClassName: 'IPhoneDarkPreview',
        );

        final result = generator.generate(config);

        expect(result, contains("@IPhoneDarkPreview(name: 'Login Screen')"));
        expect(result, contains('Widget _previewLoginScreen()'));
      });
    });

    group('Code Output Format', () {
      test('generates syntactically valid Dart code', () {
        final config = PreviewConfig(
          widgetName: 'TestWidget',
          name: 'Test',
          width: 400,
          height: 800,
          brightness: PreviewBrightness.light,
          locale: const PreviewLocale(languageCode: 'en'),
        );

        final result = generator.generate(config);

        // Verify structure
        expect(result, contains('@Preview('));
        expect(result, contains(')'));
        expect(result, contains('Widget _previewTestWidget()'));
        expect(result, contains('const TestWidget()'));
        expect(result, contains(';'));
      });

      test('handles widget name with special characters', () {
        final config = PreviewConfig(
          widgetName: 'MyCustomWidget',
        );

        final result = generator.generate(config);

        expect(result, contains('_previewMyCustomWidget'));
      });

      test('generates multiline format for multiple parameters', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          name: 'Full Config',
          width: 390,
          height: 844,
          brightness: PreviewBrightness.dark,
          locale: const PreviewLocale(languageCode: 'vi'),
        );

        final result = generator.generate(config);

        // Should have proper indentation for multiple parameters
        expect(result.contains('\n'), isTrue);
      });
    });

    group('Edge Cases', () {
      test('handles empty widget name gracefully', () {
        expect(
          () => PreviewConfig(widgetName: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles zero dimensions', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          width: 0,
          height: 0,
        );

        // Zero dimensions should be omitted
        final result = generator.generate(config);
        expect(result, isNot(contains('width:')));
        expect(result, isNot(contains('height:')));
      });

      test('handles negative dimensions by ignoring them', () {
        final config = PreviewConfig(
          widgetName: 'MyWidget',
          width: -100,
          height: -200,
        );

        final result = generator.generate(config);
        expect(result, isNot(contains('width:')));
        expect(result, isNot(contains('height:')));
      });
    });
  });
}
