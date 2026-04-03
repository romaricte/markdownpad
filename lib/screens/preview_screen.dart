import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/markdown_file.dart';

class PreviewScreen extends StatelessWidget {
  final MarkdownFile file;

  const PreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          file.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_1),
            tooltip: 'Partager',
            onPressed: () => Share.share(file.content, subject: file.title),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Markdown(
        data: file.content,
        selectable: true,
        padding: const EdgeInsets.all(20),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
          }
        },
        styleSheet: MarkdownStyleSheet(
          // Titres
          h1: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
          h2: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
          h3: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
            height: 1.4,
          ),
          // Corps
          p: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
          // Code
          code: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
          ),
          codeblockDecoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          codeblockPadding: const EdgeInsets.all(16),
          // Citation
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.primary,
                width: 3,
              ),
            ),
          ),
          blockquotePadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          // Lien
          a: TextStyle(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          // Liste
          listBullet: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 16,
          ),
          // Séparateur
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ),
    );
  }
}