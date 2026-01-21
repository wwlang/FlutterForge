import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_forge/features/assets/asset_import_dialog.dart';
import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asset Import Dialog (Task 7.1)', () {
    group('AssetImportDialog', () {
      testWidgets('displays dialog title', (tester) async {
        // Set a larger surface for the dialog
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AssetImportDialog(),
              ),
            ),
          ),
        );

        expect(find.text('Import Assets'), findsOneWidget);
      });

      testWidgets('shows supported formats info', (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AssetImportDialog(),
              ),
            ),
          ),
        );

        expect(find.textContaining('PNG'), findsOneWidget);
        expect(find.textContaining('JPG'), findsOneWidget);
        expect(find.textContaining('WebP'), findsOneWidget);
      });

      testWidgets('has pick files button', (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AssetImportDialog(),
              ),
            ),
          ),
        );

        expect(find.text('Select Files'), findsOneWidget);
      });

      testWidgets('has cancel button', (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AssetImportDialog(),
              ),
            ),
          ),
        );

        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('has import button that is initially disabled',
          (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AssetImportDialog(),
              ),
            ),
          ),
        );

        final importButton = find.widgetWithText(FilledButton, 'Import');
        expect(importButton, findsOneWidget);

        final button = tester.widget<FilledButton>(importButton);
        expect(button.onPressed, isNull);
      });
    });

    group('AssetPreviewTile', () {
      testWidgets('displays file name', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AssetPreviewTile(
                fileName: 'test_image.png',
                bytes: Uint8List.fromList([1, 2, 3]),
                onRemove: () {},
              ),
            ),
          ),
        );

        expect(find.text('test_image.png'), findsOneWidget);
      });

      testWidgets('displays file size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AssetPreviewTile(
                fileName: 'test.png',
                bytes: Uint8List(1024), // 1KB
                onRemove: () {},
              ),
            ),
          ),
        );

        expect(find.textContaining('1'), findsWidgets);
        expect(find.textContaining('KB'), findsOneWidget);
      });

      testWidgets('has remove button', (tester) async {
        var removed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AssetPreviewTile(
                fileName: 'test.png',
                bytes: Uint8List(100),
                onRemove: () => removed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.close));
        expect(removed, isTrue);
      });

      testWidgets('shows warning icon for large files', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AssetPreviewTile(
                fileName: 'large.png',
                bytes: Uint8List(15 * 1024 * 1024), // 15MB
                onRemove: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.warning), findsOneWidget);
      });
    });

    group('SupportedFormatsChip', () {
      testWidgets('displays format', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SupportedFormatsChip(format: 'PNG'),
            ),
          ),
        );

        expect(find.text('PNG'), findsOneWidget);
      });
    });

    group('formatFileSize', () {
      test('formats bytes correctly', () {
        expect(formatFileSize(512), equals('512 B'));
        expect(formatFileSize(1024), equals('1.0 KB'));
        expect(formatFileSize(1536), equals('1.5 KB'));
        expect(formatFileSize(1024 * 1024), equals('1.0 MB'));
        expect(formatFileSize(1024 * 1024 * 1024), equals('1.0 GB'));
      });
    });
  });

  group('Asset Provider (Task 7.1)', () {
    test('assetManagerProvider provides AssetManager', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final manager = container.read(assetManagerProvider);
      expect(manager, isA<AssetManager>());
    });

    test('assetsProvider returns list of assets', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final assets = container.read(assetsProvider);
      expect(assets, isEmpty);
    });
  });
}
