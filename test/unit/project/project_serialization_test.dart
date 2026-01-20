import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/services/project_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Project Serialization (Task 4.1)', () {
    late ProjectService projectService;

    setUp(() {
      projectService = ProjectService();
    });

    group('ForgeProject Model', () {
      test('creates project with required fields', () {
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

        expect(project.id, 'test-id');
        expect(project.name, 'Test Project');
        expect(project.screens, isEmpty);
        expect(project.designTokens, isEmpty);
      });

      test('creates project with screens', () {
        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'HomeScreen',
          rootNodeId: 'root-1',
          nodes: const {},
        );

        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: [screen],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        expect(project.screens.length, 1);
        expect(project.screens.first.name, 'HomeScreen');
      });

      test('creates project with design tokens', () {
        final token = DesignToken(
          id: 'token-1',
          name: 'primaryColor',
          type: TokenType.color,
          lightValue: '#6366F1',
          darkValue: '#818CF8',
        );

        final project = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
          designTokens: [token],
        );

        expect(project.designTokens.length, 1);
        expect(project.designTokens.first.name, 'primaryColor');
      });
    });

    group('ScreenDefinition Model', () {
      test('creates screen with widget nodes', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'color': '#FF0000'},
        );

        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'HomeScreen',
          rootNodeId: 'node-1',
          nodes: {'node-1': node.toJson()},
        );

        expect(screen.id, 'screen-1');
        expect(screen.name, 'HomeScreen');
        expect(screen.rootNodeId, 'node-1');
        expect(screen.nodes.containsKey('node-1'), true);
      });

      test('screen preserves nested widget hierarchy', () {
        final childNode = const WidgetNode(
          id: 'child-1',
          type: 'Text',
          properties: {'text': 'Hello'},
          parentId: 'parent-1',
        );

        final parentNode = const WidgetNode(
          id: 'parent-1',
          type: 'Column',
          properties: {},
          childrenIds: ['child-1'],
        );

        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'HomeScreen',
          rootNodeId: 'parent-1',
          nodes: {
            'parent-1': parentNode.toJson(),
            'child-1': childNode.toJson(),
          },
        );

        expect(screen.nodes.length, 2);
        expect(screen.nodes['parent-1'], isNotNull);
        expect(screen.nodes['child-1'], isNotNull);
      });
    });

    group('ProjectMetadata Model', () {
      test('creates metadata with required fields', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime(2026, 1, 21, 10, 30),
          modifiedAt: DateTime(2026, 1, 21, 14, 45),
          forgeVersion: '1.0.0',
        );

        expect(metadata.createdAt.year, 2026);
        expect(metadata.modifiedAt.hour, 14);
        expect(metadata.forgeVersion, '1.0.0');
        expect(metadata.flutterSdkVersion, '3.19.0');
      });

      test('creates metadata with optional description', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime(2026, 1, 21),
          modifiedAt: DateTime(2026, 1, 21),
          forgeVersion: '1.0.0',
          description: 'A test project',
        );

        expect(metadata.description, 'A test project');
      });
    });

    group('JSON Serialization', () {
      test('ForgeProject serializes to JSON', () {
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

        final json = project.toJson();

        expect(json['id'], 'test-id');
        expect(json['name'], 'Test Project');
        expect(json['screens'], isEmpty);
        expect(json['metadata'], isNotNull);
      });

      test('ForgeProject deserializes from JSON', () {
        final json = {
          'id': 'test-id',
          'name': 'Test Project',
          'screens': <dynamic>[],
          'metadata': {
            'createdAt': '2026-01-21T00:00:00.000',
            'modifiedAt': '2026-01-21T00:00:00.000',
            'forgeVersion': '1.0.0',
            'flutterSdkVersion': '3.19.0',
          },
          'designTokens': <dynamic>[],
        };

        final project = ForgeProject.fromJson(json);

        expect(project.id, 'test-id');
        expect(project.name, 'Test Project');
      });

      test('round-trip preserves all data via JSON encode/decode', () {
        final token = DesignToken(
          id: 'token-1',
          name: 'primary',
          type: TokenType.color,
          lightValue: '#6366F1',
        );

        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'padding': 16.0},
        );

        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'Main',
          rootNodeId: 'node-1',
          nodes: {'node-1': node.toJson()},
        );

        final original = ForgeProject(
          id: 'proj-1',
          name: 'My Project',
          screens: [screen],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
            description: 'Test',
          ),
          designTokens: [token],
        );

        // Use JSON encode/decode to simulate actual serialization
        final jsonString = jsonEncode(original.toJson());
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = ForgeProject.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.screens.length, 1);
        expect(restored.screens.first.name, 'Main');
        expect(restored.designTokens.length, 1);
        expect(restored.metadata.description, 'Test');
      });
    });

    group('ProjectService', () {
      test('creates new project with defaults', () {
        final project = projectService.createNewProject(
          name: 'Untitled Project',
        );

        expect(project.name, 'Untitled Project');
        expect(project.id, isNotEmpty);
        expect(project.screens, isEmpty);
        expect(project.metadata.forgeVersion, isNotEmpty);
        expect(project.metadata.createdAt, isNotNull);
      });

      test('creates project with default screen if requested', () {
        final project = projectService.createNewProject(
          name: 'My App',
          withDefaultScreen: true,
        );

        expect(project.screens.length, 1);
        expect(project.screens.first.name, 'Screen 1');
      });
    });

    group('.forge File Format', () {
      test('serializes project to ZIP bytes', () async {
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

        final bytes = await projectService.serializeToForgeFormat(project);

        expect(bytes, isNotEmpty);
        // Verify it's a valid ZIP
        final archive = ZipDecoder().decodeBytes(bytes);
        expect(archive.files.isNotEmpty, true);
      });

      test('forge file contains manifest.json', () async {
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

        final bytes = await projectService.serializeToForgeFormat(project);
        final archive = ZipDecoder().decodeBytes(bytes);

        ArchiveFile? manifestFile;
        for (final file in archive.files) {
          if (file.name == 'manifest.json' && file.isFile) {
            manifestFile = file;
            break;
          }
        }

        expect(manifestFile, isNotNull);
        final manifestContent = utf8.decode(manifestFile!.content as List<int>);
        final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;
        expect(manifest['formatVersion'], isNotNull);
        expect(manifest['projectId'], 'test-id');
      });

      test('forge file contains project.json', () async {
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

        final bytes = await projectService.serializeToForgeFormat(project);
        final archive = ZipDecoder().decodeBytes(bytes);

        ArchiveFile? projectFile;
        for (final file in archive.files) {
          if (file.name == 'project.json' && file.isFile) {
            projectFile = file;
            break;
          }
        }

        expect(projectFile, isNotNull);
        final projectContent = utf8.decode(projectFile!.content as List<int>);
        final projectJson = jsonDecode(projectContent) as Map<String, dynamic>;
        expect(projectJson['name'], 'Test Project');
      });

      test('deserializes from ZIP bytes', () async {
        final original = ForgeProject(
          id: 'test-id',
          name: 'Test Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final bytes = await projectService.serializeToForgeFormat(original);
        final restored = await projectService.deserializeFromForgeFormat(bytes);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
      });

      test('round-trip preserves complex project', () async {
        final node1 = const WidgetNode(
          id: 'node-1',
          type: 'Column',
          properties: {},
          childrenIds: ['node-2'],
        );

        final node2 = const WidgetNode(
          id: 'node-2',
          type: 'Text',
          properties: {'text': 'Hello World'},
          parentId: 'node-1',
        );

        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'HomeScreen',
          rootNodeId: 'node-1',
          nodes: {
            'node-1': node1.toJson(),
            'node-2': node2.toJson(),
          },
        );

        final token = DesignToken(
          id: 'token-1',
          name: 'accent',
          type: TokenType.color,
          lightValue: '#FF5722',
          darkValue: '#FF8A65',
        );

        final original = ForgeProject(
          id: 'complex-project',
          name: 'Complex Test',
          screens: [screen],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21, 10, 30),
            modifiedAt: DateTime(2026, 1, 21, 15, 45),
            forgeVersion: '1.0.0',
            description: 'A complex test project',
          ),
          designTokens: [token],
        );

        final bytes = await projectService.serializeToForgeFormat(original);
        final restored = await projectService.deserializeFromForgeFormat(bytes);

        expect(restored.id, 'complex-project');
        expect(restored.name, 'Complex Test');
        expect(restored.screens.length, 1);
        expect(restored.screens.first.nodes.length, 2);
        expect(restored.designTokens.length, 1);
        expect(restored.designTokens.first.name, 'accent');
        expect(restored.metadata.description, 'A complex test project');
      });

      test('throws on invalid ZIP data', () async {
        final invalidBytes = Uint8List.fromList([1, 2, 3, 4]);

        expect(
          () => projectService.deserializeFromForgeFormat(invalidBytes),
          throwsA(isA<ForgeFileException>()),
        );
      });

      test('throws on missing project.json', () async {
        // Create ZIP without project.json
        final archive = Archive();
        archive.addFile(ArchiveFile(
          'manifest.json',
          0,
          utf8.encode('{"formatVersion": "1.0"}'),
        ));
        final bytes = Uint8List.fromList(ZipEncoder().encode(archive));

        expect(
          () => projectService.deserializeFromForgeFormat(bytes),
          throwsA(isA<ForgeFileException>()),
        );
      });
    });

    group('Format Validation', () {
      test('validates format version compatibility', () async {
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

        final bytes = await projectService.serializeToForgeFormat(project);
        final archive = ZipDecoder().decodeBytes(bytes);

        ArchiveFile? manifestFile;
        for (final file in archive.files) {
          if (file.name == 'manifest.json' && file.isFile) {
            manifestFile = file;
            break;
          }
        }

        final manifestContent = utf8.decode(manifestFile!.content as List<int>);
        final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;

        expect(manifest['formatVersion'], '1.0');
      });

      test('file size proportional to content', () async {
        // Empty project
        final emptyProject = projectService.createNewProject(name: 'Empty');
        final emptyBytes =
            await projectService.serializeToForgeFormat(emptyProject);

        // Project with content
        final nodes = <String, dynamic>{};
        for (var i = 0; i < 100; i++) {
          final node = WidgetNode(
            id: 'node-$i',
            type: 'Container',
            properties: {'padding': i.toDouble()},
          );
          nodes['node-$i'] = node.toJson();
        }

        final screen = ScreenDefinition(
          id: 'screen-1',
          name: 'BigScreen',
          rootNodeId: 'node-0',
          nodes: nodes,
        );

        final largeProject = ForgeProject(
          id: 'large-id',
          name: 'Large Project',
          screens: [screen],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final largeBytes =
            await projectService.serializeToForgeFormat(largeProject);

        // Large project should be bigger
        expect(largeBytes.length, greaterThan(emptyBytes.length));
      });
    });
  });
}
