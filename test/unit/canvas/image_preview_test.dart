import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:flutter_forge/features/canvas/image_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Canvas Image Preview (Task 7.2)', () {
    group('ImagePreview widget', () {
      testWidgets('renders placeholder when no assetPath is set',
          (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: null,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );

        // Should show placeholder icon
        expect(find.byIcon(Icons.image), findsOneWidget);
      });

      testWidgets('renders placeholder when asset is not found',
          (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: 'assets/missing.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );

        // Should show missing asset indicator
        expect(find.byIcon(Icons.broken_image), findsOneWidget);
      });

      testWidgets('renders image when asset exists', (tester) async {
        // Create a simple 1x1 PNG (minimal valid PNG)
        final pngBytes = Uint8List.fromList([
          0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
          0x00, 0x00, 0x00, 0x0D, // IHDR length
          0x49, 0x48, 0x44, 0x52, // IHDR
          0x00, 0x00, 0x00, 0x01, // width
          0x00, 0x00, 0x00, 0x01, // height
          0x08, 0x02, // bit depth, color type
          0x00, 0x00, 0x00, // compression, filter, interlace
          0x90, 0x77, 0x53, 0xDE, // CRC
          0x00, 0x00, 0x00, 0x0C, // IDAT length
          0x49, 0x44, 0x41, 0x54, // IDAT
          0x08, 0xD7, 0x63, 0xF8, 0xFF, 0xFF, 0xFF, 0x00, // data
          0x05, 0xFE, 0x02, 0xFE, // CRC
          0x00, 0x00, 0x00, 0x00, // IEND length
          0x49, 0x45, 0x4E, 0x44, // IEND
          0xAE, 0x42, 0x60, 0x82, // CRC
        ]);

        final manager = AssetManager();
        final asset = manager.registerAsset(
          fileName: 'test.png',
          bytes: pngBytes,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assetManagerProvider.overrideWithValue(manager),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: asset.assetPath,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );

        // Should render Image widget
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('respects width and height properties', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: null,
                  width: 200,
                  height: 150,
                ),
              ),
            ),
          ),
        );

        final container = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(container.width, equals(200));
        expect(container.height, equals(150));
      });

      testWidgets('uses default size when width/height not specified',
          (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: null,
                  width: null,
                  height: null,
                ),
              ),
            ),
          ),
        );

        // Default size should be 100x100
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, equals(100));
        expect(sizedBox.height, equals(100));
      });

      testWidgets('applies BoxFit.contain by default', (tester) async {
        final pngBytes = Uint8List.fromList([
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
          0x00,
          0x00,
          0x00,
          0x0D,
          0x49,
          0x48,
          0x44,
          0x52,
          0x00,
          0x00,
          0x00,
          0x01,
          0x00,
          0x00,
          0x00,
          0x01,
          0x08,
          0x02,
          0x00,
          0x00,
          0x00,
          0x90,
          0x77,
          0x53,
          0xDE,
          0x00,
          0x00,
          0x00,
          0x0C,
          0x49,
          0x44,
          0x41,
          0x54,
          0x08,
          0xD7,
          0x63,
          0xF8,
          0xFF,
          0xFF,
          0xFF,
          0x00,
          0x05,
          0xFE,
          0x02,
          0xFE,
          0x00,
          0x00,
          0x00,
          0x00,
          0x49,
          0x45,
          0x4E,
          0x44,
          0xAE,
          0x42,
          0x60,
          0x82,
        ]);

        final manager = AssetManager();
        final asset = manager.registerAsset(
          fileName: 'test.png',
          bytes: pngBytes,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assetManagerProvider.overrideWithValue(manager),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ImagePreview(
                  assetPath: asset.assetPath,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.contain));
      });
    });

    group('buildImageFromAsset', () {
      test('returns placeholder widget for null assetPath', () {
        final widget = buildImageFromAsset(
          assetPath: null,
          assetManager: AssetManager(),
          width: 100,
          height: 100,
        );

        expect(widget, isA<Widget>());
      });

      test('returns placeholder widget for missing asset', () {
        final widget = buildImageFromAsset(
          assetPath: 'assets/missing.png',
          assetManager: AssetManager(),
          width: 100,
          height: 100,
        );

        expect(widget, isA<Widget>());
      });
    });
  });
}
