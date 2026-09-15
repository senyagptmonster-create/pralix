import 'package:flutter/material.dart';
import 'tabs/project_history_tab.dart';
import 'tabs/scale_ratio_tab.dart';
import 'tabs/scales_library_tab.dart';
import 'theme/pralix_theme.dart';

class PralixApp extends StatelessWidget {
  const PralixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pralix Scale Converter',
      debugShowCheckedModeBanner: false,
      theme: PralixTheme.themeData,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pralix Blueprint Scale'),
            bottom: TabBar(
              indicatorColor: PralixTheme.cyan,
              labelColor: PralixTheme.cyan,
              unselectedLabelColor: PralixTheme.textSecondary,
              tabs: [
                Tab(icon: Icon(Icons.straighten_rounded), text: 'Converter'),
                Tab(icon: Icon(Icons.menu_book_rounded), text: 'Scale Standards'),
                Tab(icon: Icon(Icons.history_rounded), text: 'Calculations'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ScaleRatioTab(),
              ScalesLibraryTab(),
              ProjectHistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
