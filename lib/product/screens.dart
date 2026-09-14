import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';

class PralixDashboardScreen extends StatelessWidget {
  const PralixDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pralix Hub', style: AppTheme.display(cInk))),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(context, 'Scale Converter', const ScaleConverterScreen()),
          _buildCard(context, 'Dimension Calc', const DimensionCalcScreen()),
          _buildCard(context, 'Scales Library', const ScalesLibraryScreen()),
          _buildCard(context, 'Project History', const ProjectHistoryScreen()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        color: cSurface,
        child: Center(child: Text(title, style: AppTheme.text(cInk))),
      ),
    );
  }
}

class ScaleConverterScreen extends StatelessWidget {
  const ScaleConverterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Converter', style: AppTheme.display(cInk))),
      body: Center(child: Text('Ratio Converter', style: AppTheme.text(cInk))),
    );
  }
}

class DimensionCalcScreen extends StatelessWidget {
  const DimensionCalcScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator', style: AppTheme.display(cInk))),
      body: Center(child: Text('Dimension Calc', style: AppTheme.text(cInk))),
    );
  }
}

class ScalesLibraryScreen extends StatelessWidget {
  const ScalesLibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library', style: AppTheme.display(cInk))),
      body: Center(child: Text('Standard Scales Library', style: AppTheme.text(cInk))),
    );
  }
}

class ProjectHistoryScreen extends StatelessWidget {
  const ProjectHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History', style: AppTheme.display(cInk))),
      body: Center(child: Text('Project History', style: AppTheme.text(cInk))),
    );
  }
}
