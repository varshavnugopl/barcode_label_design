import 'package:barcode_designer/models/canvas_properties.dart';

const double defaultDPI = 96.0;

double convertToPixels(double value, CanvasUnit unit,
    {double dpi = defaultDPI}) {
  if (unit == CanvasUnit.mm) {
    return (value / 25.4) * dpi;
  } else {
    return value * dpi;
  }
}

double convertFromPixels(double pixelValue, CanvasUnit unit,
    {double dpi = defaultDPI}) {
  if (unit == CanvasUnit.mm) {
    return (pixelValue / dpi) * 25.4;
  } else {
    return pixelValue / dpi;
  }
}
