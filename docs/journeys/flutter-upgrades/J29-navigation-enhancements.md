# J29: Navigation Enhancements

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J29 |
| Title | Navigation Enhancements |
| Actor | Designer building navigation-heavy applications |
| Priority | P2 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.35+ |

## User Story

As a designer building apps with navigation in FlutterForge, I want to use Flutter 3.35's NavigationDrawer header/footer slots, NavigationRail scrollable option, and route transition duration API so that I can create sophisticated navigation patterns with proper branding and smooth transitions.

## Background

Flutter 3.35 introduced navigation improvements:

**NavigationDrawer:**
- Built-in `header` slot for branding/user info
- Built-in `footer` slot for settings/logout
- Cleaner API vs custom child widgets

**NavigationRail:**
- `scrollable` property for many destinations
- Handles overflow gracefully

**Route Transitions:**
- `transitionDuration` API for custom timing
- Shared element transitions for predictive back

## Journey Stages

### S1: NavigationDrawer Header/Footer (3.35)

**Goal:** Configure NavigationDrawer with header and footer slots

#### Acceptance Criteria

```gherkin
Feature: NavigationDrawer Header and Footer
  As a designer
  I want header and footer slots in navigation drawer
  So that I can add branding and actions

  Scenario: Add NavigationDrawer to palette
    Given I open the widget palette
    When I expand the "Navigation" category
    Then I see "Navigation Drawer" widget
    And it shows header/footer support

  Scenario: Configure header slot
    Given I have a NavigationDrawer selected
    When I open "Header" section in properties
    Then I can configure header content:
      | Option | Description |
      | User Account | Avatar, name, email |
      | Brand Header | Logo and app name |
      | Custom Widget | Any widget |
      | None | No header |

  Scenario: Configure footer slot
    Given I have a NavigationDrawer
    When I open "Footer" section in properties
    Then I can configure footer content:
      | Option | Description |
      | Settings Link | Settings navigation |
      | Logout Button | Sign out action |
      | App Version | Version info |
      | Custom Widget | Any widget |
      | None | No footer |

  Scenario: Preview drawer with header/footer
    Given I have header and footer configured
    When I preview the navigation drawer
    Then the header appears at top (sticky)
    And the footer appears at bottom (sticky)
    And navigation items scroll between them

  Scenario: Code generation with header/footer
    Given I have configured header and footer
    When I export the code
    Then the output includes:
    """
    NavigationDrawer(
      header: DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            SizedBox(height: 8),
            Text(user.name, style: TextStyle(color: Colors.white)),
            Text(user.email, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
      footer: Padding(
        padding: EdgeInsets.all(16),
        child: TextButton.icon(
          icon: Icon(Icons.logout),
          label: Text('Sign Out'),
          onPressed: () => _signOut(),
        ),
      ),
      children: [
        NavigationDrawerDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    )
    """
```

### S2: NavigationRail Scrollable (3.35)

**Goal:** Configure scrollable NavigationRail for many destinations

#### Acceptance Criteria

```gherkin
Feature: NavigationRail Scrollable
  As a designer
  I want scrollable navigation rail
  So that I can have many navigation destinations

  Scenario: Enable scrollable rail
    Given I have a NavigationRail widget selected
    When I have more than 5 destinations
    Then I see "Scrollable" toggle in properties
    And it defaults to true when destinations exceed view

  Scenario: Configure scroll behavior
    Given I enable scrollable NavigationRail
    Then I can configure:
      | Setting | Description |
      | Scroll Physics | bouncing, clamping |
      | Show Scrollbar | Always, never, auto |
      | Scroll Padding | Top/bottom padding |

  Scenario: Preview scrollable rail
    Given I have 10+ destinations in NavigationRail
    When I preview the widget
    Then destinations that don't fit are scrollable
    And the rail maintains fixed width
    And selected indicator scrolls into view

  Scenario: Extended labels behavior
    Given I have a scrollable NavigationRail
    When extended labels are enabled
    Then labels scroll with icons
    And the rail width accommodates labels

  Scenario: Code generation with scrollable
    Given I have scrollable NavigationRail configured
    When I export the code
    Then the output includes:
    """
    NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      scrollable: true,
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search),
          label: Text('Search'),
        ),
        // ... many more destinations
      ],
    )
    """
```

### S3: Route Transition Duration (3.35)

**Goal:** Configure custom route transition timing

#### Acceptance Criteria

```gherkin
Feature: Route Transition Duration API
  As a designer
  I want to control route transition timing
  So that navigation feels appropriate for my app

  Scenario: Configure transition duration
    Given I am configuring screen navigation
    When I open "Transition" settings
    Then I can configure:
      | Setting | Default | Range |
      | Forward Duration | 300ms | 0-1000ms |
      | Reverse Duration | 300ms | 0-1000ms |
      | Curve | easeInOut | Standard curves |

  Scenario: Different forward/reverse timing
    Given I want different timing for forward and back
    When I set forward: 400ms, reverse: 200ms
    Then navigating forward takes 400ms
    And navigating back takes 200ms

  Scenario: Preview transition timing
    Given I have transition timing configured
    When I click "Preview Transition"
    Then I see the transition animation
    And timing matches my configuration
    And I can adjust in real-time

  Scenario: Transition presets
    Given I open transition configuration
    Then I see presets:
      | Preset | Forward | Reverse | Curve |
      | Instant | 0ms | 0ms | linear |
      | Quick | 150ms | 100ms | easeOut |
      | Standard | 300ms | 250ms | easeInOut |
      | Dramatic | 500ms | 400ms | easeInOutCubic |

  Scenario: Code generation with transition
    Given I have custom transition timing
    When I export the code
    Then the output includes:
    """
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return DetailsScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
    """
```

### S4: Shared Element Transitions (3.35)

**Goal:** Configure shared element transitions for predictive back

#### Acceptance Criteria

```gherkin
Feature: Shared Element Transitions
  As a designer
  I want shared element transitions
  So that navigation feels connected and smooth

  Scenario: Define shared element
    Given I have a widget on screen A
    When I select "Enable Shared Element Transition"
    Then I can assign a transition tag
    And link it to a widget on screen B

  Scenario: Configure shared element pair
    Given I have widgets on two screens
    When I configure shared element pair
    Then I can set:
      | Setting | Description |
      | Tag | Unique identifier |
      | Source Widget | Widget on origin screen |
      | Target Widget | Widget on destination screen |
      | Curve | Animation curve |

  Scenario: Predictive back support
    Given I have shared elements configured
    When the user starts predictive back gesture
    Then the shared element animates toward its previous position
    And the animation follows gesture progress
    And completing gesture completes transition

  Scenario: Preview shared element
    Given I have shared element pair configured
    When I click "Preview Transition"
    Then I see the element morph between screens
    And size/position interpolate smoothly

  Scenario: Code generation with shared element
    Given I have shared element transitions
    When I export the code
    Then the output includes:
    """
    // Screen A
    Hero(
      tag: 'product_image_${product.id}',
      child: Image.network(product.imageUrl),
    )

    // Screen B
    Hero(
      tag: 'product_image_${product.id}',
      child: Image.network(product.imageUrl),
    )

    // Navigation
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
    """

  Scenario: Non-Hero shared element
    Given I want shared element without Hero
    When I use SharedElementTransition API
    Then I can configure custom morphing behavior
    And it works with predictive back
```

### S5: MediaQuery Convenience Methods (3.35)

**Goal:** Support MediaQuery.widthOf/heightOf convenience methods

#### Acceptance Criteria

```gherkin
Feature: MediaQuery Convenience Methods
  As a designer
  I want simpler MediaQuery access
  So that responsive code is cleaner

  Scenario: Generate widthOf/heightOf code
    Given I have a responsive layout widget
    When I export code with MediaQuery dependencies
    Then the generated code uses convenience methods:
    """
    // Before (verbose)
    final width = MediaQuery.of(context).size.width;

    // After (3.35+)
    final width = MediaQuery.widthOf(context);
    """

  Scenario: Version-aware generation
    Given I target Flutter 3.35+
    Then generated code uses:
      | Old API | New API |
      | MediaQuery.of(context).size.width | MediaQuery.widthOf(context) |
      | MediaQuery.of(context).size.height | MediaQuery.heightOf(context) |
      | MediaQuery.of(context).padding | MediaQuery.paddingOf(context) |
      | MediaQuery.of(context).viewInsets | MediaQuery.viewInsetsOf(context) |

  Scenario: Backward compatibility
    Given I target Flutter < 3.35
    Then generated code uses old MediaQuery.of API
    And code remains compatible
```

## Supported Navigation Widgets

| Widget | Enhancement | Version | Priority |
|--------|-------------|---------|----------|
| NavigationDrawer | header/footer slots | 3.35 | P1 |
| NavigationRail | scrollable property | 3.35 | P1 |
| PageRouteBuilder | transitionDuration API | 3.35 | P2 |
| Hero | Predictive back support | 3.35 | P2 |
| SharedElementTransition | Advanced morphing | 3.35 | P3 |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Navigation render time | < 16ms |
| Transition animation | 60fps |
| Scroll performance | 60fps |
| Memory per screen | < 500KB |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)
- Navigation system

## Test Coverage Requirements

- Unit tests for NavigationDrawer header/footer
- Unit tests for NavigationRail scrollable
- Unit tests for transition duration configuration
- Unit tests for shared element pairing
- Unit tests for MediaQuery convenience methods
- Integration tests for navigation preview
- Visual tests for transition animations

## Implementation Notes

1. NavigationDrawer header/footer are named slots
2. NavigationRail scrollable requires proper height constraint
3. Transition duration API requires PageRouteBuilder
4. Hero tag uniqueness is critical for shared elements
5. Predictive back is Android 14+ feature
6. MediaQuery convenience methods optimize rebuild
