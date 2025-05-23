
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw; 
part 'widget_data.g.dart'; 

enum WidgetType { text, barcode, shape, image }
enum BarcodeInternalType {
  code128,
  qr,
  ean13,
}
enum ShapeInternalType { rectangle, circle, line }

// Helper to convert BarcodeInternalType to barcode_widget.Barcode
bw.Barcode mapBarcodeInternalType(BarcodeInternalType type) {
  switch (type) {
    case BarcodeInternalType.code128:
      return bw.Barcode.code128();
    case BarcodeInternalType.qr:
      return bw.Barcode.qrCode();
    case BarcodeInternalType.ean13:
      return bw.Barcode.ean13();
    default:
      return bw.Barcode.code128(); 
  }
}

@JsonSerializable(explicitToJson: true)
class WidgetPosition {
  double x;
  double y;

  WidgetPosition({required this.x, required this.y});

  factory WidgetPosition.fromJson(Map<String, dynamic> json) =>
      _$WidgetPositionFromJson(json);
  Map<String, dynamic> toJson() => _$WidgetPositionToJson(this);

  WidgetPosition copyWith({double? x, double? y}) {
    return WidgetPosition(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

@JsonSerializable(explicitToJson: true, disallowUnrecognizedKeys: false)
class WidgetProperties {
  // Text
  String? content;
  String? fontFamily;
  double? fontSize;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color? fontColor;
  String? alignment; // "left", "center", "right"

  // Barcode
  BarcodeInternalType? barcodeType;
  String? barcodeData;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color? foregroundColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color? barcodeBackgroundColor; // Different from widget background

  // Shape
  ShapeInternalType? shapeType;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color? strokeColor;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color? fillColor;
  double? strokeWidth;

  // Image
  String? imagePath; 

  WidgetProperties({
    this.content,
    this.fontFamily,
    this.fontSize,
    this.fontColor,
    this.alignment,
    this.barcodeType,
    this.barcodeData,
    this.foregroundColor,
    this.barcodeBackgroundColor,
    this.shapeType,
    this.strokeColor,
    this.fillColor,
    this.strokeWidth,
    this.imagePath,
  });

  factory WidgetProperties.fromJson(Map<String, dynamic> json) =>
      _$WidgetPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$WidgetPropertiesToJson(this);

  WidgetProperties copyWith({
    String? content,
    String? fontFamily,
    double? fontSize,
    Color? fontColor,
    String? alignment,
    BarcodeInternalType? barcodeType,
    String? barcodeData,
    Color? foregroundColor,
    Color? barcodeBackgroundColor,
    ShapeInternalType? shapeType,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    String? imagePath,
  }) {
    return WidgetProperties(
      content: content ?? this.content,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontColor: fontColor ?? this.fontColor,
      alignment: alignment ?? this.alignment,
      barcodeType: barcodeType ?? this.barcodeType,
      barcodeData: barcodeData ?? this.barcodeData,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      barcodeBackgroundColor: barcodeBackgroundColor ?? this.barcodeBackgroundColor,
      shapeType: shapeType ?? this.shapeType,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class WidgetData {
  String id;
  WidgetType type;
  WidgetPosition position;
  double width;
  double height;
  double rotation; // In degrees
  WidgetProperties properties;

  WidgetData({
    required this.id,
    required this.type,
    required this.position,
    required this.width,
    required this.height,
    this.rotation = 0.0,
    required this.properties,
  });

  factory WidgetData.fromJson(Map<String, dynamic> json) =>
      _$WidgetDataFromJson(json);
  Map<String, dynamic> toJson() => _$WidgetDataToJson(this);

  WidgetData copyWith({
    String? id,
    WidgetType? type,
    WidgetPosition? position,
    double? width,
    double? height,
    double? rotation,
    WidgetProperties? properties,
  }) {
    return WidgetData(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      properties: properties ?? this.properties,
    );
  }
}

// Helper for Color JSON serialization
Color? _colorFromJson(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;
  final buffer = StringBuffer();
  if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
  buffer.write(hexColor.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String? _colorToJson(Color? color) {
  return color == null ? null : '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}