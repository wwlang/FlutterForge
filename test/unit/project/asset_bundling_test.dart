import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:flutter_forge/services/project_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asset Bundling in .forge (Task 7.3)', () {
    late ProjectService projectService;

    setUp(() {
      projectService = ProjectService();
    });

    group('serializeWithAssets', () {
      test('includes assets folder in ZIP', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final assetManager = AssetManager();
        final bytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: assetManager,
        );

        final archive = ZipDecoder().decodeBytes(bytes);
        final fileNames = archive.files.map((f) => f.name).toList();

        expect(fileNames, contains('assets/'));
      });

      test('stores asset files in assets directory', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final assetManager = AssetManager()
          ..registerAsset(
            fileName: 'test.png',
            bytes: Uint8List.fromList([1, 2, 3, 4, 5]),
          );

        final bytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: assetManager,
        );

        final archive = ZipDecoder().decodeBytes(bytes);

        // Find the asset file
        ArchiveFile? assetFile;
        for (final file in archive.files) {
          if (file.name.startsWith('assets/') && file.name.endsWith('.png')) {
            assetFile = file;
            break;
          }
        }

        expect(assetFile, isNotNull);
        expect(assetFile!.content, equals([1, 2, 3, 4, 5]));
      });

      test('includes asset manifest in manifest.json', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final assetManager = AssetManager();
        final asset = assetManager.registerAsset(
          fileName: 'logo.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        );

        final bytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: assetManager,
        );

        final archive = ZipDecoder().decodeBytes(bytes);

        // Find manifest
        ArchiveFile? manifestFile;
        for (final file in archive.files) {
          if (file.name == 'manifest.json') {
            manifestFile = file;
            break;
          }
        }

        expect(manifestFile, isNotNull);
        final manifestContent = utf8.decode(manifestFile!.content as List<int>);
        final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;

        expect(manifest['assets'], isA<List<dynamic>>());
        final assets = manifest['assets'] as List<dynamic>;
        expect(assets.length, 1);
        final firstAsset = assets.first as Map<String, dynamic>;
        expect(firstAsset['id'], asset.id);
        expect(firstAsset['fileName'], 'logo.png');
        expect(firstAsset['assetPath'], asset.assetPath);
      });

      test('stores multiple assets', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final assetManager = AssetManager()
          ..registerAsset(
            fileName: 'image1.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          )
          ..registerAsset(
            fileName: 'image2.jpg',
            bytes: Uint8List.fromList([4, 5, 6]),
          )
          ..registerAsset(
            fileName: 'icon.svg',
            bytes: Uint8List.fromList([7, 8, 9]),
          );

        final bytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: assetManager,
        );

        final archive = ZipDecoder().decodeBytes(bytes);

        // Count asset files
        final assetFiles = archive.files
            .where((f) => f.name.startsWith('assets/') && f.isFile)
            .toList();
        expect(assetFiles.length, 3);
      });
    });

    group('deserializeWithAssets', () {
      test('restores assets from ZIP', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        // Create and serialize with assets
        final originalManager = AssetManager();
        final testBytes = Uint8List.fromList([10, 20, 30, 40, 50]);
        originalManager.registerAsset(
          fileName: 'test.png',
          bytes: testBytes,
        );

        final forgeBytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: originalManager,
        );

        // Deserialize into new manager
        final restoredManager = AssetManager();
        await projectService.deserializeWithAssets(
          bytes: forgeBytes,
          assetManager: restoredManager,
        );

        expect(restoredManager.assets.length, 1);
        expect(restoredManager.assets.first.bytes, equals(testBytes));
      });

      test('restores asset metadata correctly', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final originalManager = AssetManager();
        final originalAsset = originalManager.registerAsset(
          fileName: 'my-image.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        );

        final forgeBytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: originalManager,
        );

        final restoredManager = AssetManager();
        await projectService.deserializeWithAssets(
          bytes: forgeBytes,
          assetManager: restoredManager,
        );

        final restoredAsset = restoredManager.assets.first;
        expect(restoredAsset.id, originalAsset.id);
        expect(restoredAsset.fileName, originalAsset.fileName);
        expect(restoredAsset.assetPath, originalAsset.assetPath);
      });

      test('asset can be retrieved by path after restore', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final originalManager = AssetManager();
        final originalAsset = originalManager.registerAsset(
          fileName: 'logo.png',
          bytes: Uint8List.fromList([1, 2, 3, 4]),
        );

        final forgeBytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: originalManager,
        );

        final restoredManager = AssetManager();
        await projectService.deserializeWithAssets(
          bytes: forgeBytes,
          assetManager: restoredManager,
        );

        // Retrieve by path (how ImagePreview will access it)
        final retrieved =
            restoredManager.getAssetByPath(originalAsset.assetPath);
        expect(retrieved, isNotNull);
        expect(retrieved!.bytes, equals(originalAsset.bytes));
      });

      test('round-trip preserves multiple assets', () async {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final originalManager = AssetManager();
        final asset1 = originalManager.registerAsset(
          fileName: 'image1.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        );
        final asset2 = originalManager.registerAsset(
          fileName: 'image2.jpg',
          bytes: Uint8List.fromList([4, 5, 6, 7]),
        );
        final asset3 = originalManager.registerAsset(
          fileName: 'icon.svg',
          bytes: Uint8List.fromList([8, 9]),
        );

        final forgeBytes = await projectService.serializeWithAssets(
          project: project,
          assetManager: originalManager,
        );

        final restoredManager = AssetManager();
        await projectService.deserializeWithAssets(
          bytes: forgeBytes,
          assetManager: restoredManager,
        );

        expect(restoredManager.assets.length, 3);
        expect(restoredManager.getAsset(asset1.id), isNotNull);
        expect(restoredManager.getAsset(asset2.id), isNotNull);
        expect(restoredManager.getAsset(asset3.id), isNotNull);
      });
    });

    group('backwards compatibility', () {
      test('loads forge files without assets section', () async {
        // Simulate old format without assets
        final archive = Archive()
          ..addFile(
            ArchiveFile(
              'manifest.json',
              0,
              utf8.encode(jsonEncode(<String, dynamic>{
                'formatVersion': '1.0',
                'appVersion': '0.1.0',
                'projectId': 'test-id',
                'createdWith': 'FlutterForge',
                'timestamp': DateTime.now().toIso8601String(),
                // No 'assets' field
              })),
            ),
          )
          ..addFile(
            ArchiveFile(
              'project.json',
              0,
              utf8.encode(jsonEncode(<String, dynamic>{
                'id': 'test-id',
                'name': 'Old Project',
                'screens': <dynamic>[],
                'metadata': <String, dynamic>{
                  'createdAt': '2026-01-21T00:00:00.000',
                  'modifiedAt': '2026-01-21T00:00:00.000',
                  'forgeVersion': '0.0.1',
                  'flutterSdkVersion': '3.19.0',
                },
                'designTokens': <dynamic>[],
              })),
            ),
          );

        final forgeBytes = Uint8List.fromList(ZipEncoder().encode(archive));

        final assetManager = AssetManager();
        final project = await projectService.deserializeWithAssets(
          bytes: forgeBytes,
          assetManager: assetManager,
        );

        expect(project.name, 'Old Project');
        expect(assetManager.assets, isEmpty);
      });
    });
  });
}
