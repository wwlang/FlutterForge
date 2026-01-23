# J31: Cupertino Polish and Enhancements

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J31 |
| Title | Cupertino Polish and Enhancements |
| Actor | Designer building iOS-native feeling apps |
| Priority | P2 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ (extended in 3.35) |

## User Story

As a designer building iOS-native apps in FlutterForge, I want to use Flutter 3.32-3.35's Cupertino enhancements including RoundedSuperellipseBorder (Apple's squircle), CupertinoCollapsible, CupertinoSlider haptic feedback, CupertinoPicker sounds, and CupertinoButton sizing controls so that my iOS designs feel truly native.

## Background

Flutter 3.32-3.35 enhanced Cupertino components:

**Flutter 3.32:**
- `RoundedSuperellipseBorder` - Apple's squircle shape
- `CupertinoButton.minWidth/minHeight` - Button sizing control

**Flutter 3.35:**
- `CupertinoCollapsible` - iOS-style collapsible widget
- `CupertinoSlider` haptic feedback
- `CupertinoPicker` ticking sound
- RSuperellipse on more Cupertino widgets

## Journey Stages

### S1: RoundedSuperellipseBorder (Apple's Squircle) (3.32)

**Goal:** Use Apple's squircle shape for authentic iOS appearance

#### Acceptance Criteria

```gherkin
Feature: RoundedSuperellipseBorder (Squircle)
  As a designer
  I want Apple's squircle shape
  So that my iOS designs look authentic

  Scenario: Apply squircle to Container
    Given I have a Container widget selected
    When I open "Shape" section in properties
    Then I see shape options:
      | Shape | Description |
      | Rectangle | Standard corners |
      | Rounded Rectangle | Traditional rounded corners |
      | Superellipse (Squircle) | Apple's continuous corner |
      | Circle | Perfect circle |
      | Stadium | Pill shape |

  Scenario: Configure squircle radius
    Given I select "Superellipse" shape
    When I configure corner radius
    Then the squircle updates with iOS-style continuous curves
    And it looks identical to iOS app icons

  Scenario: Preview squircle vs rounded rect
    Given I am comparing shapes
    When I toggle between Rounded Rectangle and Superellipse
    Then I see the difference:
      | Rounded Rectangle | Squircle |
      | Abrupt curve transition | Smooth continuous curve |
      | Common on Android | Apple standard |

  Scenario: Squircle on buttons
    Given I have a CupertinoButton
    When I enable "Squircle Shape"
    Then the button uses RoundedSuperellipseBorder
    And matches iOS button appearance

  Scenario: Code generation with squircle
    Given I have a widget with squircle shape
    When I export the code
    Then the output includes:
    """
    Container(
      decoration: ShapeDecoration(
        color: CupertinoColors.systemBlue,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: ...,
    )
    """
```

### S2: CupertinoButton Sizing (3.32)

**Goal:** Control CupertinoButton minimum dimensions

#### Acceptance Criteria

```gherkin
Feature: CupertinoButton minWidth/minHeight
  As a designer
  I want to control button minimum size
  So that buttons fit my design requirements

  Scenario: Configure minimum width
    Given I have a CupertinoButton selected
    When I open "Size" section in properties
    Then I see "Minimum Width" control
    And I can set value (e.g., 100)

  Scenario: Configure minimum height
    Given I have a CupertinoButton
    When I set "Minimum Height"
    Then the button maintains at least that height
    And content is centered vertically

  Scenario: Touch target compliance
    Given I set button dimensions
    Then the properties panel shows warning:
      | Condition | Warning |
      | Height < 44 | "Below iOS minimum touch target" |
      | Width < 44 | "Below iOS minimum touch target" |

  Scenario: Preview size constraints
    Given I have button with min dimensions
    When I preview with different content
    Then the button expands for larger content
    And maintains minimum for small content

  Scenario: Code generation with size
    Given I have sized CupertinoButton
    When I export the code
    Then the output includes:
    """
    CupertinoButton(
      minSize: 44,
      minWidth: 100,
      minHeight: 48,
      onPressed: () {},
      child: Text('Submit'),
    )
    """
```

### S3: CupertinoCollapsible (3.35)

**Goal:** Add iOS-style collapsible widget

#### Acceptance Criteria

```gherkin
Feature: CupertinoCollapsible Widget
  As a designer
  I want iOS-style collapsible sections
  So that I can build iOS settings-like interfaces

  Scenario: Add CupertinoCollapsible to palette
    Given I open the widget palette
    When I expand "Cupertino" category
    Then I see "Cupertino Collapsible"
    And it shows iOS-style preview

  Scenario: Configure collapsible
    Given I have CupertinoCollapsible selected
    When I open properties panel
    Then I can configure:
      | Property | Description |
      | Header | Title widget/text |
      | Child | Collapsible content |
      | Initial Expanded | Start expanded or collapsed |
      | Background Color | Container background |
      | Header Padding | Padding around header |

  Scenario: Preview collapse animation
    Given I have CupertinoCollapsible on canvas
    When I click the header in preview mode
    Then the content collapses with iOS animation
    And the chevron rotates smoothly

  Scenario: iOS visual style
    Given I have CupertinoCollapsible
    Then it matches iOS system style:
      | Element | Style |
      | Background | System grouped background |
      | Chevron | SF Symbol chevron.down |
      | Animation | iOS spring timing |
      | Corners | Continuous (squircle) |

  Scenario: Code generation for collapsible
    Given I have configured CupertinoCollapsible
    When I export the code
    Then the output includes:
    """
    CupertinoCollapsible(
      header: Text('Advanced Settings'),
      initiallyExpanded: false,
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Column(
        children: [
          CupertinoListTile(
            title: Text('Option 1'),
            trailing: CupertinoSwitch(...),
          ),
          CupertinoListTile(
            title: Text('Option 2'),
            trailing: CupertinoSwitch(...),
          ),
        ],
      ),
    )
    """
```

### S4: CupertinoSlider Haptic Feedback (3.35)

**Goal:** Configure haptic feedback for iOS sliders

#### Acceptance Criteria

```gherkin
Feature: CupertinoSlider Haptic Feedback
  As a designer
  I want haptic feedback on iOS sliders
  So that interaction feels native

  Scenario: Enable haptic feedback
    Given I have a CupertinoSlider selected
    When I open "Feedback" section in properties
    Then I see "Haptic Feedback" toggle
    And it defaults to enabled

  Scenario: Configure haptic intensity
    Given I enable haptic feedback
    Then I can configure:
      | Setting | Options |
      | Type | light, medium, heavy, selection |
      | On Change | Haptic on value change |
      | On Discrete | Haptic at discrete stops |

  Scenario: Discrete slider haptics
    Given I have a discrete CupertinoSlider (divisions: 10)
    When haptic feedback is enabled
    Then haptic fires at each division
    And provides tactile "click" feedback

  Scenario: Preview haptic (simulated)
    Given I have haptic feedback configured
    When I preview on canvas
    Then a "haptic" indicator shows when haptic would fire
    And timing matches actual iOS behavior

  Scenario: Code generation with haptics
    Given I have slider with haptic feedback
    When I export the code
    Then the output includes:
    """
    CupertinoSlider(
      value: _value,
      onChanged: (newValue) {
        HapticFeedback.selectionClick();
        setState(() => _value = newValue);
      },
      min: 0,
      max: 100,
      divisions: 10,
    )
    """
```

### S5: CupertinoPicker Ticking Sound (3.35)

**Goal:** Configure ticking sound for iOS pickers

#### Acceptance Criteria

```gherkin
Feature: CupertinoPicker Ticking Sound
  As a designer
  I want ticking sounds on iOS pickers
  So that scrolling feels native to iOS

  Scenario: Enable ticking sound
    Given I have a CupertinoPicker selected
    When I open "Audio" section in properties
    Then I see "Ticking Sound" toggle
    And it defaults to enabled (matching iOS)

  Scenario: Configure sound behavior
    Given I enable ticking sound
    Then I can configure:
      | Setting | Description |
      | Sound Enabled | Master toggle |
      | Respect System | Follow iOS sound settings |
      | Volume | Relative volume level |

  Scenario: Preview sound (simulated)
    Given I have ticking sound configured
    When I scroll the picker in preview
    Then a "tick" indicator shows when sound would play
    And frequency matches scroll velocity

  Scenario: Muted state handling
    Given I have ticking enabled
    When the device is muted
    Then sound respects system mute
    And haptic feedback plays instead

  Scenario: Code generation with sound
    Given I have picker with ticking sound
    When I export the code
    Then the output includes:
    """
    CupertinoPicker(
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(),
      onSelectedItemChanged: (index) {
        // Ticking sound is automatic in CupertinoPicker
        setState(() => _selectedIndex = index);
      },
      children: items.map((item) => Center(
        child: Text(item),
      )).toList(),
    )
    """
```

### S6: RSuperellipse on Cupertino Widgets (3.35)

**Goal:** Apply squircle consistently across Cupertino widgets

#### Acceptance Criteria

```gherkin
Feature: RSuperellipse Cupertino Integration
  As a designer
  I want squircle on all Cupertino widgets
  So that my iOS design is consistent

  Scenario: Default squircle shapes
    Given I use Cupertino widgets
    Then these use squircle by default:
      | Widget | Shape Application |
      | CupertinoButton | Button background |
      | CupertinoAlertDialog | Dialog container |
      | CupertinoActionSheet | Sheet container |
      | CupertinoContextMenu | Preview container |
      | CupertinoPopupSurface | Popup background |

  Scenario: Configure squircle radius
    Given I have a Cupertino widget with squircle
    When I adjust border radius
    Then the squircle maintains continuous curves
    And matches the iOS radius at that value

  Scenario: Compare Material vs Cupertino
    Given I have similar widgets
    Then the shape differs:
      | Widget Type | Material | Cupertino |
      | Button | RoundedRectangle | RSuperellipse |
      | Dialog | RoundedRectangle | RSuperellipse |
      | Card | RoundedRectangle | RSuperellipse |

  Scenario: Export Cupertino-style design
    Given I have Cupertino widgets
    When I export the code
    Then all shapes use RoundedSuperellipseBorder
    And the app looks native on iOS
```

## Cupertino Widget Enhancement Summary

| Widget | Enhancement | Version |
|--------|-------------|---------|
| All shapes | RoundedSuperellipseBorder | 3.32 |
| CupertinoButton | minWidth/minHeight | 3.32 |
| CupertinoCollapsible | New widget | 3.35 |
| CupertinoSlider | Haptic feedback | 3.35 |
| CupertinoPicker | Ticking sound | 3.35 |
| CupertinoAlertDialog | Squircle shape | 3.35 |

## iOS Design Guidelines Compliance

| Guideline | Implementation |
|-----------|----------------|
| Touch targets >= 44pt | minHeight/minWidth validation |
| Continuous corners | RSuperellipse default |
| Haptic feedback | System haptic integration |
| Sound feedback | System sound integration |
| Dynamic Type | Text scaling support |
| Dark Mode | CupertinoColors adaptation |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Shape render time | < 16ms |
| Haptic latency | < 10ms |
| Animation frame rate | 60fps |
| Sound latency | < 50ms |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)
- Platform channels (for haptics/sound)

## Test Coverage Requirements

- Unit tests for RoundedSuperellipseBorder
- Unit tests for CupertinoButton sizing
- Unit tests for CupertinoCollapsible state
- Unit tests for haptic configuration
- Unit tests for sound configuration
- Integration tests for Cupertino preview
- Visual tests for squircle vs rounded rect
- Platform tests for haptic/sound on iOS

## Implementation Notes

1. RoundedSuperellipseBorder is in Flutter foundation
2. Squircle is mathematically a superellipse with n=4
3. Haptic requires platform channel on real devices
4. Sound uses system picker sound on iOS
5. CupertinoCollapsible may require custom implementation
6. Consider "Cupertino Mode" toggle for canvas
7. Test on real iOS devices for haptic/sound accuracy
