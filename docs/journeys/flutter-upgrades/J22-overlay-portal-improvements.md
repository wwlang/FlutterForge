# J22: OverlayPortal Improvements

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J22 |
| Title | OverlayPortal Improvements |
| Actor | Designer building dropdown menus and popups |
| Priority | P2 |
| Phase | 9 - Flutter 3.38 Enhancements |
| Flutter Version | 3.38+ |

## User Story

As a designer building UIs with dropdowns, tooltips, and popup menus in FlutterForge, I want the canvas to accurately preview overlay behaviors using Flutter 3.38's improved OverlayPortal API so that my designs match the final runtime behavior.

## Background

Flutter 3.38 enhances OverlayPortal with:
- **overlayChildLayoutBuilder**: Choose which Overlay ancestor to use
- **Simpler overlay management**: Less boilerplate for common patterns
- **Better hit testing**: Improved interaction with overlays

This benefits FlutterForge by:
1. More accurate preview of dropdown/popup widgets
2. Better canvas interaction with overlay elements
3. Simplified implementation of context menus in the editor itself
4. Support for nested overlay scenarios

## Journey Stages

### S1: DropdownMenu Widget Enhancement

**Goal:** Expose new DropdownMenu properties in properties panel

#### Acceptance Criteria

```gherkin
Feature: DropdownMenu Properties
  As a designer
  I want to configure all DropdownMenu options
  So that I can customize dropdown behavior

  Scenario: Configure cursor height
    Given I have a DropdownMenu widget selected
    When I open the properties panel
    Then I see "Cursor Height" property
    And I can set it to a numeric value (e.g., 20)

  Scenario: Configure menu controller
    Given I have a DropdownMenu widget
    When I check "Expose Controller" option
    Then the generated code includes MenuController
    And the controller is accessible for programmatic control

  Scenario: Preview dropdown open state
    Given I have a DropdownMenu widget on canvas
    When I click "Preview Open State" button
    Then the dropdown menu shows in open position
    And I can see how it overlays other content

  Scenario: Dropdown positioning preview
    Given I have a DropdownMenu near the edge of canvas
    When I preview the open state
    Then I see how the menu repositions to stay visible
    And the overlay respects canvas boundaries
```

### S2: Popup/Overlay Preview System

**Goal:** Preview overlay widgets accurately on canvas

#### Acceptance Criteria

```gherkin
Feature: Overlay Preview
  As a designer
  I want to preview overlay behavior on canvas
  So that I can design popup interactions

  Scenario: Preview tooltip position
    Given I have a widget with Tooltip
    When I hover over the widget on canvas (or use preview mode)
    Then the tooltip appears in correct position
    And it respects the configured offset and decoration

  Scenario: Preview PopupMenuButton
    Given I have a PopupMenuButton widget
    When I click "Preview Popup" in properties
    Then the popup menu appears on canvas
    And I can see menu items rendered
    And I can click away to dismiss

  Scenario: Overlay stacking order
    Given I have multiple overlay-producing widgets
    When I trigger multiple overlays
    Then they stack in correct z-order
    And later overlays appear on top

  Scenario: Overlay outside widget bounds
    Given I have a widget that spawns an overlay
    And the overlay extends beyond the widget's bounds
    When I preview the overlay
    Then it renders in the correct canvas position
    And is not clipped to the widget bounds
```

### S3: Context Menu Properties

**Goal:** Support showMenu and CupertinoContextMenu configuration

#### Acceptance Criteria

```gherkin
Feature: Context Menu Configuration
  As a designer
  I want to configure context menus
  So that I can build right-click interactions

  Scenario: Add context menu to widget
    Given I have any widget selected
    When I click "Add Context Menu" in properties
    Then a context menu configuration section appears
    And I can add menu items

  Scenario: Configure menu items
    Given I am configuring a context menu
    Then I can add items with:
      | Property | Description |
      | Title | Menu item text |
      | Icon | Optional leading icon |
      | Enabled | Whether item is interactive |
      | Divider | Add separator before item |

  Scenario: Preview context menu
    Given I have a widget with context menu configured
    When I right-click on the widget (on canvas)
    Then the context menu appears
    And I can see all configured items

  Scenario: Cupertino context menu
    Given I want iOS-style context menu
    When I select "Cupertino" style in context menu settings
    Then the preview shows CupertinoContextMenu style
    And the generated code uses CupertinoContextMenu
```

### S4: OverlayPortal in Generated Code

**Goal:** Generate clean overlay code using new API

#### Acceptance Criteria

```gherkin
Feature: Overlay Code Generation
  As a developer
  I want clean overlay code generated
  So that my exported code uses modern patterns

  Scenario: Generate OverlayPortal code
    Given I have a widget with overlay behavior
    When I export the code
    Then it uses OverlayPortal with overlayChildLayoutBuilder
    And the code is cleaner than legacy Overlay.of patterns

  Scenario: Generate overlay controller
    Given I have a programmatic overlay
    When I export the code
    Then an OverlayPortalController is generated
    And show/hide methods are properly wired

  Scenario: Nested overlay handling
    Given I have overlays within overlays (e.g., dropdown in dialog)
    When I export the code
    Then the overlayChildLayoutBuilder specifies correct ancestor
    And nesting works correctly at runtime

  Scenario: Tooltip code generation
    Given I have a widget wrapped in Tooltip
    When I export the code
    Then clean Tooltip widget code is generated
    And tooltip configuration is complete
```

## Supported Overlay Widgets

| Widget | Properties Exposed | Preview Support |
|--------|-------------------|-----------------|
| DropdownMenu | cursorHeight, menuController | Open state preview |
| PopupMenuButton | items, offset, constraints | Popup preview |
| Tooltip | message, decoration, wait/show duration | Hover preview |
| CupertinoContextMenu | actions, previewBuilder | Long-press preview |
| MenuAnchor | menuChildren, controller | Menu preview |
| DropdownButton | items, value, hint | Open state preview |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Overlay render time | < 16ms (60fps) |
| Preview transition | Smooth animation |
| Hit testing accuracy | Pixel-perfect |
| Memory per overlay | < 500KB |

## Dependencies

- Canvas rendering (existing)
- Properties panel (existing)
- Widget registry (add overlay widgets)
- Code generator (existing)

## Test Coverage Requirements

- Unit tests for new DropdownMenu properties
- Unit tests for overlay positioning calculations
- Unit tests for context menu item management
- Unit tests for code generation with OverlayPortal
- Integration tests for overlay preview interaction
- Visual tests for overlay positioning

## Implementation Notes

1. Overlay preview requires canvas-level overlay layer
2. Consider "Design Mode" vs "Preview Mode" toggle for overlays
3. Generated code should use modern OverlayPortal when available
4. Fallback to legacy patterns for older Flutter targets
5. Context menu events need special canvas event handling
