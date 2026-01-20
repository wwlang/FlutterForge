# FlutterForge Roadmap

**Last Updated:** 2026-01-21

## Overview

This roadmap tracks implementation tasks for FlutterForge. Each task maps to user journey acceptance criteria for traceability.

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

### Task 4.1: Project Model and Serialization (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-01 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J10 (Project Management) S2 |
| Requirements | FR6.1 |
| Location | `lib/services/`, `lib/core/models/` |
| Tests Added | 21 |

**Deliverables:**
- [x] `ForgeProject` model with screens, tokens, metadata
- [x] JSON serialization for all project components
- [x] .forge file format (ZIP containing manifest + project JSON)
- [x] `ProjectService` for save/load operations
- [x] File extension association

---

### Task 4.2-4.4: Project State Provider (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-02/03/04 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J10 (Project Management) S1-S3 |
| Requirements | FR6.1, FR6.2 |
| Location | `lib/providers/` |
| Tests Added | 15 |

**Deliverables:**
- [x] `CurrentProjectState` with project, filePath, isDirty
- [x] `CurrentProjectNotifier` with createNewProject(), loadProject(), markDirty(), markClean()
- [x] `windowTitleProvider` for window title based on project state
- [x] Unsaved changes tracking

---

### Task 4.5: Recent Projects (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-05 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J10 (Project Management) S4 |
| Requirements | FR6.3 |
| Location | `lib/services/` |
| Tests Added | 12 |

**Deliverables:**
- [x] `RecentProject` model with name, path, timestamp
- [x] `RecentProjectsStorage` abstract interface
- [x] `InMemoryRecentProjectsStorage` for testing
- [x] `RecentProjectsService` with 10-item limit
- [x] getRecentProjects(), addRecentProject(), removeProject(), clear()

---

### Task 4.6: Auto-Save and Recovery (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-06 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J10 (Project Management) S5 |
| Requirements | FR6.4 |
| Location | `lib/services/` |
| Tests Added | 10 |

**Deliverables:**
- [x] `RecoveryData` model with project, timestamp, originalPath
- [x] `AutoSaveStorage` abstract interface
- [x] `InMemoryAutoSaveStorage` for testing
- [x] `AutoSaveService` with 60-second interval
- [x] enable()/disable(), saveRecoveryData(), loadRecoveryData(), clearRecoveryData()

---

### Task 4.7: Multiple Screens (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-07 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P2 |
| Journey AC | J10 (Project Management) S6 |
| Requirements | FR6.5 |
| Location | `lib/providers/` |
| Tests Added | 11 |

**Deliverables:**
- [x] `ScreensState` with screens list and currentScreenId
- [x] `ScreensNotifier` with setProject(), selectScreen(), addScreen(), renameScreen(), deleteScreen()
- [x] `currentScreenProvider` for current screen access
- [x] Cannot delete last screen protection

---

### Task 4.8: Keyboard Shortcuts Consolidation (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-08 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | Multiple Journeys |
| Requirements | NFR |
| Location | `lib/features/shortcuts/` |
| Tests Added | 12 |

**Deliverables:**
- [x] `ShortcutCategory` enum (file, edit, widget, view, animation)
- [x] `ShortcutDefinition` with macShortcut and windowsShortcut
- [x] `ShortcutsRegistry` with 18+ shortcuts
- [x] Platform-aware shortcut display (Cmd vs Ctrl)
- [x] getShortcutForPlatform(), getDisplayString()

**Shortcuts Defined:**
- File: New, Open, Save, Save As
- Edit: Undo, Redo
- Widget: Copy, Paste, Cut, Duplicate, Delete
- View: Panels 1-5, Cycle Theme, Show Shortcuts
- Animation: Play/Pause

---

### Task 4.9: Copy/Paste Widgets (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-09 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J04 (Widget Tree) S4 |
| Requirements | FR3.4 |
| Location | `lib/services/` |
| Tests Added | 11 |

**Deliverables:**
- [x] `ClipboardContent` model with widgets and original IDs
- [x] `PasteResult` with pastedWidgets, idMapping, and root ID
- [x] `WidgetClipboardService` with copy(), paste(), clear()
- [x] ID remapping on paste (new UUIDs generated)
- [x] Deep copy of widget hierarchy

---

### Task 4.10: Canvas Pan and Zoom (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-4-task-10 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P2 |
| Journey AC | J03 (Design Canvas) |
| Requirements | NFR |
| Location | `lib/providers/` |
| Tests Added | 10 |

**Deliverables:**
- [x] `CanvasNavigationState` with zoomLevel and panOffset
- [x] `CanvasNavigationNotifier` with zoomIn(), zoomOut(), setZoom(), pan(), reset()
- [x] Zoom limits: 10% (0.1) to 400% (4.0)
- [x] `fitToScreen()` calculation with canvas and content bounds
- [x] `zoomPercentageProvider` for UI display

---

## Phase 4 Definition of Done

- [x] Project save/load with .forge format
- [x] New project with unsaved changes handling
- [x] Open project with error handling
- [x] Recent projects list (10 max)
- [x] Auto-save with crash recovery
- [x] Multiple screens per project
- [x] All keyboard shortcuts documented
- [x] Copy/paste/cut widgets
- [x] Canvas pan and zoom
- [x] `flutter analyze` passes
- [x] `flutter test` passes (843 tests)
- [x] All Phase 4 tasks complete

---

## Phase 4 Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-4-task-01 | J10 Project Management | S2 | COMPLETE |
| phase-4-task-02 | J10 Project Management | S1 | COMPLETE |
| phase-4-task-03 | J10 Project Management | S2 | COMPLETE |
| phase-4-task-04 | J10 Project Management | S3 | COMPLETE |
| phase-4-task-05 | J10 Project Management | S4 | COMPLETE |
| phase-4-task-06 | J10 Project Management | S5 | COMPLETE |
| phase-4-task-07 | J10 Project Management | S6 | COMPLETE |
| phase-4-task-08 | Multiple | - | COMPLETE |
| phase-4-task-09 | J04 Widget Tree | S4 | COMPLETE |
| phase-4-task-10 | J03 Design Canvas | - | COMPLETE |

---

## Phase 5: Beta Release

**Milestone:** Cross-platform validation, performance optimization, documentation, CI/CD, release packaging

**Status:** PENDING | **Estimated Tasks:** 8

### Task 5.1: Cross-Platform Validation

| Field | Value |
|-------|-------|
| ID | phase-5-task-01 |
| Status | PENDING |
| Priority | P0 |
| Requirements | NFR |
| Location | Cross-platform |

**Deliverables:**
- [ ] macOS application testing
- [ ] Windows application testing
- [ ] Linux application testing (optional)
- [ ] Platform-specific UI adjustments
- [ ] Native file dialog integration per platform

---

### Task 5.2: Performance Optimization

| Field | Value |
|-------|-------|
| ID | phase-5-task-02 |
| Status | PENDING |
| Priority | P1 |
| Requirements | NFR |
| Location | Various |

**Deliverables:**
- [ ] Large project performance (100+ widgets)
- [ ] Canvas rendering optimization
- [ ] Memory usage profiling
- [ ] Startup time optimization
- [ ] Code generation speed

---

### Task 5.3: Accessibility

| Field | Value |
|-------|-------|
| ID | phase-5-task-03 |
| Status | PENDING |
| Priority | P1 |
| Requirements | NFR |
| Location | All UI components |

**Deliverables:**
- [ ] Screen reader compatibility
- [ ] Keyboard navigation for all features
- [ ] High contrast mode support
- [ ] Focus indicators
- [ ] Semantic labels

---

### Task 5.4: Error Handling and Recovery

| Field | Value |
|-------|-------|
| ID | phase-5-task-04 |
| Status | PENDING |
| Priority | P0 |
| Requirements | NFR |
| Location | Various |

**Deliverables:**
- [ ] Comprehensive error boundaries
- [ ] User-friendly error messages
- [ ] Error reporting mechanism
- [ ] Graceful degradation
- [ ] Recovery options

---

### Task 5.5: User Documentation

| Field | Value |
|-------|-------|
| ID | phase-5-task-05 |
| Status | PENDING |
| Priority | P1 |
| Requirements | NFR |
| Location | `docs/` |

**Deliverables:**
- [ ] Getting started guide
- [ ] Feature documentation
- [ ] Keyboard shortcuts reference
- [ ] Troubleshooting guide
- [ ] Video tutorials

---

### Task 5.6: Developer Documentation

| Field | Value |
|-------|-------|
| ID | phase-5-task-06 |
| Status | PENDING |
| Priority | P2 |
| Requirements | NFR |
| Location | `docs/`, code comments |

**Deliverables:**
- [ ] Architecture overview
- [ ] API documentation
- [ ] Contributing guide
- [ ] Plugin development guide
- [ ] Code style guide

---

### Task 5.7: CI/CD Pipeline

| Field | Value |
|-------|-------|
| ID | phase-5-task-07 |
| Status | PENDING |
| Priority | P0 |
| Requirements | NFR |
| Location | `.github/workflows/` |

**Deliverables:**
- [ ] Automated testing on PR
- [ ] Build pipeline for all platforms
- [ ] Release automation
- [ ] Version management
- [ ] Changelog generation

---

### Task 5.8: Release Packaging

| Field | Value |
|-------|-------|
| ID | phase-5-task-08 |
| Status | PENDING |
| Priority | P0 |
| Requirements | NFR |
| Location | Build configuration |

**Deliverables:**
- [ ] macOS .dmg installer
- [ ] Windows .exe installer
- [ ] Code signing
- [ ] App icon and branding
- [ ] Update mechanism

---

## Phase 5 Definition of Done

- [ ] All platforms tested (macOS, Windows)
- [ ] Performance meets targets (<2s load, <500ms save)
- [ ] Accessibility audit passed
- [ ] Error handling comprehensive
- [ ] User documentation complete
- [ ] CI/CD pipeline operational
- [ ] Release packages ready
- [ ] Beta release published

---

## Overall Progress Summary

| Phase | Status | Tasks |
|-------|--------|-------|
| Phase 1: Foundation | COMPLETE | 7/7 |
| Phase 2: Core Editor | COMPLETE | 12/12 |
| Phase 3: Design System & Animation | COMPLETE | 13/13 |
| Phase 4: Polish & Save/Load | COMPLETE | 10/10 |
| Phase 5: Beta Release | PENDING | 0/8 |
| **Total** | | **42/50** |
