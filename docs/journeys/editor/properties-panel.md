# Journey: Properties Panel

> User selects widget and edits its properties with real-time canvas preview.

## Metadata

```yaml
actor: Pragmatic Flutter Developer
platform: desktop
locales: [en]
offline_capable: true
entry_points:
  - Widget selection (canvas or tree)
  - Keyboard shortcut Cmd/Ctrl+3
success_metric: Property change visible on canvas within 16ms
priority: P0
estimated_duration: 30 seconds per property edit
related_journeys:
  - ../editor/design-canvas.md
  - ../editor/widget-tree.md
  - ../export/code-generation.md
last_updated: 2026-01-21
requirements: [FR4.1, FR4.2, FR4.3, FR4.4, FR4.5, FR4.6, FR4.7]
```

## Flow Overview

```mermaid
journey
    title Property Editing
    section Select
      Widget selected: 5: Developer
      Properties appear: 5: Developer
    section Edit
      Modify value: 4: Developer
      See live preview: 5: Developer
    section Advanced
      Use color picker: 4: Developer
      Edit EdgeInsets: 4: Developer
```

---

## Stage 1: View Widget Properties

**Goal**: User sees relevant properties for selected widget

**Preconditions**:
- Widget is selected on canvas or tree
- Properties panel is visible (right side)

**Flow**:
1. User selects widget (canvas click or tree click)
2. System updates selection state
3. Properties panel loads widget's property definitions (FR4.4)
4. System displays editable properties organized by category
5. User views property names, current values, and input controls

**Acceptance Criteria**:

```gherkin
Scenario: Display Container properties
  Given Container is selected on canvas
  Then properties panel shows Container properties (FR4.1, FR4.4):
    - Layout: width, height, constraints
    - Appearance: color, decoration
    - Spacing: padding, margin
    - Alignment: alignment
  And each property shows current value or placeholder

Scenario: Display Text properties
  Given Text is selected
  Then properties panel shows Text properties:
    - Content: data (text string)
    - Style: fontSize, fontWeight, color
    - Layout: textAlign, maxLines, overflow
  And only Text-relevant properties appear (FR4.4)

Scenario: No selection state
  Given no widget is selected
  Then properties panel shows "Select a widget to edit properties"
  And panel is not empty/broken

Scenario: Property categorization
  Given widget with many properties selected
  Then properties grouped by category
  And categories are collapsible
  And common properties (size, color) appear first
```

**Edge Cases**:

| Trigger | System Response | User Recovery |
|---------|-----------------|---------------|
| Unknown widget type | Show raw properties without grouping | Edit as text |
| Property definition missing | Show warning, skip property | Report bug |
| Very long property list | Virtualized scrolling | Scroll or search |
| Panel too narrow | Wrap or show compact mode | Resize panel |

**UX Requirements**:
- Properties load: <100ms after selection
- Property grouping: Logical categories (Layout, Appearance, etc.)
- Visible focus: Clear indicator when property focused (NFR4.5)

**Emotional State**: 5 - Clear understanding of what can be edited

---

## Stage 2: Edit Basic Properties

**Goal**: User modifies property value and sees live preview on canvas

**Preconditions**:
- Widget is selected
- Properties panel shows properties
- User wants to change a value

**Flow**:
1. User locates property to edit
2. User clicks input field or control
3. User enters new value (FR4.2)
4. System validates input
5. System updates widget in data model
6. Canvas previews change in real-time (FR4.5)

**Acceptance Criteria**:

```gherkin
Scenario: Edit double property (width)
  Given Container is selected
  And width property shows empty or current value
  When user clicks width field
  And types "200"
  Then canvas updates within 16ms (FR4.5, NFR1.1)
  And Container visually shows width of 200

Scenario: Edit string property (text)
  Given Text widget is selected
  When user edits data field
  And types "Hello World"
  Then Text on canvas updates live as user types (FR4.5)
  And debounce prevents excessive updates (100ms)

Scenario: Edit int property (maxLines)
  Given Text is selected
  When user changes maxLines to 3
  Then Text on canvas respects maxLines limit
  And input validates as integer only

Scenario: Edit bool property (softWrap)
  Given Text is selected
  When user toggles softWrap checkbox
  Then Text wrapping behavior changes on canvas
  And checkbox state updates immediately

Scenario: Edit enum property (TextAlign)
  Given Text is selected
  When user opens textAlign dropdown
  Then options show: left, center, right, justify
  When user selects "center"
  Then Text aligns to center on canvas

Scenario: Clear optional property
  Given Container has color set to blue
  When user clears color field (empty/null)
  Then Container color becomes transparent/default
  And canvas updates
```

**Edge Cases**:

| Trigger | System Response | User Recovery |
|---------|-----------------|---------------|
| Invalid numeric value | Show validation error inline | Correct value |
| Value exceeds range | Clamp or warn | Adjust to valid range |
| Empty required field | Show "Required" error | Enter value |
| Rapid value changes | Debounce at 100ms | None needed |

**UX Requirements**:
- Input validation: Inline, immediate feedback
- Canvas preview: <16ms update (NFR1.1, FR4.5)
- Debounce text input: 100ms before applying
- Focus management: Tab between fields

**Emotional State**: 4 - Direct manipulation feels powerful

---

## Stage 3: Color Picker

**Goal**: User selects color using visual color picker

**Preconditions**:
- Widget has color property (e.g., Container.color, Text.style.color)
- Property is displayed in panel

**Flow**:
1. User clicks color swatch or field (FR4.3)
2. System opens color picker overlay
3. User selects color via hue/saturation/brightness
4. User optionally enters hex code
5. User adjusts alpha/opacity
6. Canvas previews color in real-time
7. User confirms or dismisses picker

**Acceptance Criteria**:

```gherkin
Scenario: Open color picker
  Given Container is selected
  When user clicks color property swatch
  Then color picker overlay opens (FR4.3)
  And current color is pre-selected
  And picker shows HSB selector, hex input, alpha slider

Scenario: Select color via picker
  Given color picker is open
  When user drags in saturation/brightness area
  Then selected color updates
  And canvas Container updates live (FR4.5)

Scenario: Enter hex color
  Given color picker is open
  When user types "#FF5733" in hex field
  Then picker updates to that color
  And canvas updates immediately

Scenario: Adjust opacity
  Given color picker is open
  When user drags alpha slider to 50%
  Then selected color becomes semi-transparent
  And canvas shows transparency

Scenario: Use preset colors
  Given color picker is open
  Then preset palette shows common colors
  When user clicks preset
  Then color selects immediately

Scenario: Dismiss picker
  Given color picker is open
  When user clicks outside picker or presses Escape
  Then picker closes
  And last selected color is kept

Scenario: Color picker accessibility
  Given user navigates via keyboard
  When focus enters color picker
  Then all controls keyboard accessible
  And values can be typed directly (RGB, HSB, Hex)
```

**Edge Cases**:

| Trigger | System Response | User Recovery |
|---------|-----------------|---------------|
| Invalid hex code | Show validation error | Correct format |
| Picker extends beyond viewport | Reposition to stay visible | None needed |
| System color picker used | Integrate with platform picker | Use either |
| Eyedropper tool (future) | Sample color from screen | N/A |

**UX Requirements**:
- Picker open: <100ms animation
- Live preview: Update canvas on every color change
- Keyboard: Full keyboard navigation
- Presets: Material Design colors available

**Emotional State**: 5 - Visual selection feels intuitive

---

## Stage 4: EdgeInsets Editor

**Goal**: User edits padding/margin using visual EdgeInsets editor

**Preconditions**:
- Widget has EdgeInsets property (padding, margin)
- Property displayed in panel

**Flow**:
1. User locates padding or margin property
2. User clicks property to expand editor (FR4.6)
3. System shows four-sided input (top, right, bottom, left)
4. User edits individual sides or all at once
5. Canvas previews changes in real-time

**Acceptance Criteria**:

```gherkin
Scenario: Edit padding with EdgeInsets editor
  Given Container is selected
  When user clicks padding property
  Then EdgeInsets editor opens (FR4.6)
  And shows: top, right, bottom, left inputs
  And visual diagram shows which side is which

Scenario: Edit individual side
  Given EdgeInsets editor is open
  When user changes top to 16
  Then only top padding updates
  And canvas shows asymmetric padding (FR4.5)

Scenario: Edit all sides at once
  Given EdgeInsets editor is open
  When user clicks "All" mode
  And enters 8
  Then all four sides become 8
  And canvas updates with uniform padding

Scenario: Edit symmetric (horizontal/vertical)
  Given EdgeInsets editor is open
  When user clicks "Symmetric" mode
  And sets horizontal: 16, vertical: 8
  Then left/right = 16, top/bottom = 8
  And canvas updates

Scenario: Keyboard editing
  Given EdgeInsets editor is open
  When user tabs through fields
  Then Tab moves: top -> right -> bottom -> left
  And values editable via keyboard
```

**Edge Cases**:

| Trigger | System Response | User Recovery |
|---------|-----------------|---------------|
| Negative value | Show warning, allow (valid in some cases) | Acknowledge |
| Very large value | Show overflow warning | Reduce value |
| Non-numeric input | Reject, show validation error | Enter number |

**UX Requirements**:
- Visual diagram: Shows which side is being edited
- Mode toggle: All / Symmetric / Individual
- Link toggle: Lock all sides together
- Live preview: <16ms canvas update

**Emotional State**: 4 - Complex property made simple

---

## Stage 5: BoxConstraints Editor

**Goal**: User edits constraints (min/max width/height)

**Preconditions**:
- Widget supports constraints (Container, ConstrainedBox)
- Property displayed in panel

**Flow**:
1. User locates constraints property
2. User clicks to expand editor (FR4.7)
3. System shows min/max width and height inputs
4. User edits constraint values
5. Canvas shows constrained widget

**Acceptance Criteria**:

```gherkin
Scenario: Edit BoxConstraints
  Given ConstrainedBox is selected
  When user clicks constraints property
  Then BoxConstraints editor opens (FR4.7)
  And shows: minWidth, maxWidth, minHeight, maxHeight

Scenario: Set size constraints
  Given constraints editor is open
  When user sets minWidth: 100, maxWidth: 300
  Then widget on canvas respects constraints
  And child sizes within bounds

Scenario: Infinite constraint
  Given constraints editor is open
  When user clears maxWidth (sets to infinity)
  Then widget can expand without limit
  And infinity symbol shown in field

Scenario: Conflicting constraints
  Given user sets minWidth: 200, maxWidth: 100
  Then validation error: "Min cannot exceed max"
  And user must correct before applying
```

**Edge Cases**:

| Trigger | System Response | User Recovery |
|---------|-----------------|---------------|
| Min > Max | Validation error | Correct values |
| Constraints cause layout overflow | Show overflow indicator on canvas | Relax constraints |
| Constraints conflict with parent | Show warning | Adjust parent or child |

**UX Requirements**:
- Infinity representation: Clear symbol or "unlimited" label
- Validation: Prevent impossible constraint combinations
- Live preview: Constraint changes visible immediately

**Emotional State**: 4 - Advanced control accessible

---

## Error Scenarios

| Error Type | Trigger Condition | User Message | Recovery Action | Fallback |
|------------|-------------------|--------------|-----------------|----------|
| Invalid value | Wrong data type entered | "Please enter a valid [type]" | Inline correction | Reset to previous |
| Range exceeded | Value outside allowed range | "Value must be between [min] and [max]" | Clamp or correct | Clamp automatically |
| Property update failure | State update error | "Could not update property" | Retry | Restart property panel |
| Color picker error | Platform picker failure | "Could not open color picker" | Use hex input | Hex fallback |

---

## Analytics Events

| Event Name | Trigger | Properties |
|------------|---------|------------|
| `property_panel_viewed` | Panel receives selection | `widget_type`, `property_count` |
| `property_edited` | Property value changed | `widget_type`, `property_name`, `old_value`, `new_value` |
| `color_picker_opened` | Color picker opened | `widget_type`, `property_name` |
| `color_picker_selected` | Color chosen | `method` (picker/hex/preset), `color_value` |
| `edgeinsets_edited` | EdgeInsets changed | `mode` (all/symmetric/individual), `values` |
| `constraints_edited` | BoxConstraints changed | `constraint_type`, `values` |
| `validation_error` | Invalid input rejected | `property_name`, `error_type`, `attempted_value` |

---

## Technical Notes

- Properties derived from `WidgetDefinition` metadata in registry
- Property changes flow through `PropertyChangeCommand` for undo/redo
- Color picker uses Flutter's built-in picker or custom implementation
- Debouncing prevents excessive re-renders during rapid edits
- All property editors use consistent component library

---

## Validation Checklist

### Core UX
- [x] All stages have goal, preconditions, flow, acceptance criteria
- [x] Edge cases documented with recovery paths
- [x] UX requirements include specific thresholds (16ms preview)
- [x] Error scenarios cover validation, range, picker failures
- [x] Analytics events capture property editing patterns
- [x] Emotional journey tracked with 1-5 scores
- [x] Accessibility: keyboard navigation, screen reader labels

### Desktop-Specific
- [x] Tab navigation between fields
- [x] Keyboard shortcuts for common actions
- [x] Panel resize behavior
- [x] Platform color picker integration

---

## Comprehensiveness Evidence

| Pass | Completed | Findings |
|------|-----------|----------|
| Edge Case Audit | Yes | Added: invalid input, range exceeded, picker positioning |
| ACUEPS Coverage | Yes | All stages have Performance (16ms), Error (validation), Accessibility |
| Cross-Journey Validation | Yes | Selection from canvas/tree triggers properties, edits visible on canvas |

**Edge cases added during audit:**
- Stage 1: Unknown widget, long property list
- Stage 2: Rapid changes, empty required field
- Stage 3: Picker viewport overflow, invalid hex
- Stage 4: Negative values, very large values
- Stage 5: Conflicting constraints, infinity representation

**Cross-journey links verified:**
- Incoming: Canvas selection, Tree selection (both trigger property display)
- Outgoing: Canvas (live preview), Code Generation (properties in output)
