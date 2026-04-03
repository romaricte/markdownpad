import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/markdown_file.dart';
import '../services/file_service.dart';

class FilesProvider extends ChangeNotifier {
  final FileService _fileService = FileService();
  final Uuid _uuid = const Uuid();

  List<MarkdownFile> _files = [];
  bool _isLoading = true;

  List<MarkdownFile> get files => _files;
  bool get isLoading => _isLoading;

  // ──────────── INIT ────────────

  Future<void> loadFiles() async {
    _isLoading = true;
    notifyListeners();

    _files = await _fileService.loadAllFiles();

    _isLoading = false;
    notifyListeners();
  }

  // ──────────── CREATE ────────────

  MarkdownFile createNewFile({String title = 'Sans titre'}) {
    final file = MarkdownFile(
      id: _uuid.v4(),
      title: title,
      content: '# $title\n\nCommencez à écrire ici…',
    );
    _files.insert(0, file);
    _save();
    notifyListeners();
    return file;
  }

  // ──────────── UPDATE ────────────

  void updateFile(MarkdownFile file) {
    final index = _files.indexWhere((f) => f.id == file.id);
    if (index != -1) {
      file.updatedAt = DateTime.now();
      _files[index] = file;
      _files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      _save();
      notifyListeners();
    }
  }

  // ──────────── DELETE ────────────

  void deleteFile(String id) {
    _files.removeWhere((f) => f.id == id);
    _save();
    notifyListeners();
  }

  // ──────────── IMPORT ────────────

  Future<MarkdownFile?> importFile() async {
    final file = await _fileService.importFile();
    if (file != null) {
      _files.insert(0, file);
      _save();
      notifyListeners();
    }
    return file;
  }

  // ──────────── RENAME ────────────

  void renameFile(String id, String newTitle) {
    final index = _files.indexWhere((f) => f.id == id);
    if (index != -1) {
      _files[index].title = newTitle;
      _files[index].updatedAt = DateTime.now();
      _save();
      notifyListeners();
    }
  }

  // ──────────── PRIVATE ────────────

  Future<void> _save() async {
    await _fileService.saveAllFiles(_files);
  }
}
