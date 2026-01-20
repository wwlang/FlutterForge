import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/services/auto_save_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auto-Save and Recovery (Task 4.6)', () {
    late AutoSaveService service;
    late InMemoryAutoSaveStorage storage;

    setUp(() {
      storage = InMemoryAutoSaveStorage();
      service = AutoSaveService(
        storage: storage,
        autoSaveInterval: const Duration(milliseconds: 100),
      );
    });

    tearDown(() {
      service.dispose();
    });

    group('Recovery Data', () {
      test('saves recovery data', () async {
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

        await service.saveRecoveryData(project);

        expect(storage.hasData, true);
      });

      test('loads recovery data', () async {
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

        await service.saveRecoveryData(project);

        final recovery = await service.loadRecoveryData();
        expect(recovery, isNotNull);
        expect(recovery?.project.name, 'Test Project');
      });

      test('clears recovery data', () async {
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

        await service.saveRecoveryData(project);
        await service.clearRecoveryData();

        expect(storage.hasData, false);
      });

      test('checks if recovery data exists', () async {
        expect(await service.hasRecoveryData(), false);

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

        await service.saveRecoveryData(project);

        expect(await service.hasRecoveryData(), true);
      });
    });

    group('RecoveryData Model', () {
      test('includes timestamp', () async {
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

        await service.saveRecoveryData(project);
        final recovery = await service.loadRecoveryData();

        expect(recovery?.timestamp, isNotNull);
        expect(
          recovery!.timestamp.difference(DateTime.now()).inSeconds.abs(),
          lessThan(5),
        );
      });

      test('includes original file path if saved', () async {
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

        await service.saveRecoveryData(
          project,
          originalPath: '/path/to/project.forge',
        );
        final recovery = await service.loadRecoveryData();

        expect(recovery?.originalPath, '/path/to/project.forge');
      });
    });

    group('Auto-Save Enable/Disable', () {
      test('can disable auto-save', () {
        expect(service.isEnabled, true);

        service.disable();

        expect(service.isEnabled, false);
      });

      test('can re-enable auto-save', () {
        service.disable();
        expect(service.isEnabled, false);

        service.enable();

        expect(service.isEnabled, true);
      });
    });
  });
}
