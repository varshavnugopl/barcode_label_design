// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelTemplate _$LabelTemplateFromJson(Map<String, dynamic> json) =>
    LabelTemplate(
      templateName: json['templateName'] as String,
      version: json['version'] as String? ?? "1.0",
      canvasProperties: CanvasProperties.fromJson(
          json['canvasProperties'] as Map<String, dynamic>),
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => WidgetData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LabelTemplateToJson(LabelTemplate instance) =>
    <String, dynamic>{
      'templateName': instance.templateName,
      'version': instance.version,
      'canvasProperties': instance.canvasProperties.toJson(),
      'widgets': instance.widgets.map((e) => e.toJson()).toList(),
    };
