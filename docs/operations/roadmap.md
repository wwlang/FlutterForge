# FlutterForge Roadmap

**Last Updated:** 2026-01-22

## Overview

This roadmap tracks implementation tasks for FlutterForge. Each task maps to user journey acceptance criteria for traceability.

**Status:** Phases 1-6 COMPLETE | Phases 7-8 IN PROGRESS

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

### Task 6.1: TextField Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-01 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J11 S1 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] TextField widget definition with InputDecoration properties
- [x] TextField renderer with design-time preview
- [x] Unit tests for registry and renderer

---

### Task 6.2: Checkbox Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-02 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J11 S2 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Checkbox widget definition with tristate support
- [x] Checkbox renderer with design-time preview
- [x] Unit tests

---

### Task 6.3: Switch Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-03 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J11 S3 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Switch widget definition with color properties
- [x] Switch renderer with design-time preview
- [x] Unit tests

---

### Task 6.4: Slider Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-04 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J11 S4 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Slider widget definition with min/max/divisions
- [x] Slider renderer with design-time preview
- [x] Unit tests

---

### Task 6.5: ListView Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-05 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J12 S1 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] ListView widget definition with scroll properties
- [x] ListView renderer with scroll preview
- [x] Unit tests

---

### Task 6.6: GridView Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-06 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J12 S2 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] GridView widget definition with count/extent patterns
- [x] GridView renderer with grid preview
- [x] Unit tests

---

### Task 6.7: SingleChildScrollView Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-07 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J12 S3 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] SingleChildScrollView widget definition
- [x] SingleChildScrollView renderer with scroll indicators
- [x] Unit tests

---

### Task 6.8: Card Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-08 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J13 S1 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Card widget definition with elevation/shape
- [x] Card renderer with shadow preview
- [x] Unit tests

---

### Task 6.9: ListTile Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-09 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J13 S2 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] ListTile widget definition with leading/trailing slots
- [x] ListTile renderer with proper layout
- [x] Unit tests

---

### Task 6.10: AppBar Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-10 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J13 S3 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] AppBar widget definition with title/actions
- [x] AppBar renderer with proper styling
- [x] Unit tests

---

### Task 6.11: Scaffold Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-11 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J13 S4 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Scaffold widget definition with slot properties
- [x] Scaffold renderer with slot visualization
- [x] Unit tests

---

### Task 6.12: Wrap Widget

| Field | Value |
|-------|-------|
| ID | phase-6-task-12 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J13 S5 |
| Location | `lib/shared/registry/`, `lib/features/canvas/` |

**Deliverables:**
- [x] Wrap widget definition with spacing/alignment
- [x] Wrap renderer with flow layout
- [x] Unit tests

---

## Phase 6 Definition of Done

- [x] 12 new widgets in registry (32 total)
- [x] All widgets render correctly on canvas
- [x] All existing 1007+ tests still pass
- [x] New widget tests added (40+ Phase 6 tests)
- [x] `flutter analyze` shows no errors

---

## Phase 7: Assets & Preview (IN PROGRESS)

**Milestone:** Image asset management, responsive device preview, live code panel

**Status:** 0/6 tasks | **Priority:** P1 | **Journey References:** J14, J15, J16

### Task 7.1: Asset Import Dialog

| Field | Value |
|-------|-------|
| ID | phase-7-task-01 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J14 S1 |
| Location | `lib/features/assets/` |

**Deliverables:**
- [ ] Asset picker dialog UI
- [ ] File system browser
- [ ] Image format validation
- [ ] Asset copy to project folder
- [ ] Unit tests

---

### Task 7.2: Canvas Image Preview

| Field | Value |
|-------|-------|
| ID | phase-7-task-02 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J14 S2 |
| Location | `lib/features/canvas/`, `lib/features/properties/` |

**Deliverables:**
- [ ] Image widget local asset support
- [ ] Asset picker in properties panel
- [ ] Missing asset placeholder
- [ ] Unit tests

---

### Task 7.3: Asset Bundling in .forge

| Field | Value |
|-------|-------|
| ID | phase-7-task-03 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J14 S3, S4 |
| Location | `lib/services/` |

**Deliverables:**
- [ ] Asset bundling in ProjectService
- [ ] Asset extraction on load
- [ ] Asset path code generation
- [ ] Unit tests

---

### Task 7.4: Device Frame Selector

| Field | Value |
|-------|-------|
| ID | phase-7-task-04 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J15 S1, S2 |
| Location | `lib/features/preview/` |

**Deliverables:**
- [ ] Device frame overlay component
- [ ] Device specifications data
- [ ] Frame selector toolbar
- [ ] Safe area visualization
- [ ] Unit tests

---

### Task 7.5: Responsive Breakpoints

| Field | Value |
|-------|-------|
| ID | phase-7-task-05 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J15 S3, S4 |
| Location | `lib/features/preview/` |

**Deliverables:**
- [ ] Breakpoint provider
- [ ] MediaQuery simulation
- [ ] Orientation toggle
- [ ] Breakpoint quick-switch buttons
- [ ] Unit tests

---

### Task 7.6: Code Preview Panel

| Field | Value |
|-------|-------|
| ID | phase-7-task-06 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J16 S1-S5 |
| Location | `lib/features/code_preview/` |

**Deliverables:**
- [ ] Code preview panel UI
- [ ] Syntax highlighting (flutter_highlight)
- [ ] Live code updates on canvas change
- [ ] Copy button with feedback
- [ ] Unit tests

---

## Phase 7 Definition of Done

- [ ] Images can be imported and previewed
- [ ] Device frames work for iOS/Android/Desktop
- [ ] Code panel shows live syntax-highlighted code
- [ ] All existing tests pass
- [ ] New tests added (~80 expected)

---

## Phase 8: Platform & Polish (PENDING)

**Milestone:** Windows/Linux support, onboarding experience, help system

**Status:** 0/6 tasks | **Priority:** P2 | **Journey References:** J17, J18

### Task 8.1: Windows Build Configuration

| Field | Value |
|-------|-------|
| ID | phase-8-task-01 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J17 S1 |
| Location | `windows/`, `.github/workflows/` |

**Deliverables:**
- [ ] Windows build configuration
- [ ] CI workflow for Windows
- [ ] MSIX/EXE installer
- [ ] High DPI support verification
- [ ] Unit tests

---

### Task 8.2: Linux Build Configuration

| Field | Value |
|-------|-------|
| ID | phase-8-task-02 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J17 S3 |
| Location | `linux/`, `.github/workflows/` |

**Deliverables:**
- [ ] Linux build configuration
- [ ] CI workflow for Linux
- [ ] AppImage/deb packaging
- [ ] Unit tests

---

### Task 8.3: Platform-Adaptive Shortcuts

| Field | Value |
|-------|-------|
| ID | phase-8-task-03 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J17 S2 |
| Location | `lib/core/shortcuts/` |

**Deliverables:**
- [ ] Platform-specific modifier mapping
- [ ] Shortcut display in menus/tooltips
- [ ] Keyboard shortcut editor UI
- [ ] Unit tests

---

### Task 8.4: Native File Dialogs

| Field | Value |
|-------|-------|
| ID | phase-8-task-04 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J17 S4 |
| Location | `lib/services/` |

**Deliverables:**
- [ ] file_selector integration
- [ ] Platform-specific dialog behavior
- [ ] Recent locations support
- [ ] Unit tests

---

### Task 8.5: Welcome Screen and Tutorial

| Field | Value |
|-------|-------|
| ID | phase-8-task-05 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J18 S1, S2 |
| Location | `lib/features/onboarding/` |

**Deliverables:**
- [ ] Welcome screen UI
- [ ] First-run detection
- [ ] Interactive tutorial system
- [ ] Tutorial step highlighting
- [ ] Unit tests

---

### Task 8.6: Help and Keyboard Reference

| Field | Value |
|-------|-------|
| ID | phase-8-task-06 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J18 S3, S4, S5 |
| Location | `lib/features/help/` |

**Deliverables:**
- [ ] Keyboard shortcut reference overlay
- [ ] Contextual help tooltips
- [ ] Documentation links
- [ ] Unit tests

---

## Phase 8 Definition of Done

- [ ] Windows build works and passes CI
- [ ] Linux build works and passes CI
- [ ] Onboarding flow complete
- [ ] Help system functional
- [ ] All existing tests pass
- [ ] New tests added (~60 expected)

---

## Overall Progress Summary

| Phase | Status | Tasks | Tests |
|-------|--------|-------|-------|
| Phase 1: Foundation | COMPLETE | 7/7 | 109 |
| Phase 2: Core Editor | COMPLETE | 12/12 | 404 |
| Phase 3: Design System & Animation | COMPLETE | 13/13 | 741 |
| Phase 4: Polish & Save/Load | COMPLETE | 10/10 | 843 |
| Phase 5: Beta Release | COMPLETE | 8/8 | 1007 |
| Phase 6: Widget Completion | COMPLETE | 12/12 | 1047+ |
| Phase 7: Assets & Preview | IN PROGRESS | 0/6 | - |
| Phase 8: Platform & Polish | PENDING | 0/6 | - |
| **Total** | **IN PROGRESS** | **62/74** | **1047+** |

---

## Journey-Task Mapping

| Journey | Description | Tasks |
|---------|-------------|-------|
| J11 | Form Input Widgets | 6.1, 6.2, 6.3, 6.4 |
| J12 | Scrolling and Lists | 6.5, 6.6, 6.7 |
| J13 | Structural Widgets | 6.8, 6.9, 6.10, 6.11, 6.12 |
| J14 | Image Asset Management | 7.1, 7.2, 7.3 |
| J15 | Responsive Preview | 7.4, 7.5 |
| J16 | Code Preview Panel | 7.6 |
| J17 | Cross-Platform Support | 8.1, 8.2, 8.3, 8.4 |
| J18 | Onboarding and Help | 8.5, 8.6 |

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
- [ ] All Phase 7-8 tasks complete
- [ ] 1300+ tests passing
- [ ] Windows build verified
- [ ] Linux build verified
- [ ] Production documentation complete
- [ ] Push version tag (v1.0.0) to trigger release
