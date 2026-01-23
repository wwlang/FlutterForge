# J24: Preview and Development Tools

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J24 |
| Title | Preview and Development Tools |
| Actor | Developer building and testing widgets in IDE |
| Priority | P1 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ (extended in 3.35/3.38) |

## User Story

As a developer using FlutterForge to build widgets, I want to leverage Flutter's @Preview annotation system including theme/brightness support, localizations, and runtime version info so that I can validate my designs directly in the IDE and generate comprehensive preview metadata.

## Background

Flutter 3.32-3.38 progressively enhanced widget preview capabilities:

**Flutter 3.32:**
- `@Preview()` annotation for IDE widget preview
- `PlatformDispatcher.engineId` for engine identification
- Flutter version info accessible at runtime

**Flutter 3.35:**
- Preview theme/brightness support
- Preview localizations support
- Custom preview configurations

**Flutter 3.38:**
- `@MultiPreview` for multiple preview variations (covered in J21)

## Journey Stages

### S1: @Preview Annotation Export (3.32)

**Goal:** Generate @Preview annotations for FlutterForge widgets

#### Acceptance Criteria

```gherkin
Feature: @Preview Annotation Export
  As a developer
  I want my FlutterForge widgets to include @Preview annotations
  So that I can preview them in my IDE

  Scenario: Basic @Preview generation
    Given I have a custom widget on canvas
    When I export the code with "Include preview annotations" enabled
    Then the output includes @Preview annotation:
    """
    @Preview()
    Widget _previewMyWidget() => const MyWidget();
    """

  Scenario: Named preview
    Given I have configured a preview name
    When I export the code
    Then the annotation includes the name:
    """
    @Preview(name: 'Default State')
    """

  Scenario: Sized preview
    Given I have a widget with specific canvas size
    When I export the code
    Then the annotation includes dimensions:
    """
    @Preview(
      name: 'Mobile',
      width: 390,
      height: 844,
    )
    """
```

### S2: Theme and Brightness Previews (3.35)

**Goal:** Generate previews with theme/brightness variations

#### Acceptance Criteria

```gherkin
Feature: Theme-Aware Preview Export
  As a developer
  I want preview annotations with theme settings
  So that I can test light/dark modes in IDE

  Scenario: Light theme preview
    Given I have a widget configured for light theme
    When I export the code
    Then the annotation includes brightness:
    """
    @Preview(
      name: 'Light Mode',
      brightness: Brightness.light,
    )
    """

  Scenario: Dark theme preview
    Given I have a widget configured for dark theme
    When I export the code
    Then the annotation includes brightness:
    """
    @Preview(
      name: 'Dark Mode',
      brightness: Brightness.dark,
    )
    """

  Scenario: Theme matrix export
    Given I enable "Export Theme Matrix" option
    When I export the code
    Then both light and dark previews are generated:
    """
    @Preview(name: 'Light', brightness: Brightness.light)
    Widget _previewLight() => const MyWidget();

    @Preview(name: 'Dark', brightness: Brightness.dark)
    Widget _previewDark() => const MyWidget();
    """
```

### S3: Localization Previews (3.35)

**Goal:** Generate previews with different locale configurations

#### Acceptance Criteria

```gherkin
Feature: Localized Preview Export
  As a developer
  I want preview annotations with locale settings
  So that I can test localized content in IDE

  Scenario: Locale-specific preview
    Given I have a widget with localized text
    And I configure preview for Vietnamese locale
    When I export the code
    Then the annotation includes locale:
    """
    @Preview(
      name: 'Vietnamese',
      locale: Locale('vi'),
    )
    """

  Scenario: Multiple locale previews
    Given I enable "Export Locale Matrix" option
    And I select locales: en, vi, es
    When I export the code
    Then previews for each locale are generated

  Scenario: RTL locale preview
    Given I configure preview for Arabic locale
    When I export the code
    Then the annotation includes RTL locale:
    """
    @Preview(
      name: 'Arabic (RTL)',
      locale: Locale('ar'),
      textDirection: TextDirection.rtl,
    )
    """
```

### S4: Flutter Version Runtime Info (3.32)

**Goal:** Display and use Flutter version info in FlutterForge

#### Acceptance Criteria

```gherkin
Feature: Flutter Version Info
  As a developer
  I want to see Flutter version information
  So that I know which features are available

  Scenario: Display Flutter version in about dialog
    Given I open the Help > About FlutterForge dialog
    Then I see the Flutter SDK version
    And the Dart version
    And the FlutterForge version

  Scenario: Version-aware feature flags
    Given I am running on Flutter 3.32
    When a feature requires Flutter 3.35+
    Then the feature is disabled
    And a tooltip explains the version requirement

  Scenario: Export version comment
    Given I export code from FlutterForge
    When I enable "Include version info" option
    Then the output includes:
    """
    // Generated by FlutterForge v1.1.0
    // Requires Flutter 3.32+ / Dart 3.10+
    """

  Scenario: Engine ID for debugging
    Given I enable "Debug Mode" in FlutterForge
    Then the status bar shows PlatformDispatcher.engineId
    And this helps identify engine instances in multi-window setups
```

### S5: Custom Preview Configurations (3.35)

**Goal:** Create and export reusable preview configurations

#### Acceptance Criteria

```gherkin
Feature: Custom Preview Configurations
  As a developer
  I want to define reusable preview configurations
  So that I maintain consistent preview settings

  Scenario: Create custom preview config
    Given I open Preview Settings
    When I click "Create Custom Configuration"
    Then I can define:
      | Setting | Example |
      | Name | "iPhone Dark Mode" |
      | Width | 390 |
      | Height | 844 |
      | Brightness | Dark |
      | Locale | en |
      | Text Scale | 1.0 |

  Scenario: Export custom preview class
    Given I have custom configurations defined
    When I export with "Include custom preview classes" enabled
    Then the output includes custom annotation class:
    """
    class IPhoneDarkPreview extends Preview {
      const IPhoneDarkPreview({super.name}) : super(
        width: 390,
        height: 844,
        brightness: Brightness.dark,
      );
    }
    """

  Scenario: Apply custom preview to widget
    Given I have a custom preview configuration
    When I apply it to a widget
    Then the export uses the custom annotation:
    """
    @IPhoneDarkPreview(name: 'Login Screen')
    Widget _previewLogin() => const LoginScreen();
    """
```

## Preview Export Options

| Option | Description | Default |
|--------|-------------|---------|
| Include @Preview | Add basic preview annotation | true |
| Theme Matrix | Export light/dark variations | false |
| Locale Matrix | Export locale variations | false |
| Include Custom Classes | Export reusable preview classes | false |
| Include Version Info | Add Flutter version comment | true |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Annotation generation time | < 50ms |
| Custom class generation | < 100ms |
| Version detection | At app startup |
| Memory for preview metadata | < 100KB |

## Dependencies

- Code generator (existing)
- Preview panel (existing, J15, J21)
- Localization support (if available)
- Theme system (existing)

## Test Coverage Requirements

- Unit tests for @Preview annotation generation
- Unit tests for theme/brightness inclusion
- Unit tests for locale inclusion
- Unit tests for custom preview class generation
- Unit tests for version info extraction
- Integration tests for preview matrix export

## Implementation Notes

1. Use `VersionInfo` class to access Flutter/Dart versions
2. Preview annotations require Dart code emission (not code_builder)
3. Custom preview classes extend the Preview base class
4. Locale matrix should use project's supported locales
5. Consider preview annotation schema validation
