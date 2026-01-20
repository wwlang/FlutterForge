# Flutter Forge

Visual Flutter UI builder with clean code export for macOS.

## Features

- **Visual Widget Tree**: Drag-and-drop widget composition with hierarchical tree view
- **Live Preview**: Real-time rendering of your Flutter UI designs
- **Design System**: Create and manage design tokens for colors, spacing, and typography
- **Code Generation**: Export clean, production-ready Dart code
- **Properties Panel**: Contextual property editing for selected widgets
- **Project Files**: Save and load your designs with `.forge` project files

## Requirements

- macOS 13.0 or later
- Flutter 3.29.0 or later (for development)

## Installation

### From Release

1. Download the latest DMG from [Releases](https://github.com/yourusername/flutter_forge/releases)
2. Open the DMG and drag Flutter Forge to Applications
3. Launch Flutter Forge from Applications

### From Source

```bash
# Clone the repository
git clone https://github.com/yourusername/flutter_forge.git
cd flutter_forge

# Install dependencies
flutter pub get

# Run the app
flutter run -d macos
```

## Getting Started

### Creating a New Project

1. Launch Flutter Forge
2. Click **File > New Project** or press `Cmd+N`
3. Your new project opens with an empty design canvas

### Adding Widgets

1. Open the **Widget Palette** on the left sidebar
2. Drag a widget (e.g., Container, Column, Row) onto the canvas
3. The widget appears in the canvas and in the widget tree

### Editing Properties

1. Select a widget in the canvas or tree
2. The **Properties Panel** on the right shows available properties
3. Edit values like padding, colors, alignment, etc.
4. Changes reflect immediately in the preview

### Using Design Tokens

1. Open the **Design System** panel
2. Create color, spacing, or typography tokens
3. In the Properties Panel, click the token icon to bind a property to a token
4. Token changes update all bound properties automatically

### Exporting Code

1. Click **View > Code Preview** or press `Cmd+E`
2. Review the generated Dart code
3. Click **Copy** to copy to clipboard
4. Paste into your Flutter project

### Saving Projects

- **Save**: `Cmd+S` or **File > Save**
- **Save As**: `Cmd+Shift+S` or **File > Save As**
- Project files use the `.forge` extension

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| New Project | `Cmd+N` |
| Open Project | `Cmd+O` |
| Save | `Cmd+S` |
| Save As | `Cmd+Shift+S` |
| Undo | `Cmd+Z` |
| Redo | `Cmd+Shift+Z` |
| Cut | `Cmd+X` |
| Copy | `Cmd+C` |
| Paste | `Cmd+V` |
| Delete | `Delete` or `Backspace` |
| Duplicate | `Cmd+D` |
| Toggle Widget Palette | `Cmd+1` |
| Toggle Widget Tree | `Cmd+2` |
| Toggle Properties | `Cmd+3` |
| Code Preview | `Cmd+E` |

## Widget Support

### Layout Widgets
- Container
- Padding
- Center
- Align
- Row
- Column
- Stack
- Expanded
- Flexible
- SizedBox

### Visual Widgets
- Text
- Icon
- Image
- Placeholder

### Input Widgets
- ElevatedButton
- TextButton
- OutlinedButton
- IconButton
- TextField
- Checkbox
- Switch
- Slider

### Scrolling Widgets
- ListView
- GridView
- SingleChildScrollView

## Accessibility

Flutter Forge includes comprehensive accessibility support:

- Full keyboard navigation
- Screen reader support with semantic labels
- WCAG 2.1 AA compliant color contrast
- Focus indicators for all interactive elements

## Development

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building for Release

```bash
# Build macOS release
flutter build macos --release
```

### Code Quality

```bash
# Run analyzer
flutter analyze

# Format code
dart format .
```

## Architecture

Flutter Forge uses a clean architecture with:

- **Riverpod** for state management
- **Freezed** for immutable data classes
- **GoRouter** for navigation
- **TDD** development methodology

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed documentation.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- [Issue Tracker](https://github.com/yourusername/flutter_forge/issues)
- [Discussions](https://github.com/yourusername/flutter_forge/discussions)
