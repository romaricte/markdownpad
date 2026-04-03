import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/markdown_file.dart';

class FileService {
  static const String _metaFileName = 'files_meta.json';

  /// Répertoire de l'app
  Future<Directory> get _appDir async {
    final dir = await getApplicationDocumentsDirectory();
    final mdDir = Directory(p.join(dir.path, 'MarkdownPad'));
    if (!await mdDir.exists()) {
      await mdDir.create(recursive: true);
    }
    return mdDir;
  }

  /// Chemin du fichier de métadonnées
  Future<File> get _metaFile async {
    final dir = await _appDir;
    return File(p.join(dir.path, _metaFileName));
  }

  // ──────────── CRUD ────────────

  /// Charge tous les fichiers sauvegardés
  Future<List<MarkdownFile>> loadAllFiles() async {
    try {
      final file = await _metaFile;
      if (!await file.exists()) return [];

      final jsonStr = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonStr);
      final files = jsonList.map((j) => MarkdownFile.fromJson(j)).toList();

      // Trie par dernière modification
      files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return files;
    } catch (e) {
      return [];
    }
  }

  /// Sauvegarde la liste des fichiers
  Future<void> saveAllFiles(List<MarkdownFile> files) async {
    final file = await _metaFile;
    final jsonStr = json.encode(files.map((f) => f.toJson()).toList());
    await file.writeAsString(jsonStr);
  }

  /// Sauvegarde le contenu d'un fichier .md sur le disque
  Future<String> saveMarkdownContent(MarkdownFile mdFile) async {
    final dir = await _appDir;
    final safeName = mdFile.title.replaceAll(RegExp(r'[^\w\s\-]'), '');
    final filePath = p.join(dir.path, '${safeName}_${mdFile.id}.md');
    final file = File(filePath);
    await file.writeAsString(mdFile.content);
    return filePath;
  }

  // ──────────── IMPORT ────────────

  /// Importe un fichier .md depuis le système
  Future<MarkdownFile?> importFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md', 'markdown', 'txt'],
    );

    if (result == null || result.files.isEmpty) return null;

    final pickedFile = result.files.first;
    final file = File(pickedFile.path!);
    final content = await file.readAsString();
    final title = p.basenameWithoutExtension(pickedFile.name);

    return MarkdownFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      filePath: pickedFile.path,
    );
  }

  // ──────────── EXPORT ────────────

  /// Exporte en fichier .md et retourne le chemin
  Future<String> exportToFile(MarkdownFile mdFile) async {
    return saveMarkdownContent(mdFile);
  }
}