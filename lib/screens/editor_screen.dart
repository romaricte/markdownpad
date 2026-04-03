import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/markdown_file.dart';
import '../providers/files_provider.dart';
import '../widgets/markdown_toolbar.dart';
import 'preview_screen.dart';

class EditorScreen extends StatefulWidget {
  final String fileId;

  const EditorScreen({super.key, required this.fileId});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _controller;
  late MarkdownFile _file;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<FilesProvider>();
    _file = provider.files.firstWhere((f) => f.id == widget.fileId);
    _controller = TextEditingController(text: _file.content);
  }

  @override
  void dispose() {
    _saveIfNeeded();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  void _saveIfNeeded() {
    if (_hasChanges) {
      _file.content = _controller.text;
      context.read<FilesProvider>().updateFile(_file);
      _hasChanges = false;
    }
  }

  void _openPreview() {
    _saveIfNeeded();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(file: _file),
      ),
    );
  }

  void _shareContent() {
    Share.share(_controller.text, subject: _file.title);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _saveIfNeeded();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _file.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_hasChanges)
                Text(
                  'Modifications non sauvegardées',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.export_1),
              tooltip: 'Partager',
              onPressed: _shareContent,
            ),
            IconButton(
              icon: const Icon(Iconsax.eye),
              tooltip: 'Aperçu',
              onPressed: _openPreview,
            ),
            if (_hasChanges)
              IconButton(
                icon: const Icon(Iconsax.tick_circle),
                tooltip: 'Sauvegarder',
                onPressed: () {
                  _saveIfNeeded();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sauvegardé ✓'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  setState(() {});
                },
              ),
            const SizedBox(width: 4),
          ],
        ),
        body: Column(
          children: [
            // Zone d'édition
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (_) => _onTextChanged(),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  height: 1.6,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  fillColor: Colors.transparent,
                  filled: true,
                ),
              ),
            ),

            // Toolbar markdown
            MarkdownToolbar(
              controller: _controller,
              onChanged: _onTextChanged,
            ),
          ],
        ),
      ),
    );
  }
}