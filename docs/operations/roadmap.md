# FlutterForge Roadmap

**Last Updated:** 2026-01-23

## Overview

This roadmap tracks implementation tasks for FlutterForge. Each task maps to user journey acceptance criteria for traceability.

**Status:** Phases 1-8 COMPLETE (73/73 tasks, 1411 tests) | Phase 9 PLANNED (35 tasks)

---

## Phase 1: Foundation (COMPLETE)

**Milestone:** Drag Container with Text child, edit padding, export basic code

**Completed:** 2026-01-21 | **Tasks:** 7/7 | **Tests:** 109

See `.claude/PROGRESS.md` for detailed Phase 1 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-1-task-01 | Widget Registry System | COMPLETE |
| phase-1-task-02 | Widget Palette UI | COMPLETE |
| phase-1-task-03 | Basic Canvas | COMPLETE |
| phase-1-task-04 | Single-Level Widget Insertion | COMPLETE |
| phase-1-task-05 | Properties Panel | COMPLETE |
| phase-1-task-06 | Code Generation | COMPLETE |
| phase-1-task-07 | App Shell Integration | COMPLETE |

---

## Phase 2: Core Editor (COMPLETE)

**Milestone:** Widget tree panel, undo/redo, 20 widgets, multi-level drag-drop

**Completed:** 2026-01-21 | **Tasks:** 12/12 | **Tests:** 404

See `.claude/PROGRESS.md` for detailed Phase 2 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-2-task-01 | Command Pattern Foundation | COMPLETE |
| phase-2-task-02 | Undo/Redo Provider Integration | COMPLETE |
| phase-2-task-03 | Widget Tree Panel UI | COMPLETE |
| phase-2-task-04 | Widget Tree Selection Sync | COMPLETE |
| phase-2-task-05 | Widget Tree Drag Reorder | COMPLETE |
| phase-2-task-06 | Widget Tree Context Menu | COMPLETE |
| phase-2-task-07 | Multi-Level Nested Drop Zones | COMPLETE |
| phase-2-task-08 | Canvas Widget Reordering | COMPLETE |
| phase-2-task-09 | Widget Registry Expansion - Layout | COMPLETE |
| phase-2-task-10 | Widget Registry Expansion - Content | COMPLETE |
| phase-2-task-11 | Widget Registry Expansion - Input | COMPLETE |
| phase-2-task-12 | Code Generation Updates | COMPLETE |

---

## Phase 3: Design System & Animation (COMPLETE)

**Milestone:** Design tokens, theme modes, animation studio with timeline and keyframes

**Completed:** 2026-01-21 | **Tasks:** 13/13 | **Tests:** 741 | **Journey References:** J08 (Design System), J09 (Animation Studio)

See `.claude/PROGRESS.md` for detailed Phase 3 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-3-task-01 | Design Token Model | COMPLETE |
| phase-3-task-02 | Design System Panel UI | COMPLETE |
| phase-3-task-03 | Semantic Token Aliasing | COMPLETE |
| phase-3-task-04 | Theme Mode Toggle | COMPLETE |
| phase-3-task-05 | Token Application to Widgets | COMPLETE |
| phase-3-task-06 | Style Presets | COMPLETE |
| phase-3-task-07 | ThemeExtension Export | COMPLETE |
| phase-3-task-08 | Animation Model and Track | COMPLETE |
| phase-3-task-09 | Animation Panel and Timeline | COMPLETE |
| phase-3-task-10 | Property Keyframing | COMPLETE |
| phase-3-task-11 | Easing Editor | COMPLETE |
| phase-3-task-12 | Animation Triggers | COMPLETE |
| phase-3-task-13 | Staggered Animation and Preview | COMPLETE |

---

## Phase 4: Polish & Save/Load (COMPLETE)

**Milestone:** Project persistence, recent files, auto-save, keyboard shortcuts, copy/paste

**Completed:** 2026-01-21 | **Tasks:** 10/10 | **Tests:** 843 | **Journey Reference:** J10 (Project Management)

See `.claude/PROGRESS.md` for detailed Phase 4 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-4-task-01 | Project Model and Serialization | COMPLETE |
| phase-4-task-02/03/04 | Project State Provider | COMPLETE |
| phase-4-task-05 | Recent Projects | COMPLETE |
| phase-4-task-06 | Auto-Save and Recovery | COMPLETE |
| phase-4-task-07 | Multiple Screens | COMPLETE |
| phase-4-task-08 | Keyboard Shortcuts Consolidation | COMPLETE |
| phase-4-task-09 | Copy/Paste Widgets | COMPLETE |
| phase-4-task-10 | Canvas Pan and Zoom | COMPLETE |

---

## Phase 5: Beta Release (COMPLETE)

**Milestone:** Cross-platform validation, performance optimization, documentation, CI/CD, release packaging

**Completed:** 2026-01-21 | **Tasks:** 8/8 | **Tests:** 1007

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-5-task-01 | Cross-Platform Validation | COMPLETE |
| phase-5-task-02 | Performance Optimization | COMPLETE |
| phase-5-task-03 | Accessibility | COMPLETE |
| phase-5-task-04 | Error Handling and Recovery | COMPLETE |
| phase-5-task-05 | User Documentation | COMPLETE |
| phase-5-task-06 | Developer Documentation | COMPLETE |
| phase-5-task-07 | CI/CD Pipeline | COMPLETE |
| phase-5-task-08 | Release Packaging | COMPLETE |

---

## Phase 6: Widget Completion (COMPLETE)

**Milestone:** Complete widget library with form inputs, scrolling containers, and structural widgets

**Completed:** 2026-01-22 | **Tasks:** 12/12 | **Tests:** 1047+ | **Journey References:** J11, J12, J13

| Task ID | Description | Status | Widget |
|---------|-------------|--------|--------|
| phase-6-task-01 | TextField Widget | COMPLETE | TextField |
| phase-6-task-02 | Checkbox Widget | COMPLETE | Checkbox |
| phase-6-task-03 | Switch Widget | COMPLETE | Switch |
| phase-6-task-04 | Slider Widget | COMPLETE | Slider |
| phase-6-task-05 | ListView Widget | COMPLETE | ListView |
| phase-6-task-06 | GridView Widget | COMPLETE | GridView |
| phase-6-task-07 | ScrollView Widget | COMPLETE | SingleChildScrollView |
| phase-6-task-08 | Card Widget | COMPLETE | Card |
| phase-6-task-09 | ListTile Widget | COMPLETE | ListTile |
| phase-6-task-10 | AppBar Widget | COMPLETE | AppBar |
| phase-6-task-11 | Scaffold Widget | COMPLETE | Scaffold |
| phase-6-task-12 | Wrap Widget | COMPLETE | Wrap |

---

## Phase 7: Assets & Preview (COMPLETE)

**Milestone:** Image asset management, responsive device preview, live code panel

**Completed:** 2026-01-22 | **Tasks:** 5/5 | **Tests:** 1322 | **Journey References:** J14, J15

| Task ID | Description | Status | Tests |
|---------|-------------|--------|-------|
| phase-7-task-01 | Asset Import Dialog | COMPLETE | 15 |
| phase-7-task-02 | Canvas Image Preview | COMPLETE | 12 |
| phase-7-task-03 | Asset Bundling in .forge | COMPLETE | 21 |
| phase-7-task-04 | Device Frame Selector | COMPLETE | 37 |
| phase-7-task-05 | Responsive Breakpoints | COMPLETE | 26 |

---

## Phase 8: Platform & Polish (COMPLETE)

**Milestone:** Windows/Linux support, onboarding experience, help system

**Completed:** 2026-01-22 | **Tasks:** 6/6 | **Tests:** 1411 | **Journey References:** J17, J18

### Task 8.1: Windows Build Configuration

| Field | Value |
|-------|-------|
| ID | phase-8-task-01 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J17 S1 |
| Location | `pubspec.yaml`, `.github/workflows/windows.yml` |

**Deliverables:**
- [x] Windows platform enabled in pubspec.yaml
- [x] CI workflow for Windows builds
- [x] MSIX packaging for Windows Store
- [x] High DPI support via release mode
- [x] Unit tests (23 tests)

---

### Task 8.2: Linux Build Configuration

| Field | Value |
|-------|-------|
| ID | phase-8-task-02 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J17 S3 |
| Location | `pubspec.yaml`, `.github/workflows/linux.yml` |

**Deliverables:**
- [x] Linux platform enabled in pubspec.yaml
- [x] CI workflow for Linux builds
- [x] AppImage packaging
- [x] DEB packaging
- [x] GTK dependencies configured

---

### Task 8.3: Platform-Adaptive Shortcuts

| Field | Value |
|-------|-------|
| ID | phase-8-task-03 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J17 S2 |
| Location | `lib/features/shortcuts/` |

**Deliverables:**
- [x] ShortcutDefinition with platform-specific shortcuts
- [x] Cmd on macOS, Ctrl on Windows/Linux
- [x] ShortcutsRegistry with 19 shortcuts
- [x] Unit tests (16 tests)

---

### Task 8.4: Welcome Screen

| Field | Value |
|-------|-------|
| ID | phase-8-task-04 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J18 S1 |
| Location | `lib/features/onboarding/` |

**Deliverables:**
- [x] WelcomeScreen with branding and quick actions
- [x] OnboardingState with first-run detection
- [x] "Don't show again" preference
- [x] Escape key to close
- [x] Unit tests (15 tests)

---

### Task 8.5: Interactive Tutorial

| Field | Value |
|-------|-------|
| ID | phase-8-task-05 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J18 S2 |
| Location | `lib/features/onboarding/` |

**Deliverables:**
- [x] TutorialStep and TutorialState models
- [x] 7-step guided tour of core workflows
- [x] TutorialOverlay with progress indicator
- [x] Skip and Exit with confirmation
- [x] TutorialCompletionScreen
- [x] Unit tests (22 tests)

---

### Task 8.6: Keyboard Shortcut Reference

| Field | Value |
|-------|-------|
| ID | phase-8-task-06 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J18 S3, S4, S5 |
| Location | `lib/features/help/` |

**Deliverables:**
- [x] ShortcutReferenceOverlay with search
- [x] PropertyHelpTooltip and WidgetHelpTooltip
- [x] HelpLinks for documentation URLs
- [x] Unit tests (13 tests)

---

## Phase 8 Definition of Done

- [x] Windows build configured with CI workflow
- [x] Linux build configured with CI workflow
- [x] Onboarding flow complete (welcome + tutorial)
- [x] Help system functional (shortcuts + tooltips)
- [x] All 1411 tests pass
- [x] New tests added (89 Phase 8 tests)

---

## Phase 9: Flutter 3.32-3.38 Enhancements (PLANNED)

**Milestone:** Leverage Flutter 3.32, 3.35, and 3.38 features for cleaner code generation, enhanced preview capabilities, new widgets, and improved accessibility

**Status:** PLANNED | **Tasks:** 0/35 | **Journey References:** J19-J31

**Prerequisites:** Flutter SDK updated to 3.38+, Dart 3.10+

---

### 9.1: Code Generation - Dart 3.10 Shorthand

#### Task 9.1.1: Enum Dot Shorthand Support

| Field | Value |
|-------|-------|
| ID | phase-9-task-01 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J19 S1, S2 |
| Location | `lib/generators/dart_generator.dart` |

**Deliverables:**
- [ ] Shorthand support for MainAxisAlignment, CrossAxisAlignment
- [ ] Shorthand support for TextAlign, FontWeight, FontStyle
- [ ] Shorthand support for BoxFit, Alignment, Axis
- [ ] Unit tests for each shorthand type

---

#### Task 9.1.2: Constructor Dot Shorthand Support

| Field | Value |
|-------|-------|
| ID | phase-9-task-02 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J19 S1, S2 |
| Location | `lib/generators/dart_generator.dart` |

**Deliverables:**
- [ ] Shorthand support for EdgeInsets (.all, .symmetric, .only)
- [ ] Shorthand support for BorderRadius (.circular, .all)
- [ ] Shorthand support for EdgeInsetsDirectional
- [ ] Non-shorthand exclusion list (Colors, Icons, Duration)
- [ ] Unit tests for constructor shorthand

---

#### Task 9.1.3: Dart Version Targeting

| Field | Value |
|-------|-------|
| ID | phase-9-task-03 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J19 S3 |
| Location | `lib/features/code_preview/`, `lib/generators/` |

**Deliverables:**
- [ ] Export settings for Dart version target
- [ ] Dart 3.9 compatibility mode (no shorthand)
- [ ] Version indicator in code panel
- [ ] Version setting persistence in project
- [ ] Unit tests for version toggling

---

### 9.2: Preview & Development Tools

#### Task 9.2.1: @Preview Annotation Export (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-04 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J24 S1 |
| Location | `lib/generators/preview_annotation_generator.dart` |

**Deliverables:**
- [ ] Basic @Preview annotation generation
- [ ] Named preview support
- [ ] Sized preview with width/height
- [ ] Unit tests for annotation generation

---

#### Task 9.2.2: Theme/Brightness Preview Export (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-05 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J24 S2 |
| Location | `lib/generators/preview_annotation_generator.dart` |

**Deliverables:**
- [ ] Light/dark theme preview annotations
- [ ] Theme matrix export option
- [ ] Brightness parameter in @Preview
- [ ] Unit tests for theme previews

---

#### Task 9.2.3: Localization Preview Export (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-06 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J24 S3 |
| Location | `lib/generators/preview_annotation_generator.dart` |

**Deliverables:**
- [ ] Locale parameter in @Preview
- [ ] Locale matrix export option
- [ ] RTL locale support
- [ ] Unit tests for localized previews

---

#### Task 9.2.4: Flutter Version Runtime Info (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-07 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J24 S4 |
| Location | `lib/services/version_service.dart` |

**Deliverables:**
- [ ] Flutter/Dart version display in About dialog
- [ ] Version-aware feature flags
- [ ] Export version comments in generated code
- [ ] Unit tests for version detection

---

### 9.3: Enhanced Menu System

#### Task 9.3.1: RawMenuAnchor Widget (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-08 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J25 S1 |
| Location | `lib/features/palette/widgets/menu/` |

**Deliverables:**
- [ ] RawMenuAnchor widget registration
- [ ] Menu item builder UI in properties
- [ ] Preview menu open state
- [ ] Code generation for RawMenuAnchor
- [ ] Unit tests for menu configuration

---

#### Task 9.3.2: SearchAnchor Lifecycle Callbacks (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-09 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J25 S2, S3 |
| Location | `lib/features/palette/widgets/search/` |

**Deliverables:**
- [ ] viewOnOpen callback property
- [ ] viewOnClose callback property
- [ ] Keyboard navigation configuration
- [ ] Code generation with callbacks
- [ ] Unit tests for lifecycle callbacks

---

### 9.4: Form Field Enhancements

#### Task 9.4.1: FormField.errorBuilder (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-10 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J26 S1 |
| Location | `lib/features/properties/form/` |

**Deliverables:**
- [ ] Custom error widget builder UI
- [ ] Error display presets (icon+text, tooltip, etc.)
- [ ] Preview error state toggle
- [ ] Code generation with errorBuilder
- [ ] Unit tests for error configuration

---

#### Task 9.4.2: InputDecoration.hint Widget (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-11 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J26 S2 |
| Location | `lib/features/properties/input/` |

**Deliverables:**
- [ ] Widget-based hint configuration
- [ ] Hint builder UI (icon + text)
- [ ] Preview hint widget
- [ ] Code generation with hint widget
- [ ] Unit tests for hint configuration

---

#### Task 9.4.3: DropdownMenuFormField (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-12 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J26 S4 |
| Location | `lib/features/palette/widgets/form/` |

**Deliverables:**
- [ ] DropdownMenuFormField widget registration
- [ ] Form field properties (validator, onSaved, restorationId)
- [ ] Dropdown items editor
- [ ] Code generation for form field
- [ ] Unit tests for form integration

---

#### Task 9.4.4: InputDecoration.visualDensity (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-13 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J26 S3 |
| Location | `lib/features/properties/input/` |

**Deliverables:**
- [ ] Visual density property control
- [ ] Density presets (compact, standard, comfortable)
- [ ] Custom density values
- [ ] Unit tests for density settings

---

### 9.5: Accessibility Roles

#### Task 9.5.1: Radio Group and Dialog Semantics (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-14 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J27 S1, S2 |
| Location | `lib/features/properties/accessibility/` |

**Deliverables:**
- [ ] Radio group semantic role configuration
- [ ] Dialog semantic role configuration
- [ ] Group label property
- [ ] Code generation with Semantics wrapper
- [ ] Unit tests for role assignment

---

#### Task 9.5.2: List and Table Semantics (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-15 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J27 S3 |
| Location | `lib/features/properties/accessibility/` |

**Deliverables:**
- [ ] List semantic role for ListView
- [ ] Table semantic role for DataTable/GridView
- [ ] Item indexing for list items
- [ ] Code generation with list semantics
- [ ] Unit tests for list/table roles

---

#### Task 9.5.3: Status and Alert Semantics (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-16 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J27 S4 |
| Location | `lib/features/properties/accessibility/` |

**Deliverables:**
- [ ] Status live region configuration
- [ ] Alert role configuration
- [ ] Live region mode (polite, assertive)
- [ ] Code generation with live regions
- [ ] Unit tests for status/alert roles

---

#### Task 9.5.4: Landmark Roles (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-17 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J27 S5 |
| Location | `lib/features/properties/accessibility/` |

**Deliverables:**
- [ ] Navigation landmark role
- [ ] Main content landmark role
- [ ] Complementary landmark role
- [ ] Landmark overlay visualization
- [ ] Unit tests for landmark roles

---

#### Task 9.5.5: Heading Levels (3.35/3.38)

| Field | Value |
|-------|-------|
| ID | phase-9-task-18 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J27 S6, J23 S3 |
| Location | `lib/features/properties/accessibility/` |

**Deliverables:**
- [ ] Heading level dropdown (H1-H6)
- [ ] Heading hierarchy validation
- [ ] Heading structure visualization
- [ ] Code generation with headingLevel
- [ ] Unit tests for heading levels

---

### 9.6: Calendar and Date Systems

#### Task 9.6.1: Custom Calendar Systems (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-19 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J28 S1, S2 |
| Location | `lib/features/palette/widgets/date/` |

**Deliverables:**
- [ ] Calendar system selector (Gregorian, Islamic, Persian, Hebrew)
- [ ] Calendar delegate configuration
- [ ] Week start day configuration
- [ ] Code generation with calendarDelegate
- [ ] Unit tests for calendar systems

---

#### Task 9.6.2: Year Picker Customization (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-20 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J28 S3 |
| Location | `lib/features/properties/date/` |

**Deliverables:**
- [ ] Year shape configuration
- [ ] Year picker styling in DatePickerThemeData
- [ ] Preview year selector
- [ ] Unit tests for year shape

---

#### Task 9.6.3: Tooltip Constraints (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-21 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J28 S4 |
| Location | `lib/features/properties/tooltip/` |

**Deliverables:**
- [ ] Tooltip constraints property (replacing height)
- [ ] Constraint presets
- [ ] Preview tooltip sizing
- [ ] Unit tests for tooltip constraints

---

#### Task 9.6.4: Carousel animateToItem (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-22 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J28 S5 |
| Location | `lib/features/palette/widgets/carousel/` |

**Deliverables:**
- [ ] CarouselController exposure option
- [ ] Navigation button configuration
- [ ] Animation duration/curve settings
- [ ] Code generation with animateToItem
- [ ] Unit tests for carousel navigation

---

### 9.7: Navigation Enhancements

#### Task 9.7.1: NavigationDrawer Header/Footer (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-23 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J29 S1 |
| Location | `lib/features/palette/widgets/navigation/` |

**Deliverables:**
- [ ] Header slot configuration (user account, brand, custom)
- [ ] Footer slot configuration (settings, logout, version)
- [ ] Preview drawer with header/footer
- [ ] Code generation with header/footer
- [ ] Unit tests for drawer slots

---

#### Task 9.7.2: NavigationRail Scrollable (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-24 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J29 S2 |
| Location | `lib/features/palette/widgets/navigation/` |

**Deliverables:**
- [ ] Scrollable property for NavigationRail
- [ ] Scroll behavior configuration
- [ ] Preview with many destinations
- [ ] Code generation with scrollable
- [ ] Unit tests for scrollable rail

---

#### Task 9.7.3: Route Transition Duration (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-25 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J29 S3 |
| Location | `lib/features/navigation/` |

**Deliverables:**
- [ ] Forward/reverse duration configuration
- [ ] Transition curve selection
- [ ] Transition presets
- [ ] Preview transition timing
- [ ] Unit tests for transition duration

---

### 9.8: Animation and Physics

#### Task 9.8.1: SpringDescription.withDurationAndBounce (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-26 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J30 S1, S2 |
| Location | `lib/features/animation/spring/` |

**Deliverables:**
- [ ] Intuitive spring configuration UI (duration + bounce)
- [ ] Spring presets (snappy, gentle, bouncy)
- [ ] Spring curve visualization
- [ ] Code generation with new API
- [ ] Unit tests for spring configuration

---

#### Task 9.8.2: Gesture Input Type Detection (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-27 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J30 S3 |
| Location | `lib/features/properties/gesture/` |

**Deliverables:**
- [ ] PointerDeviceKind configuration
- [ ] Per-input behavior settings
- [ ] Code generation with input detection
- [ ] Unit tests for gesture input types

---

#### Task 9.8.3: Divider borderRadius (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-28 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J30 S4 |
| Location | `lib/features/palette/widgets/divider/` |

**Deliverables:**
- [ ] Border radius property for Divider
- [ ] Preview rounded divider
- [ ] Code generation with borderRadius
- [ ] Unit tests for divider radius

---

### 9.9: Cupertino Polish

#### Task 9.9.1: RoundedSuperellipseBorder (Squircle) (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-29 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J31 S1 |
| Location | `lib/features/properties/shape/` |

**Deliverables:**
- [ ] Superellipse shape option for widgets
- [ ] Squircle vs rounded rect comparison
- [ ] Default squircle for Cupertino widgets
- [ ] Code generation with RoundedSuperellipseBorder
- [ ] Unit tests for squircle shape

---

#### Task 9.9.2: CupertinoButton Sizing (3.32)

| Field | Value |
|-------|-------|
| ID | phase-9-task-30 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J31 S2 |
| Location | `lib/features/palette/widgets/cupertino/` |

**Deliverables:**
- [ ] minWidth/minHeight properties
- [ ] Touch target compliance warnings
- [ ] Preview size constraints
- [ ] Code generation with size properties
- [ ] Unit tests for button sizing

---

#### Task 9.9.3: CupertinoCollapsible (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-31 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J31 S3 |
| Location | `lib/features/palette/widgets/cupertino/` |

**Deliverables:**
- [ ] CupertinoCollapsible widget registration
- [ ] Header/child configuration
- [ ] iOS-style collapse animation
- [ ] Code generation for collapsible
- [ ] Unit tests for collapse state

---

#### Task 9.9.4: CupertinoSlider Haptic Feedback (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-32 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J31 S4 |
| Location | `lib/features/palette/widgets/cupertino/` |

**Deliverables:**
- [ ] Haptic feedback toggle for CupertinoSlider
- [ ] Haptic intensity configuration
- [ ] Code generation with haptic feedback
- [ ] Unit tests for haptic configuration

---

#### Task 9.9.5: CupertinoPicker Ticking Sound (3.35)

| Field | Value |
|-------|-------|
| ID | phase-9-task-33 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J31 S5 |
| Location | `lib/features/palette/widgets/cupertino/` |

**Deliverables:**
- [ ] Ticking sound toggle for CupertinoPicker
- [ ] Sound behavior configuration
- [ ] Code generation with sound settings
- [ ] Unit tests for sound configuration

---

### 9.10: New Widgets and Enhancements

#### Task 9.10.1: CupertinoLinearActivityIndicator (3.38)

| Field | Value |
|-------|-------|
| ID | phase-9-task-34 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J23 S1 |
| Location | `lib/features/palette/widgets/cupertino/` |

**Deliverables:**
- [ ] CupertinoLinearActivityIndicator widget registration
- [ ] Value/color/backgroundColor properties
- [ ] Indeterminate vs determinate mode
- [ ] Code generation for indicator
- [ ] Unit tests for indicator

---

#### Task 9.10.2: Monitor Metadata Service (3.38)

| Field | Value |
|-------|-------|
| ID | phase-9-task-35 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J20 S1, S2, S3 |
| Location | `lib/services/monitor_service.dart` |

**Deliverables:**
- [ ] MonitorService with platform abstraction
- [ ] Monitor info display in preview settings
- [ ] DPI-aware preview rendering
- [ ] Detachable preview window positioning
- [ ] Unit tests for monitor metadata

---

## Phase 9 Definition of Done

- [ ] Dart 3.10 dot shorthand fully implemented in code generator
- [ ] Version targeting with Dart 3.9 fallback
- [ ] @Preview annotation export with theme/locale support
- [ ] RawMenuAnchor and SearchAnchor enhancements
- [ ] Form field enhancements (errorBuilder, hint widget, DropdownMenuFormField)
- [ ] Comprehensive accessibility roles (radio group, dialog, list, table, status, alert, landmarks, headings)
- [ ] Custom calendar systems support
- [ ] Navigation drawer header/footer, scrollable rail
- [ ] Spring physics with duration/bounce API
- [ ] Cupertino polish (squircle, collapsible, haptics, sounds)
- [ ] New Flutter 3.38 widgets added to palette
- [ ] All tests pass (target: 1800+ tests)
- [ ] Updated to Flutter 3.38 SDK

---

## Overall Progress Summary

| Phase | Status | Tasks | Tests |
|-------|--------|-------|-------|
| Phase 1: Foundation | COMPLETE | 7/7 | 109 |
| Phase 2: Core Editor | COMPLETE | 12/12 | 404 |
| Phase 3: Design System & Animation | COMPLETE | 13/13 | 741 |
| Phase 4: Polish & Save/Load | COMPLETE | 10/10 | 843 |
| Phase 5: Beta Release | COMPLETE | 8/8 | 1007 |
| Phase 6: Widget Completion | COMPLETE | 12/12 | 1047 |
| Phase 7: Assets & Preview | COMPLETE | 5/5 | 1322 |
| Phase 8: Platform & Polish | COMPLETE | 6/6 | 1411 |
| Phase 9: Flutter 3.32-3.38 Enhancements | PLANNED | 0/35 | - |
| **Total** | **68% COMPLETE** | **73/108** | **1411** |

---

## Journey-Task Mapping

| Journey | Description | Tasks |
|---------|-------------|-------|
| J11 | Form Input Widgets | 6.1, 6.2, 6.3, 6.4 |
| J12 | Scrolling and Lists | 6.5, 6.6, 6.7 |
| J13 | Structural Widgets | 6.8, 6.9, 6.10, 6.11, 6.12 |
| J14 | Image Asset Management | 7.1, 7.2, 7.3 |
| J15 | Responsive Preview | 7.4, 7.5 |
| J17 | Cross-Platform Support | 8.1, 8.2, 8.3 |
| J18 | Onboarding and Help | 8.4, 8.5, 8.6 |
| J19 | Dart Shorthand Code Generation | 9.1.1, 9.1.2, 9.1.3 |
| J20 | Monitor Metadata API | 9.10.2 |
| J21 | Widget Preview Enhancements | 9.2.1, 9.2.2 |
| J22 | OverlayPortal Improvements | 9.3.1, 9.3.2 |
| J23 | New Flutter 3.38 Widgets | 9.5.5, 9.10.1 |
| J24 | Preview and Development Tools | 9.2.1, 9.2.2, 9.2.3, 9.2.4 |
| J25 | Enhanced Menu System | 9.3.1, 9.3.2 |
| J26 | Form Field Enhancements | 9.4.1, 9.4.2, 9.4.3, 9.4.4 |
| J27 | Accessibility Roles | 9.5.1, 9.5.2, 9.5.3, 9.5.4, 9.5.5 |
| J28 | Calendar and Date Systems | 9.6.1, 9.6.2, 9.6.3, 9.6.4 |
| J29 | Navigation Enhancements | 9.7.1, 9.7.2, 9.7.3 |
| J30 | Animation and Physics | 9.8.1, 9.8.2, 9.8.3 |
| J31 | Cupertino Polish | 9.9.1, 9.9.2, 9.9.3, 9.9.4, 9.9.5 |

---

## Priority Summary

| Priority | Description | Task Count |
|----------|-------------|------------|
| P1 | Directly improve FlutterForge UX or generated code quality | 14 |
| P2 | Add new widget properties/capabilities | 14 |
| P3 | Nice-to-have enhancements | 7 |

---

## Release Checklist (v0.1.0 Beta)

- [x] All Phase 1-5 tasks complete
- [x] 1007 tests passing
- [x] macOS release build verified (37MB)
- [x] CI/CD pipeline configured
- [x] Documentation complete
- [ ] Push version tag (v0.1.0) to trigger release

## Release Checklist (v1.0.0 Production)

- [x] Phase 6 complete (32 widgets)
- [x] Phase 7 complete (Assets & Preview)
- [x] Phase 8 complete (Platform & Polish)
- [x] 1411 tests passing
- [x] Windows CI workflow configured
- [x] Linux CI workflow configured
- [x] Onboarding flow complete
- [x] Help system functional
- [ ] Push version tag (v1.0.0) to trigger release

## Release Checklist (v1.1.0 Flutter 3.38)

- [ ] Phase 9 complete (35 tasks)
- [ ] Dart 3.10 dot shorthand working
- [ ] Preview enhancements complete
- [ ] Accessibility roles complete
- [ ] New widgets added
- [ ] 1800+ tests passing
- [ ] Flutter 3.38 SDK requirement documented
- [ ] Push version tag (v1.1.0) to trigger release
