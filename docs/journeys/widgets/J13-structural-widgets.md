# J13: Structural Widgets

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J13 |
| Title | Structural Widgets |
| Actor | Designer building app structure |
| Priority | P0 |
| Phase | 6 - Widget Completion |

## User Story

As a designer building Flutter UIs, I want to add structural widgets (Card, ListTile, AppBar, Scaffold, Wrap) to my designs so that I can create standard Material Design app structures.

## Journey Stages

### S1: Card Widget

**Goal:** Add and configure Material Design cards

#### Acceptance Criteria

```gherkin
Feature: Card Widget
  As a designer
  I want to add Card widgets to my canvas
  So that I can create elevated content containers

  Scenario: Add Card from palette
    Given I am on the design canvas
    When I drag a Card from the Layout palette category
    And I drop it on the canvas
    Then a Card widget appears with default elevation shadow
    And the Card shows a design-time placeholder for content

  Scenario: Configure Card properties
    Given I have a Card selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | elevation | Double | 1.0 |
      | color | Color | null (surface) |
      | shadowColor | Color | null |
      | surfaceTintColor | Color | null |
      | margin | EdgeInsets | 4.0 all |
      | clipBehavior | Clip | none |

  Scenario: Configure Card shape
    Given I have a Card selected
    Then I can configure shape properties:
      | Property | Type | Default |
      | borderRadius | Double | 12.0 |
      | borderWidth | Double | 0.0 |
      | borderColor | Color | null |

  Scenario: Add content to Card
    Given I have a Card on the canvas
    When I drag a Column into the Card
    Then the Column becomes the Card's child
    And the Card expands to fit the content
```

### S2: ListTile Widget

**Goal:** Add and configure list item layouts

#### Acceptance Criteria

```gherkin
Feature: ListTile Widget
  As a designer
  I want to add ListTile widgets
  So that I can create consistent list item layouts

  Scenario: Add ListTile from palette
    Given I am on the design canvas
    When I drag a ListTile from the Content palette category
    And I drop it on the canvas
    Then a ListTile widget appears with placeholder content

  Scenario: Configure ListTile content
    Given I have a ListTile selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Description |
      | title | String | Primary text (required) |
      | subtitle | String | Secondary text |
      | leading | Widget | Start widget (icon/avatar) |
      | trailing | Widget | End widget (icon/checkbox) |

  Scenario: Configure ListTile appearance
    Given I have a ListTile selected
    Then I can also configure:
      | Property | Type | Default |
      | dense | Boolean | false |
      | enabled | Boolean | true |
      | selected | Boolean | false |
      | tileColor | Color | null |
      | selectedTileColor | Color | null |
      | contentPadding | EdgeInsets | 16h, 8v |

  Scenario: Configure ListTile interaction
    Given I have a ListTile selected
    Then I can configure:
      | Property | Type |
      | onTap | Boolean (enabled) |
      | onLongPress | Boolean (enabled) |

  Scenario: ListTile with leading icon
    Given I have a ListTile selected
    When I set leading to an Icon widget
    Then the icon appears at the start of the tile
    And proper spacing is maintained
```

### S3: AppBar Widget

**Goal:** Add and configure app bar headers

#### Acceptance Criteria

```gherkin
Feature: AppBar Widget
  As a designer
  I want to add AppBar widgets
  So that I can design app header layouts

  Scenario: Add AppBar from palette
    Given I am on the design canvas
    When I drag an AppBar from the Structure palette category
    And I drop it on the canvas
    Then an AppBar widget appears with default styling
    And the AppBar shows a placeholder title "AppBar"

  Scenario: Configure AppBar content
    Given I have an AppBar selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Description |
      | title | String | Title text |
      | centerTitle | Boolean | Center the title |
      | leading | Widget | Navigation widget |
      | automaticallyImplyLeading | Boolean | Auto back button |

  Scenario: Configure AppBar actions
    Given I have an AppBar selected
    When I configure actions
    Then I can add multiple action widgets (IconButtons)
    And they appear at the end of the AppBar

  Scenario: Configure AppBar appearance
    Given I have an AppBar selected
    Then I can configure:
      | Property | Type | Default |
      | backgroundColor | Color | null (primary) |
      | foregroundColor | Color | null |
      | elevation | Double | 4.0 |
      | shadowColor | Color | null |
      | toolbarHeight | Double | 56.0 |

  Scenario: AppBar with actions
    Given I have an AppBar selected
    When I add IconButton widgets to the actions slot
    Then they appear aligned to the right
    And proper spacing is maintained between actions
```

### S4: Scaffold Widget

**Goal:** Add and configure full app structure

#### Acceptance Criteria

```gherkin
Feature: Scaffold Widget
  As a designer
  I want to add Scaffold widgets
  So that I can design complete screen layouts

  Scenario: Add Scaffold from palette
    Given I am on the design canvas
    When I drag a Scaffold from the Structure palette category
    And I drop it on the canvas
    Then a Scaffold widget appears with placeholder slots
    And I see slots for: appBar, body, floatingActionButton, drawer

  Scenario: Configure Scaffold slots
    Given I have a Scaffold selected
    When I view the properties panel
    Then I see the following slot properties:
      | Slot | Accepts |
      | appBar | PreferredSizeWidget (AppBar) |
      | body | Widget |
      | floatingActionButton | Widget |
      | drawer | Widget |
      | endDrawer | Widget |
      | bottomNavigationBar | Widget |
      | bottomSheet | Widget |

  Scenario: Configure Scaffold appearance
    Given I have a Scaffold selected
    Then I can configure:
      | Property | Type | Default |
      | backgroundColor | Color | null (background) |
      | extendBody | Boolean | false |
      | extendBodyBehindAppBar | Boolean | false |
      | resizeToAvoidBottomInset | Boolean | true |

  Scenario: Add body to Scaffold
    Given I have a Scaffold on the canvas
    When I drag a Column into the body slot
    Then the Column becomes the Scaffold's body
    And the body fills the remaining space below the AppBar

  Scenario: Scaffold with AppBar
    Given I have a Scaffold with an AppBar set
    When I view the canvas
    Then the AppBar appears at the top
    And the body content appears below it
```

### S5: Wrap Widget

**Goal:** Add and configure flowing layouts

#### Acceptance Criteria

```gherkin
Feature: Wrap Widget
  As a designer
  I want to add Wrap widgets
  So that I can create flowing layouts that wrap to new lines

  Scenario: Add Wrap from palette
    Given I am on the design canvas
    When I drag a Wrap from the Layout palette category
    And I drop it on the canvas
    Then a Wrap widget appears with a placeholder

  Scenario: Configure Wrap layout
    Given I have a Wrap selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | direction | Axis | horizontal |
      | alignment | WrapAlignment | start |
      | spacing | Double | 0.0 |
      | runSpacing | Double | 0.0 |
      | runAlignment | WrapAlignment | start |
      | crossAxisAlignment | WrapCrossAlignment | start |

  Scenario: Wrap with children
    Given I have a Wrap on the canvas
    When I add multiple Chip widgets as children
    And the total width exceeds the Wrap's width
    Then children wrap to the next line
    And spacing is applied between items

  Scenario: Vertical Wrap
    Given I have a Wrap with direction set to vertical
    When I add children
    Then children flow vertically first
    And wrap to new columns when height is exceeded
```

## Code Generation Requirements

### Card Code Output

```dart
Card(
  elevation: 2.0,
  margin: EdgeInsets.all(8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
  child: // child widget...
)
```

### ListTile Code Output

```dart
ListTile(
  leading: Icon(Icons.person),
  title: Text('John Doe'),
  subtitle: Text('john@example.com'),
  trailing: Icon(Icons.chevron_right),
  onTap: () {},
)
```

### AppBar Code Output

```dart
AppBar(
  title: Text('My App'),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)
```

### Scaffold Code Output

```dart
Scaffold(
  appBar: AppBar(title: Text('Home')),
  body: Center(child: Text('Content')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

### Wrap Code Output

```dart
Wrap(
  spacing: 8.0,
  runSpacing: 8.0,
  alignment: WrapAlignment.start,
  children: [
    // children...
  ],
)
```

## Design-Time Considerations

### Scaffold Preview

- Show all slot positions visually
- Indicate which slots are filled/empty
- Respect screen layout in canvas viewport

### ListTile Layout

- Show proper leading/trailing positioning
- Maintain minimum touch target sizes (48x48)
- Preview selection and hover states

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Widget render time | < 16ms (60fps) |
| Property update latency | < 100ms |
| Scaffold slot detection | 100% accuracy |

## Dependencies

- WidgetRegistry (existing)
- WidgetRenderer (existing)
- PropertiesPanel (existing)
- DartGenerator (existing)
- NestedDropZone (existing)

## Test Coverage Requirements

- Unit tests for each widget definition
- Unit tests for widget rendering
- Unit tests for code generation
- Unit tests for slot-based children (Scaffold)
- Integration tests for drag-drop into slots
