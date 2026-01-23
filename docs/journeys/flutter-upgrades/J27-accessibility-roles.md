# J27: Comprehensive Accessibility Roles

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J27 |
| Title | Comprehensive Accessibility Roles |
| Actor | Designer building accessible applications |
| Priority | P1 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ (extended in 3.35) |

## User Story

As a designer building accessible apps in FlutterForge, I want to configure comprehensive semantics roles including radio groups, dialogs, lists, tables, status, alert, menu, and landmark roles so that my designs are fully accessible to screen readers and assistive technologies.

## Background

Flutter 3.32-3.35 significantly expanded semantics support:

**Flutter 3.32:**
- `SemanticsRole.radioGroup` - Group of radio buttons
- `SemanticsRole.dialog` - Modal dialog
- `SemanticsRole.list` - List container
- `SemanticsRole.table` - Table container
- `SemanticsRole.status` - Live region status
- `SemanticsRole.alert` - Alert/notification
- `SemanticsRole.menu` - Menu container

**Flutter 3.35:**
- Landmark semantic roles (navigation, main, complementary)
- Enhanced heading levels (H1-H6)
- Improved live region announcements

## Journey Stages

### S1: Radio Group Semantics (3.32)

**Goal:** Configure radio button groups with proper semantics

#### Acceptance Criteria

```gherkin
Feature: Radio Group Semantics
  As a designer
  I want proper semantics for radio button groups
  So that screen readers announce them correctly

  Scenario: Create semantic radio group
    Given I have multiple Radio widgets
    When I select them and click "Create Radio Group"
    Then they are wrapped in a semantic group
    And the group has role "radioGroup"
    And each radio has role "radio"

  Scenario: Configure group label
    Given I have a radio group
    When I open accessibility properties
    Then I can set "Group Label" (e.g., "Payment Method")
    And the label is announced by screen readers

  Scenario: Selection state announcement
    Given I have a radio group on canvas
    When I select an option in preview mode
    Then the selection change is announced:
      | Announcement |
      | "Credit Card, selected, 1 of 3" |

  Scenario: Code generation for radio group
    Given I have a configured radio group
    When I export the code
    Then the output includes:
    """
    Semantics(
      label: 'Payment Method',
      role: SemanticsRole.radioGroup,
      child: Column(
        children: [
          Radio<String>(
            value: 'credit',
            groupValue: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value),
            semanticsLabel: 'Credit Card',
          ),
          Radio<String>(
            value: 'paypal',
            groupValue: _paymentMethod,
            onChanged: (value) => setState(() => _paymentMethod = value),
            semanticsLabel: 'PayPal',
          ),
        ],
      ),
    )
    """
```

### S2: Dialog Semantics (3.32)

**Goal:** Configure dialogs with proper accessibility roles

#### Acceptance Criteria

```gherkin
Feature: Dialog Semantics
  As a designer
  I want dialogs to have proper semantics
  So that screen readers handle them correctly

  Scenario: Configure dialog semantics
    Given I have a dialog widget (AlertDialog, Dialog, etc.)
    When I open accessibility properties
    Then the dialog automatically has role "dialog"
    And I can configure:
      | Property | Description |
      | Dialog Label | Announced title |
      | Modal | Focus trap behavior |
      | Dismissible | Can dismiss with gestures |

  Scenario: Focus management
    Given I have a dialog on canvas
    When I configure focus behavior
    Then I can set:
      | Setting | Description |
      | Initial Focus | Which element gets focus on open |
      | Return Focus | Where focus goes on close |
      | Focus Trap | Keep focus inside dialog |

  Scenario: Dialog announcement
    Given I have a dialog with proper semantics
    When the dialog opens in preview
    Then screen reader announces:
      | Announcement |
      | "Dialog, [Title], [Description]" |

  Scenario: Code generation for dialog
    Given I have an accessible dialog
    When I export the code
    Then the output includes dialog semantics:
    """
    Semantics(
      role: SemanticsRole.dialog,
      label: 'Confirm Deletion',
      scopesRoute: true,
      explicitChildNodes: true,
      child: AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure?'),
        actions: [...],
      ),
    )
    """
```

### S3: List and Table Semantics (3.32)

**Goal:** Configure list and table roles for data structures

#### Acceptance Criteria

```gherkin
Feature: List Semantics
  As a designer
  I want lists to be announced correctly
  So that users know they're navigating a list

  Scenario: Configure list semantics
    Given I have a ListView widget
    When I open accessibility properties
    Then the list has role "list"
    And I can configure:
      | Property | Description |
      | List Label | "Search Results" |
      | Item Count | Announced total |
      | Current Index | For pagination |

  Scenario: List item indexing
    Given I have a list with items
    Then each item announces its position:
      | Position | Announcement |
      | First | "Item 1 of 10" |
      | Middle | "Item 5 of 10" |
      | Last | "Item 10 of 10" |

  Scenario: Table semantics
    Given I have a DataTable or GridView
    When I configure as table
    Then the container has role "table"
    And rows/columns are announced
    And headers are marked as such

  Scenario: Code generation for list
    Given I have an accessible list
    When I export the code
    Then the output includes:
    """
    Semantics(
      role: SemanticsRole.list,
      label: 'Search Results',
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Semantics(
            indexInList: index,
            child: ListTile(...),
          );
        },
      ),
    )
    """
```

### S4: Status and Alert Semantics (3.32)

**Goal:** Configure live regions for dynamic content

#### Acceptance Criteria

```gherkin
Feature: Status and Alert Semantics
  As a designer
  I want status and alert roles
  So that dynamic updates are announced

  Scenario: Configure status region
    Given I have a widget showing dynamic status (e.g., loading indicator)
    When I set role to "status"
    Then status changes are announced politely
    And I can configure:
      | Property | Description |
      | Live Region | polite, assertive, off |
      | Atomic | Announce whole region or just change |
      | Relevant | additions, removals, text, all |

  Scenario: Configure alert role
    Given I have a notification/snackbar widget
    When I set role to "alert"
    Then the alert is announced immediately (assertive)
    And focus is not moved to the alert

  Scenario: Preview live region
    Given I have a status widget
    When I trigger a status change in preview
    Then I see "Announced: [message]" indicator
    And I can test announcement timing

  Scenario: Code generation for alert
    Given I have an accessible alert
    When I export the code
    Then the output includes:
    """
    Semantics(
      role: SemanticsRole.alert,
      liveRegion: true,
      child: Container(
        color: Colors.red.shade100,
        child: Text('Error: Connection failed'),
      ),
    )
    """
```

### S5: Landmark Roles (3.35)

**Goal:** Configure page landmark regions for navigation

#### Acceptance Criteria

```gherkin
Feature: Landmark Semantics
  As a designer
  I want landmark roles for page regions
  So that users can navigate by landmarks

  Scenario: Configure navigation landmark
    Given I have a navigation widget (AppBar, NavigationRail, etc.)
    When I set landmark role to "navigation"
    Then screen readers can jump to it as a landmark
    And I can set a landmark label

  Scenario: Configure main content landmark
    Given I have the main content area
    When I set landmark role to "main"
    Then it's recognized as primary content
    And "Skip to main content" link can target it

  Scenario: Configure complementary landmark
    Given I have a sidebar or auxiliary content
    When I set landmark role to "complementary"
    Then it's recognized as supporting content

  Scenario: Landmark navigation preview
    Given I have landmarks configured
    When I enable "Show Landmarks" overlay
    Then landmarks are highlighted on canvas
    And their labels are visible

  Scenario: Code generation for landmarks
    Given I have a page with landmarks
    When I export the code
    Then the output includes landmark semantics:
    """
    Column(
      children: [
        Semantics(
          role: SemanticsRole.navigation,
          label: 'Main Navigation',
          child: AppBar(...),
        ),
        Semantics(
          role: SemanticsRole.main,
          label: 'Dashboard Content',
          child: Expanded(child: ...),
        ),
        Semantics(
          role: SemanticsRole.complementary,
          label: 'Quick Actions',
          child: Sidebar(...),
        ),
      ],
    )
    """
```

### S6: Heading Levels (3.35/3.38)

**Goal:** Configure heading hierarchy for document structure

#### Acceptance Criteria

```gherkin
Feature: Heading Level Semantics
  As a designer
  I want heading levels H1-H6
  So that content has proper hierarchy

  Scenario: Configure heading level
    Given I have a Text widget that's a heading
    When I open accessibility properties
    Then I see "Heading Level" dropdown (1-6, None)
    And selecting a level wraps in Semantics

  Scenario: Heading hierarchy validation
    Given I have multiple headings on a screen
    When I enable "Validate Headings" check
    Then warnings appear if:
      | Issue | Warning |
      | Missing H1 | "Page should have one H1" |
      | Skipped level | "H3 follows H1, missing H2" |
      | Multiple H1 | "Multiple H1 headings" |

  Scenario: Preview heading structure
    Given I have headings configured
    When I enable "Show Heading Structure"
    Then I see an outline of headings
    And their hierarchy is visualized

  Scenario: Code generation for headings
    Given I have text with heading levels
    When I export the code
    Then the output includes:
    """
    Semantics(
      headingLevel: 1,
      child: Text(
        'Dashboard',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    )
    """
```

## Supported Semantics Roles

| Role | Description | Version | Use Case |
|------|-------------|---------|----------|
| radioGroup | Group of radio buttons | 3.32 | Option selection |
| dialog | Modal dialog | 3.32 | Popups, confirmations |
| list | List container | 3.32 | ListView, lists |
| table | Table container | 3.32 | DataTable, grids |
| status | Live status region | 3.32 | Loading, progress |
| alert | Alert notification | 3.32 | Errors, warnings |
| menu | Menu container | 3.32 | Dropdowns, context menus |
| navigation | Navigation landmark | 3.35 | Nav bars, menus |
| main | Main content | 3.35 | Primary content area |
| complementary | Supporting content | 3.35 | Sidebars, related info |

## Accessibility Validation Rules

| Rule | Severity | Message |
|------|----------|---------|
| Missing H1 | Warning | Page should have exactly one H1 heading |
| Skipped heading | Warning | Heading levels should not skip (H1 -> H3) |
| Unlabeled radio group | Error | Radio groups must have a group label |
| Dialog without label | Error | Dialogs must have an accessible label |
| List without item count | Info | Consider adding item count for long lists |
| Alert without description | Error | Alerts must have descriptive content |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Semantics tree build | < 16ms |
| Announcement delay | < 100ms |
| Validation time | < 50ms |
| Memory for semantics | < 100KB per screen |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)
- Semantics debugging tools

## Test Coverage Requirements

- Unit tests for each semantics role
- Unit tests for heading level validation
- Unit tests for live region configuration
- Unit tests for code generation with semantics
- Integration tests for accessibility preview
- Accessibility audit tests (automated)
- Screen reader compatibility tests (manual)

## Implementation Notes

1. Use Semantics widget wrapper for role assignment
2. Some widgets have built-in semantics (Radio, AlertDialog)
3. Live regions require careful timing to avoid announcement spam
4. Landmarks should be used sparingly (3-5 per page)
5. Heading validation runs on canvas change
6. Consider accessibility audit panel showing all issues
