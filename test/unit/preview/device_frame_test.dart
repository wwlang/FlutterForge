import 'package:flutter/material.dart';
import 'package:flutter_forge/features/preview/device_frame.dart';
import 'package:flutter_forge/features/preview/device_specs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Device Frame Selector (Task 7.4)', () {
    group('DeviceSpecs', () {
      test('iPhone 15 Pro has correct specifications', () {
        const spec = DeviceSpecs.iPhone15Pro;

        expect(spec.name, 'iPhone 15 Pro');
        expect(spec.width, 393);
        expect(spec.height, 852);
        expect(spec.pixelRatio, 3.0);
        expect(spec.safeAreaTop, 59);
        expect(spec.safeAreaBottom, 34);
        expect(spec.cornerRadius, 55);
        expect(spec.platform, DevicePlatform.iOS);
      });

      test('iPhone 15 has correct specifications', () {
        const spec = DeviceSpecs.iPhone15;

        expect(spec.name, 'iPhone 15');
        expect(spec.width, 390);
        expect(spec.height, 844);
        expect(spec.pixelRatio, 3.0);
        expect(spec.safeAreaTop, 47);
        expect(spec.safeAreaBottom, 34);
      });

      test('iPhone SE has correct specifications', () {
        const spec = DeviceSpecs.iPhoneSE;

        expect(spec.name, 'iPhone SE');
        expect(spec.width, 375);
        expect(spec.height, 667);
        expect(spec.pixelRatio, 2.0);
        expect(spec.safeAreaTop, 20);
        expect(spec.safeAreaBottom, 0);
      });

      test('iPad Pro 12.9 has correct specifications', () {
        const spec = DeviceSpecs.iPadPro129;

        expect(spec.name, 'iPad Pro 12.9');
        expect(spec.width, 1024);
        expect(spec.height, 1366);
        expect(spec.pixelRatio, 2.0);
        expect(spec.safeAreaTop, 24);
        expect(spec.safeAreaBottom, 20);
        expect(spec.cornerRadius, 18);
      });

      test('iPad mini has correct specifications', () {
        const spec = DeviceSpecs.iPadMini;

        expect(spec.name, 'iPad mini');
        expect(spec.width, 744);
        expect(spec.height, 1133);
        expect(spec.pixelRatio, 2.0);
      });

      test('Pixel 8 has correct specifications', () {
        const spec = DeviceSpecs.pixel8;

        expect(spec.name, 'Pixel 8');
        expect(spec.width, 412);
        expect(spec.height, 915);
        expect(spec.pixelRatio, 2.75);
        expect(spec.safeAreaTop, 36);
        expect(spec.safeAreaBottom, 48);
        expect(spec.platform, DevicePlatform.android);
      });

      test('Pixel 8 Pro has correct specifications', () {
        const spec = DeviceSpecs.pixel8Pro;

        expect(spec.name, 'Pixel 8 Pro');
        expect(spec.width, 448);
        expect(spec.height, 998);
        expect(spec.pixelRatio, 2.75);
      });

      test('Samsung S24 has correct specifications', () {
        const spec = DeviceSpecs.samsungS24;

        expect(spec.name, 'Samsung S24');
        expect(spec.width, 360);
        expect(spec.height, 780);
        expect(spec.pixelRatio, 3.0);
        expect(spec.safeAreaTop, 32);
        expect(spec.safeAreaBottom, 44);
      });

      test('MacBook Pro 14 has correct specifications', () {
        const spec = DeviceSpecs.macBookPro14;

        expect(spec.name, 'MacBook Pro 14"');
        expect(spec.width, 1512);
        expect(spec.height, 982);
        expect(spec.pixelRatio, 2.0);
        expect(spec.safeAreaTop, 0);
        expect(spec.safeAreaBottom, 0);
        expect(spec.platform, DevicePlatform.desktop);
      });

      test('all devices list contains all defined devices', () {
        const allDevices = DeviceSpecs.allDevices;

        expect(allDevices.length, greaterThanOrEqualTo(9));
        expect(allDevices.map((d) => d.name), contains('iPhone 15 Pro'));
        expect(allDevices.map((d) => d.name), contains('Pixel 8'));
        expect(allDevices.map((d) => d.name), contains('MacBook Pro 14"'));
      });

      test('iOS devices list contains only iOS devices', () {
        const iosDevices = DeviceSpecs.iosDevices;

        expect(iosDevices, isNotEmpty);
        for (final device in iosDevices) {
          expect(device.platform, DevicePlatform.iOS);
        }
      });

      test('Android devices list contains only Android devices', () {
        const androidDevices = DeviceSpecs.androidDevices;

        expect(androidDevices, isNotEmpty);
        for (final device in androidDevices) {
          expect(device.platform, DevicePlatform.android);
        }
      });

      test('Desktop devices list contains only desktop devices', () {
        const desktopDevices = DeviceSpecs.desktopDevices;

        expect(desktopDevices, isNotEmpty);
        for (final device in desktopDevices) {
          expect(device.platform, DevicePlatform.desktop);
        }
      });
    });

    group('DeviceSpec properties', () {
      test('size returns correct Size', () {
        const spec = DeviceSpecs.iPhone15Pro;

        expect(spec.size, const Size(393, 852));
      });

      test('landscapeSize returns rotated Size', () {
        const spec = DeviceSpecs.iPhone15Pro;

        expect(spec.landscapeSize, const Size(852, 393));
      });

      test('safeAreaInsets returns EdgeInsets', () {
        const spec = DeviceSpecs.iPhone15Pro;
        final insets = spec.safeAreaInsets;

        expect(insets.top, 59);
        expect(insets.bottom, 34);
        expect(insets.left, 0);
        expect(insets.right, 0);
      });

      test('landscapeSafeAreaInsets returns rotated insets', () {
        const spec = DeviceSpecs.iPhone15Pro;
        final insets = spec.landscapeSafeAreaInsets;

        // In landscape, top/bottom become left/right
        expect(insets.left, 59);
        expect(insets.right, 34);
        expect(insets.top, 0);
        expect(insets.bottom, 0);
      });
    });

    group('DeviceFrameProvider', () {
      test('default device is Custom', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(deviceFrameProvider);

        expect(state.selectedDevice, isNull);
        expect(state.isCustom, isTrue);
      });

      test('can select a device', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        final state = container.read(deviceFrameProvider);
        expect(state.selectedDevice, DeviceSpecs.iPhone15Pro);
        expect(state.isCustom, isFalse);
      });

      test('can set custom size', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(deviceFrameProvider.notifier).setCustomSize(600, 400);

        final state = container.read(deviceFrameProvider);
        expect(state.isCustom, isTrue);
        expect(state.customWidth, 600);
        expect(state.customHeight, 400);
        expect(state.viewportSize, const Size(600, 400));
      });

      test('viewportSize uses device size when device selected', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        final state = container.read(deviceFrameProvider);
        expect(state.viewportSize, const Size(393, 852));
      });

      test('can toggle orientation', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        // Default is portrait
        var state = container.read(deviceFrameProvider);
        expect(state.isPortrait, isTrue);
        expect(state.viewportSize, const Size(393, 852));

        // Toggle to landscape
        container.read(deviceFrameProvider.notifier).toggleOrientation();

        state = container.read(deviceFrameProvider);
        expect(state.isPortrait, isFalse);
        expect(state.viewportSize, const Size(852, 393));
      });

      test('toggleOrientation works for custom size', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(deviceFrameProvider.notifier).setCustomSize(600, 400);

        // Toggle to landscape (should swap dimensions)
        container.read(deviceFrameProvider.notifier).toggleOrientation();

        final state = container.read(deviceFrameProvider);
        expect(state.viewportSize, const Size(400, 600));
      });

      test('can toggle safe area visibility', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Default is visible
        var state = container.read(deviceFrameProvider);
        expect(state.showSafeAreas, isTrue);

        container.read(deviceFrameProvider.notifier).toggleSafeAreaVisibility();

        state = container.read(deviceFrameProvider);
        expect(state.showSafeAreas, isFalse);
      });

      test(
        'currentSafeAreaInsets returns device insets when device selected',
        () {
          final container = ProviderContainer();
          addTearDown(container.dispose);

          container
              .read(deviceFrameProvider.notifier)
              .selectDevice(DeviceSpecs.iPhone15Pro);

          final state = container.read(deviceFrameProvider);
          expect(state.currentSafeAreaInsets.top, 59);
          expect(state.currentSafeAreaInsets.bottom, 34);
        },
      );

      test('currentSafeAreaInsets respects orientation', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);
        container.read(deviceFrameProvider.notifier).toggleOrientation();

        final state = container.read(deviceFrameProvider);
        // In landscape, safe areas are on sides
        expect(state.currentSafeAreaInsets.left, 59);
        expect(state.currentSafeAreaInsets.right, 34);
        expect(state.currentSafeAreaInsets.top, 0);
      });

      test('currentSafeAreaInsets returns zero for custom size', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(deviceFrameProvider);
        expect(state.currentSafeAreaInsets, EdgeInsets.zero);
      });
    });

    group('DeviceFrameWidget', () {
      testWidgets(
        'renders child without frame when custom size',
        (tester) async {
          // Set a small custom size that fits in test window
          final container = ProviderContainer();
          addTearDown(container.dispose);

          container.read(deviceFrameProvider.notifier).setCustomSize(300, 400);

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(
                home: Scaffold(
                  body: DeviceFrame(
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          );

          // Should render child
          expect(find.text('Test'), findsOneWidget);

          // Should not have device frame decoration
          expect(find.byType(DeviceFrameOverlay), findsNothing);
        },
      );

      testWidgets('renders device frame when device selected', (tester) async {
        // Use iPhone SE which fits in default test window (375x667)
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhoneSE);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: DeviceFrame(
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should render child
        expect(find.text('Test'), findsOneWidget);

        // Should have device frame overlay
        expect(find.byType(DeviceFrameOverlay), findsOneWidget);
      });

      testWidgets(
        'renders safe area indicators when enabled',
        (tester) async {
          // Use iPhone SE which fits in default test window
          final container = ProviderContainer();
          addTearDown(container.dispose);

          container
              .read(deviceFrameProvider.notifier)
              .selectDevice(DeviceSpecs.iPhoneSE);

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: DeviceFrame(
                      child: Text('Test'),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Should have safe area indicators
          expect(find.byType(SafeAreaIndicator), findsWidgets);
        },
      );

      testWidgets(
        'constrains child to device viewport size',
        (tester) async {
          // Use iPhone SE which fits in default test window (375x667)
          final container = ProviderContainer();
          addTearDown(container.dispose);

          container
              .read(deviceFrameProvider.notifier)
              .selectDevice(DeviceSpecs.iPhoneSE);

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: const MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: Center(
                      child: DeviceFrame(
                        child: Placeholder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Find the constrained box
          final constrainedBox = tester.widget<SizedBox>(
            find
                .ancestor(
                  of: find.byType(Placeholder),
                  matching: find.byType(SizedBox),
                )
                .first,
          );

          expect(constrainedBox.width, 375);
          expect(constrainedBox.height, 667);
        },
      );
    });

    group('DeviceFrameSelector widget', () {
      testWidgets('shows current device name', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        expect(find.text('iPhone 15 Pro'), findsOneWidget);
      });

      testWidgets('shows "Custom" when no device selected', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        expect(find.text('Custom'), findsOneWidget);
      });

      testWidgets('opens dropdown with device categories', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        // Tap the selector
        await tester.tap(find.byType(DeviceFrameSelector));
        await tester.pumpAndSettle();

        // Should show categories
        expect(find.text('iOS'), findsOneWidget);
        expect(find.text('Android'), findsOneWidget);
        expect(find.text('Desktop'), findsOneWidget);
      });

      testWidgets('selecting device updates provider', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        // Initially custom
        expect(container.read(deviceFrameProvider).isCustom, isTrue);

        // Open dropdown
        await tester.tap(find.byType(DeviceFrameSelector));
        await tester.pumpAndSettle();

        // Select iPhone 15 Pro
        await tester.tap(find.text('iPhone 15 Pro'));
        await tester.pumpAndSettle();

        // Provider should be updated
        expect(
          container.read(deviceFrameProvider).selectedDevice?.name,
          'iPhone 15 Pro',
        );
      });

      testWidgets('has orientation toggle button', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        // Should have orientation toggle
        expect(find.byIcon(Icons.screen_rotation), findsOneWidget);
      });

      testWidgets('orientation toggle changes viewport', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(deviceFrameProvider.notifier)
            .selectDevice(DeviceSpecs.iPhone15Pro);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: DeviceFrameSelector(),
              ),
            ),
          ),
        );

        // Initially portrait
        expect(container.read(deviceFrameProvider).isPortrait, isTrue);

        // Tap orientation toggle
        await tester.tap(find.byIcon(Icons.screen_rotation));
        await tester.pumpAndSettle();

        // Should be landscape
        expect(container.read(deviceFrameProvider).isPortrait, isFalse);
      });
    });
  });
}
