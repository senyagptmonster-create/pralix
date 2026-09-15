import 'package:flutter/material.dart';
import '../theme/pralix_theme.dart';

class ScalesLibraryTab extends StatelessWidget {
  const ScalesLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scales = [
      {'ratio': '1:20 (Detail)', 'use': 'Cabinetry, stair details, window sections', 'mult': '1mm on plan = 20mm real'},
      {'ratio': '1:50 (Interior)', 'use': 'Floor plans, apartment layouts, elevations', 'mult': '1mm on plan = 50mm real'},
      {'ratio': '1:100 (Architecture)', 'use': 'General building elevations & site masterplans', 'mult': '1cm on plan = 1m real'},
      {'ratio': '1:200 (Site Layout)', 'use': 'Urban zoning, parking lots, terrain contours', 'mult': '1cm on plan = 2m real'},
      {'ratio': '1:500 (Civil)', 'use': 'Civil engineering & regional survey grids', 'mult': '1cm on plan = 5m real'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: scales.length,
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final s = scales[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PralixTheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s['ratio']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: PralixTheme.sky)),
                  Text(s['mult']!, style: const TextStyle(fontSize: 11, color: PralixTheme.amber, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Text(s['use']!, style: const TextStyle(fontSize: 12, color: PralixTheme.textSecondary)),
            ],
          ),
        );
      },
    );
  }
}
