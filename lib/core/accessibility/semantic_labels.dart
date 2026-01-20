/// Semantic labels for accessibility and screen reader support.
///
/// All user-facing elements should use these labels for consistency
/// and to support WCAG compliance.
class SemanticLabels {
  const SemanticLabels._();

  // === Widget Palette ===
  static const String widgetPalette = 'Widget palette';
  static const String widgetPaletteSearch = 'Search widgets';
  static const String widgetCategory = 'Widget category';
  static String widgetDraggable(String widgetName) =>
      'Drag to add $widgetName widget';

  // === Widget Tree ===
  static const String widgetTree = 'Widget tree';
  static const String widgetTreeRoot = 'Root widget';
  static String widgetTreeNode(String type, int depth) =>
      '$type widget at depth $depth';
  static String widgetTreeExpand(String type) => 'Expand $type children';
  static String widgetTreeCollapse(String type) => 'Collapse $type children';
  static String widgetTreeSelected(String type) => '$type widget, selected';
  static const String widgetTreeEmpty = 'Widget tree is empty';

  // === Design Canvas ===
  static const String designCanvas = 'Design canvas';
  static const String canvasZoomIn = 'Zoom in';
  static const String canvasZoomOut = 'Zoom out';
  static const String canvasResetZoom = 'Reset zoom to 100%';
  static const String canvasFitToScreen = 'Fit canvas to screen';
  static String canvasZoomLevel(int percent) => 'Zoom level $percent percent';
  static const String canvasDropZone = 'Drop zone for new widgets';
  static String canvasWidget(String type) => '$type widget on canvas';

  // === Properties Panel ===
  static const String propertiesPanel = 'Properties panel';
  static const String propertiesEmpty = 'No widget selected';
  static String propertyEditor(String propertyName) =>
      '$propertyName property editor';
  static String propertyValue(String propertyName, String value) =>
      '$propertyName is $value';
  static const String propertyBindToken = 'Bind to design token';
  static const String propertyUnbindToken = 'Remove token binding';

  // === Design System Panel ===
  static const String designSystemPanel = 'Design system panel';
  static const String designTokensList = 'Design tokens list';
  static String designToken(String name, String type) => '$name $type token';
  static const String addColorToken = 'Add color token';
  static const String addSpacingToken = 'Add spacing token';
  static const String addTypographyToken = 'Add typography token';
  static String editToken(String name) => 'Edit $name token';
  static String deleteToken(String name) => 'Delete $name token';

  // === Animation Panel ===
  static const String animationPanel = 'Animation panel';
  static const String animationTimeline = 'Animation timeline';
  static const String animationPlayPause = 'Play or pause animation';
  static const String animationStop = 'Stop animation';
  static String animationKeyframe(String property, double time) =>
      'Keyframe for $property at ${time}s';
  static const String addKeyframe = 'Add keyframe';
  static const String deleteKeyframe = 'Delete keyframe';
  static const String easingEditor = 'Easing curve editor';

  // === Code Generation ===
  static const String codePreview = 'Generated code preview';
  static const String copyCode = 'Copy code to clipboard';
  static const String exportCode = 'Export generated code';

  // === File Operations ===
  static const String newProject = 'Create new project';
  static const String openProject = 'Open existing project';
  static const String saveProject = 'Save current project';
  static const String saveProjectAs = 'Save project as new file';
  static const String recentProjects = 'Recent projects list';
  static String recentProject(String name) => 'Open recent project $name';

  // === Edit Operations ===
  static const String undo = 'Undo last action';
  static const String redo = 'Redo last undone action';
  static const String cut = 'Cut selected widget';
  static const String copy = 'Copy selected widget';
  static const String paste = 'Paste copied widget';
  static const String duplicate = 'Duplicate selected widget';
  static const String delete = 'Delete selected widget';

  // === View Operations ===
  static const String togglePalette = 'Toggle widget palette visibility';
  static const String toggleTree = 'Toggle widget tree visibility';
  static const String toggleProperties = 'Toggle properties panel visibility';
  static const String toggleDesignSystem =
      'Toggle design system panel visibility';
  static const String toggleAnimation = 'Toggle animation panel visibility';

  // === Theme ===
  static const String themeMode = 'Theme mode';
  static const String lightTheme = 'Switch to light theme';
  static const String darkTheme = 'Switch to dark theme';
  static const String systemTheme = 'Use system theme';

  // === Dialogs ===
  static const String closeDialog = 'Close dialog';
  static const String confirmAction = 'Confirm action';
  static const String cancelAction = 'Cancel action';

  // === Status ===
  static const String unsavedChanges = 'Project has unsaved changes';
  static const String savedSuccessfully = 'Project saved successfully';
  static String errorMessage(String error) => 'Error: $error';
}
