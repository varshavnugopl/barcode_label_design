import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:barcode_designer/models/canvas_properties.dart';
import 'package:barcode_designer/models/label_template.dart';
import 'package:barcode_designer/models/widget_data.dart';

final Uuid _uuid = Uuid();

final currentTemplateProvider =
    StateNotifierProvider<LabelTemplateNotifier, LabelTemplate>((ref) {
  return LabelTemplateNotifier(
    LabelTemplate(
      templateName: "Untitled Label",
      canvasProperties: CanvasProperties(
        width: 4, // inches
        height: 6, // inches
        units: CanvasUnit.inches,
        backgroundColor: Colors.white,
      ),
      widgets: [],
    ),
  );
});

class LabelTemplateNotifier extends StateNotifier<LabelTemplate> {
  LabelTemplateNotifier(super.state);

  void updateTemplate(LabelTemplate newTemplate) {
    state = newTemplate;
  }

  void updateCanvasProperties(CanvasProperties newCanvasProps) {
    state = state.copyWith(canvasProperties: newCanvasProps);
  }

  void addWidget(WidgetType type) {
    final newWidget = WidgetData(
      id: _uuid.v4(),
      type: type,
      position: WidgetPosition(x: 50, y: 50), // Default position in pixels
      width: type == WidgetType.text ? 150 : 100, // Default width in pixels
      height: 50, // Default height in pixels
      properties: _getDefaultProperties(type),
    );
    state = state.copyWith(widgets: [...state.widgets, newWidget]);
  }

  WidgetProperties _getDefaultProperties(WidgetType type) {
    switch (type) {
      case WidgetType.text:
        return WidgetProperties(
            content: "Sample Text",
            fontSize: 16,
            fontColor: Colors.black,
            alignment: "left");
      case WidgetType.barcode:
        return WidgetProperties(
            barcodeType: BarcodeInternalType.code128,
            barcodeData: "123456789",
            foregroundColor: Colors.black,
            barcodeBackgroundColor: Colors.white);
      case WidgetType.shape:
        return WidgetProperties(
            shapeType: ShapeInternalType.rectangle,
            fillColor: Colors.blue,
            strokeColor: Colors.black,
            strokeWidth: 1);
      case WidgetType.image:
        return WidgetProperties(imagePath: "");
      default:
        return WidgetProperties();
    }
  }

  void updateWidget(WidgetData updatedWidget) {
    state = state.copyWith(
      widgets: state.widgets
          .map((w) => w.id == updatedWidget.id ? updatedWidget : w)
          .toList(),
    );
  }

  void removeWidget(String widgetId) {
    state = state.copyWith(
        widgets: state.widgets.where((w) => w.id != widgetId).toList());
  }

  void clearWidgets() {
    state = state.copyWith(widgets: []);
  }
}

final selectedWidgetIdProvider = StateProvider<String?>((ref) => null);

final canvasZoomProvider = StateProvider<double>((ref) => 1.0);
