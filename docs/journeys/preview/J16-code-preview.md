# J16: Code Preview Panel

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J16 |
| Title | Code Preview Panel |
| Actor | Designer reviewing generated code |
| Priority | P1 |
| Phase | 7 - Assets & Preview |

## User Story

As a designer building Flutter UIs, I want to see live code preview in a dedicated panel so that I can understand the code being generated and copy it to my Flutter projects.

## Journey Stages

### S1: Code Preview Panel UI

**Goal:** Add dedicated panel for code preview

#### Acceptance Criteria

```gherkin
Feature: Code Preview Panel
  As a designer
  I want a dedicated code preview panel
  So that I can see generated code alongside my design

  Scenario: Access code preview panel
    Given I am on the design canvas
    When I click the "Code" tab in the right panel area
    Or I use keyboard shortcut Cmd+Shift+C
    Then the Code Preview panel opens
    And it shows the generated Dart code for the current screen

  Scenario: Panel layout
    Given the Code Preview panel is open
    Then I see:
      | Element | Position |
      | Title bar | Top |
      | Copy button | Top right |
      | Language indicator | Top left (Dart) |
      | Code area | Main content |
      | Line numbers | Left gutter |

  Scenario: Panel resizing
    Given the Code Preview panel is open
    When I drag the panel divider
    Then the panel resizes horizontally
    And the code wraps or scrolls appropriately
    And the minimum width is 300px

  Scenario: Panel state persistence
    Given I have resized the Code Preview panel
    When I close and reopen the app
    Then the panel remembers its size
    And it remembers whether it was open/closed
```

### S2: Live Code Updates

**Goal:** Code updates automatically as design changes

#### Acceptance Criteria

```gherkin
Feature: Live Code Updates
  As a designer
  I want the code to update as I make changes
  So that I can see the immediate effect of my design decisions

  Scenario: Add widget updates code
    Given the Code Preview panel is open
    When I add a Container widget to the canvas
    Then the code preview updates within 100ms
    And I see the new Container in the generated code

  Scenario: Property change updates code
    Given I have a Text widget selected
    And the Code Preview panel is open
    When I change the fontSize property to 24
    Then the code preview updates immediately
    And I see `fontSize: 24` in the TextStyle

  Scenario: Delete widget updates code
    Given I have widgets on the canvas
    When I delete a widget
    Then the code preview updates
    And the deleted widget's code is removed

  Scenario: Undo/redo updates code
    Given I have made changes to the canvas
    When I undo an action
    Then the code preview reflects the previous state
    And when I redo, it reflects the restored state

  Scenario: Debounced updates
    Given I am rapidly changing properties
    When I type quickly in a text field
    Then code updates are debounced (100ms delay)
    And performance remains smooth
```

### S3: Syntax Highlighting

**Goal:** Display code with proper Dart syntax highlighting

#### Acceptance Criteria

```gherkin
Feature: Syntax Highlighting
  As a designer
  I want syntax highlighted code
  So that the code is easy to read and understand

  Scenario: Dart keyword highlighting
    Given the Code Preview shows Dart code
    Then keywords are highlighted in blue:
      | Keywords |
      | class, const, final, return, if, else |
      | void, static, override, required |

  Scenario: Type highlighting
    Given the Code Preview shows Dart code
    Then types are highlighted in cyan:
      | Types |
      | Widget, BuildContext, StatelessWidget |
      | Container, Text, Row, Column |
      | Color, EdgeInsets, double, int |

  Scenario: String highlighting
    Given the Code Preview shows Dart code
    Then strings are highlighted in green:
      | Examples |
      | 'Hello World' |
      | "text" |

  Scenario: Number highlighting
    Given the Code Preview shows Dart code
    Then numbers are highlighted in orange:
      | Examples |
      | 16.0, 24, 0xFF000000 |

  Scenario: Comment highlighting
    Given the Code Preview shows Dart code with comments
    Then comments are highlighted in gray:
      | Examples |
      | // Single line comment |
      | /* Multi-line comment */ |

  Scenario: Theme-aware highlighting
    Given the app is in dark mode
    Then the syntax highlighting colors adapt
    And contrast ratios meet WCAG AA standards
    And the code remains readable
```

### S4: Copy Functionality

**Goal:** Easy code copying to clipboard

#### Acceptance Criteria

```gherkin
Feature: Copy Code
  As a designer
  I want to copy generated code easily
  So that I can paste it into my Flutter projects

  Scenario: Copy all code
    Given the Code Preview panel is open
    When I click the "Copy" button
    Then all generated code is copied to clipboard
    And a success toast appears "Code copied to clipboard"

  Scenario: Copy keyboard shortcut
    Given the Code Preview panel is focused
    When I press Cmd+C
    Then the entire code is copied to clipboard

  Scenario: Select and copy partial code
    Given the Code Preview panel is open
    When I select a portion of the code with mouse
    And I press Cmd+C
    Then only the selected code is copied

  Scenario: Copy with line numbers option
    Given I want to include line numbers
    When I right-click and select "Copy with line numbers"
    Then the copied code includes line number prefix

  Scenario: Copy success feedback
    Given I click the Copy button
    Then the button icon changes to a checkmark briefly
    And after 2 seconds it returns to copy icon
```

### S5: Code Structure

**Goal:** Well-formatted, production-ready code

#### Acceptance Criteria

```gherkin
Feature: Code Structure
  As a designer
  I want properly structured code
  So that I can use it directly in production

  Scenario: Import statements
    Given I have widgets on the canvas
    Then the generated code includes:
      ```dart
      import 'package:flutter/material.dart';
      ```

  Scenario: Class structure
    Given I have a design named "HomeScreen"
    Then the generated code structure is:
      ```dart
      class HomeScreen extends StatelessWidget {
        const HomeScreen({super.key});

        @override
        Widget build(BuildContext context) {
          return // widget tree
        }
      }
      ```

  Scenario: Proper indentation
    Given I have nested widgets
    Then each level is indented with 2 spaces
    And closing parentheses align with opening widgets

  Scenario: Trailing commas
    Given I have widgets with multiple properties
    Then each property ends with a trailing comma
    And the closing parenthesis is on its own line

  Scenario: Code follows dart_style formatting
    Given the generated code
    Then it passes `dart format` without changes
    And follows official Dart style guidelines
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Code generation | < 50ms |
| Syntax highlighting | < 16ms |
| Update latency | < 100ms |
| Copy to clipboard | < 10ms |

## Dependencies

- DartGenerator (existing)
- Workbench UI (existing)
- flutter_highlight or similar package

## Test Coverage Requirements

- Unit tests for code generation timing
- Unit tests for syntax highlighting accuracy
- Unit tests for copy functionality
- Integration tests for live updates
- Visual tests for highlighting appearance
