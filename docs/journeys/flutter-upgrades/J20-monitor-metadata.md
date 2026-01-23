# J20: Monitor Metadata API for Responsive Preview

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J20 |
| Title | Monitor Metadata API for Responsive Preview |
| Actor | Designer previewing designs on multiple monitors |
| Priority | P2 |
| Phase | 9 - Flutter 3.38 Enhancements |
| Flutter Version | 3.38+ |

## User Story

As a designer using FlutterForge with multiple monitors, I want the preview to detect and use actual monitor specifications (resolution, DPI, refresh rate) so that I can see accurate device simulations and optimize my workflow across displays.

## Background

Flutter 3.38 introduces the Monitor Metadata API, allowing apps to query:
- Monitor resolution (physical pixels)
- Logical size (device-independent pixels)
- Device pixel ratio (DPI scaling)
- Refresh rate
- Monitor position in virtual screen space

This enables FlutterForge to:
1. Show accurate previews on high-DPI displays
2. Auto-position preview windows on appropriate monitors
3. Display monitor info in the preview panel
4. Support multi-window workflows (future)

## Journey Stages

### S1: Display Monitor Information

**Goal:** Show current monitor specifications in the preview panel

#### Acceptance Criteria

```gherkin
Feature: Monitor Information Display
  As a designer
  I want to see my monitor specifications
  So that I understand how my design appears on this display

  Scenario: View current monitor info
    Given I am using FlutterForge on any monitor
    When I open the Preview panel settings
    Then I see the current monitor specifications:
      | Property | Example |
      | Name/Model | "Built-in Retina Display" |
      | Resolution | 3024 x 1964 |
      | Logical Size | 1512 x 982 |
      | Device Pixel Ratio | 2.0 |
      | Refresh Rate | 120Hz |

  Scenario: Multi-monitor detection
    Given I have multiple monitors connected
    When I open the monitor selector
    Then all connected monitors are listed
    And each shows its key specifications
    And the current monitor is highlighted

  Scenario: Monitor changes detected
    Given FlutterForge is running
    When I connect or disconnect a monitor
    Then the monitor list updates automatically
    And a notification appears briefly
```

### S2: DPI-Aware Preview Rendering

**Goal:** Preview renders accurately based on monitor DPI

#### Acceptance Criteria

```gherkin
Feature: DPI-Aware Preview
  As a designer
  I want previews to render at correct scale
  So that I see accurate device representations

  Scenario: High-DPI preview rendering
    Given I am on a 2x DPI monitor (Retina)
    And I preview an iPhone 15 Pro (3x)
    When the preview renders
    Then the simulated 3x content renders at 1.5x physical scale
    And text and images remain sharp

  Scenario: Standard DPI preview
    Given I am on a 1x DPI monitor
    And I preview an iPhone 15 Pro (3x)
    When the preview renders
    Then the preview indicates limited resolution
    And a tooltip explains physical vs simulated rendering

  Scenario: Preview scale indicator
    Given a device preview is active
    Then I see the current preview scale factor
    And the relationship between device DPI and monitor DPI
```

### S3: Smart Preview Window Positioning

**Goal:** Preview windows open on optimal monitor

#### Acceptance Criteria

```gherkin
Feature: Preview Window Positioning
  As a designer with multiple monitors
  I want preview windows to open on appropriate displays
  So that my workflow is optimized

  Scenario: Detach preview to second monitor
    Given I have two monitors
    When I click "Detach Preview" button
    Then the preview opens in a new window
    And it positions on the monitor with more space
    And the main editor remains on the primary monitor

  Scenario: Remember preview window position
    Given I moved a detached preview to a specific monitor
    When I close and reopen the detached preview
    Then it opens on the same monitor
    And at the same position

  Scenario: Handle monitor disconnection
    Given a detached preview is on an external monitor
    When that monitor is disconnected
    Then the preview window moves to an available monitor
    And no content is lost
```

### S4: Refresh Rate Awareness

**Goal:** Use monitor refresh rate for smooth previews

#### Acceptance Criteria

```gherkin
Feature: Refresh Rate Optimization
  As a designer
  I want smooth animations in preview
  So that I can accurately judge motion design

  Scenario: Match preview frame rate to monitor
    Given I am on a 120Hz monitor
    When previewing animations
    Then the preview renders at up to 120fps
    And animation playback is smooth

  Scenario: Frame rate indicator
    Given an animation is playing in preview
    Then I see the current frame rate
    And whether it matches the monitor refresh rate

  Scenario: Lower refresh rate fallback
    Given I am on a 60Hz monitor
    When previewing 120fps animations
    Then a notice indicates reduced preview fidelity
    And "Best viewed on 120Hz" suggestion appears
```

## Monitor Metadata Usage

| API Call | FlutterForge Usage |
|----------|-------------------|
| `Display.displays` | List all connected monitors |
| `Display.size` | Physical resolution |
| `Display.logicalSize` | Logical (DIP) resolution |
| `Display.devicePixelRatio` | DPI scaling factor |
| `Display.refreshRate` | Animation frame rate |
| `Display.bounds` | Position for window placement |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Monitor detection | < 100ms |
| DPI scaling accuracy | Exact match to Flutter rendering |
| Refresh rate target | Match monitor capability |
| Memory per monitor | < 1KB metadata |

## Dependencies

- Preview panel (existing)
- Device frame selector (existing, J15)
- Window management (platform-specific)

## Test Coverage Requirements

- Unit tests for monitor metadata parsing
- Unit tests for DPI calculations
- Unit tests for window positioning logic
- Integration tests for multi-monitor scenarios (manual)
- Platform tests for macOS, Windows, Linux

## Platform Considerations

| Platform | API | Notes |
|----------|-----|-------|
| macOS | NSScreen | Full support expected |
| Windows | Win32 Display API | Full support expected |
| Linux | GDK/X11/Wayland | Wayland may have limitations |

## Implementation Notes

1. Create `MonitorService` to abstract platform differences
2. Cache monitor metadata, refresh on display configuration change
3. Handle graceful fallback when API unavailable (older Flutter)
4. Consider user preference to disable monitor-aware features
