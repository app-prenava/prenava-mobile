import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/bidan_profile.dart';
import '../providers/appointment_providers.dart';

class BidanSelectionPage extends ConsumerStatefulWidget {
  const BidanSelectionPage({super.key});

  @override
  ConsumerState<BidanSelectionPage> createState() => _BidanSelectionPageState();
}

class _BidanSelectionPageState extends ConsumerState<BidanSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Bidan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFA6978)),
            )
          : state.bidans.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada dokter / bidan tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.bidans.length,
                  itemBuilder: (context, index) {
                    final bidan = state.bidans[index];
                    return _buildBidanCard(bidan);
                  },
                ),
    );
  }

  Widget _buildBidanCard(BidanProfile bidan) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFA6978).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.medical_services,
                    color: Color(0xFFFA6978),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bidan.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      if (bidan.specialization != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          bidan.specialization!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFA6978),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bidan.address,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            if (bidan.averageRating != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    bidan.averageRating!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bidan.totalReviews != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${bidan.totalReviews} ulasan)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(appointmentNotifierProvider.notifier)
                      .selectBidan(bidan);
                  context.push('/appointments/create/consent');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pilih Bidan Ini',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
