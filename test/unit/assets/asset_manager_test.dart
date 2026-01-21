import 'dart:typed_data';

import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asset Import (Task 7.1)', () {
    group('AssetManager', () {
      late AssetManager assetManager;

      setUp(() {
        assetManager = AssetManager();
      });

      group('Asset Validation', () {
        test('validates PNG files as supported', () {
          expect(assetManager.isSupported('logo.png'), isTrue);
          expect(assetManager.isSupported('LOGO.PNG'), isTrue);
        });

        test('validates JPEG files as supported', () {
          expect(assetManager.isSupported('photo.jpg'), isTrue);
          expect(assetManager.isSupported('photo.jpeg'), isTrue);
          expect(assetManager.isSupported('PHOTO.JPG'), isTrue);
        });

        test('validates WebP files as supported', () {
          expect(assetManager.isSupported('image.webp'), isTrue);
        });

        test('validates GIF files as supported', () {
          expect(assetManager.isSupported('animation.gif'), isTrue);
        });

        test('validates SVG files as supported', () {
          expect(assetManager.isSupported('icon.svg'), isTrue);
        });

        test('rejects unsupported file types', () {
          expect(assetManager.isSupported('document.pdf'), isFalse);
          expect(assetManager.isSupported('data.json'), isFalse);
          expect(assetManager.isSupported('code.dart'), isFalse);
          expect(assetManager.isSupported('noextension'), isFalse);
        });
      });

      group('File Size Validation', () {
        test('accepts files under 10MB', () {
          final bytes = Uint8List(5 * 1024 * 1024); // 5MB
          final result = assetManager.validateSize(bytes);
          expect(result.isValid, isTrue);
          expect(result.requiresConfirmation, isFalse);
        });

        test('requires confirmation for files over 10MB', () {
          final bytes = Uint8List(15 * 1024 * 1024); // 15MB
          final result = assetManager.validateSize(bytes);
          expect(result.isValid, isTrue);
          expect(result.requiresConfirmation, isTrue);
          expect(result.sizeInMB, closeTo(15, 0.1));
        });

        test('rejects files over 50MB', () {
          final bytes = Uint8List(55 * 1024 * 1024); // 55MB
          final result = assetManager.validateSize(bytes);
          expect(result.isValid, isFalse);
        });
      });

      group('Asset Registration', () {
        test('registers new asset with generated path', () {
          final asset = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          expect(asset.id, isNotEmpty);
          expect(asset.fileName, equals('logo.png'));
          expect(asset.assetPath, startsWith('assets/'));
          expect(asset.assetPath, endsWith('.png'));
          expect(asset.bytes.length, equals(3));
        });

        test('generates unique asset paths for duplicate names', () {
          final asset1 = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );
          final asset2 = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([4, 5, 6]),
          );

          expect(asset1.assetPath, isNot(equals(asset2.assetPath)));
        });

        test('stores registered assets in registry', () {
          expect(assetManager.assets, isEmpty);

          assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          expect(assetManager.assets, hasLength(1));
        });

        test('provides asset by ID lookup', () {
          final registered = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          final found = assetManager.getAsset(registered.id);
          expect(found, isNotNull);
          expect(found!.fileName, equals('logo.png'));
        });

        test('provides asset by path lookup', () {
          final registered = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          final found = assetManager.getAssetByPath(registered.assetPath);
          expect(found, isNotNull);
          expect(found!.id, equals(registered.id));
        });
      });

      group('Asset Removal', () {
        test('removes asset from registry', () {
          final asset = assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          expect(assetManager.assets, hasLength(1));

          assetManager.removeAsset(asset.id);

          expect(assetManager.assets, isEmpty);
        });

        test('returns false for non-existent asset removal', () {
          final result = assetManager.removeAsset('non-existent-id');
          expect(result, isFalse);
        });
      });

      group('Asset Serialization', () {
        test('exports assets as map for serialization', () {
          assetManager.registerAsset(
            fileName: 'logo.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          final exported = assetManager.exportAssets();
          expect(exported, hasLength(1));
          expect(exported.first['fileName'], equals('logo.png'));
          expect(exported.first['bytes'], isA<List<int>>());
        });

        test('imports assets from serialized data', () {
          final imported = AssetManager.fromExported([
            {
              'id': 'test-id',
              'fileName': 'imported.png',
              'assetPath': 'assets/imported.png',
              'bytes': [1, 2, 3],
            },
          ]);

          expect(imported.assets, hasLength(1));
          expect(imported.assets.first.id, equals('test-id'));
          expect(imported.assets.first.fileName, equals('imported.png'));
        });
      });
    });

    group('ProjectAsset', () {
      test('creates with required properties', () {
        final asset = ProjectAsset(
          id: 'test-id',
          fileName: 'logo.png',
          assetPath: 'assets/logo.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        );

        expect(asset.id, equals('test-id'));
        expect(asset.fileName, equals('logo.png'));
        expect(asset.assetPath, equals('assets/logo.png'));
        expect(asset.bytes.length, equals(3));
      });

      test('computes file extension', () {
        final png = ProjectAsset(
          id: 'id',
          fileName: 'logo.png',
          assetPath: 'assets/logo.png',
          bytes: Uint8List(0),
        );
        expect(png.extension, equals('png'));

        final jpg = ProjectAsset(
          id: 'id',
          fileName: 'photo.JPEG',
          assetPath: 'assets/photo.jpeg',
          bytes: Uint8List(0),
        );
        expect(jpg.extension, equals('jpeg'));
      });

      test('computes file size in bytes', () {
        final asset = ProjectAsset(
          id: 'id',
          fileName: 'logo.png',
          assetPath: 'assets/logo.png',
          bytes: Uint8List(1024),
        );
        expect(asset.sizeBytes, equals(1024));
      });

      test('serializes to JSON', () {
        final asset = ProjectAsset(
          id: 'test-id',
          fileName: 'logo.png',
          assetPath: 'assets/logo.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        );

        final json = asset.toJson();
        expect(json['id'], equals('test-id'));
        expect(json['fileName'], equals('logo.png'));
        expect(json['assetPath'], equals('assets/logo.png'));
        expect(json['bytes'], equals([1, 2, 3]));
      });

      test('deserializes from JSON', () {
        final json = {
          'id': 'test-id',
          'fileName': 'logo.png',
          'assetPath': 'assets/logo.png',
          'bytes': [1, 2, 3],
        };

        final asset = ProjectAsset.fromJson(json);
        expect(asset.id, equals('test-id'));
        expect(asset.fileName, equals('logo.png'));
        expect(asset.bytes.length, equals(3));
      });
    });

    group('SizeValidationResult', () {
      test('creates valid result for small files', () {
        final result = SizeValidationResult.valid(sizeBytes: 1024);
        expect(result.isValid, isTrue);
        expect(result.requiresConfirmation, isFalse);
      });

      test('creates confirmation-required result for large files', () {
        final result = SizeValidationResult.needsConfirmation(
          sizeBytes: 15 * 1024 * 1024,
        );
        expect(result.isValid, isTrue);
        expect(result.requiresConfirmation, isTrue);
        expect(result.sizeInMB, closeTo(15, 0.1));
      });

      test('creates invalid result for oversized files', () {
        final result = SizeValidationResult.invalid(
          reason: 'File exceeds 50MB limit',
        );
        expect(result.isValid, isFalse);
        expect(result.errorMessage, contains('50MB'));
      });
    });
  });
}
