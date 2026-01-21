# J18: Onboarding and Help

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J18 |
| Title | Onboarding and Help |
| Actor | New user learning FlutterForge |
| Priority | P2 |
| Phase | 8 - Platform & Polish |

## User Story

As a new FlutterForge user, I want a guided introduction and accessible help resources so that I can quickly learn how to use the application effectively.

## Journey Stages

### S1: First-Run Welcome Screen

**Goal:** Introduce new users to FlutterForge

#### Acceptance Criteria

```gherkin
Feature: Welcome Screen
  As a new user
  I want a welcome screen on first launch
  So that I understand what FlutterForge can do

  Scenario: First launch detection
    Given I have never launched FlutterForge before
    When I launch the application
    Then a welcome screen appears
    And it covers the main workspace

  Scenario: Welcome screen content
    Given the welcome screen is shown
    Then I see:
      | Element | Content |
      | Logo | FlutterForge logo |
      | Headline | "Design Flutter UIs visually" |
      | Subheading | Brief value proposition |
      | CTA buttons | "Start Tutorial", "Create Project", "Skip" |

  Scenario: Skip welcome screen
    Given the welcome screen is shown
    When I click "Skip" or press Escape
    Then the welcome screen closes
    And I see the normal empty workspace
    And the preference "showWelcome" is set to false

  Scenario: Suppress future welcome
    Given I have seen the welcome screen
    When I check "Don't show again"
    And I close the welcome screen
    Then on next launch, the welcome screen doesn't appear

  Scenario: Re-enable welcome screen
    Given I have disabled the welcome screen
    When I go to Preferences > General
    And I enable "Show welcome screen on startup"
    Then on next launch, the welcome screen appears
```

### S2: Interactive Tutorial

**Goal:** Guide users through core features step by step

#### Acceptance Criteria

```gherkin
Feature: Interactive Tutorial
  As a new user
  I want an interactive tutorial
  So that I can learn by doing

  Scenario: Start tutorial
    Given I click "Start Tutorial" on the welcome screen
    Or I select Help > Interactive Tutorial
    Then the tutorial mode begins
    And a tutorial overlay appears
    And the first step is highlighted

  Scenario: Tutorial steps
    Given I am in tutorial mode
    Then the tutorial covers these steps in order:
      | Step | Action | Target |
      | 1 | Drag a Container to canvas | Widget palette |
      | 2 | Select the Container | Canvas |
      | 3 | Change the color property | Properties panel |
      | 4 | Add a Text widget as child | Widget tree |
      | 5 | Edit the text content | Properties panel |
      | 6 | Export the code | Code panel |
      | 7 | Save the project | File menu |

  Scenario: Tutorial step highlighting
    Given I am on tutorial step 2
    Then the target element (Canvas) is highlighted
    And other areas are dimmed
    And a tooltip explains what to do
    And I cannot interact with non-target areas

  Scenario: Tutorial step completion
    Given I am on a tutorial step
    When I complete the required action
    Then a success animation plays
    And the tutorial advances to the next step
    And progress indicator updates (e.g., "3 of 7")

  Scenario: Skip tutorial step
    Given I am on a tutorial step
    When I click "Skip this step"
    Then the step is marked as skipped
    And the tutorial advances
    And I can return to skipped steps later

  Scenario: Exit tutorial early
    Given I am in the middle of the tutorial
    When I press Escape or click "Exit Tutorial"
    Then a confirmation dialog appears
    And if I confirm, the tutorial closes
    And my progress is saved

  Scenario: Resume tutorial
    Given I exited the tutorial early
    When I go to Help > Interactive Tutorial
    Then I'm asked "Resume from step 4?" or "Start over"
    And I can choose to continue where I left off

  Scenario: Tutorial completion
    Given I complete all tutorial steps
    Then a congratulations screen appears
    And it summarizes what I learned
    And suggests next steps ("Explore templates", "Read docs")
```

### S3: Keyboard Shortcut Reference

**Goal:** Quick access to keyboard shortcuts

#### Acceptance Criteria

```gherkin
Feature: Keyboard Shortcut Reference
  As a user
  I want quick access to keyboard shortcuts
  So that I can work more efficiently

  Scenario: Open shortcut reference
    Given I am using FlutterForge
    When I press Cmd+/ (macOS) or Ctrl+/ (Windows/Linux)
    Or I select Help > Keyboard Shortcuts
    Then a keyboard shortcut overlay appears

  Scenario: Shortcut categories
    Given the shortcut reference is open
    Then shortcuts are organized by category:
      | Category | Examples |
      | File | New, Open, Save, Export |
      | Edit | Undo, Redo, Cut, Copy, Paste |
      | View | Zoom In, Zoom Out, Toggle Panels |
      | Canvas | Select All, Delete, Duplicate |
      | Navigation | Widget Tree, Properties, Code |

  Scenario: Search shortcuts
    Given the shortcut reference is open
    When I type in the search field
    Then shortcuts are filtered by action name
    And matching text is highlighted

  Scenario: Platform-appropriate display
    Given I am on macOS
    Then shortcuts show with Mac symbols (Cmd, Opt, Shift)
    Given I am on Windows
    Then shortcuts show with Windows keys (Ctrl, Alt, Shift)

  Scenario: Close shortcut reference
    Given the shortcut reference is open
    When I press Escape or click outside
    Then the overlay closes
    And focus returns to the previous element
```

### S4: Contextual Help

**Goal:** In-context help where users need it

#### Acceptance Criteria

```gherkin
Feature: Contextual Help
  As a user
  I want help relevant to what I'm doing
  So that I can learn without leaving my workflow

  Scenario: Property tooltip help
    Given I hover over a property label in the Properties panel
    Then a tooltip appears with:
      | Content | Example |
      | Property name | "padding" |
      | Description | "Space around the widget's content" |
      | Type | "EdgeInsets" |
      | Link | "Learn more" |

  Scenario: Widget palette tooltips
    Given I hover over a widget in the palette
    Then a tooltip appears with:
      | Content | Example |
      | Widget name | "Container" |
      | Description | "A convenience widget for styling" |
      | Category | "Layout" |

  Scenario: Empty state help
    Given the canvas is empty
    Then I see helpful guidance:
      | Element | Content |
      | Illustration | Visual hint to drag widgets |
      | Text | "Drag widgets from the palette" |
      | Link | "Watch tutorial" |

  Scenario: Error state help
    Given a widget shows an error state
    Then the error message includes:
      | Content | Purpose |
      | What went wrong | Clear description |
      | How to fix it | Actionable steps |
      | Help link | Documentation reference |
```

### S5: Documentation Links

**Goal:** Connect to external documentation

#### Acceptance Criteria

```gherkin
Feature: Documentation Links
  As a user
  I want quick access to documentation
  So that I can learn more about features

  Scenario: Help menu documentation link
    Given I click Help > Documentation
    Then my browser opens to the FlutterForge docs site
    And the docs site is responsive and searchable

  Scenario: Widget documentation links
    Given I have a widget selected
    When I click the "?" icon in the properties panel
    Then my browser opens to that widget's documentation
    And the URL includes the widget type

  Scenario: Flutter documentation links
    Given I am viewing widget properties
    When I click "View Flutter docs"
    Then my browser opens to the Flutter API docs for that widget
    And it links to the correct widget class

  Scenario: Report issue link
    Given I encounter a problem
    When I click Help > Report Issue
    Then my browser opens to the GitHub issues page
    And a new issue template is pre-filled with:
      | Field | Content |
      | Version | FlutterForge version |
      | Platform | OS and version |
      | Template | Bug report or feature request |
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Welcome screen load | < 500ms |
| Tutorial step transition | < 200ms |
| Shortcut overlay open | < 100ms |
| Tooltip appear delay | 500ms |

## Accessibility Requirements

- All tutorial content is screen reader accessible
- Keyboard navigation through all tutorial steps
- High contrast mode support
- Reduced motion option for animations

## Dependencies

- SharedPreferences for state persistence
- PlatformInfo for shortcut display
- url_launcher for external links

## Test Coverage Requirements

- Unit tests for first-run detection
- Unit tests for tutorial state management
- Unit tests for shortcut lookup
- Integration tests for tutorial flow
- Accessibility tests for screen reader support
