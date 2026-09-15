import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/pralix_repository.dart';

class ProjectHistoryPage extends StatelessWidget {
  const ProjectHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PralixRepository>(context);
    final history = repo.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculations History'),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Color(0xFF8FA8C4)),
              tooltip: 'Clear History',
              onPressed: () => _confirmClear(context, repo),
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.history_edu_outlined,
                    size: 48,
                    color: Color(0xFF8FA8C4),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No saved architectural calculations.',
                    style: TextStyle(color: Color(0xFF8FA8C4)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final item = history[i];
                final dateStr =
                    '${item.timestamp.year}-${item.timestamp.month.toString().padLeft(2, '0')}-${item.timestamp.day.toString().padLeft(2, '0')}';

                return Card(
                  color: const Color(0xFF141F30),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.projectName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF0F6FC),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.scaleRatioLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00E5FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Physical: ',
                              style: TextStyle(fontSize: 12, color: Color(0xFF8FA8C4)),
                            ),
                            Text(
                              '${item.realMeters.toStringAsFixed(2)} m',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF0F6FC),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Drawing: ',
                              style: TextStyle(fontSize: 12, color: Color(0xFF8FA8C4)),
                            ),
                            Text(
                              '${item.drawingMm.toStringAsFixed(1)} mm',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00E5FF),
                              ),
                            ),
                          ],
                        ),
                        if (item.notes.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.notes,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8FA8C4),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$dateStr • ${item.calculationType}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF5A728E),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Color(0xFF5A728E),
                              ),
                              onPressed: () => repo.deleteCalculation(item.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmClear(BuildContext context, PralixRepository repo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141F30),
        title: const Text('Clear All Calculations?'),
        content: const Text(
          'This will remove all recorded scale calculations permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF8FA8C4))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9480F),
            ),
            onPressed: () {
              repo.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
