
import 'package:json_annotation/json_annotation.dart';
import 'canvas_properties.dart';
import 'widget_data.dart';

part 'label_template.g.dart';

@JsonSerializable(explicitToJson: true)
class LabelTemplate {
  String templateName;
  String version;
  CanvasProperties canvasProperties;
  List<WidgetData> widgets;

  LabelTemplate({
    required this.templateName,
    this.version = "1.0",
    required this.canvasProperties,
    required this.widgets,
  });

  factory LabelTemplate.fromJson(Map<String, dynamic> json) =>
      _$LabelTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$LabelTemplateToJson(this);

  LabelTemplate copyWith({
    String? templateName,
    String? version,
    CanvasProperties? canvasProperties,
    List<WidgetData>? widgets,
  }) {
    return LabelTemplate(
      templateName: templateName ?? this.templateName,
      version: version ?? this.version,
      canvasProperties: canvasProperties ?? this.canvasProperties,
      widgets: widgets ?? this.widgets,
    );
  }
}