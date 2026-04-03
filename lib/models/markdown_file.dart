class MarkdownFile {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;
  String? filePath; // null si fichier interne

  MarkdownFile({
    required this.id,
    required this.title,
    this.content = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.filePath,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Extrait un aperçu des premières lignes
  String get preview {
    final lines = content.split('\n').where((l) => l.trim().isNotEmpty);
    if (lines.isEmpty) return 'Document vide';
    // On retire le markdown brut pour l'aperçu
    final raw = lines.take(3).join(' ');
    final clean = raw.replaceAll(RegExp(r'[#*_`>\[\]\-!]'), '').trim();
    return clean.length > 120 ? '${clean.substring(0, 120)}…' : clean;
  }

  /// Nombre de mots
  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Formatage de la date
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';

    return '${updatedAt.day.toString().padLeft(2, '0')}/'
        '${updatedAt.month.toString().padLeft(2, '0')}/'
        '${updatedAt.year}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'filePath': filePath,
      };

  factory MarkdownFile.fromJson(Map<String, dynamic> json) {
    return MarkdownFile(
      id: json['id'],
      title: json['title'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      filePath: json['filePath'],
    );
  }
}