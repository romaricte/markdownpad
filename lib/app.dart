import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/files_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class MarkdownPadApp extends StatelessWidget {
  const MarkdownPadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilesProvider(),
      child: MaterialApp(
        title: 'MarkdownPad',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}