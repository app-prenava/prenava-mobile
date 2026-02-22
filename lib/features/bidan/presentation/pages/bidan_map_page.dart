import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/bidan_location.dart';
import '../providers/bidan_providers.dart';

class BidanMapPage extends ConsumerStatefulWidget {
  const BidanMapPage({super.key});

  @override
  ConsumerState<BidanMapPage> createState() => _BidanMapPageState();
}

class _BidanMapPageState extends ConsumerState<BidanMapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Map will be centered using initialCenter in MapOptions
    // No need to manually center with MapController
  }

  void _showBidanBottomSheet(BidanLocation bidan) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bidan.bidanName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bidan.addressLabel,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: bidan.phone,
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      }
                    },
                    child: Text(
                      bidan.phone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bidanLocationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Bidan'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(bidanLocationNotifierProvider.notifier).loadBidanLocations();
        },
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(bidanLocationNotifierProvider.notifier).loadBidanLocations();
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : state.bidanLocations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada lokasi bidan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: const LatLng(-2.5489, 118.0149),
                          initialZoom: 5.0,
                          minZoom: 4.0,
                          maxZoom: 18.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.prenava.mobile',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: state.bidanLocations
                                .map((location) => Marker(
                                      point: LatLng(location.latitude, location.longitude),
                                      width: 40,
                                      height: 40,
                                      child: GestureDetector(
                                        onTap: () => _showBidanBottomSheet(location),
                                        child: const Icon(
                                          Icons.location_on,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
