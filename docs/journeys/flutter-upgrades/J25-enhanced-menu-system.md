# J25: Enhanced Menu System

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J25 |
| Title | Enhanced Menu System |
| Actor | Designer building navigation and context menus |
| Priority | P1 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ |

## User Story

As a designer building apps with menus in FlutterForge, I want access to Flutter 3.32's RawMenuAnchor for custom menu systems and improved SearchAnchor with lifecycle callbacks so that I can create sophisticated menu-driven interfaces.

## Background

Flutter 3.32 introduced key menu system improvements:

**RawMenuAnchor:**
- Low-level menu anchor for fully custom menu implementations
- Direct control over menu positioning and behavior
- Foundation for building custom dropdown/popup patterns

**SearchAnchor Improvements:**
- `viewOnOpen` callback when search view opens
- `viewOnClose` callback when search view closes
- Better keyboard navigation
- Improved focus management

## Journey Stages

### S1: RawMenuAnchor Widget

**Goal:** Add RawMenuAnchor to widget palette for custom menu systems

#### Acceptance Criteria

```gherkin
Feature: RawMenuAnchor Widget
  As a designer
  I want to use RawMenuAnchor for custom menus
  So that I have full control over menu behavior

  Scenario: Add RawMenuAnchor to palette
    Given I open the widget palette
    When I expand the "Menu" or "Navigation" category
    Then I see "Raw Menu Anchor" widget
    And it has a description explaining its use case

  Scenario: Configure RawMenuAnchor
    Given I have a RawMenuAnchor on canvas
    When I open the properties panel
    Then I can configure:
      | Property | Type | Description |
      | menuChildren | List<Widget> | Menu item widgets |
      | controller | MenuController | Programmatic control |
      | anchorTapClosesMenu | bool | Auto-close on tap |
      | consumeOutsideTap | bool | Handle outside taps |
      | alignmentOffset | Offset | Menu position offset |
      | clipBehavior | Clip | Overflow clipping |

  Scenario: Add menu items visually
    Given I have a RawMenuAnchor selected
    When I click "Add Menu Item" in properties
    Then I can add menu items of types:
      | Type | Description |
      | MenuItemButton | Standard clickable item |
      | SubmenuButton | Nested submenu |
      | MenuDivider | Visual separator |
      | Custom Widget | Any widget |

  Scenario: Preview menu open state
    Given I have a RawMenuAnchor with menu items
    When I click "Preview Open" in properties
    Then the menu displays in open position on canvas
    And I can see menu item arrangement
    And menu positioning relative to anchor

  Scenario: Code generation for RawMenuAnchor
    Given I have a configured RawMenuAnchor
    When I export the code
    Then clean RawMenuAnchor code is generated:
    """
    RawMenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          child: Text('Option 1'),
        ),
        MenuDivider(),
        MenuItemButton(
          onPressed: () {},
          child: Text('Option 2'),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () => controller.toggle(),
          icon: Icon(Icons.more_vert),
        );
      },
    )
    """
```

### S2: SearchAnchor Lifecycle Callbacks (3.32)

**Goal:** Expose viewOnOpen/viewOnClose callbacks for SearchAnchor

#### Acceptance Criteria

```gherkin
Feature: SearchAnchor Lifecycle Callbacks
  As a designer
  I want to handle search view open/close events
  So that I can trigger analytics or state changes

  Scenario: Configure viewOnOpen callback
    Given I have a SearchAnchor widget selected
    When I open the properties panel
    Then I see "View Lifecycle" section
    And I can configure "On View Open" action:
      | Action Type | Description |
      | Analytics Event | Fire analytics when search opens |
      | State Change | Update app state |
      | Custom Code | User-provided callback |

  Scenario: Configure viewOnClose callback
    Given I have a SearchAnchor widget
    When I configure "On View Close" action
    Then I can specify what happens when search closes
    And the generated code includes the callback

  Scenario: Code generation with callbacks
    Given I have SearchAnchor with lifecycle callbacks
    When I export the code
    Then the output includes:
    """
    SearchAnchor(
      viewOnOpen: () {
        // Analytics or state code
      },
      viewOnClose: () {
        // Cleanup code
      },
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          onTap: () => controller.openView(),
        );
      },
      suggestionsBuilder: (context, controller) {
        return [/* suggestions */];
      },
    )
    """

  Scenario: Preview search lifecycle
    Given I have a SearchAnchor on canvas
    When I tap the search anchor in preview mode
    Then the search view opens
    And I see "viewOnOpen called" indicator
    When I close the search view
    Then I see "viewOnClose called" indicator
```

### S3: SearchAnchor Keyboard Navigation (3.32)

**Goal:** Configure improved keyboard navigation for SearchAnchor

#### Acceptance Criteria

```gherkin
Feature: SearchAnchor Keyboard Navigation
  As a designer
  I want to configure keyboard navigation
  So that search is accessible via keyboard

  Scenario: Configure keyboard shortcuts
    Given I have a SearchAnchor widget
    When I open the "Keyboard" section in properties
    Then I can configure:
      | Setting | Default | Description |
      | Enable keyboard nav | true | Arrow key navigation |
      | Submit on Enter | true | Select on Enter key |
      | Close on Escape | true | Dismiss on Escape |
      | Focus trap | true | Keep focus in search |

  Scenario: Preview keyboard navigation
    Given I have a SearchAnchor on canvas
    When I enable preview mode and focus the search
    Then I can use arrow keys to navigate suggestions
    And Enter selects the highlighted suggestion
    And Escape closes the search view

  Scenario: Accessibility properties
    Given I have a SearchAnchor widget
    Then I can configure accessibility:
      | Property | Description |
      | searchFieldLabel | Screen reader label |
      | searchViewLabel | Search view label |
      | hintText | Placeholder text |
```

### S4: Menu Semantics Roles (3.32)

**Goal:** Support comprehensive menu-related semantics roles

#### Acceptance Criteria

```gherkin
Feature: Menu Semantics Roles
  As a designer
  I want proper semantics for menu components
  So that menus are accessible to screen readers

  Scenario: Menu role assignment
    Given I have a RawMenuAnchor
    When I configure accessibility settings
    Then the menu container has role "menu"
    And menu items have role "menuitem"
    And submenus have role "submenu"

  Scenario: Radio group in menu
    Given I have a menu with radio options
    When I mark items as "Radio Group"
    Then the container has role "radiogroup"
    And items have role "menuitemradio"
    And selection state is announced

  Scenario: Code generation with semantics
    Given I have a menu with semantic roles
    When I export the code
    Then the output includes Semantics wrappers:
    """
    Semantics(
      role: SemanticsRole.menu,
      child: Column(
        children: [
          Semantics(
            role: SemanticsRole.menuitem,
            child: MenuItemButton(...),
          ),
        ],
      ),
    )
    """
```

## Supported Menu Widgets

| Widget | Category | New in 3.32 | Properties |
|--------|----------|-------------|------------|
| RawMenuAnchor | Menu | Yes | Full custom control |
| SearchAnchor | Search | Enhanced | viewOnOpen/Close callbacks |
| MenuAnchor | Menu | Existing | Standard menus |
| PopupMenuButton | Menu | Existing | Simple popup menus |
| DropdownMenu | Input | Existing | Form dropdowns |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Menu render time | < 16ms (60fps) |
| Keyboard response | < 50ms |
| Search suggestion latency | < 100ms |
| Memory per menu | < 500KB |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)
- Accessibility system (J27)

## Test Coverage Requirements

- Unit tests for RawMenuAnchor property configuration
- Unit tests for SearchAnchor lifecycle callbacks
- Unit tests for keyboard navigation settings
- Unit tests for semantics role assignment
- Unit tests for code generation
- Integration tests for menu preview
- Accessibility tests for screen reader compatibility

## Implementation Notes

1. RawMenuAnchor requires builder pattern for anchor widget
2. Menu items can be nested (SubmenuButton)
3. SearchAnchor callbacks are optional - handle null case
4. Keyboard navigation is default-on, allow disabling
5. Consider menu positioning preview overlay on canvas
6. Semantics roles require Flutter 3.32+ Semantics API
