# J17: Cross-Platform Support

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J17 |
| Title | Cross-Platform Support |
| Actor | Designer using FlutterForge on Windows/Linux |
| Priority | P2 |
| Phase | 8 - Platform & Polish |

## User Story

As a designer using FlutterForge, I want the application to work seamlessly on Windows and Linux so that I can use it regardless of my operating system.

## Journey Stages

### S1: Windows Build and Support

**Goal:** Full Windows application support

#### Acceptance Criteria

```gherkin
Feature: Windows Application
  As a Windows user
  I want FlutterForge to run natively on Windows
  So that I can use it in my development environment

  Scenario: Windows installation
    Given I download FlutterForge for Windows
    When I run the installer (MSI or EXE)
    Then the application installs to Program Files
    And a Start Menu shortcut is created
    And a Desktop shortcut option is offered

  Scenario: Windows application launch
    Given FlutterForge is installed on Windows
    When I launch the application
    Then it opens within 3 seconds
    And the UI renders correctly with Windows styling
    And window controls (minimize, maximize, close) work

  Scenario: High DPI support
    Given I have a high DPI display (150% or higher)
    When I run FlutterForge
    Then the UI scales appropriately
    And text and icons remain crisp
    And no blurry elements appear

  Scenario: Windows file associations
    Given FlutterForge is installed
    Then .forge files are associated with the application
    And double-clicking a .forge file opens it in FlutterForge
```

### S2: Platform-Adaptive Keyboard Shortcuts

**Goal:** Use platform-appropriate modifier keys

#### Acceptance Criteria

```gherkin
Feature: Platform Keyboard Shortcuts
  As a user on different platforms
  I want familiar keyboard shortcuts
  So that I can work efficiently with my platform's conventions

  Scenario: Modifier key mapping
    Given the following actions
    Then keyboard shortcuts use platform-appropriate modifiers:
      | Action | macOS | Windows/Linux |
      | Save | Cmd+S | Ctrl+S |
      | Undo | Cmd+Z | Ctrl+Z |
      | Redo | Cmd+Shift+Z | Ctrl+Y |
      | Copy | Cmd+C | Ctrl+C |
      | Paste | Cmd+V | Ctrl+V |
      | Cut | Cmd+X | Ctrl+X |
      | Select All | Cmd+A | Ctrl+A |
      | Export Code | Cmd+E | Ctrl+E |
      | New Project | Cmd+N | Ctrl+N |
      | Open Project | Cmd+O | Ctrl+O |

  Scenario: Shortcut display in menus
    Given I open the Edit menu
    Then shortcuts display with platform-appropriate symbols:
      | Platform | Symbols |
      | macOS | Cmd symbol, Option symbol, Shift symbol |
      | Windows | Ctrl, Alt, Shift |

  Scenario: Shortcut display in tooltips
    Given I hover over a toolbar button
    Then the tooltip shows platform-appropriate shortcuts
    And the modifier keys match my platform

  Scenario: Custom shortcut editor
    Given I open Preferences > Keyboard Shortcuts
    Then I see a list of all available shortcuts
    And I can customize any shortcut
    And conflicts are detected and warned
```

### S3: Linux Build and Support

**Goal:** Full Linux application support

#### Acceptance Criteria

```gherkin
Feature: Linux Application
  As a Linux user
  I want FlutterForge to run on Linux
  So that I can use it in my preferred environment

  Scenario: Linux package formats
    Given FlutterForge is released
    Then the following package formats are available:
      | Format | Target |
      | .deb | Debian, Ubuntu |
      | .rpm | Fedora, RHEL |
      | AppImage | Universal |
      | Snap | Ubuntu Snap Store |

  Scenario: Linux application launch
    Given FlutterForge is installed on Linux
    When I launch the application
    Then it opens within 3 seconds
    And the UI renders with GTK/native styling
    And window decorations match the desktop environment

  Scenario: Linux file manager integration
    Given FlutterForge is installed
    Then .forge files show with the app icon
    And "Open with FlutterForge" appears in context menu
    And recent files appear in the file manager

  Scenario: Wayland and X11 support
    Given I run a Wayland desktop environment
    When I launch FlutterForge
    Then it runs natively on Wayland
    And drag-drop works correctly
    And window positioning works correctly
```

### S4: Platform-Specific File Dialogs

**Goal:** Native file dialog experience

#### Acceptance Criteria

```gherkin
Feature: Native File Dialogs
  As a user
  I want native file dialogs
  So that I can navigate my filesystem naturally

  Scenario: macOS file dialogs
    Given I am on macOS
    When I click "Open Project"
    Then the native macOS file picker opens
    And it supports Quick Look preview
    And it integrates with iCloud Drive

  Scenario: Windows file dialogs
    Given I am on Windows
    When I click "Open Project"
    Then the native Windows file picker opens
    And it shows Recent Places
    And it supports OneDrive integration

  Scenario: Linux file dialogs
    Given I am on Linux
    When I click "Open Project"
    Then the native file picker opens
    And it respects the desktop environment (GTK/Qt)
    And it shows bookmarks from the file manager

  Scenario: File dialog filtering
    Given I open a file dialog
    Then file type filters are available:
      | Filter | Extensions |
      | FlutterForge Projects | .forge |
      | All Files | * |

  Scenario: Recent locations
    Given I have previously saved projects
    When I open a file dialog
    Then my recent project locations are accessible
    And I can quickly navigate to them
```

## CI/CD Requirements

### GitHub Actions Workflows

```yaml
# Windows build workflow
- os: windows-latest
  flutter-version: '3.19.x'
  build-command: flutter build windows --release
  artifact: build/windows/runner/Release/*.exe

# Linux build workflow
- os: ubuntu-latest
  flutter-version: '3.19.x'
  build-command: flutter build linux --release
  artifact: build/linux/x64/release/bundle/*
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Windows installer size | < 50MB |
| Linux package size | < 50MB |
| Launch time | < 3s on all platforms |
| Memory usage | < 500MB baseline |
| CPU idle usage | < 5% |

## Dependencies

- PlatformInfo (existing)
- PlatformUI (existing)
- ShortcutManager (existing)

## Test Coverage Requirements

- Unit tests for platform detection
- Unit tests for shortcut mapping
- Integration tests on Windows CI
- Integration tests on Linux CI
- File dialog smoke tests on each platform
