import 'package:flutter/material.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The root widget of the FlutterForge application.
///
/// Sets up theme, routing, and global providers.
class FlutterForgeApp extends ConsumerWidget {
  const FlutterForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'FlutterForge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Workbench(),
    );
  }
}
