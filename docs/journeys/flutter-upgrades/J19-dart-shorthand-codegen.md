# J19: Dart 3.10 Dot Shorthand in Code Generation

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J19 |
| Title | Dart 3.10 Dot Shorthand in Code Generation |
| Actor | Developer exporting code from FlutterForge |
| Priority | P1 |
| Phase | 9 - Flutter 3.38 Enhancements |
| Flutter Version | 3.38+ (Dart 3.10+) |

## User Story

As a developer exporting Flutter code from FlutterForge, I want the generated code to use Dart 3.10's dot shorthand syntax (e.g., `.start` instead of `MainAxisAlignment.start`) so that my exported code is cleaner, more readable, and follows modern Dart idioms.

## Background

Dart 3.10 introduces dot shorthand syntax for enum values and static constants when the type can be inferred from context. This makes code more concise:

```dart
// Before (Dart 3.9)
Row(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.center,
)

// After (Dart 3.10)
Row(
  mainAxisAlignment: .start,
  crossAxisAlignment: .center,
)
```

## Journey Stages

### S1: Enable Dot Shorthand Generation

**Goal:** Code generator outputs dot shorthand syntax when context allows

#### Acceptance Criteria

```gherkin
Feature: Dot Shorthand Code Generation
  As a developer
  I want generated code to use dot shorthand
  So that my exported code is modern and concise

  Scenario: Row with MainAxisAlignment uses shorthand
    Given I have a Row widget on the canvas
    And mainAxisAlignment is set to "center"
    When I export the code
    Then the output contains "mainAxisAlignment: .center"
    And NOT "mainAxisAlignment: MainAxisAlignment.center"

  Scenario: Column with CrossAxisAlignment uses shorthand
    Given I have a Column widget on the canvas
    And crossAxisAlignment is set to "stretch"
    When I export the code
    Then the output contains "crossAxisAlignment: .stretch"

  Scenario: Container with BoxFit uses shorthand
    Given I have a Container with an Image child
    And the Image has fit set to "cover"
    When I export the code
    Then the output contains "fit: .cover"

  Scenario: Text with TextAlign uses shorthand
    Given I have a Text widget
    And textAlign is set to "right"
    When I export the code
    Then the output contains "textAlign: .right"

  Scenario: FontWeight uses shorthand
    Given I have a Text widget with bold style
    When I export the code
    Then the output contains "fontWeight: .bold"
    Or "fontWeight: .w700"

  Scenario: EdgeInsets uses shorthand
    Given I have a Padding widget
    And padding is set to EdgeInsets.all(16)
    When I export the code
    Then the output contains "padding: .all(16)"
```

### S2: Contextual Shorthand Application

**Goal:** Apply shorthand only where type inference works

#### Acceptance Criteria

```gherkin
Feature: Context-Aware Shorthand
  As a developer
  I want shorthand used only where valid
  So that exported code always compiles

  Scenario: Shorthand in constructor parameters
    Given a widget has a parameter with enum type
    When the type is inferable from constructor signature
    Then shorthand is used

  Scenario: No shorthand in variables
    Given code generates a local variable
    And the type is not explicitly declared
    Then full enum name is used (no shorthand)

  Scenario: Shorthand with Colors
    Given I set a color to Colors.blue
    When I export the code
    Then the output uses "Colors.blue" (no shorthand for Colors)
    Because Colors requires the class prefix

  Scenario: Shorthand with Alignment
    Given I have an Align widget
    And alignment is set to Alignment.topLeft
    When I export the code
    Then the output contains "alignment: .topLeft"

  Scenario: Shorthand with BorderRadius
    Given I have a Container with decoration
    And borderRadius is circular(8)
    When I export the code
    Then the output contains "borderRadius: .circular(8)"
```

### S3: Version-Aware Generation

**Goal:** Toggle shorthand based on target Dart version

#### Acceptance Criteria

```gherkin
Feature: Dart Version Targeting
  As a developer
  I want to control code generation for different Dart versions
  So that I can export code compatible with my project

  Scenario: Dart 3.10+ target (default)
    Given export settings use Dart 3.10+ target
    When I export code
    Then dot shorthand syntax is used where applicable

  Scenario: Dart 3.9 compatibility mode
    Given I enable "Dart 3.9 compatibility" in export settings
    When I export code
    Then full enum names are used (no shorthand)
    And code is compatible with Dart 3.9

  Scenario: Version setting persists
    Given I change the Dart version target
    When I close and reopen the project
    Then the version setting is preserved

  Scenario: Version indicator in code panel
    Given the code panel is open
    Then the target Dart version is displayed
    And I can click to change it
```

## Supported Shorthand Types

| Type | Example Before | Example After |
|------|----------------|---------------|
| MainAxisAlignment | `MainAxisAlignment.center` | `.center` |
| CrossAxisAlignment | `CrossAxisAlignment.stretch` | `.stretch` |
| MainAxisSize | `MainAxisSize.min` | `.min` |
| TextAlign | `TextAlign.center` | `.center` |
| TextOverflow | `TextOverflow.ellipsis` | `.ellipsis` |
| FontWeight | `FontWeight.bold` | `.bold` |
| FontStyle | `FontStyle.italic` | `.italic` |
| BoxFit | `BoxFit.cover` | `.cover` |
| Alignment | `Alignment.center` | `.center` |
| AlignmentDirectional | `AlignmentDirectional.topStart` | `.topStart` |
| EdgeInsets | `EdgeInsets.all(16)` | `.all(16)` |
| EdgeInsetsDirectional | `EdgeInsetsDirectional.only(start: 8)` | `.only(start: 8)` |
| BorderRadius | `BorderRadius.circular(8)` | `.circular(8)` |
| Axis | `Axis.horizontal` | `.horizontal` |
| VerticalDirection | `VerticalDirection.down` | `.down` |
| TextDirection | `TextDirection.ltr` | `.ltr` |
| Clip | `Clip.antiAlias` | `.antiAlias` |
| StackFit | `StackFit.expand` | `.expand` |
| Overflow | `Overflow.visible` | `.visible` |
| WrapAlignment | `WrapAlignment.start` | `.start` |

## Non-Shorthand Types

These types should NOT use shorthand (require class prefix):

| Type | Reason |
|------|--------|
| Colors | Static class, not enum |
| Icons | Static class, not enum |
| Duration | Constructor call |
| Offset | Constructor call |
| Size | Constructor call |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Code generation time | No change from current (<500ms) |
| Output size reduction | ~10-15% fewer characters |
| Compilation success | 100% (always valid Dart) |

## Dependencies

- DartGenerator (existing)
- Code export settings (existing)
- code_builder package

## Test Coverage Requirements

- Unit tests for each shorthand type
- Unit tests for non-shorthand exclusions
- Unit tests for version targeting
- Integration tests for export with shorthand
- Regression tests for compilation success

## Implementation Notes

The `code_builder` package may need updates to support dot shorthand, or custom emit logic may be required. Consider:

1. Custom `DartEmitter` that recognizes shorthand-eligible types
2. Post-processing step that converts full names to shorthand
3. Type registry mapping enum types to their shorthand eligibility
