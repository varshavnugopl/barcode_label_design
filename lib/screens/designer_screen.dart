import 'package:barcode_designer/providers/app_provider.dart';
import 'package:barcode_designer/services/template_services.dart';
import 'package:barcode_designer/widgets/canvas_widget.dart';
import 'package:barcode_designer/widgets/properties_panel.dart';
import 'package:barcode_designer/widgets/toolbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesignerScreen extends ConsumerWidget {
  const DesignerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templateService = TemplateService();

    return Scaffold(
      appBar: AppBar(
        title: Text(ref
            .watch(currentTemplateProvider.select((tpl) => tpl.templateName))),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: "Load Template",
            onPressed: () async {
              final template = await templateService.loadTemplate();
              if (template != null) {
                ref
                    .read(currentTemplateProvider.notifier)
                    .updateTemplate(template);
                ref.read(selectedWidgetIdProvider.notifier).state =
                    null; // Deselect on load
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Template "${template.templateName}" loaded.')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Save Template",
            onPressed: () async {
              final currentTemplate = ref.read(currentTemplateProvider);
              final success =
                  await templateService.saveTemplate(currentTemplate);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(success
                        ? 'Template saved!'
                        : 'Failed to save template.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "New Template",
            onPressed: () {
              ref.read(currentTemplateProvider.notifier).updateTemplate(ref
                  .read(currentTemplateProvider.notifier)
                  .state
                  .copyWith(templateName: "Untitled Label", widgets: []));
              ref.read(selectedWidgetIdProvider.notifier).state = null;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New blank template created.')),
              );
            },
          ),
          PopupMenuButton<double>(
            icon: const Icon(Icons.zoom_in),
            tooltip: "Zoom",
            onSelected: (double zoomValue) {
              ref.read(canvasZoomProvider.notifier).state = zoomValue;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
              const PopupMenuItem<double>(value: 0.5, child: Text('50%')),
              const PopupMenuItem<double>(value: 0.75, child: Text('75%')),
              const PopupMenuItem<double>(value: 1.0, child: Text('100%')),
              const PopupMenuItem<double>(value: 1.5, child: Text('150%')),
              const PopupMenuItem<double>(value: 2.0, child: Text('200%')),
            ],
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          ToolbarWidget(),
          CanvasWidget(),
          PropertiesPanel(),
        ],
      ),
    );
  }
}
