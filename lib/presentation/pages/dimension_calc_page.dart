import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/scale_calculator.dart';
import '../../data/pralix_repository.dart';

class DimensionCalcPage extends StatefulWidget {
  const DimensionCalcPage({super.key});

  @override
  State<DimensionCalcPage> createState() => _DimensionCalcPageState();
}

class _DimensionCalcPageState extends State<DimensionCalcPage> {
  final TextEditingController _lengthCtrl = TextEditingController(text: '6.0');
  final TextEditingController _widthCtrl = TextEditingController(text: '4.0');
  final TextEditingController _heightCtrl = TextEditingController(text: '2.8');

  String _selectedScale = '1:50';

  double get _ratioValue {
    final s = ScaleCalculator.standardScales.firstWhere(
      (item) => item.label == _selectedScale,
      orElse: () => ScaleCalculator.standardScales[4],
    );
    return s.ratioValue;
  }

  @override
  void dispose() {
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PralixRepository>(context);

    final lengthM = double.tryParse(_lengthCtrl.text) ?? 0.0;
    final widthM = double.tryParse(_widthCtrl.text) ?? 0.0;
    final heightM = double.tryParse(_heightCtrl.text) ?? 0.0;

    final lengthMm = ScaleCalculator.realMetersToDrawingMm(lengthM, _ratioValue);
    final widthMm = ScaleCalculator.realMetersToDrawingMm(widthM, _ratioValue);
    final heightMm = ScaleCalculator.realMetersToDrawingMm(heightM, _ratioValue);

    final realAreaM2 = lengthM * widthM;
    final drawingAreaCm2 = ScaleCalculator.realAreaToDrawingCm2(realAreaM2, _ratioValue);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spatial Dimension Engine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Scale Selector
            Card(
              color: const Color(0xFF141F30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Drawing Scale Ratio',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8FA8C4),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedScale,
                      dropdownColor: const Color(0xFF1D2C42),
                      underline: const SizedBox(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00E5FF),
                      ),
                      items: ScaleCalculator.standardScales.map((s) {
                        return DropdownMenuItem(value: s.label, child: Text(s.label));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedScale = v);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Inputs for 3D room/element dimensions
            const Text(
              'Real-World Measurements (Meters)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F6FC),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _dimInputField(
                    label: 'Length (L)',
                    controller: _lengthCtrl,
                    onChanged: () => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dimInputField(
                    label: 'Width (W)',
                    controller: _widthCtrl,
                    onChanged: () => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dimInputField(
                    label: 'Height (H)',
                    controller: _heightCtrl,
                    onChanged: () => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sheet Drawing Measurements Table
            const Text(
              'Drawing Plan & Section Equivalents',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F6FC),
              ),
            ),
            const SizedBox(height: 10),

            Card(
              color: const Color(0xFF141F30),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _sheetDimRow('Drawing Length', '${lengthMm.toStringAsFixed(1)} mm', '${(lengthMm / 10).toStringAsFixed(1)} cm on paper'),
                    const Divider(color: Color(0xFF223854)),
                    _sheetDimRow('Drawing Width', '${widthMm.toStringAsFixed(1)} mm', '${(widthMm / 10).toStringAsFixed(1)} cm on paper'),
                    const Divider(color: Color(0xFF223854)),
                    _sheetDimRow('Drawing Height (Section)', '${heightMm.toStringAsFixed(1)} mm', '${(heightMm / 10).toStringAsFixed(1)} cm on paper'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Area Comparison Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10283E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF223854)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REAL FLOOR AREA',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8FA8C4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${realAreaM2.toStringAsFixed(2)} m²',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                        Text(
                          '${(realAreaM2 * 10.7639).toStringAsFixed(1)} sq ft',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF8FA8C4)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: const Color(0xFF223854),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PAPER DRAWING AREA',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8FA8C4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${drawingAreaCm2.toStringAsFixed(1)} cm²',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF0F6FC),
                          ),
                        ),
                        Text(
                          'At $_selectedScale projection',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF8FA8C4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action to save area calculation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  repo.saveCalculation(
                    projectName: 'Room Area (${lengthM}m x ${widthM}m)',
                    scaleRatioLabel: _selectedScale,
                    realMeters: realAreaM2,
                    drawingMm: drawingAreaCm2,
                    calculationType: 'Spatial Footprint',
                    notes: 'Floor area: ${realAreaM2.toStringAsFixed(1)} m²',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Spatial footprint logged.'),
                      backgroundColor: Color(0xFF1D2C42),
                    ),
                  );
                },
                icon: const Icon(Icons.layers_outlined, size: 18),
                label: const Text('Log Spatial Footprint'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dimInputField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8FA8C4)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _sheetDimRow(String title, String mainVal, String subVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFFF0F6FC)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mainVal,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E5FF),
                ),
              ),
              Text(
                subVal,
                style: const TextStyle(fontSize: 10, color: Color(0xFF8FA8C4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
