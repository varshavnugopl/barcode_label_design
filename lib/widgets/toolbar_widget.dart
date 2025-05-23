import 'package:barcode_designer/models/widget_data.dart';
import 'package:barcode_designer/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolbarWidget extends ConsumerWidget {
  const ToolbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 60,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _ToolbarButton(
            icon: Icons.text_fields,
            tooltip: "Add Text",
            onPressed: () => ref
                .read(currentTemplateProvider.notifier)
                .addWidget(WidgetType.text),
          ),
          _ToolbarButton(
            icon: Icons.qr_code_scanner,
            tooltip: "Add Barcode",
            onPressed: () => ref
                .read(currentTemplateProvider.notifier)
                .addWidget(WidgetType.barcode),
          ),
          _ToolbarButton(
            icon: Icons.crop_square,
            tooltip: "Add Shape",
            onPressed: () => ref
                .read(currentTemplateProvider.notifier)
                .addWidget(WidgetType.shape),
          ),
          _ToolbarButton(
              icon: Icons.image,
              tooltip: "Add Image (Not Implemented)",
              onPressed: () {
                // ref.read(currentTemplateProvider.notifier).addWidget(WidgetType.image)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Image widget not fully implemented yet.")),
                );
              }),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
