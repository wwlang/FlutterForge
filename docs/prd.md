# FlutterForge: Product Requirements Document

**Version:** 2.0 | **Date:** January 2026 | **Author:** verabyte.io | **Status:** Draft

> **Scope:** WHAT the product does and WHY. For HOW, see [architecture.md](architecture.md). For code quality rules, see [coding-standards.md](coding-standards.md).

---

## 1. Executive Summary

**FlutterForge** is a cross-platform desktop application enabling Flutter developers to visually design UIs via drag-and-drop, then export clean, idiomatic Dart code.

| Attribute | Value |
|-----------|-------|
| Target | Flutter developers (2-5 years experience) |
| Differentiator | Developer-focused, clean code output, offline-first, one-time purchase |
| Platforms | macOS, Windows, Linux |
| Price Model | $29-49 one-time (not subscription) |

---

## 2. Problem & Opportunity

### 2.1 Pain Points

| Pain Point | Impact |
|------------|--------|
| Boilerplate layout code (nested Rows/Columns) | High development time |
| Mental overhead visualizing widget hierarchies | Slows iteration |
| Figma → Flutter translation is manual | Error-prone, time-consuming |
| FlutterFlow: expensive, web-only, opinionated output | Not developer-friendly |

### 2.2 Market Gap

- No developer-focused visual builder outputting maintainable code
- No native desktop tooling using Flutter for Flutter

### 2.3 Opportunity

Lightweight, affordable, developer-centric tool treating visual design as code generation accelerator, not replacement.

---

## 3. Target Users

### 3.1 Primary: Pragmatic Flutter Developer

| Attribute | Description |
|-----------|-------------|
| Experience | 2-5 years Flutter/mobile |
| Context | Multiple projects, freelance |
| Values | Speed without sacrificing code quality |
| Price sensitivity | High; dislikes subscriptions |

**Jobs to Be Done:**
1. "Scaffold this UI in minutes, not hours"
2. "Experiment with layouts visually before coding"
3. "Get code I can paste and customize freely"

### 3.2 Secondary: Design-to-Code Bridge

Translates Figma/Sketch mockups to Flutter widgets efficiently.

### 3.3 Non-Target

- No-code beginners seeking full app building
- Backend/database integration needs
- Real-time collaboration (v1)

---

## 4. Functional Requirements

### FR1: Widget Palette

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR1.1 | Display categorized widget list | P0 |
| FR1.2 | Drag initiation to canvas | P0 |
| FR1.3 | Search/filter functionality | P1 |
| FR1.4 | Widget preview thumbnails | P2 |

**MVP Widgets:**

| Category | Widgets |
|----------|---------|
| Layout | Container, Row, Column, Stack, Expanded, Flexible, SizedBox, Padding, Center, Align, Wrap |
| Content | Text, Icon, Image, Placeholder |
| Input | ElevatedButton, TextButton, IconButton, TextField, Checkbox, Switch, Slider |
| Scrolling | ListView, SingleChildScrollView |
| Structure | Card, ListTile, AppBar, Scaffold |

### FR2: Design Canvas

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR2.1 | Render live Flutter widgets | P0 |
| FR2.2 | Accept drops from palette | P0 |
| FR2.3 | Nested widget insertion via drop zones | P0 |
| FR2.4 | Selection state visual overlay | P0 |
| FR2.5 | Click-to-select any widget | P0 |
| FR2.6 | Widget reordering within parent | P1 |
| FR2.7 | Guides/snapping during drag | P2 |
| FR2.8 | Zoom and pan | P2 |

### FR3: Widget Tree Panel

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR3.1 | Hierarchical tree display | P0 |
| FR3.2 | Selection sync with canvas | P0 |
| FR3.3 | Drag-to-reorder within tree | P1 |
| FR3.4 | Delete via context menu | P0 |
| FR3.5 | Expand/collapse nested structures | P0 |

### FR4: Properties Panel

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR4.1 | Editable properties for selected widget | P0 |
| FR4.2 | Property types: String, double, int, bool, enum, Color | P0 |
| FR4.3 | Color picker | P1 |
| FR4.4 | Show only relevant properties per widget | P0 |
| FR4.5 | Real-time canvas preview on change | P0 |
| FR4.6 | EdgeInsets editor | P1 |
| FR4.7 | BoxConstraints editor | P1 |

### FR5: Code Generation

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR5.1 | Generate valid, compilable Dart code | P0 |
| FR5.2 | dart_style formatted output | P0 |
| FR5.3 | StatelessWidget generation | P0 |
| FR5.4 | StatefulWidget option | P1 |
| FR5.5 | Snippet-only export option | P1 |
| FR5.6 | Copy to clipboard | P0 |
| FR5.7 | Export to .dart file | P0 |
| FR5.8 | Live code preview panel | P1 |

**Code Quality Standards:** No unnecessary nesting, proper `const` usage, consistent naming.

### FR6: Project Management

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR6.1 | Save to local .forge file | P0 |
| FR6.2 | Open existing projects | P0 |
| FR6.3 | Recent projects list | P1 |
| FR6.4 | Auto-save with recovery | P2 |
| FR6.5 | Multiple screens per project | P1 |

### FR7: Edit Operations

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR7.1 | Undo/Redo (Cmd/Ctrl+Z, Cmd/Ctrl+Shift+Z) | P0 |
| FR7.2 | Delete (Delete/Backspace) | P0 |
| FR7.3 | Duplicate (Cmd/Ctrl+D) | P1 |
| FR7.4 | Cut/Copy/Paste | P1 |

### FR8: Design System Manager

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR8.1 | Token management (Colors, Typography, Spacing, Radii) | P0 |
| FR8.2 | Semantic aliasing (blue-500 → primaryBrand) | P1 |
| FR8.3 | Theme mode toggle (Light/Dark/High-Contrast) | P0 |
| FR8.4 | Reusable style presets | P1 |
| FR8.5 | ThemeExtension class export | P1 |

### FR9: Animation Studio

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR9.1 | Timeline panel (multi-track editor) | P1 |
| FR9.2 | Property keyframing | P1 |
| FR9.3 | Easing editor (cubic-bezier) | P2 |
| FR9.4 | Animation triggers (OnLoad, OnTap, OnScroll) | P1 |
| FR9.5 | Staggered orchestration | P2 |

### FR10: Testing Requirements

| ID | Requirement | Priority |
|----|-------------|:--------:|
| FR10.1 | Unit tests for code generation | P0 |
| FR10.2 | Widget tests for property editors | P0 |
| FR10.3 | Integration tests for DnD workflows | P1 |
| FR10.4 | Golden tests for generated code | P1 |
| FR10.5 | Performance benchmarks (1000+ nodes) | P2 |

---

## 5. Non-Functional Requirements

### NFR1: Performance

| ID | Metric | Target |
|----|--------|--------|
| NFR1.1 | Canvas render after property change | < 16ms (60fps) |
| NFR1.2 | Code generation (100 widgets) | < 500ms |
| NFR1.3 | Application launch | < 3 seconds |
| NFR1.4 | Memory (typical project) | < 500MB |

### NFR2: Platform Support

| ID | Platform | Priority |
|----|----------|:--------:|
| NFR2.1 | macOS (Apple Silicon + Intel) | P0 |
| NFR2.2 | Windows 10/11 | P0 |
| NFR2.3 | Linux (Ubuntu/Debian) | P1 |

### NFR3: Usability

| ID | Requirement |
|----|-------------|
| NFR3.1 | First export within 5 minutes (new user) |
| NFR3.2 | All primary actions keyboard accessible |
| NFR3.3 | Platform-native conventions (menus, shortcuts) |

### NFR4: Accessibility

| ID | Requirement | Priority |
|----|-------------|:--------:|
| NFR4.1 | Keyboard accessible interactive elements | P0 |
| NFR4.2 | Screen reader support for tree navigation | P1 |
| NFR4.3 | High contrast mode | P1 |
| NFR4.4 | 44x44 minimum touch targets | P0 |
| NFR4.5 | Visible focus indicators | P0 |

### NFR5: Testing Coverage

| Layer | Target |
|-------|--------|
| Domain/Models | 90%+ |
| Services/Generators | 85%+ |
| UI Widgets | 70%+ |

---

## 6. Technology Stack

> Implementation details in [architecture.md](architecture.md)

| Component | Technology | Version |
|-----------|------------|---------|
| Framework | Flutter | 3.19+ |
| Language | Dart | 3.3+ |
| State Management | Riverpod | 3.0+ |
| Data Classes | Freezed | 2.5+ |
| Code Generation | code_builder | 4.10+ |
| Navigation | go_router | 14+ |
| Linting | very_good_analysis | 6.0+ |

---

## 7. Roadmap

### Phase 1: Foundation (Weeks 1-3)

- [ ] Project scaffolding
- [ ] Core data model (WidgetNode, Project)
- [ ] Widget registry (5 basic widgets)
- [ ] Basic canvas with single-level DnD
- [ ] Properties panel (basic types)
- [ ] Simple code generation

**Milestone:** Drag Container with Text child, edit padding, export basic code

### Phase 2: Core Editor (Weeks 4-6)

- [ ] Nested DnD with drop zones
- [ ] Widget tree panel
- [ ] 15+ widgets
- [ ] EdgeInsets/Alignment/BoxDecoration editors
- [ ] Formatted code generation
- [ ] Undo/Redo

**Milestone:** Build realistic layouts, export formatted code

### Phase 3: Design System & Animation (Weeks 7-9)

- [ ] DesignToken model
- [ ] Theme Manager UI
- [ ] ThemeExtension generator
- [ ] flutter_animate integration
- [ ] Timeline UI

**Milestone:** Theme globally, animate widgets on entrance

### Phase 4: Polish & Save/Load (Weeks 10-11)

- [ ] Project save/load
- [ ] Recent projects
- [ ] Keyboard shortcuts
- [ ] Copy/paste widgets
- [ ] Selection handles
- [ ] Live code preview

**Milestone:** Full workflow—create, design, save, reopen, export

### Phase 5: Beta Release (Weeks 12-13)

- [ ] Cross-platform testing
- [ ] Performance optimization
- [ ] Error handling
- [ ] Documentation
- [ ] Landing page
- [ ] Beta recruitment

**Milestone:** Public beta release

---

## 8. Success Metrics

### Product Metrics (6 months post-launch)

| Metric | Target |
|--------|--------|
| Downloads | 5,000+ |
| Paid conversions | 500+ |
| Weekly active users | 1,000+ |
| Exports per user per week | 10+ |

### Quality Metrics

| Metric | Target |
|--------|--------|
| Crash-free sessions | > 99% |
| App Store rating | > 4.5 |
| Support tickets per 100 users | < 5 |
| Time to first export | < 5 min |

---

## 9. Competitive Position

| Feature | FlutterForge | FlutterFlow | Manual Coding |
|---------|:------------:|:-----------:|:-------------:|
| Visual UI design | ✓ | ✓ | ✗ |
| Clean code export | ✓ | Partial | N/A |
| Native desktop | ✓ | ✗ | N/A |
| Offline | ✓ | ✗ | ✓ |
| Typed Design System | ✓ | ✗ | Manual |
| Timeline animations | ✓ | Basic | Manual |
| Price | $29-49 once | $30-70/mo | Free |

---

## 10. Business Model

### Pricing

| Tier | Price | Includes |
|------|-------|----------|
| Standard | $29 | Core features, 1 year updates |
| Pro | $49 | + templates, priority support |
| Upgrade | $19 | Major version upgrades |

### Distribution

- Direct: flutterforge.dev (Gumroad/Paddle/LemonSqueezy)
- Optional: macOS App Store, Microsoft Store

---

## 11. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|:----------:|:------:|------------|
| DnD complexity underestimated | Medium | High | Spike early; evaluate packages |
| Animation state conflicts | High | High | Engine overrides panel during playback |
| FlutterFlow adds dev features | Low | Medium | Differentiate on code quality, price |
| Flutter desktop limitations | Medium | Medium | Early testing; workaround list |
| Code gen edge cases | High | Medium | Extensive tests; feedback loop |

---

## 12. Open Questions

1. Widget scope for MVP—how many is enough?
2. Licensing—per-device or per-user?
3. Final naming—FlutterForge vs alternatives
4. Landing page test before building?
5. Animation MVP—flutter_animate presets vs full keyframes?
6. Opt-in analytics for feature usage?

---

## Appendix A: Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| Save | ⌘S | Ctrl+S |
| Open | ⌘O | Ctrl+O |
| Export | ⌘E | Ctrl+E |
| Undo | ⌘Z | Ctrl+Z |
| Redo | ⌘⇧Z | Ctrl+Shift+Z |
| Delete | ⌫ | Delete |
| Duplicate | ⌘D | Ctrl+D |
| Copy | ⌘C | Ctrl+C |
| Paste | ⌘V | Ctrl+V |
| Zoom In/Out | ⌘+/⌘- | Ctrl++/Ctrl+- |

---

## Appendix B: Widget Properties (Sample)

### Container

| Property | Type | Default |
|----------|------|---------|
| width | double? | null |
| height | double? | null |
| color | Color? | null |
| padding | EdgeInsets? | null |
| margin | EdgeInsets? | null |
| alignment | Alignment? | null |
| decoration | BoxDecoration? | null |

### Text

| Property | Type | Default |
|----------|------|---------|
| data | String | 'Text' |
| style.fontSize | double? | null |
| style.fontWeight | FontWeight? | null |
| style.color | Color? | null |
| textAlign | TextAlign? | null |
| maxLines | int? | null |
| overflow | TextOverflow? | null |

---

*See [architecture.md](architecture.md) for implementation details.*
