import 'package:barcode_designer/providers/app_provider.dart';
import 'package:barcode_designer/utils/conversations.dart';
import 'package:barcode_designer/widgets/renderd_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CanvasWidget extends ConsumerWidget {
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(currentTemplateProvider);
    final selectedWidgetId = ref.watch(selectedWidgetIdProvider);
    final canvasZoom = ref.watch(canvasZoomProvider);

    final canvasProps = template.canvasProperties;
    final pixelSize = canvasProps.getPixelDimensions(defaultDPI);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedWidgetIdProvider.notifier).state = null;
        },
        child: Container(
          color: Colors.grey[400],
          alignment: Alignment.center,
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 4.0,
            onInteractionEnd: (details) {},
            child: Container(
              width: pixelSize.width * canvasZoom,
              height: pixelSize.height * canvasZoom,
              decoration: BoxDecoration(
                color: canvasProps.backgroundColor,
                border: Border.all(color: Colors.black54, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: template.widgets.map((widgetData) {
                  return RenderedWidget(
                    widgetData: widgetData,
                    isSelected: widgetData.id == selectedWidgetId,
                    canvasZoom: canvasZoom,
                    onTap: () {
                      ref.read(selectedWidgetIdProvider.notifier).state =
                          widgetData.id;
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
