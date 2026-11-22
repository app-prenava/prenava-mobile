import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/screening_models.dart';
import '../providers/screening_providers.dart';

class ScreeningPage extends ConsumerStatefulWidget {
  /// True during mandatory onboarding (no skip, blocks back button).
  /// False when triggered as a re-screening from Account/History.
  final bool isInitial;

  const ScreeningPage({
    super.key,
    this.isInitial = true,
  });

  @override
  ConsumerState<ScreeningPage> createState() => _ScreeningPageState();
}

class _ScreeningPageState extends ConsumerState<ScreeningPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0 = Welcome intro, 1..N = Questions
  final Map<int, String> _selectedAnswers = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSubmit(ScreeningQuestionsResponse data) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final result = await ref
        .read(screeningNotifierProvider.notifier)
        .submitScreening(version: data.version, answers: _selectedAnswers);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      context.go(
        '/screening/result',
        extra: {
          'result': result,
          'isInitial': widget.isInitial,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan hasil skrining. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(screeningQuestionsProvider);
    final userName =
        ref.watch(authNotifierProvider).user?.name.split(' ').first ?? 'Bunda';

    return PopScope(
      canPop: !widget.isInitial,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: questionsAsync.when(
            loading: () => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFA6978)),
                  SizedBox(height: 16),
                  Text(
                    'Menyiapkan skrining personalisasi...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 56, color: Color(0xFFFA6978)),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat pertanyaan skrining',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pastikan koneksi internet Bunda aktif lalu coba lagi.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ref.invalidate(screeningQuestionsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFA6978),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data: (data) {
              final questions = data.questions;
              final totalQuestions = questions.length;
              final totalPages = totalQuestions + 1;

              return Column(
                children: [
                  _buildTopBar(totalQuestions),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: totalPages,
                      onPageChanged: (idx) =>
                          setState(() => _currentStep = idx),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildIntroStep(userName, totalQuestions);
                        }
                        final question = questions[index - 1];
                        final isLast = index == totalPages - 1;
                        return _buildQuestionStep(
                          question: question,
                          questionNumber: index,
                          totalQuestions: totalQuestions,
                          isLast: isLast,
                          data: data,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(int totalQuestions) {
    final canGoBack = _currentStep > 0 || !widget.isInitial;
    final progress =
        totalQuestions > 0 ? (_currentStep / totalQuestions).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: canGoBack ? Colors.grey[700] : Colors.transparent,
            ),
            onPressed: canGoBack
                ? () {
                    if (_currentStep > 0) {
                      _goToPage(_currentStep - 1);
                    } else if (!widget.isInitial) {
                      context.pop();
                    }
                  }
                : null,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _currentStep == 0 ? 0.05 : progress,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _currentStep == 0 ? 'Mulai' : '$_currentStep/$totalQuestions',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroStep(String userName, int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 56,
                color: Color(0xFFFA6978),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Personalisasi Beranda untuk $userName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Jawab $totalQuestions pertanyaan singkat (±2 menit) agar Prenava dapat menonjolkan fitur yang paling sesuai dengan kebutuhan kehamilan Bunda saat ini.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFA6978).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: Color(0xFFFA6978)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hasil skrining ini bertujuan untuk menyesuaikan rekomendasi fitur & edukasi aplikasi, bukan merupakan diagnosis medis.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => _goToPage(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Mulai Skrining',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildQuestionStep({
    required ScreeningQuestionModel question,
    required int questionNumber,
    required int totalQuestions,
    required bool isLast,
    required ScreeningQuestionsResponse data,
  }) {
    final selectedValue = _selectedAnswers[question.id];
    final canContinue = selectedValue != null && !_isSubmitting;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.dimensionLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFA6978),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final opt = question.options[idx];
                final isSelected = selectedValue == opt.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAnswers[question.id] = opt.value;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFA6978).withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFA6978)
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFFA6978)
                                  : const Color(0xFF2D3748),
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? const Color(0xFFFA6978)
                              : Colors.grey[400],
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: canContinue
                ? () {
                    if (isLast) {
                      _handleSubmit(data);
                    } else {
                      _goToPage(questionNumber + 1);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    isLast ? 'Selesai & Lihat Rekomendasi' : 'Lanjut',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
