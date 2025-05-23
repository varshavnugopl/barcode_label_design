// lib/widgets/properties_panel.dart
import 'package:barcode_designer/models/canvas_properties.dart';
import 'package:barcode_designer/models/widget_data.dart';
import 'package:barcode_designer/providers/app_provider.dart';
import 'package:barcode_designer/utils/conversations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertiesPanel extends ConsumerWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWidgetId = ref.watch(selectedWidgetIdProvider);
    final template = ref.watch(currentTemplateProvider);
    final selectedWidget = selectedWidgetId == null
        ? null
        : template.widgets.firstWhere((w) => w.id == selectedWidgetId);

    return Container(
      width: 280,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: selectedWidget == null
            ? _CanvasPropertiesEditor(
                properties: template.canvasProperties,
                onChanged: (newProps) {
                  print(
                      "PropertiesPanel: Updating canvas properties in provider. New props: Width=${newProps.width}, Height=${newProps.height}, Units=${newProps.units.name}, BGColor=${newProps.backgroundColor}");
                  ref
                      .read(currentTemplateProvider.notifier)
                      .updateCanvasProperties(newProps);
                },
              )
            : _WidgetPropertiesEditor(
                widgetData: selectedWidget,
                onChanged: (newWidgetData) {
                  ref
                      .read(currentTemplateProvider.notifier)
                      .updateWidget(newWidgetData);
                },
                onDelete: () {
                  ref
                      .read(currentTemplateProvider.notifier)
                      .removeWidget(selectedWidget.id);
                  ref.read(selectedWidgetIdProvider.notifier).state = null;
                },
              ),
      ),
    );
  }
}

class _CanvasPropertiesEditor extends StatefulWidget {
  final CanvasProperties properties;
  final ValueChanged<CanvasProperties> onChanged;

  const _CanvasPropertiesEditor(
      {required this.properties, required this.onChanged});

  @override
  State<_CanvasPropertiesEditor> createState() =>
      _CanvasPropertiesEditorState();
}

class _CanvasPropertiesEditorState extends State<_CanvasPropertiesEditor> {
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late CanvasProperties _currentProps;

  @override
  void initState() {
    super.initState();
    _currentProps = widget.properties;
    _widthController =
        TextEditingController(text: _currentProps.width.toStringAsFixed(2));
    _heightController =
        TextEditingController(text: _currentProps.height.toStringAsFixed(2));
  }

  @override
  void didUpdateWidget(covariant _CanvasPropertiesEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.properties != oldWidget.properties) {
      _currentProps = widget.properties;

      final newWidthText = _currentProps.width.toStringAsFixed(2);
      if (_widthController.text != newWidthText) {
        _widthController.text = newWidthText;
      }

      final newHeightText = _currentProps.height.toStringAsFixed(2);
      if (_heightController.text != newHeightText) {
        _heightController.text = newHeightText;
      }
    }
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged(_currentProps);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Canvas Properties",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _PropertyRow(
          label: "Width (${_currentProps.units.name})",
          child: SizedBox(
            width: 80,
            child: TextField(
              controller: _widthController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (val) {
                FocusScope.of(context).unfocus();

                final newWidth = double.tryParse(val) ?? _currentProps.width;
                print(
                    "CanvasPropertiesEditor: Submitted width string: '$val', parsed new width: $newWidth");
                if (newWidth != _currentProps.width) {
                  _currentProps = _currentProps.copyWith(width: newWidth);
                  _update();
                } else if (val != _currentProps.width.toStringAsFixed(2)) {
                  _widthController.text =
                      _currentProps.width.toStringAsFixed(2);
                }
              },
            ),
          ),
        ),
        _PropertyRow(
          label: "Height (${_currentProps.units.name})",
          child: SizedBox(
            width: 80,
            child: TextField(
              controller: _heightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (val) {
                FocusScope.of(context).unfocus();

                final newHeight = double.tryParse(val) ?? _currentProps.height;
                print(
                    "CanvasPropertiesEditor: Submitted height string: '$val', parsed new height: $newHeight");
                if (newHeight != _currentProps.height) {
                  _currentProps = _currentProps.copyWith(height: newHeight);
                  _update();
                } else if (val != _currentProps.height.toStringAsFixed(2)) {
                  _heightController.text =
                      _currentProps.height.toStringAsFixed(2);
                }
              },
            ),
          ),
        ),
        DropdownButtonFormField<CanvasUnit>(
          decoration: const InputDecoration(labelText: "Units"),
          value: _currentProps.units,
          items: CanvasUnit.values.map((unit) {
            return DropdownMenuItem(value: unit, child: Text(unit.name));
          }).toList(),
          onChanged: (CanvasUnit? newValue) {
            if (newValue != null) {
              // Basic conversion: if units change, try to maintain pixel size approximately
              // This is a simplification. A robust solution would recalculate.
              final currentPixelWidth =
                  convertToPixels(_currentProps.width, _currentProps.units);
              final currentPixelHeight =
                  convertToPixels(_currentProps.height, _currentProps.units);

              _currentProps = _currentProps.copyWith(
                units: newValue,
                width: convertFromPixels(currentPixelWidth, newValue),
                height: convertFromPixels(currentPixelHeight, newValue),
              );
              _widthController.text = _currentProps.width.toStringAsFixed(2);
              _heightController.text = _currentProps.height.toStringAsFixed(2);
              _update();
              setState(() {}); // To update unit label in width/height
            }
          },
        ),
        DropdownButtonFormField<CanvasOrientation>(
          decoration: const InputDecoration(labelText: "Orientation"),
          value: _currentProps.orientation,
          items: CanvasOrientation.values.map((orientation) {
            return DropdownMenuItem(
                value: orientation, child: Text(orientation.name));
          }).toList(),
          onChanged: (CanvasOrientation? newValue) {
            if (newValue != null) {
              _currentProps = _currentProps.copyWith(orientation: newValue);
              _update();
            }
          },
        ),
        _ColorPickerEditor(
            label: "Background Color",
            color: _currentProps.backgroundColor ?? Colors.white,
            onColorChanged: (color) {
              _currentProps = _currentProps.copyWith(backgroundColor: color);
              _update();
            }),
      ],
    );
  }
}

class _WidgetPropertiesEditor extends StatefulWidget {
  final WidgetData widgetData;
  final ValueChanged<WidgetData> onChanged;
  final VoidCallback onDelete;

  const _WidgetPropertiesEditor({
    required this.widgetData,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_WidgetPropertiesEditor> createState() =>
      _WidgetPropertiesEditorState();
}

class _WidgetPropertiesEditorState extends State<_WidgetPropertiesEditor> {
  late TextEditingController _xController,
      _yController,
      _widthController,
      _heightController,
      _rotationController;
  late WidgetData _currentWidgetData;

  @override
  void initState() {
    super.initState();
    _currentWidgetData = widget.widgetData;
    _initializeControllers();
    _addListeners(); // Add listeners ONCE
  }

  void _initializeControllers() {
    _xController = TextEditingController(
        text: _currentWidgetData.position.x.toStringAsFixed(1));
    _yController = TextEditingController(
        text: _currentWidgetData.position.y.toStringAsFixed(1));
    _widthController = TextEditingController(
        text: _currentWidgetData.width.toStringAsFixed(1));
    _heightController = TextEditingController(
        text: _currentWidgetData.height.toStringAsFixed(1));
    _rotationController = TextEditingController(
        text: _currentWidgetData.rotation.toStringAsFixed(1));
  }

  void _addListeners() {
    _xController.addListener(() => _handleNumericInput(
        _xController,
        (val) => _currentWidgetData = _currentWidgetData.copyWith(
            position: _currentWidgetData.position.copyWith(x: val))));
    _yController.addListener(() => _handleNumericInput(
        _yController,
        (val) => _currentWidgetData = _currentWidgetData.copyWith(
            position: _currentWidgetData.position.copyWith(y: val))));
    _widthController.addListener(() => _handleNumericInput(_widthController,
        (val) => _currentWidgetData = _currentWidgetData.copyWith(width: val),
        minValue: 1.0));
    _heightController.addListener(() => _handleNumericInput(_heightController,
        (val) => _currentWidgetData = _currentWidgetData.copyWith(height: val),
        minValue: 1.0));
    _rotationController.addListener(() => _handleNumericInput(
        _rotationController,
        (val) =>
            _currentWidgetData = _currentWidgetData.copyWith(rotation: val)));
  }

  void _handleNumericInput(
      TextEditingController controller, Function(double) updater,
      {double? minValue}) {
    final double? newValue = double.tryParse(controller.text);
    if (newValue != null) {
      // Min value check could be more robust (e.g., clamp or revert)
      // For now, it allows update and relies on model/renderer constraints
      if (minValue != null && newValue < minValue) {
        // Potentially do something, e.g. clamp: newValue = max(newValue, minValue);
        // For now, we proceed with the parsed value.
      }
      updater(newValue);
      _update();
    }
    // If parsing fails (e.g. text is "abc" or empty after being non-empty),
    // _currentWidgetData is not updated. The TextField will show "abc".
    // When/if an external update happens, didUpdateWidget might correct it.
  }

  @override
  void didUpdateWidget(covariant _WidgetPropertiesEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.widgetData != oldWidget.widgetData) {
      _currentWidgetData = widget.widgetData;

      final newXText = _currentWidgetData.position.x.toStringAsFixed(1);
      if (_xController.text != newXText) {
        _xController.text = newXText;
      }

      final newYText = _currentWidgetData.position.y.toStringAsFixed(1);
      if (_yController.text != newYText) {
        _yController.text = newYText;
      }

      final newWidthText = _currentWidgetData.width.toStringAsFixed(1);
      if (_widthController.text != newWidthText) {
        _widthController.text = newWidthText;
      }

      final newHeightText = _currentWidgetData.height.toStringAsFixed(1);
      if (_heightController.text != newHeightText) {
        _heightController.text = newHeightText;
      }

      final newRotationText = _currentWidgetData.rotation.toStringAsFixed(1);
      if (_rotationController.text != newRotationText) {
        _rotationController.text = newRotationText;
      }
    }
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged(_currentWidgetData);
  }

  @override
  Widget build(BuildContext context) {
    final props = _currentWidgetData.properties;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Widget: ${widget.widgetData.type.name}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("ID: ${widget.widgetData.id.substring(0, 8)}...",
            style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 16),

        _PropertyRow(
          label: "X (px)",
          child: SizedBox(
              width: 70,
              child: TextField(
                controller: _xController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                // onSubmitted: (v) {
                //   _currentWidgetData = _currentWidgetData.copyWith(
                //       position: _currentWidgetData.position
                //           .copyWith(x: double.tryParse(v)));
                //   _update();
                // }
              )),
        ),
        _PropertyRow(
          label: "Y (px)",
          child: SizedBox(
              width: 70,
              child: TextField(
                controller: _yController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                // onSubmitted: (v) {
                //   _currentWidgetData = _currentWidgetData.copyWith(
                //       position: _currentWidgetData.position
                //           .copyWith(y: double.tryParse(v)));
                //   _update();
                // }
              )),
        ),
        _PropertyRow(
          label: "Width (px)",
          child: SizedBox(
              width: 70,
              child: TextField(
                controller: _widthController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                // onSubmitted: (v) {
                //   _currentWidgetData =
                //       _currentWidgetData.copyWith(width: double.tryParse(v));
                //   _update();
                // }
              )),
        ),
        _PropertyRow(
          label: "Height (px)",
          child: SizedBox(
              width: 70,
              child: TextField(
                controller: _heightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                // onSubmitted: (v) {
                //   _currentWidgetData =
                //       _currentWidgetData.copyWith(height: double.tryParse(v));
                //   _update();
                // }
              )),
        ),
        _PropertyRow(
          label: "Rotation (°)",
          child: SizedBox(
              width: 70,
              child: TextField(
                controller: _rotationController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                // onSubmitted: (v) {
                //   _currentWidgetData = _currentWidgetData.copyWith(
                //       rotation: double.tryParse(v));
                //   _update();
                // }
              )),
        ),

        const Divider(height: 20),

        if (_currentWidgetData.type == WidgetType.text) ...[
          _TextPropertyEditor(
              properties: props,
              onChanged: (newProps) {
                _currentWidgetData =
                    _currentWidgetData.copyWith(properties: newProps);
                _update();
              })
        ],
        if (_currentWidgetData.type == WidgetType.barcode) ...[
          _BarcodePropertyEditor(
              properties: props,
              onChanged: (newProps) {
                _currentWidgetData =
                    _currentWidgetData.copyWith(properties: newProps);
                _update();
              })
        ],
        if (_currentWidgetData.type == WidgetType.shape) ...[
          _ShapePropertyEditor(
              properties: props,
              onChanged: (newProps) {
                _currentWidgetData =
                    _currentWidgetData.copyWith(properties: newProps);
                _update();
              })
        ],
        // Add editors for other widget types (Shape, Image)

        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete, color: Colors.white),
          label: const Text("Delete Widget",
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: widget.onDelete,
        )
      ],
    );
  }
}

class _TextPropertyEditor extends StatefulWidget {
  final WidgetProperties properties;
  final ValueChanged<WidgetProperties> onChanged;
  const _TextPropertyEditor(
      {required this.properties, required this.onChanged});

  @override
  State<_TextPropertyEditor> createState() => _TextPropertyEditorState();
}

class _TextPropertyEditorState extends State<_TextPropertyEditor> {
  late TextEditingController _contentController, _fontSizeController;
  late WidgetProperties _currentProps;

  @override
  void initState() {
    super.initState();
    _currentProps = widget.properties;
    _contentController =
        TextEditingController(text: _currentProps.content ?? "");
    _fontSizeController =
        TextEditingController(text: _currentProps.fontSize?.toString() ?? "16");

    _contentController.addListener(() {
      if (_currentProps.content != _contentController.text) {
        _currentProps =
            _currentProps.copyWith(content: _contentController.text);
        _update();
      }
    });

    _fontSizeController.addListener(() {
      final newFontSizeText = _fontSizeController.text;
      // Compare with string representation of current prop to avoid loop from formatting
      if ((_currentProps.fontSize?.toString() ?? "16") != newFontSizeText) {
        final double? newSize = double.tryParse(newFontSizeText);
        if (newSize != null) {
          _currentProps = _currentProps.copyWith(fontSize: newSize);
          _update();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant _TextPropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.properties != oldWidget.properties) {
      _currentProps = widget.properties;

      final newContentText = _currentProps.content ?? "";
      if (_contentController.text != newContentText) {
        _contentController.text = newContentText;
      }

      final newFontSizeText = _currentProps.fontSize?.toString() ?? "16";
      if (_fontSizeController.text != newFontSizeText) {
        _fontSizeController.text = newFontSizeText;
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _fontSizeController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged(_currentProps);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _contentController,
          decoration: const InputDecoration(
              labelText: "Content", border: OutlineInputBorder()),
          // onSubmitted: (val) {
          //   _currentProps = _currentProps.copyWith(content: val);
          //   _update();
          // },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _fontSizeController,
          decoration: const InputDecoration(
              labelText: "Font Size", border: OutlineInputBorder()),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          // onSubmitted: (val) {
          //   _currentProps =
          //       _currentProps.copyWith(fontSize: double.tryParse(val));
          //   _update();
          // },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Alignment"),
          value: _currentProps.alignment ?? "left",
          items: ["left", "center", "right"]
              .map((align) => DropdownMenuItem(
                  value: align, child: Text(align.capitalize())))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              _currentProps = _currentProps.copyWith(alignment: val);
              _update();
            }
          },
        ),
        _ColorPickerEditor(
            label: "Font Color",
            color: _currentProps.fontColor ?? Colors.black,
            onColorChanged: (color) {
              _currentProps = _currentProps.copyWith(fontColor: color);
              _update();
            }),
      ],
    );
  }
}

class _BarcodePropertyEditor extends StatefulWidget {
  final WidgetProperties properties;
  final ValueChanged<WidgetProperties> onChanged;
  const _BarcodePropertyEditor(
      {required this.properties, required this.onChanged});

  @override
  State<_BarcodePropertyEditor> createState() => _BarcodePropertyEditorState();
}

class _BarcodePropertyEditorState extends State<_BarcodePropertyEditor> {
  late TextEditingController _dataController;
  late WidgetProperties _currentProps;

  @override
  void initState() {
    super.initState();
    _currentProps = widget.properties;
    _dataController =
        TextEditingController(text: _currentProps.barcodeData ?? "");
    _dataController.addListener(() {
      if (_currentProps.barcodeData != _dataController.text) {
        _currentProps =
            _currentProps.copyWith(barcodeData: _dataController.text);
        _update();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _BarcodePropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.properties != oldWidget.properties) {
      _currentProps = widget.properties;
      final newBarcodeDataText = _currentProps.barcodeData ?? "";
      if (_dataController.text != newBarcodeDataText) {
        _dataController.text = newBarcodeDataText;
      }
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged(_currentProps);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<BarcodeInternalType>(
          decoration: const InputDecoration(labelText: "Barcode Type"),
          value: _currentProps.barcodeType ?? BarcodeInternalType.code128,
          items: BarcodeInternalType.values
              .map((type) =>
                  DropdownMenuItem(value: type, child: Text(type.name)))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              _currentProps = _currentProps.copyWith(barcodeType: val);
              _update();
            }
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dataController,
          decoration: const InputDecoration(
              labelText: "Barcode Data", border: OutlineInputBorder()),
          // onSubmitted: (val) {
          //   _currentProps = _currentProps.copyWith(barcodeData: val);
          //   _update();
          // },
        ),
        const SizedBox(height: 8),
        _ColorPickerEditor(
            label: "Foreground Color",
            color: _currentProps.foregroundColor ?? Colors.black,
            onColorChanged: (color) {
              _currentProps = _currentProps.copyWith(foregroundColor: color);
              _update();
            }),
        _ColorPickerEditor(
            label: "Background Color",
            color: _currentProps.barcodeBackgroundColor ?? Colors.white,
            onColorChanged: (color) {
              _currentProps =
                  _currentProps.copyWith(barcodeBackgroundColor: color);
              _update();
            }),
      ],
    );
  }
  // void _update() { widget.onChanged(_currentProps); }
}

class _ShapePropertyEditor extends StatefulWidget {
  final WidgetProperties properties;
  final ValueChanged<WidgetProperties> onChanged;

  const _ShapePropertyEditor(
      {required this.properties, required this.onChanged});

  @override
  State<_ShapePropertyEditor> createState() => _ShapePropertyEditorState();
}

class _ShapePropertyEditorState extends State<_ShapePropertyEditor> {
  late WidgetProperties _currentProps;
  late TextEditingController _strokeWidthController;

  @override
  void initState() {
    super.initState();
    _currentProps = widget.properties;
    _strokeWidthController = TextEditingController(
        text: _currentProps.strokeWidth?.toString() ?? "1");

    _strokeWidthController.addListener(() {
      final newSWText = _strokeWidthController.text;
      if ((_currentProps.strokeWidth?.toString() ?? "1") != newSWText) {
        final double? newStrokeWidth = double.tryParse(newSWText);
        if (newStrokeWidth != null) {
          _currentProps = _currentProps.copyWith(strokeWidth: newStrokeWidth);
          _update();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ShapePropertyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.properties != oldWidget.properties) {
      _currentProps = widget.properties;
      final newStrokeWidthText = _currentProps.strokeWidth?.toString() ?? "1";
      if (_strokeWidthController.text != newStrokeWidthText) {
        _strokeWidthController.text = newStrokeWidthText;
      }
    }
  }

  @override
  void dispose() {
    _strokeWidthController.dispose();
    super.dispose();
  }

  void _update() {
    widget.onChanged(_currentProps);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ShapeInternalType>(
          decoration: const InputDecoration(labelText: "Shape Type"),
          value: _currentProps.shapeType ?? ShapeInternalType.rectangle,
          items: ShapeInternalType.values
              .map((type) =>
                  DropdownMenuItem(value: type, child: Text(type.name)))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              _currentProps = _currentProps.copyWith(shapeType: val);
              _update();
            }
          },
        ),
        const SizedBox(height: 8),
        _ColorPickerEditor(
            label: "Fill Color",
            color: _currentProps.fillColor ?? Colors.blue,
            onColorChanged: (color) {
              _currentProps = _currentProps.copyWith(fillColor: color);
              _update();
            }),
        _ColorPickerEditor(
            label: "Stroke Color",
            color: _currentProps.strokeColor ?? Colors.black,
            onColorChanged: (color) {
              _currentProps = _currentProps.copyWith(strokeColor: color);
              _update();
            }),
        TextField(
          controller: _strokeWidthController,
          decoration: const InputDecoration(
              labelText: "Stroke Width", border: OutlineInputBorder()),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          // onSubmitted: (val) {
          //   _currentProps =
          //       _currentProps.copyWith(strokeWidth: double.tryParse(val));
          //   _update();
          // },
        ),
      ],
    );
  }
}

class _PropertyRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _PropertyRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          child,
        ],
      ),
    );
  }
}

class _ColorPickerEditor extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _ColorPickerEditor({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Pick $label'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: color,
                      onColorChanged: onColorChanged,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
