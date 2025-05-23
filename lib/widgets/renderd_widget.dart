import 'package:barcode_widget/barcode_widget.dart' as bw;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barcode_designer/models/widget_data.dart';
import 'package:barcode_designer/providers/app_provider.dart';

const double handleSize = 10.0;
const double minSize = 20.0;

class RenderedWidget extends ConsumerWidget {
  final WidgetData widgetData;
  final bool isSelected;
  final double canvasZoom;
  final VoidCallback onTap;

  const RenderedWidget({
    super.key,
    required this.widgetData,
    required this.isSelected,
    required this.canvasZoom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget childWidget;

    switch (widgetData.type) {
      case WidgetType.text:
        childWidget = Text(
          widgetData.properties.content ?? "",
          style: TextStyle(
            fontSize: (widgetData.properties.fontSize ?? 16) * canvasZoom,
            color: widgetData.properties.fontColor ?? Colors.black,
            fontFamily: widgetData.properties.fontFamily,
          ),
          textAlign: _getTextAlign(widgetData.properties.alignment),
        );
        break;
      case WidgetType.barcode:
        childWidget = bw.BarcodeWidget(
          barcode: mapBarcodeInternalType(
              widgetData.properties.barcodeType ?? BarcodeInternalType.code128),
          data: widgetData.properties.barcodeData ?? "Error",
          width: widgetData.width * canvasZoom,
          height: widgetData.height * canvasZoom,
          color: widgetData.properties.foregroundColor ?? Colors.black,
          backgroundColor: widgetData.properties.barcodeBackgroundColor ??
              Colors.transparent,
          errorBuilder: (context, error) => Center(
              child: Text('Error: $error',
                  style:
                      TextStyle(color: Colors.red, fontSize: 10 * canvasZoom))),
        );
        break;
      case WidgetType.shape:
        childWidget = Container(
          decoration: BoxDecoration(
            color: widgetData.properties.fillColor,
            border: Border.all(
              color: widgetData.properties.strokeColor ?? Colors.transparent,
              width: (widgetData.properties.strokeWidth ?? 1) * canvasZoom,
            ),
            borderRadius:
                widgetData.properties.shapeType == ShapeInternalType.circle
                    ? BorderRadius.circular(widgetData.width / 2 * canvasZoom)
                    : BorderRadius.zero,
          ),
        );
        break;
      case WidgetType.image:
        childWidget = Icon(Icons.image_not_supported,
            size: 30 * canvasZoom, color: Colors.grey);
        break;
      default:
        childWidget =
            Text("Unknown Widget", style: TextStyle(fontSize: 12 * canvasZoom));
    }
    Widget interactiveContent = GestureDetector(
      onTap: onTap,
      onPanUpdate: (details) {
        final newX = widgetData.position.x + (details.delta.dx / canvasZoom);
        final newY = widgetData.position.y + (details.delta.dy / canvasZoom);
        ref.read(currentTemplateProvider.notifier).updateWidget(
              widgetData.copyWith(
                position: WidgetPosition(x: newX, y: newY),
              ),
            );
      },
      child: Container(
        width: widgetData.width * canvasZoom,
        height: widgetData.height * canvasZoom,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.blue, width: 1.0 / canvasZoom)
              : null,
        ),
        child: childWidget,
      ),
    );

    if (isSelected) {
      return Positioned(
        left: widgetData.position.x * canvasZoom,
        top: widgetData.position.y * canvasZoom,
        child: Transform.rotate(
          angle: (widgetData.rotation * 3.1415926535 / 180.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              interactiveContent,
              Positioned(
                left: -handleSize / 2,
                top: -handleSize / 2,
                child: ResizeHandle(
                  onDrag: (dx, dy) {
                    double newWidth = widgetData.width - dx / canvasZoom;
                    double newHeight = widgetData.height - dy / canvasZoom;
                    double newX = widgetData.position.x + dx / canvasZoom;
                    double newY = widgetData.position.y + dy / canvasZoom;
                    if (newWidth >= minSize && newHeight >= minSize) {
                      ref.read(currentTemplateProvider.notifier).updateWidget(
                            widgetData.copyWith(
                                width: newWidth,
                                height: newHeight,
                                position: WidgetPosition(x: newX, y: newY)),
                          );
                    }
                  },
                ),
              ),
              Positioned(
                right: -handleSize / 2,
                top: -handleSize / 2,
                child: ResizeHandle(
                  onDrag: (dx, dy) {
                    double newWidth = widgetData.width + dx / canvasZoom;
                    double newHeight = widgetData.height - dy / canvasZoom;
                    double newY = widgetData.position.y + dy / canvasZoom;
                    if (newWidth >= minSize && newHeight >= minSize) {
                      ref.read(currentTemplateProvider.notifier).updateWidget(
                            widgetData.copyWith(
                                width: newWidth,
                                height: newHeight,
                                position:
                                    widgetData.position.copyWith(y: newY)),
                          );
                    }
                  },
                ),
              ),
              Positioned(
                left: -handleSize / 2,
                bottom: -handleSize / 2,
                child: ResizeHandle(
                  onDrag: (dx, dy) {
                    double newWidth = widgetData.width - dx / canvasZoom;
                    double newHeight = widgetData.height + dy / canvasZoom;
                    double newX = widgetData.position.x + dx / canvasZoom;
                    if (newWidth >= minSize && newHeight >= minSize) {
                      ref.read(currentTemplateProvider.notifier).updateWidget(
                            widgetData.copyWith(
                                width: newWidth,
                                height: newHeight,
                                position:
                                    widgetData.position.copyWith(x: newX)),
                          );
                    }
                  },
                ),
              ),
              Positioned(
                right: -handleSize / 2,
                bottom: -handleSize / 2,
                child: ResizeHandle(
                  onDrag: (dx, dy) {
                    double newWidth = widgetData.width + dx / canvasZoom;
                    double newHeight = widgetData.height + dy / canvasZoom;
                    if (newWidth >= minSize && newHeight >= minSize) {
                      ref.read(currentTemplateProvider.notifier).updateWidget(
                            widgetData.copyWith(
                                width: newWidth, height: newHeight),
                          );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Positioned(
      left: widgetData.position.x * canvasZoom,
      top: widgetData.position.y * canvasZoom,
      child: Transform.rotate(
        angle: (widgetData.rotation * 3.1415926535 / 180.0),
        child: interactiveContent,
      ),
    );
  }

  TextAlign _getTextAlign(String? align) {
    switch (align) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}

class ResizeHandle extends StatelessWidget {
  final Function(double dx, double dy) onDrag;
  const ResizeHandle({super.key, required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onDrag(details.delta.dx, details.delta.dy),
      child: Container(
        width: handleSize,
        height: handleSize,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
