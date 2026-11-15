import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/audio/voice_recorder.dart';
import '../../data/models/maternal_rag_model.dart';
import '../providers/maternal_rag_providers.dart';
import '../widgets/danger_catalog_bottom_sheet.dart';
import '../widgets/emergency_alert_banner.dart';
import '../widgets/nearby_faskes_referral_section.dart';

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
    'Aturan minum tablet tambah darah (TTD)',
    'Jadwal periksa kehamilan (ANC) & USG',
    'Keluar bercak atau darah segar saat hamil',
    'Kepala pusing hebat & pandangan kabur',
    'Gerakan janin terasa lebih jarang',
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
            'Izin mikrofon belum aktif. Silakan izinkan akses mikrofon atau ketik pertanyaan Bunda di kolom bawah.',
          ),
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
          content: Text('Rekaman suara belum terdengar. Silakan coba kembali.'),
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
        onSelectSymptomQuery: _sendQuestion,
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tanya Bidan (Buku KIA)',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              'Panduan Resmi KIA Kemenkes RI',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              onPressed: _showDangerCatalog,
              icon: const Icon(
                Icons.menu_book_rounded,
                size: 15,
                color: Color(0xFF334155),
              ),
              label: const Text(
                'Panduan KIA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Banner merah HANYA tampil jika baru saja terjadi deteksi tanda bahaya aktif
            if (state.activeEmergency != null)
              EmergencyAlertBanner(
                consultation: state.activeEmergency!,
                onDismiss: () => ref
                    .read(maternalRagNotifierProvider.notifier)
                    .dismissEmergency(),
              ),

            // Area Daftar Percakapan
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

            // Saran pertanyaan ringkas di atas kolom ketik (hanya saat sudah ada obrolan)
            if (state.consultations.isNotEmpty && !state.isLoading)
              Container(
                height: 36,
                margin: const EdgeInsets.only(bottom: 6),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickPrompts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final prompt = _quickPrompts[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _sendQuestion(prompt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          prompt,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Bar Indikator Loading (R-27)
            if (state.isLoading)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Color(0xFF334155),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Memeriksa pedoman Buku KIA...',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Bar Error (R-27)
            if (state.errorMessage != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: const Color(0xFFFEF2F2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 16,
                      color: Color(0xFF991B1B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Input Bar
            _isRecording
                ? _buildRecordingBar()
                : _buildInputBar(state.isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kartu Pengantar yang Tenang (Tanpa Warna Merah)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.health_and_safety_outlined,
                        size: 20,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Halo Bunda, ada yang ingin ditanyakan hari ini?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tanyakan seputar gizi, jadwal pemeriksaan, atau keluhan yang dirasakan lewat suara maupun tulisan. Seluruh penjelasan mengacu pada Buku KIA Kemenkes RI.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Contoh pertanyaan:',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _quickPrompts.map((prompt) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _sendQuestion(prompt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          prompt,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Daftar Bidan & Faskes Terdekat dalam tampilan tenang (isEmergencyContext: false)
          const NearbyFaskesReferralSection(
            maxVisibleItems: 2,
            isEmergencyContext: false,
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(MaternalConsultationItem item) {
    final firstAidList = item.effectiveFirstAidSteps;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gelembung Pertanyaan Ibu Hamil (Tenang & Proporsional)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(12).copyWith(
                  bottomRight: const Radius.circular(2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.transcribedText != null &&
                      item.transcribedText!.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.mic_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      item.query,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Kartu Respons Bidan (Warna merah HANYA saat item.isEmergency == true)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.96,
              ),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12).copyWith(
                  topLeft: const Radius.circular(2),
                ),
                border: Border.all(
                  color: item.isEmergency
                      ? const Color(0xFFFECACA)
                      : const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tingkat 1 Hierarki: Header Status Konsultasi
                  Row(
                    children: [
                      Icon(
                        item.isEmergency
                            ? Icons.warning_amber_rounded
                            : Icons.health_and_safety_outlined,
                        size: 16,
                        color: item.isEmergency
                            ? const Color(0xFF991B1B)
                            : const Color(0xFF065F46),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.isEmergency
                              ? 'Panduan Rujukan Tanda Bahaya'
                              : 'Penjelasan Bidan (Buku KIA)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: item.isEmergency
                                ? const Color(0xFF7F1D1D)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tingkat 2 Hierarki: Penjelasan Klinis & Langkah Awal (Jika Tanda Bahaya)
                  if (item.isEmergency) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.dangerKeywords.isNotEmpty) ...[
                            Text(
                              'Gejala terdeteksi: ${item.dangerKeywords.join(", ")}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            item.effectiveRecommendedAction,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.effectiveClinicalRisk,
                            style: const TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: Color(0xFF475569),
                            ),
                          ),
                          if (firstAidList.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Divider(height: 1, color: Color(0xFFFECACA)),
                            const SizedBox(height: 8),
                            const Text(
                              'Langkah Awal Sebelum Berangkat ke Faskes:',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            for (int i = 0; i < firstAidList.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${i + 1}. ',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF7F1D1D),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        firstAidList[i],
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          height: 1.35,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),

                    // Tingkat 3 Hierarki: Daftar Faskes Terdekat (Mode Darurat)
                    const NearbyFaskesReferralSection(
                      maxVisibleItems: 3,
                      isEmergencyContext: true,
                    ),
                  ] else ...[
                    // Konten Markdown Jawaban Konsultasi Normal
                    MarkdownBody(
                      data: item.aiAnswer,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: Color(0xFF1E293B),
                        ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                        listBullet: const TextStyle(
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 6),

                  // Kutipan Sumber Halaman Buku KIA (Ringkas & Tenang)
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 13,
                        color: Color(0xFF475569),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Referensi: ${item.kiaPageRef ?? item.referenceSource}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF475569),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.fiber_manual_record_rounded,
            color: Color(0xFFB91C1C),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Merekam suara (${_formatTimer(_recordSeconds)})',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontSize: 12.5,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _cancelRecording,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF475569),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Batal', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: _stopAndSubmitRecording,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF334155),
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Kirim',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.mic_none_rounded,
              color: Color(0xFF334155),
              size: 21,
            ),
            tooltip: 'Rekam pertanyaan suara',
            onPressed: isLoading ? null : _toggleRecording,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Semantics(
              label: 'Kolom input keluhan atau pertanyaan kehamilan',
              textField: true,
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                enabled: !isLoading,
                onSubmitted: _sendQuestion,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: 'Tulis keluhan atau pertanyaan Bunda...',
                  hintStyle: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF475569),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF334155),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 38,
            height: 38,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _sendQuestion(_textController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF334155),
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
