import 'package:flutter/material.dart';
import 'package:flutter_forge/features/preview/responsive_breakpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Responsive Breakpoints (Task 7.5)', () {
    group('ResponsiveBreakpoint', () {
      test('compact breakpoint has correct values', () {
        const breakpoint = ResponsiveBreakpoint.compact;

        expect(breakpoint.name, 'Compact');
        expect(breakpoint.minWidth, 0);
        expect(breakpoint.maxWidth, 599);
      });

      test('medium breakpoint has correct values', () {
        const breakpoint = ResponsiveBreakpoint.medium;

        expect(breakpoint.name, 'Medium');
        expect(breakpoint.minWidth, 600);
        expect(breakpoint.maxWidth, 839);
      });

      test('expanded breakpoint has correct values', () {
        const breakpoint = ResponsiveBreakpoint.expanded;

        expect(breakpoint.name, 'Expanded');
        expect(breakpoint.minWidth, 840);
        expect(breakpoint.maxWidth, 1199);
      });

      test('large breakpoint has correct values', () {
        const breakpoint = ResponsiveBreakpoint.large;

        expect(breakpoint.name, 'Large');
        expect(breakpoint.minWidth, 1200);
        expect(breakpoint.maxWidth, 1599);
      });

      test('extraLarge breakpoint has correct values', () {
        const breakpoint = ResponsiveBreakpoint.extraLarge;

        expect(breakpoint.name, 'Extra Large');
        expect(breakpoint.minWidth, 1600);
        expect(breakpoint.maxWidth, double.infinity);
      });

      test('fromWidth returns compact for small widths', () {
        expect(
          ResponsiveBreakpoint.fromWidth(320),
          ResponsiveBreakpoint.compact,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(375),
          ResponsiveBreakpoint.compact,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(599),
          ResponsiveBreakpoint.compact,
        );
      });

      test('fromWidth returns medium for tablet-like widths', () {
        expect(
          ResponsiveBreakpoint.fromWidth(600),
          ResponsiveBreakpoint.medium,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(768),
          ResponsiveBreakpoint.medium,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(839),
          ResponsiveBreakpoint.medium,
        );
      });

      test('fromWidth returns expanded for larger tablets', () {
        expect(
          ResponsiveBreakpoint.fromWidth(840),
          ResponsiveBreakpoint.expanded,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(1024),
          ResponsiveBreakpoint.expanded,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(1199),
          ResponsiveBreakpoint.expanded,
        );
      });

      test('fromWidth returns large for desktop widths', () {
        expect(
          ResponsiveBreakpoint.fromWidth(1200),
          ResponsiveBreakpoint.large,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(1400),
          ResponsiveBreakpoint.large,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(1599),
          ResponsiveBreakpoint.large,
        );
      });

      test('fromWidth returns extraLarge for wide screens', () {
        expect(
          ResponsiveBreakpoint.fromWidth(1600),
          ResponsiveBreakpoint.extraLarge,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(1920),
          ResponsiveBreakpoint.extraLarge,
        );
        expect(
          ResponsiveBreakpoint.fromWidth(2560),
          ResponsiveBreakpoint.extraLarge,
        );
      });

      test('isMobile returns true for compact and medium', () {
        expect(ResponsiveBreakpoint.compact.isMobile, isTrue);
        expect(ResponsiveBreakpoint.medium.isMobile, isFalse);
        expect(ResponsiveBreakpoint.expanded.isMobile, isFalse);
      });

      test('isTablet returns true for medium and expanded', () {
        expect(ResponsiveBreakpoint.compact.isTablet, isFalse);
        expect(ResponsiveBreakpoint.medium.isTablet, isTrue);
        expect(ResponsiveBreakpoint.expanded.isTablet, isTrue);
        expect(ResponsiveBreakpoint.large.isTablet, isFalse);
      });

      test('isDesktop returns true for large and extraLarge', () {
        expect(ResponsiveBreakpoint.expanded.isDesktop, isFalse);
        expect(ResponsiveBreakpoint.large.isDesktop, isTrue);
        expect(ResponsiveBreakpoint.extraLarge.isDesktop, isTrue);
      });
    });

    group('ResponsiveBreakpointProvider', () {
      test('default width is 375', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(responsiveBreakpointProvider);

        expect(state.viewportWidth, 375);
        expect(state.currentBreakpoint, ResponsiveBreakpoint.compact);
      });

      test('setViewportWidth updates breakpoint', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Set to medium width
        container
            .read(responsiveBreakpointProvider.notifier)
            .setViewportWidth(700);

        final state = container.read(responsiveBreakpointProvider);
        expect(state.viewportWidth, 700);
        expect(state.currentBreakpoint, ResponsiveBreakpoint.medium);
      });

      test('breakpoint changes as width crosses thresholds', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(responsiveBreakpointProvider.notifier);

        // Start compact
        expect(
          container.read(responsiveBreakpointProvider).currentBreakpoint,
          ResponsiveBreakpoint.compact,
        );

        // Cross to medium
        notifier.setViewportWidth(600);
        expect(
          container.read(responsiveBreakpointProvider).currentBreakpoint,
          ResponsiveBreakpoint.medium,
        );

        // Cross to expanded
        notifier.setViewportWidth(840);
        expect(
          container.read(responsiveBreakpointProvider).currentBreakpoint,
          ResponsiveBreakpoint.expanded,
        );

        // Cross to large
        notifier.setViewportWidth(1200);
        expect(
          container.read(responsiveBreakpointProvider).currentBreakpoint,
          ResponsiveBreakpoint.large,
        );

        // Cross to extraLarge
        notifier.setViewportWidth(1600);
        expect(
          container.read(responsiveBreakpointProvider).currentBreakpoint,
          ResponsiveBreakpoint.extraLarge,
        );
      });
    });

    group('MediaQuerySimulator', () {
      testWidgets('provides simulated MediaQueryData', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(responsiveBreakpointProvider.notifier)
            .setViewportWidth(400);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: MediaQuerySimulator(
                child: _MediaQueryReader(),
              ),
            ),
          ),
        );

        // MediaQueryReader should see the simulated width
        expect(find.text('Width: 400.0'), findsOneWidget);
      });

      testWidgets('simulates device pixel ratio', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(responsiveBreakpointProvider.notifier)
            .setDevicePixelRatio(3);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: MediaQuerySimulator(
                child: _PixelRatioReader(),
              ),
            ),
          ),
        );

        expect(find.text('Pixel Ratio: 3.0'), findsOneWidget);
      });

      testWidgets('simulates padding (safe areas)', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(responsiveBreakpointProvider.notifier).setPadding(
              const EdgeInsets.only(top: 47, bottom: 34),
            );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: MediaQuerySimulator(
                child: _PaddingReader(),
              ),
            ),
          ),
        );

        expect(find.text('Top: 47.0'), findsOneWidget);
        expect(find.text('Bottom: 34.0'), findsOneWidget);
      });

      testWidgets('simulates text scale factor', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(responsiveBreakpointProvider.notifier)
            .setTextScaleFactor(1.5);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: MediaQuerySimulator(
                child: _TextScaleReader(),
              ),
            ),
          ),
        );

        expect(find.text('Text Scale: 1.5'), findsOneWidget);
      });

      testWidgets(
        'combines with device frame for full simulation',
        (tester) async {
          final container = ProviderContainer();
          addTearDown(container.dispose);

          // Simulate iPhone-like settings
          container.read(responsiveBreakpointProvider.notifier)
            ..setViewportWidth(393)
            ..setViewportHeight(852)
            ..setDevicePixelRatio(3)
            ..setPadding(const EdgeInsets.only(top: 59, bottom: 34));

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(
                home: MediaQuerySimulator(
                  child: _FullMediaQueryReader(),
                ),
              ),
            ),
          );

          expect(find.text('Size: Size(393.0, 852.0)'), findsOneWidget);
          expect(find.text('Pixel Ratio: 3.0'), findsOneWidget);
          expect(find.text('Padding Top: 59.0'), findsOneWidget);
        },
      );
    });

    group('ResponsiveBreakpointState', () {
      test('copyWith creates new instance with updated values', () {
        const original = ResponsiveBreakpointState(
          viewportWidth: 500,
          viewportHeight: 900,
          devicePixelRatio: 3,
        );

        final updated = original.copyWith(viewportWidth: 600);

        expect(updated.viewportWidth, 600);
        expect(updated.viewportHeight, 900);
        expect(updated.devicePixelRatio, 3);
      });

      test('currentBreakpoint updates when viewport width changes', () {
        const compact = ResponsiveBreakpointState(viewportWidth: 350);
        const medium = ResponsiveBreakpointState(viewportWidth: 700);
        const expanded = ResponsiveBreakpointState(viewportWidth: 1000);

        expect(compact.currentBreakpoint, ResponsiveBreakpoint.compact);
        expect(medium.currentBreakpoint, ResponsiveBreakpoint.medium);
        expect(expanded.currentBreakpoint, ResponsiveBreakpoint.expanded);
      });
    });

    group('BreakpointIndicator widget', () {
      testWidgets('displays current breakpoint name', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: BreakpointIndicator(),
              ),
            ),
          ),
        );

        expect(find.text('Compact'), findsOneWidget);
      });

      testWidgets('updates when breakpoint changes', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: BreakpointIndicator(),
              ),
            ),
          ),
        );

        expect(find.text('Compact'), findsOneWidget);

        // Change to medium
        container
            .read(responsiveBreakpointProvider.notifier)
            .setViewportWidth(700);
        await tester.pumpAndSettle();

        expect(find.text('Medium'), findsOneWidget);
      });

      testWidgets('shows viewport dimensions', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(responsiveBreakpointProvider.notifier)
          ..setViewportWidth(350)
          ..setViewportHeight(800);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: BreakpointIndicator(),
              ),
            ),
          ),
        );

        expect(find.text('350 x 800'), findsOneWidget);
      });
    });
  });
}

// Helper widgets for testing MediaQuery simulation

class _MediaQueryReader extends StatelessWidget {
  const _MediaQueryReader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text('Width: $width');
  }
}

class _PixelRatioReader extends StatelessWidget {
  const _PixelRatioReader();

  @override
  Widget build(BuildContext context) {
    final ratio = MediaQuery.of(context).devicePixelRatio;
    return Text('Pixel Ratio: $ratio');
  }
}

class _PaddingReader extends StatelessWidget {
  const _PaddingReader();

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Top: ${padding.top}'),
        Text('Bottom: ${padding.bottom}'),
      ],
    );
  }
}

class _TextScaleReader extends StatelessWidget {
  const _TextScaleReader();

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    final scale = textScaler.scale(1);
    return Text('Text Scale: $scale');
  }
}

class _FullMediaQueryReader extends StatelessWidget {
  const _FullMediaQueryReader();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Size: ${mediaQuery.size}'),
        Text('Pixel Ratio: ${mediaQuery.devicePixelRatio}'),
        Text('Padding Top: ${mediaQuery.padding.top}'),
      ],
    );
  }
}
