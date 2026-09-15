import 'package:flutter/material.dart';
import '../../domain/scale_calculator.dart';

class SheetSizeInfo {
  final String format;
  final String dimensionsMm;
  final String commonPurpose;

  const SheetSizeInfo({
    required this.format,
    required this.dimensionsMm,
    required this.commonPurpose,
  });
}

class ScalesLibraryPage extends StatelessWidget {
  const ScalesLibraryPage({super.key});

  final List<SheetSizeInfo> _sheets = const [
    SheetSizeInfo(
      format: 'ISO A0',
      dimensionsMm: '841 × 1189 mm',
      commonPurpose: 'Master urban plans, complete set tender overview, large site plans.',
    ),
    SheetSizeInfo(
      format: 'ISO A1',
      dimensionsMm: '594 × 841 mm',
      commonPurpose: 'Standard architectural working drawings, elevations, sections.',
    ),
    SheetSizeInfo(
      format: 'ISO A2',
      dimensionsMm: '420 × 594 mm',
      commonPurpose: 'Intermediate construction details, small site layouts.',
    ),
    SheetSizeInfo(
      format: 'ISO A3',
      dimensionsMm: '297 × 420 mm',
      commonPurpose: 'Office review sets, presentation booklets, interior schedules.',
    ),
    SheetSizeInfo(
      format: 'ISO A4',
      dimensionsMm: '210 × 297 mm',
      commonPurpose: 'Specification sheets, calculation notes, detail callout packets.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scales & Drafting Standards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Architectural Scales Catalog
            const Text(
              'Architectural & Engineering Scale Reference',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F6FC),
              ),
            ),
            const SizedBox(height: 12),

            ...ScaleCalculator.standardScales.map((scale) {
              return Card(
                color: const Color(0xFF141F30),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00E5FF).withAlpha(60)),
                        ),
                        child: Text(
                          scale.label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  scale.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF38BDF8),
                                  ),
                                ),
                                Text(
                                  '1mm = ${(scale.ratioValue / 1000).toStringAsFixed(2)}m',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF8FA8C4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              scale.description,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF0F6FC),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              scale.typicalUse,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8FA8C4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Standard Sheet Sizes
            const Text(
              'ISO Standard Sheet Dimensions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F6FC),
              ),
            ),
            const SizedBox(height: 12),

            ..._sheets.map((sheet) {
              return Card(
                color: const Color(0xFF10283E),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141F30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Color(0xFF00E5FF),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${sheet.format} (${sheet.dimensionsMm})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF0F6FC),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      sheet.commonPurpose,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF8FA8C4)),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
