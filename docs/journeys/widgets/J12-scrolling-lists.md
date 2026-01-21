# J12: Scrolling and Lists

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J12 |
| Title | Scrolling and List Widgets |
| Actor | Designer building scrollable layouts |
| Priority | P0 |
| Phase | 6 - Widget Completion |

## User Story

As a designer building Flutter UIs, I want to add scrolling and list widgets (ListView, GridView, SingleChildScrollView) to my designs so that I can create scrollable content layouts.

## Journey Stages

### S1: ListView Widget

**Goal:** Add and configure vertical/horizontal list layouts

#### Acceptance Criteria

```gherkin
Feature: ListView Widget
  As a designer
  I want to add ListView widgets to my canvas
  So that I can design scrollable list layouts

  Scenario: Add ListView from palette
    Given I am on the design canvas
    When I drag a ListView from the Layout palette category
    And I drop it on the canvas
    Then a ListView widget appears with a placeholder indicating scroll area
    And the ListView shows a design-time hint "Drop children here"

  Scenario: Add children to ListView
    Given I have a ListView on the canvas
    When I drag widgets into the ListView
    Then they appear as scrollable children
    And I can reorder them via drag-drop in the widget tree

  Scenario: Configure ListView properties
    Given I have a ListView selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | scrollDirection | Axis | vertical |
      | reverse | Boolean | false |
      | padding | EdgeInsets | null |
      | shrinkWrap | Boolean | false |
      | physics | ScrollPhysics | null |

  Scenario: ListView scroll direction
    Given I have a ListView selected
    When I set scrollDirection to "horizontal"
    Then the canvas shows children arranged horizontally
    And the scroll indicator changes to horizontal

  Scenario: ListView design-time scroll preview
    Given I have a ListView with multiple children
    When I hover over the ListView in the canvas
    Then I see scroll handles indicating scrollable content
    And I can scroll within the canvas to preview content
```

### S2: GridView Widget

**Goal:** Add and configure grid layouts

#### Acceptance Criteria

```gherkin
Feature: GridView Widget
  As a designer
  I want to add GridView widgets
  So that I can design grid-based scrollable layouts

  Scenario: Add GridView from palette
    Given I am on the design canvas
    When I drag a GridView from the Layout palette category
    And I drop it on the canvas
    Then a GridView widget appears with grid placeholder cells

  Scenario: Configure GridView with count
    Given I have a GridView selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | crossAxisCount | Integer | 2 |
      | mainAxisSpacing | Double | 0.0 |
      | crossAxisSpacing | Double | 0.0 |
      | childAspectRatio | Double | 1.0 |

  Scenario: GridView with extent
    Given I want fixed-width grid items
    When I configure maxCrossAxisExtent
    Then items have a maximum width of that value
    And the grid automatically calculates column count

  Scenario: Configure GridView scrolling
    Given I have a GridView selected
    Then I can also configure:
      | Property | Type | Default |
      | scrollDirection | Axis | vertical |
      | reverse | Boolean | false |
      | shrinkWrap | Boolean | false |
      | padding | EdgeInsets | null |

  Scenario: Add children to GridView
    Given I have a GridView on the canvas
    When I drag widgets into the GridView
    Then they appear in grid cells
    And the grid layout updates based on crossAxisCount
```

### S3: SingleChildScrollView Widget

**Goal:** Add scrolling capability to any widget

#### Acceptance Criteria

```gherkin
Feature: SingleChildScrollView Widget
  As a designer
  I want to wrap content in a SingleChildScrollView
  So that I can make any content scrollable

  Scenario: Add SingleChildScrollView from palette
    Given I am on the design canvas
    When I drag a SingleChildScrollView from the Layout palette category
    And I drop it on the canvas
    Then a scroll container appears with a single child slot

  Scenario: Configure SingleChildScrollView
    Given I have a SingleChildScrollView selected
    When I view the properties panel
    Then I see the following configurable properties:
      | Property | Type | Default |
      | scrollDirection | Axis | vertical |
      | reverse | Boolean | false |
      | padding | EdgeInsets | null |
      | physics | ScrollPhysics | null |

  Scenario: Add child to SingleChildScrollView
    Given I have a SingleChildScrollView on the canvas
    When I drag a Column widget into it
    And the Column has many children
    Then the content becomes scrollable
    And the design-time preview shows scroll indicators

  Scenario: Nested scroll warning
    Given I have a SingleChildScrollView containing a ListView
    When I view the widget tree
    Then I see a warning indicator about nested scrollables
    And the properties panel suggests setting shrinkWrap on inner list
```

## Code Generation Requirements

### ListView Code Output

```dart
ListView(
  scrollDirection: Axis.vertical,
  padding: EdgeInsets.all(8.0),
  children: [
    // child widgets...
  ],
)
```

### GridView Code Output

```dart
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: 8.0,
  crossAxisSpacing: 8.0,
  childAspectRatio: 1.0,
  children: [
    // child widgets...
  ],
)
```

### SingleChildScrollView Code Output

```dart
SingleChildScrollView(
  scrollDirection: Axis.vertical,
  padding: EdgeInsets.all(16.0),
  child: Column(
    // children...
  ),
)
```

## Design-Time Considerations

### Scroll Preview

- Show scroll indicators at design time
- Allow limited scroll interaction in canvas
- Display overflow indicator when content exceeds viewport

### Performance

- Limit rendered children in canvas to prevent performance issues
- Show placeholder for off-screen items
- Use design-time constraints to prevent infinite expansion

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Widget render time | < 16ms (60fps) |
| Scroll preview frame rate | 60fps |
| Max visible children in preview | 20 |

## Dependencies

- WidgetRegistry (existing)
- WidgetRenderer (existing)
- PropertiesPanel (existing)
- DartGenerator (existing)
- NestedDropZone (existing)

## Test Coverage Requirements

- Unit tests for each widget definition
- Unit tests for widget rendering with children
- Unit tests for code generation
- Unit tests for scroll direction changes
- Integration tests for drag-drop into scroll containers
