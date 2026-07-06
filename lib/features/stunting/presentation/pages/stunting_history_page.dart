import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

class StuntingHistoryPage extends ConsumerStatefulWidget {
  const StuntingHistoryPage({super.key});

  @override
  ConsumerState<StuntingHistoryPage> createState() => _StuntingHistoryPageState();
}

class _StuntingHistoryPageState extends ConsumerState<StuntingHistoryPage> {
  List<StuntingHistoryItem> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() async {
    try {
      final dataSource = ref.read(stuntingRepositoryProvider);
      final history = await dataSource.getHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Anda'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Skrining', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat skrining.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                
                // Determine color and label based on risk level
                // Assuming 1 = Tinggi, 2 = Sedang, 0/others = Rendah
                Color riskColor = Colors.green;
                String riskText = "Risiko Rendah";
                IconData riskIcon = Icons.check_circle;
                
                if (item.riskLevel == 1) {
                  riskColor = Colors.red;
                  riskText = "Risiko Tinggi";
                  riskIcon = Icons.warning;
                } else if (item.riskLevel == 2) {
                  riskColor = Colors.orange;
                  riskText = "Risiko Sedang";
                  riskIcon = Icons.info;
                }

                return InkWell(
                  onTap: () {
                    context.push('/stunting/history/detail/${item.id}');
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: riskColor.withOpacity(0.3), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(riskIcon, color: riskColor, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    riskText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: riskColor,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.date.split('T').first,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Skor Probabilitas:',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              Text(
                                '${(item.score * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/stunting/screening');
        },
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Skrining Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
