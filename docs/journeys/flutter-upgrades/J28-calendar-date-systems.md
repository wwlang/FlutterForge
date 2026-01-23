# J28: Calendar and Date Systems

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J28 |
| Title | Calendar and Date Systems |
| Actor | Designer building date pickers for international apps |
| Priority | P2 |
| Phase | 9 - Flutter 3.32-3.38 Enhancements |
| Flutter Version | 3.32+ |

## User Story

As a designer building apps for international audiences in FlutterForge, I want to configure custom calendar systems (Islamic, Persian, Hebrew, etc.) using Flutter 3.32's calendarDelegate and customize year picker shapes so that my date pickers work correctly for users in different regions.

## Background

Flutter 3.32 introduced:

**calendarDelegate:**
- Custom calendar system support
- Non-Gregorian calendar rendering
- Localized date calculations

**DatePicker yearShape:**
- Customizable year picker appearance
- Shape consistency with design system

These features enable:
1. Apps for Middle East (Islamic calendar)
2. Apps for Iran (Persian/Jalali calendar)
3. Apps for Israel (Hebrew calendar)
4. Consistent year picker styling

## Journey Stages

### S1: Calendar System Selection (3.32)

**Goal:** Allow selection of calendar system for date pickers

#### Acceptance Criteria

```gherkin
Feature: Custom Calendar Systems
  As a designer
  I want to select different calendar systems
  So that date pickers work for international users

  Scenario: Select calendar system
    Given I have a DatePicker widget selected
    When I open the "Calendar" section in properties
    Then I see "Calendar System" dropdown with options:
      | System | Description |
      | Gregorian | Western calendar (default) |
      | Islamic (Hijri) | Islamic lunar calendar |
      | Persian (Jalali) | Iranian solar calendar |
      | Hebrew | Jewish lunisolar calendar |
      | Buddhist | Thai Buddhist calendar |
      | Japanese | Japanese imperial calendar |

  Scenario: Preview non-Gregorian calendar
    Given I select "Islamic (Hijri)" calendar system
    When I preview the date picker
    Then the calendar shows Islamic months:
      | Month | Arabic |
      | Muharram | محرم |
      | Safar | صفر |
      | Rabi' al-Awwal | ربيع الأول |
    And dates are in Hijri format
    And the picker respects RTL layout

  Scenario: Preview Persian calendar
    Given I select "Persian (Jalali)" calendar system
    When I preview the date picker
    Then the calendar shows Persian months:
      | Month | Persian |
      | Farvardin | فروردین |
      | Ordibehesht | اردیبهشت |
      | Khordad | خرداد |
    And year is in Persian format (e.g., 1404)
    And week starts on Saturday

  Scenario: Calendar-aware date constraints
    Given I have an Islamic calendar date picker
    When I set minimum date to "1 Ramadan 1446"
    And maximum date to "30 Shawwal 1446"
    Then only dates in that range are selectable
    And constraints work with Islamic calendar math
```

### S2: Calendar Delegate Configuration (3.32)

**Goal:** Configure detailed calendar delegate settings

#### Acceptance Criteria

```gherkin
Feature: Calendar Delegate Settings
  As a designer
  I want to configure calendar delegate details
  So that the calendar behaves correctly

  Scenario: Configure week start day
    Given I have a date picker with calendar delegate
    When I open "Week Settings"
    Then I can configure first day of week:
      | Calendar | Default Start |
      | Gregorian | Sunday/Monday (locale) |
      | Islamic | Saturday |
      | Persian | Saturday |
      | Hebrew | Sunday |

  Scenario: Configure month/year format
    Given I have a non-Gregorian calendar
    When I configure display format
    Then I can set:
      | Setting | Options |
      | Month Format | Full name, Short name, Number |
      | Year Format | Full digits, Era format |
      | Day Format | Arabic numerals, Local numerals |

  Scenario: Leap year handling
    Given I have a calendar date picker
    Then the calendar correctly handles leap years:
      | Calendar | Leap Rule |
      | Gregorian | Every 4 years (with century rules) |
      | Islamic | 11 leap years per 30-year cycle |
      | Persian | Complex solar calculation |
      | Hebrew | 7 leap years per 19-year cycle |

  Scenario: Code generation with delegate
    Given I have a Persian calendar configured
    When I export the code
    Then the output includes calendar delegate:
    """
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      calendarDelegate: PersianCalendarDelegate(
        firstDayOfWeek: DateTime.saturday,
        locale: Locale('fa'),
      ),
    )
    """
```

### S3: Year Picker Customization (3.32)

**Goal:** Configure year picker shape and appearance

#### Acceptance Criteria

```gherkin
Feature: DatePicker yearShape
  As a designer
  I want to customize year picker appearance
  So that it matches my design system

  Scenario: Configure year shape
    Given I have a DatePicker widget
    When I open "Year Picker Style" in properties
    Then I can configure:
      | Property | Options |
      | Shape | Rounded Rectangle, Circle, Stadium |
      | Border Radius | 0-20 dp |
      | Selected Color | Theme color picker |
      | Unselected Color | Theme color picker |

  Scenario: Preview year picker
    Given I have year picker styling configured
    When I click "Preview Year Selector"
    Then the year picker displays with custom styling
    And selected year shows configured shape
    And colors match my configuration

  Scenario: Year range configuration
    Given I have a date picker
    When I configure year range
    Then I can set:
      | Setting | Description |
      | Start Year | First selectable year |
      | End Year | Last selectable year |
      | Show Count | Number of years visible |

  Scenario: Code generation with yearShape
    Given I have customized year picker
    When I export the code
    Then the output includes:
    """
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              yearStyle: TextStyle(...),
              yearForegroundColor: WidgetStatePropertyAll(Colors.blue),
              yearBackgroundColor: WidgetStatePropertyAll(Colors.blue.shade50),
              yearOverlayColor: WidgetStatePropertyAll(Colors.blue.shade100),
            ),
          ),
          child: child!,
        );
      },
    )
    """
```

### S4: Tooltip Constraints (3.32)

**Goal:** Configure tooltip sizing constraints

#### Acceptance Criteria

```gherkin
Feature: Tooltip Constraints
  As a designer
  I want better control over tooltip sizing
  So that tooltips fit their content properly

  Scenario: Configure tooltip constraints
    Given I have a Tooltip widget selected
    When I open "Size" section in properties
    Then I see "Constraints" replacing deprecated "height":
      | Property | Description |
      | Min Width | Minimum tooltip width |
      | Max Width | Maximum tooltip width |
      | Min Height | Minimum tooltip height |
      | Max Height | Maximum tooltip height |

  Scenario: Constraint presets
    Given I'm configuring tooltip constraints
    Then I see preset options:
      | Preset | Constraints |
      | Compact | max 200x100 |
      | Standard | max 300x150 |
      | Large | max 400x200 |
      | Custom | User defined |

  Scenario: Preview tooltip sizing
    Given I have a tooltip with long content
    When I set max width constraint
    Then the tooltip wraps text at that width
    And preview shows the constrained tooltip

  Scenario: Code generation with constraints
    Given I have configured tooltip constraints
    When I export the code
    Then the output includes:
    """
    Tooltip(
      message: 'This is a helpful tooltip with more information',
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 150,
      ),
      child: Icon(Icons.help),
    )
    """
```

### S5: Carousel Animation (3.32)

**Goal:** Support Carousel animateToItem() for programmatic navigation

#### Acceptance Criteria

```gherkin
Feature: Carousel animateToItem
  As a designer
  I want to animate carousel to specific items
  So that I can create guided experiences

  Scenario: Configure carousel controller
    Given I have a CarouselView widget
    When I check "Expose Controller" in properties
    Then the generated code includes CarouselController
    And I can configure controller methods

  Scenario: Add navigation buttons
    Given I have a carousel with controller
    When I add navigation controls
    Then I can configure:
      | Control | Action |
      | Previous | animateToItem(currentIndex - 1) |
      | Next | animateToItem(currentIndex + 1) |
      | Jump to | animateToItem(specificIndex) |
      | Indicators | Dots that jump to items |

  Scenario: Configure animation
    Given I have carousel navigation
    When I configure animation settings
    Then I can set:
      | Setting | Options |
      | Duration | Milliseconds |
      | Curve | ease, linear, bounce, etc. |

  Scenario: Code generation with animateToItem
    Given I have a carousel with navigation
    When I export the code
    Then the output includes:
    """
    class _CarouselScreenState extends State<CarouselScreen> {
      final _controller = CarouselController();

      @override
      Widget build(BuildContext context) {
        return Column(
          children: [
            CarouselView(
              controller: _controller,
              itemExtent: 300,
              children: [...],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _controller.animateToItem(
                    _controller.selectedItem - 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _controller.animateToItem(
                    _controller.selectedItem + 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    }
    """
```

## Supported Calendar Systems

| Calendar | Locale | Week Start | Numerals |
|----------|--------|------------|----------|
| Gregorian | en, etc. | Sunday/Monday | Western |
| Islamic (Hijri) | ar | Saturday | Arabic-Indic |
| Persian (Jalali) | fa | Saturday | Persian |
| Hebrew | he | Sunday | Hebrew |
| Buddhist | th | Sunday | Thai |
| Japanese | ja | Sunday | Japanese |

## Calendar Package Dependencies

| Calendar | Package |
|----------|---------|
| Persian | shamsi_date or persian_datetime |
| Islamic | hijri or islamic_date |
| Hebrew | kosher_dart (if available) |
| Others | Custom CalendarDelegate implementation |

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Calendar render time | < 50ms |
| Date calculation | < 5ms |
| Year picker animation | 60fps |
| Memory per calendar | < 200KB |

## Dependencies

- Widget registry (existing)
- Properties panel (existing)
- Code generator (existing)
- Calendar packages (external)

## Test Coverage Requirements

- Unit tests for calendar delegate configuration
- Unit tests for year shape customization
- Unit tests for tooltip constraints
- Unit tests for carousel animation
- Unit tests for date calculations per calendar
- Integration tests for calendar preview
- Visual tests for non-Gregorian rendering

## Implementation Notes

1. Calendar delegates may require external packages
2. Consider bundling common calendar packages
3. RTL support essential for Arabic/Persian/Hebrew
4. Year shape uses DatePickerThemeData
5. Tooltip constraints replace deprecated height
6. Carousel controller requires StatefulWidget
