// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WidgetPosition _$WidgetPositionFromJson(Map<String, dynamic> json) =>
    WidgetPosition(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$WidgetPositionToJson(WidgetPosition instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

WidgetProperties _$WidgetPropertiesFromJson(Map<String, dynamic> json) =>
    WidgetProperties(
      content: json['content'] as String?,
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontColor: _colorFromJson(json['fontColor'] as String?),
      alignment: json['alignment'] as String?,
      barcodeType: $enumDecodeNullable(
          _$BarcodeInternalTypeEnumMap, json['barcodeType']),
      barcodeData: json['barcodeData'] as String?,
      foregroundColor: _colorFromJson(json['foregroundColor'] as String?),
      barcodeBackgroundColor:
          _colorFromJson(json['barcodeBackgroundColor'] as String?),
      shapeType:
          $enumDecodeNullable(_$ShapeInternalTypeEnumMap, json['shapeType']),
      strokeColor: _colorFromJson(json['strokeColor'] as String?),
      fillColor: _colorFromJson(json['fillColor'] as String?),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$WidgetPropertiesToJson(WidgetProperties instance) =>
    <String, dynamic>{
      'content': instance.content,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'fontColor': _colorToJson(instance.fontColor),
      'alignment': instance.alignment,
      'barcodeType': _$BarcodeInternalTypeEnumMap[instance.barcodeType],
      'barcodeData': instance.barcodeData,
      'foregroundColor': _colorToJson(instance.foregroundColor),
      'barcodeBackgroundColor': _colorToJson(instance.barcodeBackgroundColor),
      'shapeType': _$ShapeInternalTypeEnumMap[instance.shapeType],
      'strokeColor': _colorToJson(instance.strokeColor),
      'fillColor': _colorToJson(instance.fillColor),
      'strokeWidth': instance.strokeWidth,
      'imagePath': instance.imagePath,
    };

const _$BarcodeInternalTypeEnumMap = {
  BarcodeInternalType.code128: 'code128',
  BarcodeInternalType.qr: 'qr',
  BarcodeInternalType.ean13: 'ean13',
};

const _$ShapeInternalTypeEnumMap = {
  ShapeInternalType.rectangle: 'rectangle',
  ShapeInternalType.circle: 'circle',
  ShapeInternalType.line: 'line',
};

WidgetData _$WidgetDataFromJson(Map<String, dynamic> json) => WidgetData(
      id: json['id'] as String,
      type: $enumDecode(_$WidgetTypeEnumMap, json['type']),
      position:
          WidgetPosition.fromJson(json['position'] as Map<String, dynamic>),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      properties:
          WidgetProperties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WidgetDataToJson(WidgetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WidgetTypeEnumMap[instance.type]!,
      'position': instance.position.toJson(),
      'width': instance.width,
      'height': instance.height,
      'rotation': instance.rotation,
      'properties': instance.properties.toJson(),
    };

const _$WidgetTypeEnumMap = {
  WidgetType.text: 'text',
  WidgetType.barcode: 'barcode',
  WidgetType.shape: 'shape',
  WidgetType.image: 'image',
};
