import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/audio/voice_recorder.dart';
import '../providers/maternal_rag_providers.dart';
import '../widgets/danger_catalog_bottom_sheet.dart';
import '../widgets/emergency_alert_banner.dart';
import '../../data/models/maternal_rag_model.dart';

class MaternalVoiceConsultationPage extends ConsumerStatefulWidget {
  const MaternalVoiceConsultationPage({super.key});

  @override
  ConsumerState<MaternalVoiceConsultationPage> createState() =>
      _MaternalVoiceConsultationPageState();
}

class _MaternalVoiceConsultationPageState
    extends ConsumerState<MaternalVoiceConsultationPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoiceRecorderService _recorder = VoiceRecorderService();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  final List<String> _quickPrompts = [
    'Berapa banyak tablet tambah darah (TTD) yang wajib diminum?',
    'Bagaimana tanda gerakan janin yang sehat dan aktif?',
    'Cara mengatasi mual muntah di pagi hari saat hamil muda',
    'Tolong bidan, keluar darah segar dari jalan lahir!',
    'Berapa kali jadwal periksa ANC dan USG ke dokter?',
  ];

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recorder.cancelRecording();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuestion(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    ref.read(maternalRagNotifierProvider.notifier).askText(text);
    _scrollToBottom();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopAndSubmitRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final success = await _recorder.startRecording();
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Izin mikrofon belum aktif atau tidak didukung di browser ini. Mohon izinkan akses mikrofon atau ketik pertanyaan Anda.',
          ),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });

    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _recordSeconds++;
      });
      if (_recordSeconds >= 60) {
        _stopAndSubmitRecording();
      }
    });
  }

  Future<void> _stopAndSubmitRecording() async {
    _recordTimer?.cancel();
    final bytes = await _recorder.stopRecording();
    if (!mounted) return;

    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });

    if (bytes == null || bytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rekaman suara kosong. Silakan coba kembali.'),
        ),
      );
      return;
    }

    final multipart = MultipartFile.fromBytes(
      bytes,
      filename: 'voice_note_${DateTime.now().millisecondsSinceEpoch}.webm',
    );

    ref.read(maternalRagNotifierProvider.notifier).askVoice(multipart);
    _scrollToBottom();
  }

  void _cancelRecording() {
    _recordTimer?.cancel();
    _recorder.cancelRecording();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  void _showDangerCatalog() {
    final state = ref.read(maternalRagNotifierProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DangerCatalogBottomSheet(
        catalog: state.dangerCatalog,
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maternalRagNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tanya Bidan AI (Buku KIA)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Standar Medis Kemenkes RI',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            tooltip: 'Katalog Tanda Bahaya KIA',
            onPressed: _showDangerCatalog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Banner Tanda Bahaya Aktif jika ada
            if (state.activeEmergency != null)
              EmergencyAlertBanner(
                consultation: state.activeEmergency!,
                onDismiss: () =>
                    ref.read(maternalRagNotifierProvider.notifier).dismissEmergency(),
              ),

            // Quick Question Chips
            Container(
              height: 48,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = _quickPrompts[index];
                  final isEmergencySample = prompt.contains('darah segar');
                  return ActionChip(
                    backgroundColor: isEmergencySample
                        ? const Color(0xFFFFEBEE)
                        : Colors.white,
                    side: BorderSide(
                      color: isEmergencySample
                          ? const Color(0xFFFFCDD2)
                          : const Color(0xFFE0E0E0),
                    ),
                    label: Text(
                      prompt,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEmergencySample
                            ? const Color(0xFFB71C1C)
                            : const Color(0xFF424242),
                        fontWeight: isEmergencySample
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onPressed: state.isLoading ? null : () => _sendQuestion(prompt),
                  );
                },
              ),
            ),

            // Message Stream Area
            Expanded(
              child: state.consultations.isEmpty && !state.isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: state.consultations.length,
                      itemBuilder: (context, index) {
                        final item = state.consultations[index];
                        return _buildConsultationCard(item);
                      },
                    ),
            ),

            // Loading indicator bar
            if (state.isLoading)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: const Color(0xFFFFF0F2),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFFA6978),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bidan AI sedang mencari rujukan resmi di Buku KIA...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFA6978),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Error Bar
            if (state.errorMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                color: const Color(0xFFFFEBEE),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Input Bar
            _isRecording ? _buildRecordingBar() : _buildInputBar(state.isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                size: 50,
                color: Color(0xFFFA6978),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Konsultasi Medis Buku KIA',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ajukan pertanyaan seputar nutrisi, jadwal pemeriksaan, dan keluhan kehamilan melalui suara atau teks. Bidan AI akan memberikan rujukan resmi dari Buku KIA Kemenkes RI.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF757575)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(MaternalConsultationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Query Bubble
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFA6978),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: const Radius.circular(0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.transcribedText != null && item.transcribedText!.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.mic, size: 14, color: Colors.white70),
                    ),
                  Flexible(
                    child: Text(
                      item.query,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // AI Bidan Answer Bubble
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: item.isEmergency
                    ? const Color(0xFFFFEBEE)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  topLeft: const Radius.circular(0),
                ),
                border: Border.all(
                  color: item.isEmergency
                      ? const Color(0xFFFFCDD2)
                      : const Color(0xFFE0E0E0),
                  width: item.isEmergency ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card Bidan AI
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: item.isEmergency
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFFFA6978),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.isEmergency
                              ? Icons.emergency
                              : Icons.health_and_safety_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.isEmergency
                              ? 'Bidan Prenava (Deteksi Bahaya)'
                              : 'Bidan Prenava AI',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: item.isEmergency
                                ? const Color(0xFFB71C1C)
                                : const Color(0xFF424242),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.providerUsed.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Markdown Content
                  MarkdownBody(
                    data: item.aiAnswer,
                    shrinkWrap: true,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF263238)),
                      strong: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263238)),
                      listBullet: const TextStyle(color: Color(0xFFFA6978)),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Rujukan Resmi Kemenkes Badge
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Rujukan: ${item.referenceSource}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF0F2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Text(
            'Merekam Suara: ${_formatTimer(_recordSeconds)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFB71C1C),
              fontSize: 13,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _cancelRecording,
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 6),
          ElevatedButton.icon(
            onPressed: _stopAndSubmitRecording,
            icon: const Icon(Icons.stop, size: 16),
            label: const Text('Kirim'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic, color: Color(0xFFFA6978)),
            tooltip: 'Mulai Rekam Suara',
            onPressed: isLoading ? null : _toggleRecording,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              textInputAction: TextInputAction.send,
              enabled: !isLoading,
              onSubmitted: _sendQuestion,
              decoration: InputDecoration(
                hintText: 'Tanyakan keluhan atau gizi kehamilan...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFA6978),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: isLoading
                  ? null
                  : () => _sendQuestion(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}
