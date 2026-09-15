class ScaleRatio {
  final String label;
  final double ratioValue; // e.g. 50.0 for 1:50
  final String category;
  final String description;
  final String typicalUse;

  const ScaleRatio({
    required this.label,
    required this.ratioValue,
    required this.category,
    required this.description,
    required this.typicalUse,
  });
}

class ScaleCalculator {
  ScaleCalculator._();

  static const List<ScaleRatio> standardScales = [
    ScaleRatio(
      label: '1:1',
      ratioValue: 1.0,
      category: 'Full Scale',
      description: 'Full-size true reproduction.',
      typicalUse: 'Component prototyping, mockups, finish samples.',
    ),
    ScaleRatio(
      label: '1:5',
      ratioValue: 5.0,
      category: 'Detail',
      description: 'High-precision construction detail.',
      typicalUse: 'Joinery, custom millwork, glazing junction profiles.',
    ),
    ScaleRatio(
      label: '1:10',
      ratioValue: 10.0,
      category: 'Detail',
      description: 'Interior architecture assemblies.',
      typicalUse: 'Cabinetry, stair details, wall section callouts.',
    ),
    ScaleRatio(
      label: '1:20',
      ratioValue: 20.0,
      category: 'Interior',
      description: 'Room-scale interior elevations.',
      typicalUse: 'Bathroom layouts, kitchen elevations, structural bays.',
    ),
    ScaleRatio(
      label: '1:50',
      ratioValue: 50.0,
      category: 'Architectural',
      description: 'Standard detailed building plans.',
      typicalUse: 'Residential floor plans, primary building sections.',
    ),
    ScaleRatio(
      label: '1:100',
      ratioValue: 100.0,
      category: 'Architectural',
      description: 'General arrangement building layout.',
      typicalUse: 'Commercial floor plans, building elevations, roof plans.',
    ),
    ScaleRatio(
      label: '1:200',
      ratioValue: 200.0,
      category: 'Site / Planning',
      description: 'Complex building footprints & site context.',
      typicalUse: 'Multi-story massing, site layout, shadow studies.',
    ),
    ScaleRatio(
      label: '1:500',
      ratioValue: 500.0,
      category: 'Site / Planning',
      description: 'Campus and neighborhood site plans.',
      typicalUse: 'Urban context, landscape master planning, vehicular flow.',
    ),
    ScaleRatio(
      label: '1:1000',
      ratioValue: 1000.0,
      category: 'Civil / Urban',
      description: 'Topographical and zoning survey.',
      typicalUse: 'Topographical surveys, municipal district zoning.',
    ),
    ScaleRatio(
      label: '1:1250',
      ratioValue: 1250.0,
      category: 'Civil / Urban',
      description: 'Ordnance and legal boundary survey.',
      typicalUse: 'Statutory planning applications, legal boundary location.',
    ),
  ];

  /// Converts real-world meters to drawing millimeters.
  /// Example: 5.0 real meters at 1:50 -> 5000 mm / 50 = 100.0 mm.
  static double realMetersToDrawingMm(double realMeters, double ratioValue) {
    if (ratioValue <= 0) return 0.0;
    final realMm = realMeters * 1000.0;
    return realMm / ratioValue;
  }

  /// Converts drawing millimeters to real-world meters.
  /// Example: 100.0 drawing mm at 1:50 -> (100.0 * 50) / 1000 = 5.0 m.
  static double drawingMmToRealMeters(double drawingMm, double ratioValue) {
    if (ratioValue <= 0) return 0.0;
    final realMm = drawingMm * ratioValue;
    return realMm / 1000.0;
  }

  /// Converts real square meters to drawing square centimeters.
  /// 1 m² = 10,000 cm². At 1:50, linear factor is 1/50, area factor is 1/(50^2).
  static double realAreaToDrawingCm2(double realM2, double ratioValue) {
    if (ratioValue <= 0) return 0.0;
    final realCm2 = realM2 * 10000.0;
    return realCm2 / (ratioValue * ratioValue);
  }
}
