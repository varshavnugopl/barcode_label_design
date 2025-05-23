// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasProperties _$CanvasPropertiesFromJson(Map<String, dynamic> json) =>
    CanvasProperties(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      orientation: $enumDecodeNullable(
              _$CanvasOrientationEnumMap, json['orientation']) ??
          CanvasOrientation.portrait,
      units: $enumDecodeNullable(_$CanvasUnitEnumMap, json['units']) ??
          CanvasUnit.inches,
      backgroundColor: json['backgroundColor'] == null
          ? Colors.white
          : _colorFromJson(json['backgroundColor'] as String?),
    );

Map<String, dynamic> _$CanvasPropertiesToJson(CanvasProperties instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'orientation': _$CanvasOrientationEnumMap[instance.orientation]!,
      'units': _$CanvasUnitEnumMap[instance.units]!,
      'backgroundColor': _colorToJson(instance.backgroundColor),
    };

const _$CanvasOrientationEnumMap = {
  CanvasOrientation.portrait: 'portrait',
  CanvasOrientation.landscape: 'landscape',
};

const _$CanvasUnitEnumMap = {
  CanvasUnit.mm: 'mm',
  CanvasUnit.inches: 'inches',
};
