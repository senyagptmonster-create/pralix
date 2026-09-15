import 'package:flutter/material.dart';
import '../theme/pralix_theme.dart';

class ProjectHistoryTab extends StatelessWidget {
  const ProjectHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {'name': 'Master Bedroom Suite Wall', 'plan': '142 mm', 'ratio': '1:50', 'real': '7.10 meters'},
      {'name': 'Staircase Riser Detail', 'plan': '85 mm', 'ratio': '1:20', 'real': '1.70 meters'},
      {'name': 'Lot Boundary Perimeter', 'plan': '220 mm', 'ratio': '1:200', 'real': '44.00 meters'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: history.length,
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final h = history[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PralixTheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: PralixTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text('${h['plan']!} @ ${h['ratio']!}', style: const TextStyle(fontSize: 12, color: PralixTheme.textSecondary)),
                ],
              ),
              Text(h['real']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: PralixTheme.cyan)),
            ],
          ),
        );
      },
    );
  }
}
