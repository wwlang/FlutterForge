# Integration Tests

The integration tests have been moved to `test/integration/` so they run in headless mode
using `TestWidgetsFlutterBinding` instead of `IntegrationTestWidgetsFlutterBinding`.

## Running Integration Tests

```bash
# Run all integration tests (headless)
flutter test test/integration/

# Run a specific test file
flutter test test/integration/journey_canvas_test.dart
```

## Test Files

The following journey tests are available in `test/integration/`:

- `app_smoke_test.dart` - App launch smoke test (G5 validation)
- `journey_animation_test.dart` - Animation Studio (J10)
- `journey_canvas_test.dart` - Canvas interactions (G4.5 E2E)
- `journey_codegen_test.dart` - Code generation
- `journey_design_system_test.dart` - Design System (J09)
- `journey_edit_operations_test.dart` - Edit operations (J08)
- `journey_palette_test.dart` - Widget palette
- `journey_project_test.dart` - Project management (J07)
- `journey_properties_test.dart` - Properties panel
- `journey_tree_test.dart` - Widget tree

## Test Utilities

`test_utils.dart` provides shared helpers for:
- Dragging widgets to canvas
- Selecting widgets
- Keyboard shortcuts (undo, redo, copy, paste, etc.)
- Panel navigation
