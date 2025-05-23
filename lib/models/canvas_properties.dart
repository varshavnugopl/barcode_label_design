
import 'package:flutter/material.dart'; 
import 'package:json_annotation/json_annotation.dart';

part 'canvas_properties.g.dart'; 


enum CanvasOrientation { portrait, landscape }

enum CanvasUnit { mm, inches }

@JsonSerializable() 
class CanvasProperties {
  double width; // in units
  double height; // in units
  CanvasOrientation orientation;
  CanvasUnit units;
  @JsonKey(
      fromJson: _colorFromJson,
      toJson: _colorToJson) 
  Color? backgroundColor;

  CanvasProperties({
    required this.width,
    required this.height,
    this.orientation = CanvasOrientation.portrait,
    this.units = CanvasUnit.inches,
    this.backgroundColor = Colors.white,
  });

  factory CanvasProperties.fromJson(Map<String, dynamic> json) =>
      _$CanvasPropertiesFromJson(json); 
  Map<String, dynamic> toJson() =>
      _$CanvasPropertiesToJson(this); 

 
  CanvasProperties copyWith({
    double? width,
    double? height,
    CanvasOrientation? orientation,
    CanvasUnit? units,
    Color? backgroundColor,
  }) {
    return CanvasProperties(
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      units: units ?? this.units,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  // Helper to get pixel dimensions (this was in the previous solution)
  Size getPixelDimensions(double dpi) {
    double w = units == CanvasUnit.mm ? width / 25.4 * dpi : width * dpi;
    double h = units == CanvasUnit.mm ? height / 25.4 * dpi : height * dpi;
    return orientation == CanvasOrientation.portrait ? Size(w, h) : Size(h, w);
  }
}


Color? _colorFromJson(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;
  final buffer = StringBuffer();
  if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
  buffer.write(hexColor.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String? _colorToJson(Color? color) {
  return color == null
      ? null
      : '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}
