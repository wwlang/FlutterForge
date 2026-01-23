# J26: Form Field Enhancements

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J26 |
| Title | Form Field Enhancements |
| Actor | Designer building forms with validation |
| Priority | P1 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ (extended in 3.35) |

## User Story

As a designer building forms in FlutterForge, I want access to Flutter 3.32's FormField.errorBuilder for custom error rendering, InputDecoration hint widget support, and Flutter 3.35's DropdownMenuFormField so that I can create polished, accessible forms with rich validation feedback.

## Background

Flutter 3.32-3.35 introduced significant form improvements:

**Flutter 3.32:**
- `FormField.errorBuilder` - Custom error widget rendering
- `InputDecoration.hint` - Widget-based hints (not just text)
- `InputDecoration.visualDensity` - Density control for inputs

**Flutter 3.35:**
- `DropdownMenuFormField` - Form field with restoration support
- Enhanced form field state management

## Journey Stages

### S1: Custom Error Builder (3.32)

**Goal:** Allow custom error widget rendering for form fields

#### Acceptance Criteria

```gherkin
Feature: FormField.errorBuilder
  As a designer
  I want custom error widget rendering
  So that validation errors match my design system

  Scenario: Configure error builder
    Given I have a TextFormField widget selected
    When I open the "Validation" section in properties
    Then I see "Custom Error Display" option
    And I can choose:
      | Option | Description |
      | Default | Standard red text below field |
      | Custom Widget | Design custom error widget |
      | Icon + Text | Error icon with message |
      | Tooltip | Show error in tooltip |
      | None | Hide error text (for custom handling) |

  Scenario: Design custom error widget
    Given I select "Custom Widget" for error display
    When I click "Design Error Widget"
    Then I can build a custom error display with:
      | Element | Description |
      | Error Text | The validation message |
      | Error Icon | Custom icon widget |
      | Background | Error container styling |
      | Animation | Shake, fade-in, etc. |

  Scenario: Preview validation error
    Given I have a form field with custom error builder
    When I click "Preview Error State" in properties
    Then the field displays as if validation failed
    And my custom error widget is visible
    And I can see how it affects layout

  Scenario: Code generation with errorBuilder
    Given I have configured a custom error builder
    When I export the code
    Then the output includes:
    """
    TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Email required';
        return null;
      },
      errorBuilder: (context, errorText) {
        return Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 16),
            SizedBox(width: 4),
            Text(errorText, style: TextStyle(color: Colors.red)),
          ],
        );
      },
    )
    """
```

### S2: Widget-Based Hints (3.32)

**Goal:** Support hint as Widget instead of just String

#### Acceptance Criteria

```gherkin
Feature: InputDecoration.hint Widget
  As a designer
  I want rich hint content in input fields
  So that I can provide helpful guidance

  Scenario: Configure hint widget
    Given I have a TextField widget selected
    When I open the "Hint" section in properties
    Then I see options:
      | Option | Description |
      | Text | Simple hint text (hintText) |
      | Widget | Custom hint widget |

  Scenario: Design hint widget
    Given I select "Widget" for hint
    When I design the hint content
    Then I can include:
      | Element | Example |
      | Icon | Leading icon in hint |
      | Rich Text | Styled hint text |
      | Row | Icon + Text combination |

  Scenario: Animated hint example
    Given I want an animated hint
    When I design a hint with "Typing animation"
    Then the hint shows animated placeholder effect
    And the animation plays in preview

  Scenario: Code generation with hint widget
    Given I have a custom hint widget configured
    When I export the code
    Then the output includes:
    """
    TextField(
      decoration: InputDecoration(
        hint: Row(
          children: [
            Icon(Icons.email_outlined, color: Colors.grey),
            SizedBox(width: 8),
            Text('Enter your email', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    )
    """

  Scenario: Hint vs hintText
    Given I have both hint widget and hintText configured
    Then the properties panel shows a warning
    And explains that hint takes precedence
    And hintText is ignored when hint is set
```

### S3: Input Visual Density (3.32)

**Goal:** Configure visual density for input fields

#### Acceptance Criteria

```gherkin
Feature: InputDecoration.visualDensity
  As a designer
  I want to control input field density
  So that forms fit different contexts

  Scenario: Configure visual density
    Given I have a TextField widget selected
    When I open the "Layout" section in properties
    Then I see "Visual Density" control with options:
      | Density | Description |
      | Standard | Default spacing |
      | Comfortable | More padding |
      | Compact | Less padding |
      | Custom | Specific horizontal/vertical values |

  Scenario: Preview density variations
    Given I have a TextField on canvas
    When I toggle through density options
    Then I see the field size change in real-time
    And content padding adjusts accordingly

  Scenario: Custom density values
    Given I select "Custom" visual density
    Then I can set:
      | Property | Range |
      | Horizontal | -4.0 to 4.0 |
      | Vertical | -4.0 to 4.0 |

  Scenario: Code generation with density
    Given I have compact visual density configured
    When I export the code
    Then the output includes:
    """
    TextField(
      decoration: InputDecoration(
        labelText: 'Username',
        visualDensity: VisualDensity.compact,
      ),
    )
    """
```

### S4: DropdownMenuFormField (3.35)

**Goal:** Add DropdownMenuFormField with form integration

#### Acceptance Criteria

```gherkin
Feature: DropdownMenuFormField Widget
  As a designer
  I want dropdown menus as proper form fields
  So that they integrate with form validation

  Scenario: Add DropdownMenuFormField to palette
    Given I open the widget palette
    When I expand the "Input" or "Form" category
    Then I see "Dropdown Menu Form Field"
    And it's distinct from DropdownMenu

  Scenario: Configure form field properties
    Given I have a DropdownMenuFormField selected
    When I open the properties panel
    Then I can configure:
      | Property | Description |
      | initialValue | Default selection |
      | validator | Validation function |
      | onSaved | Save handler |
      | restorationId | State restoration key |
      | autovalidateMode | When to validate |

  Scenario: Configure dropdown items
    Given I have a DropdownMenuFormField
    When I click "Edit Items"
    Then I can add/remove/reorder dropdown entries
    And each entry has label and value
    And I can set leadingIcon per item

  Scenario: Preview validation
    Given I have a DropdownMenuFormField with required validator
    When I preview the form without selection
    Then validation error displays
    And error uses errorBuilder if configured

  Scenario: Form restoration
    Given I have a DropdownMenuFormField with restorationId
    When I export the code
    Then the output includes restoration support:
    """
    DropdownMenuFormField<String>(
      restorationId: 'country_dropdown',
      initialValue: null,
      validator: (value) {
        if (value == null) return 'Please select a country';
        return null;
      },
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'us', label: 'United States'),
        DropdownMenuEntry(value: 'uk', label: 'United Kingdom'),
      ],
    )
    """

  Scenario: Form integration
    Given I have a Form with DropdownMenuFormField
    When I configure form submission
    Then the dropdown value is included in form data
    And onSaved callback is called on form save
```

### S5: TabBar Interaction Callbacks (3.32)

**Goal:** Expose onHover and onFocusChange for TabBar

#### Acceptance Criteria

```gherkin
Feature: TabBar Interaction Callbacks
  As a designer
  I want hover and focus callbacks on tabs
  So that I can create interactive tab effects

  Scenario: Configure onHover callback
    Given I have a TabBar widget selected
    When I open the "Interactions" section
    Then I see "On Hover" configuration
    And I can specify hover effects:
      | Effect | Description |
      | Scale | Enlarge tab on hover |
      | Color | Change color on hover |
      | Custom | User-defined callback |

  Scenario: Configure onFocusChange callback
    Given I have a TabBar widget
    When I configure "On Focus Change"
    Then I can specify focus effects
    And the generated code includes callbacks

  Scenario: Preview hover effect
    Given I have TabBar with hover effects on canvas
    When I hover over tabs in preview mode
    Then hover effects are visible
    And I can validate the interaction design
```

## Supported Form Enhancements

| Widget | Enhancement | Version | Priority |
|--------|-------------|---------|----------|
| FormField | errorBuilder | 3.32 | P1 |
| InputDecoration | hint (Widget) | 3.32 | P1 |
| InputDecoration | visualDensity | 3.32 | P2 |
| DropdownMenuFormField | New widget | 3.35 | P1 |
| TabBar | onHover/onFocusChange | 3.32 | P2 |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Form validation time | < 10ms |
| Error render time | < 16ms |
| Dropdown open time | < 100ms |
| Memory per form field | < 50KB |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Form validation system (if exists)
- Code generator (existing)

## Test Coverage Requirements

- Unit tests for errorBuilder configuration
- Unit tests for hint widget building
- Unit tests for visual density settings
- Unit tests for DropdownMenuFormField properties
- Unit tests for TabBar callbacks
- Unit tests for code generation
- Integration tests for form field preview
- Visual tests for error display styles

## Implementation Notes

1. errorBuilder receives BuildContext and error string
2. hint widget replaces hintText when both set
3. visualDensity affects content padding, not border
4. DropdownMenuFormField extends FormField<T>
5. Consider error animation library for shake effects
6. Tab hover requires builder pattern for custom effects
