import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inspection_manifest.dart';

class InspectionStorageService {
  static const String _activeInspectionKey = 'soteria_active_inspection_id';

  Future<Directory> getInspectionDirectory(String inspectionId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final inspectionDir = Directory(p.join(appDir.path, 'inspections', inspectionId));
    if (!await inspectionDir.exists()) {
      await inspectionDir.create(recursive: true);
    }
    return inspectionDir;
  }

  Future<void> saveManifest(InspectionManifest manifest) async {
    try {
      final dir = await getInspectionDirectory(manifest.inspectionId);
      final manifestFile = File(p.join(dir.path, 'manifest.json'));
      final jsonStr = jsonEncode(manifest.toJson());
      await manifestFile.writeAsString(jsonStr);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeInspectionKey, manifest.inspectionId);
    } catch (e) {
      debugPrint('Error saving inspection manifest: $e');
    }
  }

  Future<InspectionManifest?> loadManifest(String inspectionId) async {
    try {
      final dir = await getInspectionDirectory(inspectionId);
      final manifestFile = File(p.join(dir.path, 'manifest.json'));
      if (await manifestFile.exists()) {
        final jsonStr = await manifestFile.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        return InspectionManifest.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading inspection manifest: $e');
    }
    return null;
  }

  Future<InspectionManifest?> loadActiveManifest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activeId = prefs.getString(_activeInspectionKey);
      if (activeId != null && activeId.isNotEmpty) {
        return await loadManifest(activeId);
      }
    } catch (e) {
      debugPrint('Error loading active manifest: $e');
    }
    return null;
  }

  Future<void> clearActiveInspection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeInspectionKey);
  }

  Future<String> calculateFileSha256(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final digest = sha256.convert(bytes);
        return digest.toString();
      }
    } catch (e) {
      debugPrint('Error computing SHA-256 for file $filePath: $e');
    }
    return '';
  }

  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
    } catch (e) {
      debugPrint('Error getting file size: $e');
    }
    return 0;
  }
}
