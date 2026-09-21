import 'package:flutter/material.dart';
import '../painters/blueprint_scale_painter.dart';
import '../theme/pralix_theme.dart';

class ScaleRatioTab extends StatefulWidget {
  const ScaleRatioTab({super.key});

  @override
  State<ScaleRatioTab> createState() => _ScaleRatioTabState();
}

class _ScaleRatioTabState extends State<ScaleRatioTab> {
  int _selectedRatio = 50; // 1:50
  double _drawingMm = 120.0;

  final List<int> _ratios = const [20, 50, 100, 200, 500];

  @override
  Widget build(BuildContext context) {
    final realMeters = (_drawingMm * _selectedRatio) / 1000.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Blueprint Scale Canvas
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: BlueprintScalePainter(ratioDenom: _selectedRatio),
            ),
          ),
          const SizedBox(height: 16),

          // Scale Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _ratios.map((r) {
                final isSelected = _selectedRatio == r;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('1:$r'),
                    selected: isSelected,
                    selectedColor: PralixTheme.cyan,
                    backgroundColor: PralixTheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : PralixTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedRatio = r);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Converter Calculation Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PralixTheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Drawing Measurement:', style: TextStyle(color: PralixTheme.textSecondary)),
                    Text('${_drawingMm.toStringAsFixed(0)} mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: PralixTheme.sky)),
                  ],
                ),
                Slider(
                  value: _drawingMm,
                  min: 5.0,
                  max: 500.0,
                  divisions: 99,
                  activeColor: PralixTheme.cyan,
                  inactiveColor: Colors.white12,
                  onChanged: (val) => setState(() => _drawingMm = val),
                ),
                const Divider(color: Colors.white10, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Actual Real-World Length:', style: TextStyle(color: PralixTheme.textSecondary)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${realMeters.toStringAsFixed(2)} meters',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: PralixTheme.cyan),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
