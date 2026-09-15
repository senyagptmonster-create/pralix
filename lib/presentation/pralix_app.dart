import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/pralix_repository.dart';
import 'pages/scale_ratio_page.dart';
import 'pages/dimension_calc_page.dart';
import 'pages/scales_library_page.dart';
import 'pages/project_history_page.dart';

class PralixApp extends StatelessWidget {
  const PralixApp({super.key});

  static ThemeData get blueprintTheme {
    const bg = Color(0xFF0A101A);
    const surface = Color(0xFF131D2E);
    const elevated = Color(0xFF1C2B40);
    const cyanAccent = Color(0xFF00E5FF);
    const border = Color(0xFF223854);
    const textLight = Color(0xFFF0F6FC);
    const textMuted = Color(0xFF8FA8C4);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: cyanAccent,
      colorScheme: const ColorScheme.dark(
        primary: cyanAccent,
        secondary: Color(0xFF38BDF8),
        surface: surface,
        onPrimary: bg,
        onSecondary: bg,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: cyanAccent),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: cyanAccent.withAlpha(40),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cyanAccent,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: cyanAccent);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cyanAccent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: Color(0xFF5A728E), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cyanAccent,
          foregroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PralixRepository()..initialize(),
      child: MaterialApp(
        title: 'Pralix Architectural Scales',
        debugShowCheckedModeBanner: false,
        theme: blueprintTheme,
        home: const _PralixShell(),
      ),
    );
  }
}

class _PralixShell extends StatefulWidget {
  const _PralixShell();

  @override
  State<_PralixShell> createState() => _PralixShellState();
}

class _PralixShellState extends State<_PralixShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ScaleRatioPage(),
    DimensionCalcPage(),
    ScalesLibraryPage(),
    ProjectHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.straighten_outlined),
            selectedIcon: Icon(Icons.straighten),
            label: 'Converter',
          ),
          NavigationDestination(
            icon: Icon(Icons.aspect_ratio_outlined),
            selectedIcon: Icon(Icons.aspect_ratio),
            label: 'Dimensions',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_open),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
