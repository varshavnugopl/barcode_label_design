import 'dart:convert';
import 'dart:io';
import 'package:barcode_designer/models/label_template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // For web platform check

class TemplateService {
  Future<LabelTemplate?> loadTemplate() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        if (kIsWeb) {
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            String jsonString = utf8.decode(bytes);
            Map<String, dynamic> jsonMap = jsonDecode(jsonString);
            return LabelTemplate.fromJson(jsonMap);
          }
        } else {
          // For mobile/desktop
          File file = File(result.files.single.path!);
          String jsonString = await file.readAsString();
          Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          return LabelTemplate.fromJson(jsonMap);
        }
      }
    } catch (e) {
      print("Error loading template: $e");
    }
    return null;
  }

  Future<bool> saveTemplate(LabelTemplate template) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${template.templateName.replaceAll(' ', '_')}.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (outputFile != null) {
        if (!outputFile.toLowerCase().endsWith('.json')) {
          outputFile += '.json';
        }

        String jsonString = jsonEncode(template.toJson());

        if (kIsWeb) {
          print("Web Save: Output path is $outputFile");
          print("Web Save Data: $jsonString");
          final file = File(outputFile);
        }
        if (kIsWeb) {
          await FilePicker.platform.saveFile(
            dialogTitle: 'Save Template As:',
            fileName: '${template.templateName.replaceAll(' ', '_')}.json',
            bytes: utf8.encode(jsonString),
          );
        } else {
          final file = File(outputFile);
          await file.writeAsString(jsonString);
        }
        return true;
      }
    } catch (e) {
      print("Error saving template: $e");
    }
    return false;
  }
}
