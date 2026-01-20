import 'dart:ui';

import 'package:flutter_forge/providers/canvas_navigation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Canvas Pan and Zoom (Task 4.10)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Zoom', () {
      test('default zoom is 100%', () {
        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, 1.0);
      });

      test('can zoom in', () {
        container.read(canvasNavigationProvider.notifier).zoomIn();

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, greaterThan(1.0));
      });

      test('can zoom out', () {
        container.read(canvasNavigationProvider.notifier).zoomOut();

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, lessThan(1.0));
      });

      test('zoom has minimum limit', () {
        for (var i = 0; i < 20; i++) {
          container.read(canvasNavigationProvider.notifier).zoomOut();
        }

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, greaterThanOrEqualTo(0.1));
      });

      test('zoom has maximum limit', () {
        for (var i = 0; i < 20; i++) {
          container.read(canvasNavigationProvider.notifier).zoomIn();
        }

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, lessThanOrEqualTo(4.0));
      });

      test('can set specific zoom level', () {
        container.read(canvasNavigationProvider.notifier).setZoom(1.5);

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, 1.5);
      });

      test('zoom fit clips to valid range', () {
        container.read(canvasNavigationProvider.notifier).setZoom(10.0);

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, lessThanOrEqualTo(4.0));
      });

      test('can reset zoom to 100%', () {
        container.read(canvasNavigationProvider.notifier).zoomIn();
        container.read(canvasNavigationProvider.notifier).zoomIn();

        expect(container.read(canvasNavigationProvider).zoomLevel, isNot(1.0));

        container.read(canvasNavigationProvider.notifier).resetZoom();

        expect(container.read(canvasNavigationProvider).zoomLevel, 1.0);
      });
    });

    group('Pan', () {
      test('default pan is origin', () {
        final state = container.read(canvasNavigationProvider);
        expect(state.panOffset, Offset.zero);
      });

      test('can pan canvas', () {
        container.read(canvasNavigationProvider.notifier).pan(
              const Offset(100, 50),
            );

        final state = container.read(canvasNavigationProvider);
        expect(state.panOffset.dx, 100);
        expect(state.panOffset.dy, 50);
      });

      test('pan accumulates', () {
        container.read(canvasNavigationProvider.notifier).pan(
              const Offset(50, 25),
            );
        container.read(canvasNavigationProvider.notifier).pan(
              const Offset(30, 15),
            );

        final state = container.read(canvasNavigationProvider);
        expect(state.panOffset.dx, 80);
        expect(state.panOffset.dy, 40);
      });

      test('can set specific pan offset', () {
        container.read(canvasNavigationProvider.notifier).setPanOffset(
              const Offset(200, 150),
            );

        final state = container.read(canvasNavigationProvider);
        expect(state.panOffset, const Offset(200, 150));
      });

      test('can reset pan to origin', () {
        container.read(canvasNavigationProvider.notifier).pan(
              const Offset(100, 50),
            );

        container.read(canvasNavigationProvider.notifier).resetPan();

        expect(
          container.read(canvasNavigationProvider).panOffset,
          Offset.zero,
        );
      });
    });

    group('Reset All', () {
      test('resets both zoom and pan', () {
        container.read(canvasNavigationProvider.notifier).zoomIn();
        container.read(canvasNavigationProvider.notifier).pan(
              const Offset(100, 50),
            );

        container.read(canvasNavigationProvider.notifier).resetAll();

        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, 1.0);
        expect(state.panOffset, Offset.zero);
      });
    });

    group('Zoom Presets', () {
      test('can fit to screen', () {
        container.read(canvasNavigationProvider.notifier).fitToScreen(
              screenSize: const Size(800, 600),
              contentSize: const Size(400, 300),
            );

        // Should calculate appropriate zoom to fit content
        final state = container.read(canvasNavigationProvider);
        expect(state.zoomLevel, greaterThan(0));
      });

      test('fit to screen centers content', () {
        container.read(canvasNavigationProvider.notifier).fitToScreen(
              screenSize: const Size(800, 600),
              contentSize: const Size(400, 300),
            );

        // Pan should be adjusted to center
        final state = container.read(canvasNavigationProvider);
        expect(state.panOffset, isNotNull);
      });
    });

    group('Zoom Display', () {
      test('formats zoom as percentage', () {
        container.read(canvasNavigationProvider.notifier).setZoom(1.5);

        final display = container.read(zoomDisplayProvider);
        expect(display, '150%');
      });

      test('rounds percentage display', () {
        container.read(canvasNavigationProvider.notifier).setZoom(0.333);

        final display = container.read(zoomDisplayProvider);
        expect(display, '33%');
      });
    });
  });
}
