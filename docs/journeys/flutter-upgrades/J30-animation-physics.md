# J30: Animation and Physics Enhancements

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J30 |
| Title | Animation and Physics Enhancements |
| Actor | Designer creating animations and interactions |
| Priority | P2 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ |

## User Story

As a designer creating animations in FlutterForge, I want to use Flutter 3.32's SpringDescription.withDurationAndBounce() for easier spring physics configuration and improved gesture handling so that I can create natural-feeling animations without complex physics math.

## Background

Flutter 3.32 introduced animation and physics improvements:

**SpringDescription.withDurationAndBounce():**
- Intuitive spring configuration
- Duration-based (not stiffness/damping)
- Bounce factor (0.0 = no bounce, 1.0 = maximum)

**ScaleStartDetails PointerDeviceKind:**
- Know if gesture is from mouse, touch, or stylus
- Adapt behavior per input type

**Divider borderRadius:**
- Rounded dividers for softer designs

## Journey Stages

### S1: SpringDescription.withDurationAndBounce() (3.32)

**Goal:** Configure spring animations with intuitive parameters

#### Acceptance Criteria

```gherkin
Feature: Intuitive Spring Configuration
  As a designer
  I want to configure springs with duration and bounce
  So that I don't need to understand physics constants

  Scenario: Configure spring animation
    Given I have an animated widget selected
    When I open "Animation" settings
    And I select "Spring" animation type
    Then I see intuitive configuration:
      | Parameter | Range | Description |
      | Duration | 0.1-2.0s | How long to settle |
      | Bounce | 0.0-1.0 | How bouncy (0=none) |

  Scenario: Preview bounce levels
    Given I am configuring a spring animation
    When I adjust the bounce slider
    Then I see real-time preview:
      | Bounce | Behavior |
      | 0.0 | Critically damped, no overshoot |
      | 0.25 | Slight overshoot |
      | 0.5 | Moderate bounce |
      | 0.75 | Strong bounce |
      | 1.0 | Maximum bounce |

  Scenario: Spring presets
    Given I open spring configuration
    Then I see presets:
      | Preset | Duration | Bounce | Use Case |
      | Snappy | 0.3s | 0.0 | Quick responses |
      | Gentle | 0.5s | 0.1 | Subtle movements |
      | Bouncy | 0.4s | 0.4 | Playful interactions |
      | Springy | 0.6s | 0.6 | Exaggerated bounces |

  Scenario: Compare old vs new API
    Given I want to understand the difference
    Then I see comparison:
    """
    // Old API (complex)
    SpringDescription(
      mass: 1.0,
      stiffness: 500.0,
      damping: 15.0,
    )

    // New API (intuitive)
    SpringDescription.withDurationAndBounce(
      duration: Duration(milliseconds: 400),
      bounce: 0.3,
    )
    """

  Scenario: Code generation with spring
    Given I have a spring animation configured
    When I export the code
    Then the output includes:
    """
    final spring = SpringDescription.withDurationAndBounce(
      duration: Duration(milliseconds: 400),
      bounce: 0.3,
    );

    final simulation = SpringSimulation(spring, 0, 1, 0);
    _controller.animateWith(simulation);
    """
```

### S2: Animation Studio Spring Integration

**Goal:** Integrate spring physics into Animation Studio

#### Acceptance Criteria

```gherkin
Feature: Animation Studio Spring Integration
  As a designer
  I want springs in Animation Studio
  So that I can create physics-based animations visually

  Scenario: Add spring curve to timeline
    Given I am in Animation Studio
    When I select a keyframe
    And I choose "Spring" easing
    Then I see spring configuration UI
    And the timeline shows spring curve preview

  Scenario: Preview spring on timeline
    Given I have a spring animation between keyframes
    When I scrub the timeline
    Then the preview shows spring behavior
    And overshoot is visible past the target keyframe

  Scenario: Spring curve visualization
    Given I have a spring configured
    Then the curve editor shows:
      | Element | Description |
      | Progress line | Actual position over time |
      | Target line | Final destination |
      | Overshoot area | Where bounce exceeds target |
      | Settle point | When animation completes |

  Scenario: Export animation with spring
    Given I have a spring-based animation
    When I export the code
    Then AnimationController uses SpringSimulation
    And spring parameters match configuration
```

### S3: Gesture Input Type Detection (3.32)

**Goal:** Configure gesture behavior based on input device

#### Acceptance Criteria

```gherkin
Feature: ScaleStartDetails PointerDeviceKind
  As a designer
  I want to handle different input types differently
  So that gestures feel native to each input method

  Scenario: Detect input type in gestures
    Given I have a GestureDetector or ScaleGestureRecognizer
    When I configure gesture handling
    Then I can differentiate:
      | Input Type | Behavior |
      | Touch | Standard sensitivity |
      | Mouse | Reduced sensitivity (precise) |
      | Stylus | Pressure-aware |
      | Trackpad | Two-finger gesture support |

  Scenario: Configure per-input behavior
    Given I have a zoomable widget
    When I open "Gesture" settings
    Then I can configure:
      | Setting | Description |
      | Mouse Scroll Zoom | Scroll to zoom on mouse |
      | Touch Pinch Zoom | Pinch to zoom on touch |
      | Trackpad Pinch | Two-finger pinch on trackpad |
      | Min Scale | Minimum zoom level |
      | Max Scale | Maximum zoom level |

  Scenario: Preview input-specific behavior
    Given I have input-specific gestures configured
    When I preview on different devices
    Then the behavior adapts per input type
    And I can test each input method

  Scenario: Code generation with input detection
    Given I have input-specific gesture handling
    When I export the code
    Then the output includes:
    """
    GestureDetector(
      onScaleStart: (details) {
        final inputType = details.pointerDeviceKind;
        if (inputType == PointerDeviceKind.mouse) {
          // Use mouse-specific sensitivity
          _scaleSensitivity = 0.5;
        } else {
          // Use touch sensitivity
          _scaleSensitivity = 1.0;
        }
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_scale * details.scale * _scaleSensitivity)
              .clamp(_minScale, _maxScale);
        });
      },
      child: ...,
    )
    """
```

### S4: Divider borderRadius (3.32)

**Goal:** Support rounded dividers

#### Acceptance Criteria

```gherkin
Feature: Divider borderRadius
  As a designer
  I want rounded dividers
  So that they match modern soft design aesthetics

  Scenario: Configure divider radius
    Given I have a Divider widget selected
    When I open properties panel
    Then I see "Border Radius" property
    And I can set radius value (0-10 dp)

  Scenario: Preview rounded divider
    Given I have a divider with borderRadius
    When I preview on canvas
    Then the divider has rounded ends
    And thickness affects the radius appearance

  Scenario: Vertical divider radius
    Given I have a VerticalDivider
    Then borderRadius also applies
    And rounds the vertical ends

  Scenario: Code generation with radius
    Given I have a rounded divider
    When I export the code
    Then the output includes:
    """
    Divider(
      height: 20,
      thickness: 2,
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(2),
    )
    """
```

### S5: Expansible Widget Base Class (3.32)

**Goal:** Support custom expandable widgets

#### Acceptance Criteria

```gherkin
Feature: Expansible Widget Base
  As a designer
  I want to create custom expandable widgets
  So that I can build consistent expansion patterns

  Scenario: Create expandable widget
    Given I want a custom expandable widget
    When I select "Expansible" base type
    Then I can configure:
      | Property | Description |
      | Initial State | expanded/collapsed |
      | Animation Duration | Expansion time |
      | Animation Curve | Easing curve |
      | Maintainer State | Keep state on toggle |

  Scenario: Expandable presets
    Given I open expandable configuration
    Then I see presets:
      | Preset | Style |
      | Accordion | One open at a time |
      | Tree View | Nested hierarchy |
      | Collapsible Section | Simple expand/collapse |
      | Expandable Card | Card with expandable content |

  Scenario: Preview expand/collapse
    Given I have an expandable widget
    When I toggle expansion in preview
    Then the animation plays smoothly
    And child content shows/hides

  Scenario: Code generation for expansible
    Given I have a custom expandable widget
    When I export the code
    Then the output extends Expansible:
    """
    class CustomExpandable extends StatefulWidget {
      @override
      State<CustomExpandable> createState() => _CustomExpandableState();
    }

    class _CustomExpandableState extends State<CustomExpandable>
        with SingleTickerProviderStateMixin {
      late AnimationController _controller;
      bool _expanded = false;

      @override
      Widget build(BuildContext context) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                  _expanded ? _controller.forward() : _controller.reverse();
                });
              },
              child: _buildHeader(),
            ),
            SizeTransition(
              sizeFactor: _controller,
              child: _buildContent(),
            ),
          ],
        );
      }
    }
    """
```

## Animation Enhancements Summary

| Feature | Old Way | New Way (3.32+) |
|---------|---------|-----------------|
| Spring physics | mass/stiffness/damping | duration/bounce |
| Gesture input | Raw pointer event | PointerDeviceKind enum |
| Divider style | Square ends only | Rounded borderRadius |
| Expandable | Custom implementation | Expansible base class |

## Spring Physics Reference

| Bounce Value | Physical Behavior | Use Case |
|--------------|-------------------|----------|
| 0.0 | Critically damped | Precise UI movements |
| 0.1-0.2 | Slightly underdamped | Natural feel |
| 0.3-0.4 | Moderate bounce | Playful interactions |
| 0.5-0.6 | Strong bounce | Attention-grabbing |
| 0.7-1.0 | Extreme bounce | Cartoon/game effects |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Spring calculation | < 1ms |
| Animation frame rate | 60fps |
| Gesture response | < 16ms |
| Memory per animation | < 50KB |

## Dependencies

- Animation Studio (existing, Phase 3)
- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)

## Test Coverage Requirements

- Unit tests for SpringDescription.withDurationAndBounce
- Unit tests for PointerDeviceKind handling
- Unit tests for Divider borderRadius
- Unit tests for Expansible base class
- Integration tests for Animation Studio spring
- Visual tests for spring curve visualization
- Performance tests for animation frame rate

## Implementation Notes

1. SpringDescription.withDurationAndBounce is factory constructor
2. Bounce converts internally to damping ratio
3. PointerDeviceKind available in gesture detail objects
4. Divider borderRadius applies to BoxDecoration
5. Expansible is abstract class for custom implementations
6. Consider spring curve editor widget for Animation Studio
