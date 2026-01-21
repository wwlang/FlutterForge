# J14: Image Asset Management

## Journey Overview

| Field | Value |
|-------|-------|
| Journey ID | J14 |
| Title | Image Asset Management |
| Actor | Designer adding images to designs |
| Priority | P1 |
| Phase | 7 - Assets & Preview |

## User Story

As a designer building Flutter UIs, I want to import and manage image assets in my projects so that I can preview real images on the canvas and generate correct asset references in code.

## Journey Stages

### S1: Import Local Images

**Goal:** Add images from local filesystem to project

#### Acceptance Criteria

```gherkin
Feature: Import Local Images
  As a designer
  I want to import local images into my project
  So that I can use them in my designs

  Scenario: Open asset picker dialog
    Given I am working on a project
    When I click the "Add Asset" button in the assets panel
    Or I use the keyboard shortcut Cmd+Shift+A
    Then an asset picker dialog opens
    And I can browse my local filesystem

  Scenario: Import single image
    Given the asset picker dialog is open
    When I select a PNG, JPG, or WebP file
    And I click "Import"
    Then the image is copied to the project's assets folder
    And the image appears in the assets panel
    And a thumbnail preview is generated

  Scenario: Import multiple images
    Given the asset picker dialog is open
    When I select multiple image files
    And I click "Import"
    Then all images are copied to the project's assets folder
    And they all appear in the assets panel

  Scenario: Supported image formats
    Given I am importing images
    Then the following formats are supported:
      | Format | Extension |
      | PNG | .png |
      | JPEG | .jpg, .jpeg |
      | WebP | .webp |
      | GIF | .gif |
      | SVG | .svg |

  Scenario: Image import size validation
    Given I try to import an image larger than 10MB
    When I click "Import"
    Then I see a warning about large file size
    And I can choose to import anyway or cancel
```

### S2: Preview Images in Canvas

**Goal:** Show imported images in the design canvas

#### Acceptance Criteria

```gherkin
Feature: Canvas Image Preview
  As a designer
  I want to see my imported images on the canvas
  So that I can design with real assets

  Scenario: Add Image widget with local asset
    Given I have imported an image "logo.png"
    When I select an Image widget on the canvas
    And I set the source property to "assets/logo.png"
    Then the actual image displays on the canvas
    And the image respects width/height constraints

  Scenario: Image asset picker in properties panel
    Given I have an Image widget selected
    When I click the asset picker button in the properties panel
    Then I see a grid of available project assets
    And I can select one to set as the image source

  Scenario: Image placeholder for missing asset
    Given I have an Image widget with source "assets/missing.png"
    And the file does not exist
    Then the canvas shows a placeholder with broken image icon
    And a warning indicator appears on the widget

  Scenario: Image scaling modes
    Given I have an Image widget with an asset
    When I configure the BoxFit property
    Then the canvas preview updates to show:
      | BoxFit | Behavior |
      | contain | Image fits within bounds |
      | cover | Image covers bounds, may crop |
      | fill | Image stretches to fill |
      | fitWidth | Width matches, height scales |
      | fitHeight | Height matches, width scales |
```

### S3: Bundle Assets in .forge File

**Goal:** Include images when saving projects

#### Acceptance Criteria

```gherkin
Feature: Asset Bundling
  As a designer
  I want my images bundled with my project
  So that I can share complete designs

  Scenario: Save project with assets
    Given I have a project with imported images
    When I save the project as a .forge file
    Then the .forge file contains:
      | Content | Location |
      | Project JSON | /project.json |
      | Images | /assets/* |
    And the file size reflects the included assets

  Scenario: Load project with assets
    Given I open a .forge file containing images
    Then the images are extracted to a temporary location
    And the canvas displays the images correctly
    And the assets panel shows all included images

  Scenario: Asset reference integrity
    Given I have a project with image references
    When I rename an image in the assets panel
    Then all widget references are updated automatically
    And the canvas continues to display correctly
```

### S4: Code Generation for Assets

**Goal:** Generate correct Image widget code with asset references

#### Acceptance Criteria

```gherkin
Feature: Asset Code Generation
  As a designer
  I want correct asset references in generated code
  So that my Flutter app can display the images

  Scenario: Generate Image.asset code
    Given I have an Image widget with source "assets/logo.png"
    When I export the code
    Then the generated code is:
      ```dart
      Image.asset(
        'assets/logo.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      )
      ```

  Scenario: Generate pubspec.yaml assets section
    Given I have a project with multiple images
    When I export the project
    Then a pubspec.yaml snippet is generated:
      ```yaml
      flutter:
        assets:
          - assets/logo.png
          - assets/background.jpg
      ```

  Scenario: Asset path validation
    Given I have an Image widget with an asset reference
    When the asset file doesn't exist
    Then a warning is shown during code generation
    And the code still generates with a TODO comment
```

## Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| Image import time | < 2s for 5MB image |
| Thumbnail generation | < 500ms |
| Canvas render with images | < 32ms (30fps minimum) |
| .forge file compression | 50% size reduction |

## Dependencies

- ProjectService (existing)
- Image widget (existing)
- PropertiesPanel (existing)
- DartGenerator (existing)

## Security Considerations

- Validate image file headers match extension
- Sanitize file paths to prevent directory traversal
- Limit maximum file size (10MB default)

## Test Coverage Requirements

- Unit tests for asset import
- Unit tests for .forge bundling
- Unit tests for code generation with assets
- Integration tests for image preview in canvas
- Edge case tests for missing/invalid assets
