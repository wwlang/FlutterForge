# J23: New Flutter 3.38 Widgets

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J23 |
| Title | New Flutter 3.38 Widgets |
| Actor | Designer adding new widgets to palette |
| Priority | P2 |
| Phase | 9 - Flutter 3.38 Enhancements |
| Flutter Version | 3.38+ |

## User Story

As a designer using FlutterForge, I want access to new widgets and widget enhancements from Flutter 3.38 (including CupertinoLinearActivityIndicator and improved DatePicker) so that I can use the latest Flutter features in my designs.

## New Widgets to Add

### CupertinoLinearActivityIndicator

iOS-style linear progress indicator (new in 3.38)

### Enhanced CupertinoDatePicker

Now supports `selectableDayPredicate` for controlling which days can be selected

### Enhanced DropdownMenu

New `cursorHeight` and `menuController` properties (covered in J22)

## Journey Stages

### S1: CupertinoLinearActivityIndicator

**Goal:** Add iOS-style linear progress indicator to palette

#### Acceptance Criteria

```gherkin
Feature: CupertinoLinearActivityIndicator Widget
  As a designer
  I want to use iOS-style linear progress indicator
  So that my iOS designs follow platform conventions

  Scenario: Add CupertinoLinearActivityIndicator to canvas
    Given I open the widget palette
    When I expand the "Cupertino" or "Progress" category
    Then I see "Cupertino Linear Activity Indicator"
    When I drag it to canvas
    Then a linear progress indicator appears

  Scenario: Configure activity indicator properties
    Given I have a CupertinoLinearActivityIndicator selected
    When I open the properties panel
    Then I can configure:
      | Property | Type | Default |
      | value | double (0.0-1.0) | null (indeterminate) |
      | color | Color | CupertinoColors.activeBlue |
      | backgroundColor | Color | null |
      | borderRadius | BorderRadius | default |

  Scenario: Indeterminate vs determinate mode
    Given I have a CupertinoLinearActivityIndicator
    When I leave "value" empty (null)
    Then the indicator shows indeterminate animation
    When I set "value" to 0.5
    Then the indicator shows 50% progress (static)

  Scenario: Preview animation
    Given I have an indeterminate indicator on canvas
    When I enter preview mode
    Then the animation plays smoothly
    And I can see the iOS-style progress animation
```

### S2: Enhanced CupertinoDatePicker

**Goal:** Expose selectableDayPredicate property

#### Acceptance Criteria

```gherkin
Feature: CupertinoDatePicker Enhancement
  As a designer
  I want to configure which days are selectable
  So that I can design date pickers with restrictions

  Scenario: Configure selectable days
    Given I have a CupertinoDatePicker selected
    When I open the properties panel
    Then I see "Selectable Days" configuration section

  Scenario: Weekdays only preset
    Given I am configuring selectable days
    When I select "Weekdays Only" preset
    Then Saturday and Sunday are disabled in preview
    And the generated code includes predicate for weekdays

  Scenario: Future dates only preset
    Given I am configuring selectable days
    When I select "Future Dates Only" preset
    Then past dates are disabled in preview
    And the generated code compares against DateTime.now()

  Scenario: Custom date range
    Given I am configuring selectable days
    When I select "Custom Range"
    And set start date and end date
    Then only dates in that range are selectable
    And the generated code includes range check

  Scenario: Preview disabled dates
    Given I have configured selectable days
    When I preview the date picker
    Then disabled dates appear grayed out
    And I cannot select them
```

### S3: Accessibility Improvements

**Goal:** Support new HeadingLevel and expanded semantics

#### Acceptance Criteria

```gherkin
Feature: Semantics Enhancements
  As a designer
  I want to configure accessibility semantics
  So that my designs are accessible

  Scenario: Configure heading level
    Given I have a Text widget selected
    When I expand the "Accessibility" section in properties
    Then I see "Heading Level" dropdown
    And I can select levels 1-6

  Scenario: Heading level code generation
    Given I have a Text with heading level 1
    When I export the code
    Then the output includes:
    """
    Semantics(
      headingLevel: 1,
      child: Text('Title'),
    )
    """

  Scenario: Configure expanded state
    Given I have a collapsible widget (ExpansionTile, ExpansionPanel)
    When I open the properties panel
    Then I see "Expanded" semantics property
    And it automatically maps to the expanded state

  Scenario: Semantics preview
    Given I have widgets with semantic properties
    When I enable "Accessibility Overlay" in preview
    Then I see semantic boundaries highlighted
    And heading levels are indicated
    And expanded states are shown
```

### S4: Text Layout Debugging

**Goal:** Add debug visualization for text layout

#### Acceptance Criteria

```gherkin
Feature: Text Layout Debug Mode
  As a designer
  I want to see text layout boundaries
  So that I can debug text overflow and alignment

  Scenario: Enable text layout debugging
    Given I have Text widgets on canvas
    When I enable "Debug Text Layout" in View menu
    Then text layout boxes are visualized:
      | Box | Color |
      | Paragraph bounds | Blue outline |
      | Line bounds | Green outline |
      | Character bounds | Red dots (on hover) |

  Scenario: Debug text overflow
    Given I have a Text widget with potential overflow
    When debug mode is enabled
    Then I see where text would be clipped
    And overflow indicators appear at boundaries

  Scenario: Debug text alignment
    Given I have a Text with alignment configured
    When debug mode is enabled
    Then I see the available space vs used space
    And alignment direction is indicated

  Scenario: Toggle debug mode per widget
    Given I have multiple Text widgets
    When I select one and toggle "Debug This Widget"
    Then only that widget shows debug visualization
    And others render normally
```

## Widget Palette Categories

| Category | New/Updated Widgets |
|----------|-------------------|
| Progress | CupertinoLinearActivityIndicator |
| Cupertino | CupertinoDatePicker (enhanced) |
| Input | DropdownMenu (enhanced in J22) |

## Widget Properties Summary

### CupertinoLinearActivityIndicator

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| value | double? | null | Progress (null = indeterminate) |
| color | Color? | activeBlue | Progress color |
| backgroundColor | Color? | null | Track color |
| borderRadius | BorderRadius? | default | Corner radius |

### CupertinoDatePicker (New Properties)

| Property | Type | Description |
|----------|------|-------------|
| selectableDayPredicate | Function? | Returns true for selectable days |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Widget render time | < 16ms |
| Animation frame rate | 60fps |
| Memory per widget | < 100KB |
| Code generation time | < 100ms |

## Dependencies

- Widget registry (existing)
- Widget palette (existing)
- Properties panel (existing)
- Code generator (existing)

## Test Coverage Requirements

- Unit tests for CupertinoLinearActivityIndicator rendering
- Unit tests for selectableDayPredicate logic
- Unit tests for heading level code generation
- Unit tests for text debug visualization
- Integration tests for new widgets on canvas
- Visual regression tests for Cupertino styling

## Implementation Notes

1. CupertinoLinearActivityIndicator needs Cupertino theme context in preview
2. selectableDayPredicate requires predicate builder UI
3. HeadingLevel semantics require Semantics wrapper in code gen
4. Text debug uses Flutter's debugPaintTextLayoutBoxes flag
5. Consider "Cupertino Mode" toggle for canvas to show iOS styling
