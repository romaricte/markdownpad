import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../providers/files_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/file_tile.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FilesProvider>().loadFiles();
    });
  }

  void _createNewFile() {
    final provider = context.read<FilesProvider>();
    final file = provider.createNewFile();
    _openEditor(file.id);
  }

  Future<void> _importFile() async {
    final provider = context.read<FilesProvider>();
    final file = await provider.importFile();
    if (file != null && mounted) {
      _openEditor(file.id);
    }
  }

  void _openEditor(String fileId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(fileId: fileId),
      ),
    );
  }

  void _showRenameDialog(String fileId, String currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Renommer'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nom du document',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<FilesProvider>()
                    .renameFile(fileId, controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Renommer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String fileId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer'),
        content: Text('Supprimer « $title » ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              context.read<FilesProvider>().deleteFile(fileId);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MarkdownPad',
          style: theme.textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.import_1),
            tooltip: 'Importer',
            onPressed: _importFile,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<FilesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.files.isEmpty) {
            return EmptyState(
              onCreateNew: _createNewFile,
              onImport: _importFile,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: provider.files.length,
            itemBuilder: (context, index) {
              final file = provider.files[index];
              return FileTile(
                file: file,
                onTap: () => _openEditor(file.id),
                onRename: () => _showRenameDialog(file.id, file.title),
                onDelete: () => _showDeleteDialog(file.id, file.title),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<FilesProvider>(
        builder: (context, provider, _) {
          if (provider.files.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: _createNewFile,
            child: const Icon(Iconsax.add),
          );
        },
      ),
    );
  }
}