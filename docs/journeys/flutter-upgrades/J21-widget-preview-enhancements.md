# J21: Widget Preview Enhancements (MultiPreview)

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J21 |
| Title | Widget Preview Enhancements (MultiPreview) |
| Actor | Designer creating and organizing widget variations |
| Priority | P1 |
| Phase | 9 - Flutter 3.38 Enhancements |
| Flutter Version | 3.38+ |

## User Story

As a designer building component libraries in FlutterForge, I want to create multiple preview configurations for a single widget (different sizes, themes, states) and organize them into groups so that I can efficiently validate all variations and export comprehensive preview documentation.

## Background

Flutter 3.38 enhances the Widget Preview feature with:
- **MultiPreview**: Single annotation creates multiple previews
- **Custom Preview annotations**: Reusable preview configurations
- **Runtime transformations**: Dynamic preview modifications
- **Group property**: Organize previews into logical groups

FlutterForge can leverage these for:
1. Generating preview matrices (light/dark x sizes)
2. Exporting preview annotations with code
3. Grouping widget variants in the palette
4. Building component documentation

## Journey Stages

### S1: Multiple Widget States Preview

**Goal:** Preview a widget in multiple states simultaneously

#### Acceptance Criteria

```gherkin
Feature: Multi-State Preview
  As a designer
  I want to preview multiple widget states at once
  So that I can compare variations side by side

  Scenario: Add state variation
    Given I have a Button widget selected
    When I click "Add Preview Variation" in the preview panel
    Then a new preview variant is created
    And I can configure it independently (disabled, loading, etc.)

  Scenario: View all variations
    Given I have multiple preview variations defined
    When I open the preview panel
    Then all variations display in a grid
    And each shows its configuration label

  Scenario: Theme matrix preview
    Given I have a widget with variations
    When I enable "Theme Matrix" toggle
    Then each variation shows in both light and dark theme
    And the grid expands to show the matrix

  Scenario: Size matrix preview
    Given I have a widget with variations
    When I enable "Size Matrix" toggle
    Then each variation shows at multiple sizes:
      | Size | Width |
      | Small | 320 |
      | Medium | 390 |
      | Large | 768 |

  Scenario: Combined matrix preview
    Given I enable both Theme and Size matrix
    Then I see a comprehensive grid:
      | Variation | Light/320 | Light/390 | Light/768 | Dark/320 | Dark/390 | Dark/768 |
      | Normal | Preview | Preview | Preview | Preview | Preview | Preview |
      | Disabled | Preview | Preview | Preview | Preview | Preview | Preview |
```

### S2: Preview Groups Organization

**Goal:** Organize previews into logical groups

#### Acceptance Criteria

```gherkin
Feature: Preview Groups
  As a designer
  I want to group related previews
  So that my component library is organized

  Scenario: Create preview group
    Given I have multiple widgets
    When I select widgets and click "Create Group"
    Then a new preview group is created
    And I can name it (e.g., "Button Variants")

  Scenario: View grouped previews
    Given I have preview groups defined
    When I open the preview organizer
    Then groups are displayed as collapsible sections
    And I can expand/collapse each group

  Scenario: Assign widget to group
    Given I have a preview group "Form Inputs"
    When I drag a TextField widget to that group
    Then the widget's previews appear in that group

  Scenario: Export group as documentation
    Given I have a preview group "Navigation Components"
    When I click "Export Group Documentation"
    Then a Markdown file generates with:
      | Content |
      | Group name as heading |
      | Each widget with preview image |
      | Properties table |
      | Code snippet |
```

### S3: Custom Preview Configurations

**Goal:** Create reusable preview configurations

#### Acceptance Criteria

```gherkin
Feature: Custom Preview Configs
  As a designer
  I want to save and reuse preview configurations
  So that I maintain consistency across my component library

  Scenario: Save preview configuration
    Given I have configured a preview with specific settings:
      | Setting | Value |
      | Theme | Dark |
      | Device | iPhone 15 Pro |
      | Scale | 1.0 |
    When I click "Save Configuration"
    Then I can name it (e.g., "Dark iPhone Preview")
    And it appears in my saved configurations

  Scenario: Apply saved configuration
    Given I have a widget without preview configured
    When I select my "Dark iPhone Preview" configuration
    Then those settings apply to the widget
    And the preview updates accordingly

  Scenario: Configuration presets
    Given I open the configuration selector
    Then I see built-in presets:
      | Preset | Description |
      | All Themes | Light + Dark |
      | All Platforms | iOS + Android + Desktop |
      | Accessibility | Normal + Large Text + High Contrast |
      | Responsive | Mobile + Tablet + Desktop sizes |

  Scenario: Edit configuration
    Given I have a saved configuration
    When I right-click and select "Edit"
    Then I can modify its settings
    And all widgets using it update
```

### S4: Preview Annotation Export

**Goal:** Export preview configurations as Flutter annotations

#### Acceptance Criteria

```gherkin
Feature: Preview Annotation Export
  As a developer
  I want preview configurations exported as annotations
  So that my IDE shows the same previews

  Scenario: Export single preview annotation
    Given I have a widget with preview configured
    When I export the code
    Then the output includes @Preview annotation:
    """
    @Preview(
      name: 'Default',
      width: 390,
      height: 844,
    )
    """

  Scenario: Export MultiPreview annotation
    Given I have a widget with multiple variations
    When I export the code
    Then the output includes @MultiPreview annotations:
    """
    @MultiPreview([
      Preview(name: 'Light', brightness: Brightness.light),
      Preview(name: 'Dark', brightness: Brightness.dark),
    ])
    """

  Scenario: Export custom preview annotation
    Given I have reusable preview configurations
    When I export with "Include custom annotations" option
    Then the output includes custom annotation class:
    """
    class DarkMobilePreview extends Preview {
      const DarkMobilePreview() : super(
        brightness: Brightness.dark,
        width: 390,
        height: 844,
      );
    }
    """

  Scenario: Group annotation export
    Given I have a preview group
    When I export the group
    Then each widget includes group property:
    """
    @Preview(
      name: 'Primary Button',
      group: 'Buttons',
    )
    """
```

### S5: Runtime Preview Transformations

**Goal:** Apply dynamic transformations to previews

#### Acceptance Criteria

```gherkin
Feature: Preview Transformations
  As a designer
  I want to apply transformations to previews
  So that I can test edge cases

  Scenario: Text scale transformation
    Given I have a widget preview
    When I enable "Text Scale" transformation
    And set scale to 2.0
    Then the preview shows the widget with 2x text size
    And I can verify text overflow handling

  Scenario: Locale transformation
    Given I have a widget with localized text
    When I enable "Locale" transformation
    And select different locales
    Then the preview shows the widget in each locale
    And I can verify text fits in all languages

  Scenario: Color blindness simulation
    Given I have a widget preview
    When I enable "Color Blindness" transformation
    Then I can select simulation types:
      | Type | Description |
      | Protanopia | Red-blind |
      | Deuteranopia | Green-blind |
      | Tritanopia | Blue-blind |
    And the preview applies color filters

  Scenario: Reduced motion
    Given I have a widget with animations
    When I enable "Reduced Motion" transformation
    Then animations are disabled in preview
    And I verify the static states work
```

## Preview Configuration Schema

```yaml
preview:
  name: "Button Variations"
  group: "Components/Buttons"
  variations:
    - name: "Primary"
      theme: light
      properties:
        variant: primary
    - name: "Secondary"
      theme: light
      properties:
        variant: secondary
  matrix:
    themes: [light, dark]
    sizes: [320, 390, 768]
  transformations:
    - textScale: 1.0
    - textScale: 2.0
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Preview render time | < 100ms per variant |
| Matrix generation | < 500ms for 12 cells |
| Memory per preview | < 2MB |
| Group export time | < 2s for 10 widgets |

## Dependencies

- Preview panel (existing, J15)
- Code generator (existing)
- Device frame selector (existing)
- Theme mode toggle (existing)

## Test Coverage Requirements

- Unit tests for preview variation management
- Unit tests for group operations
- Unit tests for annotation generation
- Unit tests for transformation application
- Integration tests for matrix preview rendering
- Visual regression tests for preview output

## Implementation Notes

1. Preview variations stored per-widget in project file
2. Groups stored at project level with widget references
3. Annotation export requires code_builder extension
4. Transformations use MediaQuery simulation (existing)
5. Consider lazy loading for large preview matrices
