# Barcode Label Designer (Flutter)

A Flutter application for designing and customizing barcode labels, similar in concept to software like BarTender. This application allows users to create label templates, add text, barcodes, and shapes, and then save/load these templates as JSON files.

## Features

*   **Customizable Canvas:** Design labels on a canvas with adjustable dimensions (width, height), units (inches, mm), and orientation (portrait, landscape).
*   **Widget Palette:**
    *   **Text:** Add and edit text blocks with basic formatting (content, font size, alignment, color).
    *   **Barcodes:** Add various barcode types (e.g., Code128, QR Code, EAN-13) and configure their data and appearance.
    *   **Shapes:** Add basic shapes like rectangles (more can be added).
    *   **(Planned) Images:** Placeholder for adding images to labels.
*   **Drag & Drop:** Easily position elements on the canvas by dragging them.
*   **Widget Manipulation:**
    *   Select widgets to view and edit their properties.
    *   Resize widgets using handles.
    *   Rotate widgets.
    *   Delete widgets.
*   **Properties Panel:** A dedicated panel to inspect and modify the properties of the selected widget or the canvas itself.
    *   **Canvas Properties:** Template Name, Width, Height, Units, Orientation, Background Color.
    *   **Widget Properties:** Position (X, Y), Dimensions (Width, Height), Rotation, and type-specific properties (e.g., text content, barcode data).
*   **JSON-Based Templates:**
    *   Label designs are stored and managed using a flexible JSON structure.
    *   **Save:** Export the current label design as a `.json` file.
    *   **Load:** Import and render label designs from existing `.json` template files.
*   **State Management:** Uses Riverpod for managing application state.
*   **Cross-Platform:** Built with Flutter, aiming for web and desktop compatibility.

## Project Overview (from Task Document)

The goal is to build an application similar to BarTender software. It should allow users to design, create, customize, save, and reuse barcode label templates. A JSON-based template system is a core part of the architecture.

Key requirements include:
*   Customizable label canvas with grid and real-time preview.
*   Drag and drop functionality for text, barcodes, shapes, and images.
*   Widget manipulation (resize, rotation, layering, precise positioning).
*   Rich text editing and barcode configuration.
*   Template management (save/load JSON).

*(This project implements a subset of these features with a focus on core functionality.)*

## Getting Started

### Prerequisites

*   Flutter SDK: Make sure you have Flutter installed. Refer to the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
*   A code editor like VS Code or Android Studio with Flutter and Dart plugins.

### Installation & Running

1.  **Clone the repository (if applicable):**
    ```bash
    git clone <your-repository-url>
    cd barcode_designer
    ```
2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Generate JSON serialization code:**
    The project uses `json_serializable` for handling JSON data models. You need to run the build runner to generate the necessary `.g.dart` files:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    If you make changes to the model files (in `lib/models/`), you'll need to run this command again. For continuous development, you can use:
    ```bash
    flutter pub run build_runner watch --delete-conflicting-outputs
    ```
4.  **Run the application:**
    You can run the app on a connected device, emulator, or as a web build:
    ```bash
    flutter run
    ```
    To run specifically for web:
    ```bash
    flutter run -d chrome
    ```

## Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── models/                   # Data models (LabelTemplate, WidgetData, etc.)
├── providers/                # Riverpod providers for state management
├── services/                 # Services (e.g., TemplateService for save/load)
├── utils/                    # Utility functions (e.g., unit conversions)
├── widgets/                  # Reusable UI components
│   ├── canvas_widget.dart
│   ├── properties_panel.dart
│   ├── rendered_widget.dart
│   └── toolbar_widget.dart
└── screens/                  # Top-level screen widgets (DesignerScreen)
```

## Key Dependencies

*   `flutter_riverpod`: For state management.
*   `uuid`: For generating unique IDs for widgets.
*   `file_picker`: For saving and loading template files.
*   `path_provider`: (Potentially used by file_picker or for default paths).
*   `barcode_widget`: For rendering barcode graphics.
*   `flutter_colorpicker`: For selecting colors.
*   `json_annotation` & `json_serializable`: For JSON serialization/deserialization.
*   `build_runner`: Tool for code generation.

