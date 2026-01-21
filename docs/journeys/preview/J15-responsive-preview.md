# J15: Responsive Preview

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J15 |
| Title | Responsive Preview |
| Actor | Designer testing responsive layouts |
| Priority | P1 |
| Phase | 7 - Assets & Preview |

## User Story

As a designer building Flutter UIs, I want to preview my designs in different device frames (iPhone, Android, Tablet, Desktop) so that I can ensure my layouts work across screen sizes.

## Journey Stages

### S1: Device Frame Selector

**Goal:** Switch between device form factors

#### Acceptance Criteria

```gherkin
Feature: Device Frame Selector
  As a designer
  I want to select different device frames
  So that I can preview my design on various screen sizes

  Scenario: View device frame toolbar
    Given I am on the design canvas
    Then I see a device frame selector in the canvas toolbar
    And it shows the current device (default: Custom)

  Scenario: Select iPhone device
    Given I click the device frame selector
    When I choose "iPhone 15 Pro"
    Then the canvas viewport changes to 393x852 points
    And an iPhone frame overlay appears around the canvas
    And the status bar area is indicated

  Scenario: Select Android device
    Given I click the device frame selector
    When I choose "Pixel 8"
    Then the canvas viewport changes to 412x915 points
    And an Android frame overlay appears
    And the navigation bar area is indicated

  Scenario: Available device presets
    Given I open the device frame selector
    Then I see the following device categories:
      | Category | Devices |
      | iOS | iPhone 15 Pro, iPhone 15, iPhone SE, iPad Pro 12.9, iPad mini |
      | Android | Pixel 8, Pixel 8 Pro, Samsung S24, Samsung Tab S9 |
      | Desktop | MacBook Pro 14", Windows Laptop, Custom |

  Scenario: Custom viewport size
    Given I select "Custom" from the device selector
    When I enter width: 600 and height: 400
    Then the canvas viewport adjusts to 600x400
    And no device frame is shown
```

### S2: Device Frame Specifications

**Goal:** Accurate device dimensions and safe areas

#### Acceptance Criteria

```gherkin
Feature: Device Specifications
  As a designer
  I want accurate device dimensions
  So that my designs match real devices

  Scenario: iPhone 15 Pro specifications
    Given I select "iPhone 15 Pro"
    Then the following values are applied:
      | Property | Value |
      | Width | 393 |
      | Height | 852 |
      | Pixel Ratio | 3.0 |
      | Safe Area Top | 59 |
      | Safe Area Bottom | 34 |
      | Corner Radius | 55 |

  Scenario: iPad Pro 12.9 specifications
    Given I select "iPad Pro 12.9"
    Then the following values are applied:
      | Property | Value |
      | Width | 1024 |
      | Height | 1366 |
      | Pixel Ratio | 2.0 |
      | Safe Area Top | 24 |
      | Safe Area Bottom | 20 |
      | Corner Radius | 18 |

  Scenario: Safe area visualization
    Given I have a device frame selected
    Then the safe areas are shown as subtle overlays
    And I can toggle safe area visibility on/off
    And widgets outside safe areas show a warning indicator
```

### S3: Breakpoint-Based Layout Preview

**Goal:** Preview responsive layouts at different breakpoints

#### Acceptance Criteria

```gherkin
Feature: Breakpoint Preview
  As a designer
  I want to preview my layouts at different breakpoints
  So that I can verify responsive behavior

  Scenario: Breakpoint indicator
    Given I have a device frame selected
    Then I see the current breakpoint indicator:
      | Width Range | Breakpoint |
      | < 600 | Mobile |
      | 600-840 | Tablet |
      | 840-1200 | Desktop |
      | > 1200 | Large Desktop |

  Scenario: Quick breakpoint switching
    Given I am designing a responsive layout
    When I use the breakpoint quick-switch buttons
    Then the canvas snaps to:
      | Button | Width |
      | Mobile | 375 |
      | Tablet | 768 |
      | Desktop | 1024 |
      | Large | 1440 |

  Scenario: Responsive widget preview
    Given I have a layout using LayoutBuilder
    When I change the device frame size
    Then the layout responds to the new constraints
    And I see how widgets adapt to the space

  Scenario: Orientation toggle
    Given I have a mobile device selected
    When I click the orientation toggle
    Then the viewport rotates (393x852 -> 852x393)
    And the device frame rotates accordingly
    And my layout adapts to the new orientation
```

### S4: MediaQuery Simulation

**Goal:** Simulate MediaQuery values for preview

#### Acceptance Criteria

```gherkin
Feature: MediaQuery Simulation
  As a designer
  I want to simulate MediaQuery values
  So that my MediaQuery-dependent layouts preview correctly

  Scenario: Simulated MediaQuery values
    Given I have a device frame selected
    Then the canvas provides simulated MediaQuery with:
      | Property | Simulated |
      | size | Device viewport size |
      | devicePixelRatio | Device pixel ratio |
      | padding | Safe area insets |
      | viewInsets | 0 (no keyboard) |
      | platformBrightness | Current theme mode |

  Scenario: Keyboard simulation
    Given I have a TextField selected
    When I enable "Show keyboard" in preview settings
    Then viewInsets.bottom is set to keyboard height (336)
    And the layout shows how it responds to keyboard

  Scenario: Text scale simulation
    Given I want to test accessibility
    When I adjust the text scale slider (0.8x - 2.0x)
    Then all text in the preview scales accordingly
    And I can verify text doesn't overflow

  Scenario: Dark mode toggle
    Given I am previewing my design
    When I toggle dark mode in the preview toolbar
    Then platformBrightness switches to dark
    And theme-aware widgets update their appearance
```

## Device Specifications Table

| Device | Width | Height | Ratio | Safe Top | Safe Bottom |
|--------|-------|--------|-------|----------|-------------|
| iPhone 15 Pro | 393 | 852 | 3.0 | 59 | 34 |
| iPhone 15 | 390 | 844 | 3.0 | 47 | 34 |
| iPhone SE | 375 | 667 | 2.0 | 20 | 0 |
| iPad Pro 12.9 | 1024 | 1366 | 2.0 | 24 | 20 |
| iPad mini | 744 | 1133 | 2.0 | 24 | 20 |
| Pixel 8 | 412 | 915 | 2.75 | 36 | 48 |
| Pixel 8 Pro | 448 | 998 | 2.75 | 36 | 48 |
| Samsung S24 | 360 | 780 | 3.0 | 32 | 44 |
| MacBook Pro 14 | 1512 | 982 | 2.0 | 0 | 0 |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Frame switch time | < 100ms |
| Viewport resize | < 16ms (60fps) |
| Safe area calculation | < 1ms |
| Memory per frame asset | < 500KB |

## Dependencies

- DesignCanvas (existing)
- CanvasNavigationProvider (existing)
- ThemeModeProvider (existing)

## Test Coverage Requirements

- Unit tests for device specifications
- Unit tests for safe area calculations
- Unit tests for breakpoint detection
- Unit tests for MediaQuery simulation
- Integration tests for frame switching
- Visual regression tests for device frames
