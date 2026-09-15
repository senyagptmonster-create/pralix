import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/scale_calculator.dart';
import '../../data/pralix_repository.dart';

class ScaleRatioPage extends StatefulWidget {
  const ScaleRatioPage({super.key});

  @override
  State<ScaleRatioPage> createState() => _ScaleRatioPageState();
}

class _ScaleRatioPageState extends State<ScaleRatioPage> {
  final TextEditingController _inputCtrl = TextEditingController(text: '4.50');
  final TextEditingController _projectCtrl = TextEditingController(text: 'Residential Plan');
  final TextEditingController _notesCtrl = TextEditingController();

  String _selectedScale = '1:50';
  bool _isRealToDrawing = true; // true: Real Meters -> Drawing mm, false: Drawing mm -> Real Meters

  double get _currentRatioValue {
    final match = ScaleCalculator.standardScales.firstWhere(
      (s) => s.label == _selectedScale,
      orElse: () => ScaleCalculator.standardScales[4], // 1:50
    );
    return match.ratioValue;
  }

  double get _calculatedOutput {
    final val = double.tryParse(_inputCtrl.text) ?? 0.0;
    if (_isRealToDrawing) {
      return ScaleCalculator.realMetersToDrawingMm(val, _currentRatioValue);
    } else {
      return ScaleCalculator.drawingMmToRealMeters(val, _currentRatioValue);
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _projectCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PralixRepository>(context);
    final output = _calculatedOutput;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale Ratio Converter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF141F30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF223854)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isRealToDrawing = true),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isRealToDrawing
                              ? const Color(0xFF00E5FF).withAlpha(35)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isRealToDrawing
                                ? const Color(0xFF00E5FF)
                                : Colors.transparent,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Real (m) → Drawing (mm)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isRealToDrawing
                                ? const Color(0xFF00E5FF)
                                : const Color(0xFF8FA8C4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _isRealToDrawing = false),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isRealToDrawing
                              ? const Color(0xFF00E5FF).withAlpha(35)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: !_isRealToDrawing
                                ? const Color(0xFF00E5FF)
                                : Colors.transparent,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Drawing (mm) → Real (m)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: !_isRealToDrawing
                                ? const Color(0xFF00E5FF)
                                : const Color(0xFF8FA8C4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Scale selector row
            const Text(
              'Select Architectural Ratio',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8FA8C4),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ScaleCalculator.standardScales.map((s) {
                  final isSelected = _selectedScale == s.label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s.label),
                      selected: isSelected,
                      selectedColor: const Color(0xFF00E5FF).withAlpha(45),
                      backgroundColor: const Color(0xFF141F30),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFF8FA8C4),
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF00E5FF)
                            : const Color(0xFF223854),
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedScale = s.label);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Input field
            Card(
              color: const Color(0xFF141F30),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRealToDrawing
                          ? 'Real-World Dimension (Meters)'
                          : 'Drawing Measurement (Millimeters)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8FA8C4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _inputCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF0F6FC),
                      ),
                      decoration: InputDecoration(
                        suffixText: _isRealToDrawing ? 'meters (m)' : 'mm',
                        suffixStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8FA8C4),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calculation Result Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF10283E),
                    Color(0xFF141F30),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00E5FF).withAlpha(120)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isRealToDrawing ? 'DRAWING SHEET DIMENSION' : 'REAL WORLD SPAN',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _selectedScale,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        output.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFF0F6FC),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isRealToDrawing ? 'mm' : 'meters',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8FA8C4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isRealToDrawing
                        ? 'Equivalent to ${(output / 10).toStringAsFixed(2)} cm on paper'
                        : 'Equivalent to ${(output * 1000).toStringAsFixed(0)} mm in physical space',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8FA8C4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Save to project card
            Card(
              color: const Color(0xFF141F30),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Store to Calculation Log',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF0F6FC),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _projectCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Project Tag (e.g. Master Bedroom)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Structural note or grid reference',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final realM = _isRealToDrawing
                              ? (double.tryParse(_inputCtrl.text) ?? 0.0)
                              : output;
                          final drawingMm = _isRealToDrawing
                              ? output
                              : (double.tryParse(_inputCtrl.text) ?? 0.0);

                          repo.saveCalculation(
                            projectName: _projectCtrl.text,
                            scaleRatioLabel: _selectedScale,
                            realMeters: realM,
                            drawingMm: drawingMm,
                            calculationType: 'Linear Span',
                            notes: _notesCtrl.text.trim(),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calculation added to project history.'),
                              backgroundColor: Color(0xFF1D2C42),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                        label: const Text('Record Dimension to Project'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
