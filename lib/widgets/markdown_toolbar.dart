import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MarkdownToolbar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const MarkdownToolbar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  void _wrapSelection(String before, String after) {
    final text = controller.text;
    final sel = controller.selection;
    final selected = sel.textInside(text);

    final newText = text.replaceRange(
      sel.start,
      sel.end,
      '$before$selected$after',
    );

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: sel.start + before.length + selected.length,
      ),
    );
    onChanged();
  }

  void _insertAtCursor(String insertion) {
    final text = controller.text;
    final sel = controller.selection;
    final pos = sel.baseOffset < 0 ? text.length : sel.baseOffset;

    // Vérifie si on est en début de ligne
    final prefix = pos > 0 && text[pos - 1] != '\n' ? '\n' : '';

    final newText = text.replaceRange(pos, pos, '$prefix$insertion');
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: pos + prefix.length + insertion.length,
      ),
    );
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A28) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              _ToolBtn(
                icon: Iconsax.text_bold,
                tooltip: 'Gras',
                onTap: () => _wrapSelection('**', '**'),
              ),
              _ToolBtn(
                icon: Iconsax.text_italic,
                tooltip: 'Italique',
                onTap: () => _wrapSelection('*', '*'),
              ),
              _ToolBtn(
                icon: Iconsax.text_underline,
                tooltip: 'Barré',
                onTap: () => _wrapSelection('~~', '~~'),
              ),
              _divider(),
              _ToolBtn(
                icon: Iconsax.hashtag,
                tooltip: 'Titre',
                onTap: () => _insertAtCursor('## '),
              ),
              _ToolBtn(
                icon: Iconsax.quote_up,
                tooltip: 'Citation',
                onTap: () => _insertAtCursor('> '),
              ),
              _ToolBtn(
                icon: Iconsax.code,
                tooltip: 'Code inline',
                onTap: () => _wrapSelection('`', '`'),
              ),
              _ToolBtn(
                icon: Iconsax.code_1,
                tooltip: 'Bloc de code',
                onTap: () => _wrapSelection('```\n', '\n```'),
              ),
              _divider(),
              _ToolBtn(
                icon: Iconsax.task_square,
                tooltip: 'Liste',
                onTap: () => _insertAtCursor('- '),
              ),
              _ToolBtn(
                icon: Iconsax.tick_square,
                tooltip: 'Checkbox',
                onTap: () => _insertAtCursor('- [ ] '),
              ),
              _ToolBtn(
                icon: Iconsax.link,
                tooltip: 'Lien',
                onTap: () => _wrapSelection('[', '](url)'),
              ),
              _ToolBtn(
                icon: Iconsax.image,
                tooltip: 'Image',
                onTap: () => _insertAtCursor('![alt](url)'),
              ),
              _ToolBtn(
                icon: Iconsax.minus,
                tooltip: 'Séparateur',
                onTap: () => _insertAtCursor('\n---\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.grey.withOpacity(0.3),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ToolBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }
}