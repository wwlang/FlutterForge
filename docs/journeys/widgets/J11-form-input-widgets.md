# J11: Form Input Widgets

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J11 |
| Title | Form Input Widgets |
| Actor | Designer building forms |
| Priority | P0 |
| Phase | 6 - Widget Completion |

## User Story

As a designer building Flutter UIs, I want to add form input widgets (TextField, Checkbox, Switch, Slider) to my designs so that I can create interactive form layouts without writing code.

## Journey Stages

### S1: TextField Widget

**Goal:** Add and configure text input fields

#### Acceptance Criteria

```gherkin
Feature: TextField Widget
  As a designer
  I want to add TextField widgets to my canvas
  So that I can design form input layouts

  Scenario: Add TextField from palette
    Given I am on the design canvas
    When I drag a TextField from the Input palette category
    And I drop it on the canvas
    Then a TextField widget appears with default hint text "Enter text"
    And the TextField is visible with standard Material styling

  Scenario: Configure TextField decoration
    Given I have a TextField selected on the canvas
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | labelText | String | null |
      | hintText | String | "Enter text" |
      | helperText | String | null |
      | prefixIcon | Icon | null |
      | suffixIcon | Icon | null |
      | obscureText | Boolean | false |
      | maxLines | Integer | 1 |
      | enabled | Boolean | true |

  Scenario: Configure TextField input type
    Given I have a TextField selected
    When I set the keyboardType property
    Then I can choose from:
      | text |
      | number |
      | email |
      | phone |
      | multiline |
    And the canvas preview updates to show appropriate input behavior

  Scenario: TextField validation indicator
    Given I have a TextField with errorText property set
    When I view the canvas
    Then the TextField displays the error text in red below the input
    And the border color changes to error red
```

### S2: Checkbox Widget

**Goal:** Add and configure checkbox inputs

#### Acceptance Criteria

```gherkin
Feature: Checkbox Widget
  As a designer
  I want to add Checkbox widgets
  So that I can design boolean selection interfaces

  Scenario: Add Checkbox from palette
    Given I am on the design canvas
    When I drag a Checkbox from the Input palette category
    And I drop it on the canvas
    Then a Checkbox widget appears unchecked by default

  Scenario: Configure Checkbox value
    Given I have a Checkbox selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | value | Boolean | false |
      | tristate | Boolean | false |
      | activeColor | Color | null (theme primary) |
      | checkColor | Color | null (white) |

  Scenario: Tristate Checkbox
    Given I have a Checkbox with tristate enabled
    When I click the checkbox in the properties panel
    Then it cycles through: false -> true -> null -> false
    And the canvas shows: unchecked -> checked -> indeterminate -> unchecked

  Scenario: CheckboxListTile variant
    Given I want a checkbox with a label
    When I drag CheckboxListTile from the palette
    Then I can configure:
      | Property | Type |
      | title | Widget (typically Text) |
      | subtitle | Widget |
      | secondary | Widget |
      | controlAffinity | leading/trailing |
```

### S3: Switch Widget

**Goal:** Add and configure toggle switches

#### Acceptance Criteria

```gherkin
Feature: Switch Widget
  As a designer
  I want to add Switch widgets
  So that I can design on/off toggle interfaces

  Scenario: Add Switch from palette
    Given I am on the design canvas
    When I drag a Switch from the Input palette category
    And I drop it on the canvas
    Then a Switch widget appears in the off position

  Scenario: Configure Switch appearance
    Given I have a Switch selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | value | Boolean | false |
      | activeColor | Color | null (theme primary) |
      | activeTrackColor | Color | null |
      | inactiveThumbColor | Color | null |
      | inactiveTrackColor | Color | null |

  Scenario: SwitchListTile variant
    Given I want a switch with a label
    When I drag SwitchListTile from the palette
    Then I can configure:
      | Property | Type |
      | title | Widget |
      | subtitle | Widget |
      | secondary | Widget |
      | controlAffinity | leading/trailing |
```

### S4: Slider Widget

**Goal:** Add and configure slider inputs

#### Acceptance Criteria

```gherkin
Feature: Slider Widget
  As a designer
  I want to add Slider widgets
  So that I can design range selection interfaces

  Scenario: Add Slider from palette
    Given I am on the design canvas
    When I drag a Slider from the Input palette category
    And I drop it on the canvas
    Then a Slider widget appears with default range 0-1

  Scenario: Configure Slider range
    Given I have a Slider selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | value | Double | 0.5 |
      | min | Double | 0.0 |
      | max | Double | 1.0 |
      | divisions | Integer | null (continuous) |
      | label | String | null |

  Scenario: Configure Slider appearance
    Given I have a Slider selected
    Then I can also configure:
      | Property | Type |
      | activeColor | Color |
      | inactiveColor | Color |
      | thumbColor | Color |

  Scenario: Discrete Slider with divisions
    Given I have a Slider with divisions set to 5
    And min is 0 and max is 100
    Then the slider snaps to values: 0, 20, 40, 60, 80, 100
    And when label is set, it shows the current value on drag
```

## Code Generation Requirements

### TextField Code Output

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
    prefixIcon: Icon(Icons.email),
  ),
  keyboardType: TextInputType.emailAddress,
  obscureText: false,
  maxLines: 1,
  onChanged: (value) {},
)
```

### Checkbox Code Output

```dart
Checkbox(
  value: false,
  tristate: false,
  activeColor: Colors.blue,
  onChanged: (value) {},
)
```

### Switch Code Output

```dart
Switch(
  value: false,
  activeColor: Colors.green,
  onChanged: (value) {},
)
```

### Slider Code Output

```dart
Slider(
  value: 50.0,
  min: 0.0,
  max: 100.0,
  divisions: 10,
  label: '50',
  onChanged: (value) {},
)
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Widget render time | < 16ms (60fps) |
| Property update latency | < 100ms |
| Code generation | < 50ms |

## Dependencies

- WidgetRegistry (existing)
- WidgetRenderer (existing)
- PropertiesPanel (existing)
- DartGenerator (existing)

## Test Coverage Requirements

- Unit tests for each widget definition
- Unit tests for widget rendering
- Unit tests for code generation
- Integration tests for drag-drop workflow
