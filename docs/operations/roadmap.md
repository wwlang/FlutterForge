# FlutterForge Roadmap

**Last Updated:** 2026-01-23

## Overview

This roadmap tracks implementation tasks for FlutterForge. Each task maps to user journey acceptance criteria for traceability.

**Status:** Phases 1-8 COMPLETE (73/73 tasks, 1411 tests) | Phase 9 PLANNED (10 tasks)

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

## Phase 9: Flutter 3.38 Enhancements (PLANNED)

**Milestone:** Leverage Flutter 3.38 and Dart 3.10 features for cleaner code generation, enhanced preview capabilities, and new widgets

**Status:** PLANNED | **Tasks:** 0/10 | **Journey References:** J19, J20, J21, J22, J23

**Prerequisites:** Flutter SDK updated to 3.38+, Dart 3.10+

---

### Task 9.1: Dart 3.10 Dot Shorthand - Enum Support

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

### Task 9.2: Dart 3.10 Dot Shorthand - Constructor Support

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

### Task 9.3: Dart Version Targeting

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

### Task 9.4: Monitor Metadata Service

| Field | Value |
|-------|-------|
| ID | phase-9-task-04 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J20 S1, S2 |
| Location | `lib/services/monitor_service.dart` |

**Deliverables:**
- [ ] MonitorService with platform abstraction
- [ ] Monitor info display in preview settings
- [ ] DPI-aware preview rendering
- [ ] Multi-monitor detection
- [ ] Unit tests for monitor metadata

---

### Task 9.5: Preview Window Positioning

| Field | Value |
|-------|-------|
| ID | phase-9-task-05 |
| Status | PENDING |
| Priority | P3 |
| Journey AC | J20 S3, S4 |
| Location | `lib/features/preview/` |

**Deliverables:**
- [ ] Detachable preview window
- [ ] Smart positioning on optimal monitor
- [ ] Position persistence across sessions
- [ ] Refresh rate awareness for animations
- [ ] Unit tests for window positioning

---

### Task 9.6: Multi-State Preview Variations

| Field | Value |
|-------|-------|
| ID | phase-9-task-06 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J21 S1, S2 |
| Location | `lib/features/preview/` |

**Deliverables:**
- [ ] Preview variation model
- [ ] Add/remove preview variations UI
- [ ] Theme matrix toggle (light/dark)
- [ ] Size matrix toggle (mobile/tablet/desktop)
- [ ] Unit tests for preview variations

---

### Task 9.7: Preview Groups and Export

| Field | Value |
|-------|-------|
| ID | phase-9-task-07 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J21 S2, S3, S4 |
| Location | `lib/features/preview/`, `lib/generators/` |

**Deliverables:**
- [ ] Preview group model and storage
- [ ] Group organization UI
- [ ] @Preview annotation export
- [ ] @MultiPreview annotation export
- [ ] Group documentation export (Markdown)
- [ ] Unit tests for annotation generation

---

### Task 9.8: DropdownMenu Enhancements

| Field | Value |
|-------|-------|
| ID | phase-9-task-08 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J22 S1 |
| Location | `lib/features/palette/`, `lib/features/properties/` |

**Deliverables:**
- [ ] DropdownMenu widget in registry
- [ ] cursorHeight property
- [ ] menuController property
- [ ] Preview open state toggle
- [ ] Unit tests for DropdownMenu

---

### Task 9.9: Overlay Preview System

| Field | Value |
|-------|-------|
| ID | phase-9-task-09 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J22 S2, S3 |
| Location | `lib/features/canvas/`, `lib/features/properties/` |

**Deliverables:**
- [ ] Overlay layer on canvas
- [ ] Tooltip preview on hover
- [ ] PopupMenuButton preview
- [ ] Context menu configuration UI
- [ ] Unit tests for overlay preview

---

### Task 9.10: New Flutter 3.38 Widgets

| Field | Value |
|-------|-------|
| ID | phase-9-task-10 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J23 S1, S2, S3, S4 |
| Location | `lib/features/palette/`, `lib/generators/` |

**Deliverables:**
- [ ] CupertinoLinearActivityIndicator widget
- [ ] CupertinoDatePicker selectableDayPredicate UI
- [ ] HeadingLevel semantics property
- [ ] Text layout debug visualization
- [ ] Unit tests for new widgets

---

## Phase 9 Definition of Done

- [ ] Dart 3.10 dot shorthand fully implemented in code generator
- [ ] Version targeting with Dart 3.9 fallback
- [ ] Monitor metadata service functional
- [ ] Multi-state preview variations working
- [ ] Preview annotation export implemented
- [ ] DropdownMenu enhancements complete
- [ ] New Flutter 3.38 widgets added to palette
- [ ] All tests pass (target: 1500+ tests)
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
| Phase 9: Flutter 3.38 Enhancements | PLANNED | 0/10 | - |
| **Total** | **88% COMPLETE** | **73/83** | **1411** |

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
| J19 | Dart Shorthand Code Generation | 9.1, 9.2, 9.3 |
| J20 | Monitor Metadata API | 9.4, 9.5 |
| J21 | Widget Preview Enhancements | 9.6, 9.7 |
| J22 | OverlayPortal Improvements | 9.8, 9.9 |
| J23 | New Flutter 3.38 Widgets | 9.10 |

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

- [ ] Phase 9 complete
- [ ] Dart 3.10 dot shorthand working
- [ ] Preview enhancements complete
- [ ] New widgets added
- [ ] 1500+ tests passing
- [ ] Flutter 3.38 SDK requirement documented
- [ ] Push version tag (v1.1.0) to trigger release
