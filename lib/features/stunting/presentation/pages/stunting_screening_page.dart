import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/core/theme/app_theme.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/presentation/providers/stunting_providers.dart';
import 'package:prenava_mobile/features/stunting/presentation/widgets/stunting_intro_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StuntingScreeningPage extends ConsumerStatefulWidget {
  const StuntingScreeningPage({super.key});

  @override
  ConsumerState<StuntingScreeningPage> createState() => _StuntingScreeningPageState();
}

class _StuntingScreeningPageState extends ConsumerState<StuntingScreeningPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(stuntingFormProvider.notifier);
      notifier.reset();
      notifier.fetchQuestions();
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const StuntingIntroDialog(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stuntingFormProvider);
    final notifier = ref.read(stuntingFormProvider.notifier);
    final predictionState = ref.watch(stuntingPredictionProvider);

    final isPredicting = predictionState.status == PredictionStatus.loading;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Skrining Risiko Stunting'),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: isPredicting
                  ? null
                  : () => context.go('/home'),
            ),
          ),
          body: state.isLoading
              ? _buildLoadingState()
              : state.error != null
                  ? _buildErrorState(state.error!)
                  : _buildForm(state, notifier, predictionState),
        ),
        if (isPredicting) _buildPredictionOverlay(),
      ],
    );
  }

  Widget _buildPredictionOverlay() {
    return _PredictionLoadingOverlay();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryPink),
          SizedBox(height: 16),
          Text(
            'Memuat pertanyaan...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.warningRed),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(stuntingFormProvider.notifier).fetchQuestions(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
    StuntingFormState state,
    StuntingFormNotifier notifier,
    PredictionState predictionState,
  ) {
    if (state.questions.isEmpty) return const SizedBox();

    final currentQuestion = state.questions[state.currentStep];
    final progress = notifier.progress;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          color: AppColors.primaryPink,
          minHeight: 6,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan ${state.currentStep + 1} dari ${state.questions.length}',
                  style: TextStyle(
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currentQuestion.label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0),
                const SizedBox(height: 32),
                _buildInput(currentQuestion, state, notifier),
              ],
            ),
          ),
        ),
        _buildBottomBar(state, notifier, predictionState),
      ],
    );
  }

  Widget _buildInput(
    StuntingQuestion question,
    StuntingFormState state,
    StuntingFormNotifier notifier,
  ) {
    final currentValue = state.answers[question.key];

    switch (question.type) {
      case 'select':
        return Column(
          children: question.options?.map((opt) {
                final isSelected = currentValue == opt.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => notifier.updateAnswer(question.key, opt.value),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPink : const Color(0xFFE0E0E0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? AppColors.primaryPink : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.primaryPink),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList() ??
              [],
        );
      case 'boolean':
        return Row(
          children: [
            Expanded(
              child: _buildBoolOption(
                label: 'Ya',
                isSelected: currentValue == true,
                onTap: () => notifier.updateAnswer(question.key, true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBoolOption(
                label: 'Tidak',
                isSelected: currentValue == false,
                onTap: () => notifier.updateAnswer(question.key, false),
              ),
            ),
          ],
        );
      case 'number':
        return _NumberQuestionInput(
          key: ValueKey(question.key),
          question: question,
          initialValue: currentValue as double?,
          onChanged: (val) {
            if (val == null) {
              notifier.removeAnswer(question.key);
            } else {
              notifier.updateAnswer(question.key, val);
            }
          },
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildBoolOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryPink : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    StuntingFormState state,
    StuntingFormNotifier notifier,
    PredictionState predictionState,
  ) {
    final isValid = notifier.isCurrentStepValid();
    final isLastStep = state.currentStep == state.questions.length - 1;
    final isSubmitting = predictionState.status == PredictionStatus.loading;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (state.currentStep > 0) ...[
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : () => notifier.previousStep(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kembali', style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: !isValid || isSubmitting
                  ? null
                  : () {
                      if (isLastStep) {
                        _handleSubmit(state, notifier);
                      } else {
                        notifier.nextStep();
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(isLastStep ? 'Lihat Hasil' : 'Selanjutnya'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(StuntingFormState state, StuntingFormNotifier notifier) async {
    await ref.read(stuntingPredictionProvider.notifier).submit(state.answers);
    final resultState = ref.read(stuntingPredictionProvider);
    if (resultState.status == PredictionStatus.success) {
      if (mounted) {
        context.pushReplacement('/stunting/result', extra: resultState.result);
      }
    } else if (resultState.status == PredictionStatus.failure) {
      if (!mounted) return;

      final error = resultState.error ?? 'Terjadi kesalahan';
      final isSessionExpired = error.contains('Sesi login') || error.contains('401');
      final isServerDown = error.contains('Server ML') || error.contains('504');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSessionExpired
                ? '🔒 Sesi login berakhir. Silakan login kembali.'
                : isServerDown
                    ? '⏳ Server sedang tidak tersedia. Coba lagi dalam beberapa saat.'
                    : error,
          ),
          duration: const Duration(seconds: 8),
          action: isSessionExpired
              ? SnackBarAction(
                  label: 'Login',
                  onPressed: () => context.go('/login'),
                )
              : SnackBarAction(
                  label: 'Coba Lagi',
                  onPressed: () => _handleSubmit(state, notifier),
                ),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Fullscreen prediction loading overlay
// ---------------------------------------------------------------------------
class _PredictionLoadingOverlay extends StatefulWidget {
  @override
  State<_PredictionLoadingOverlay> createState() => _PredictionLoadingOverlayState();
}

class _PredictionLoadingOverlayState extends State<_PredictionLoadingOverlay> {
  static const _messages = [
    'Menganalisis data...',
    'Memproses prediksi risiko...',
    'Menghitung faktor risiko...',
    'Menyiapkan rekomendasi...',
    'Hampir selesai...',
  ];

  int _messageIndex = 0;
  late final _timer;

  @override
  void initState() {
    super.initState();
    _timer = Stream.periodic(const Duration(seconds: 3)).listen((_) {
      if (mounted) {
        setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  color: AppColors.primaryPink,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Menganalisis Risiko Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _messages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, size: 14, color: AppColors.primaryPink),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Proses ini membutuhkan waktu 5–15 detik.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryPink),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Number input widget — controller managed in state to prevent rebuild bug
// ---------------------------------------------------------------------------
class _NumberQuestionInput extends StatefulWidget {
  final StuntingQuestion question;
  final double? initialValue;
  final void Function(double?) onChanged;

  const _NumberQuestionInput({
    super.key,
    required this.question,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_NumberQuestionInput> createState() => _NumberQuestionInputState();
}

class _NumberQuestionInputState extends State<_NumberQuestionInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Format as integer string if value is a whole number (e.g. 157.0 → "157")
    final val = widget.initialValue;
    final initialText = val == null
        ? ''
        : (val % 1 == 0 ? val.toInt().toString() : val.toString());
    _controller = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      // integers only — no decimal keyboard on Android
      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
      decoration: InputDecoration(
        hintText: 'Masukkan angka',
        suffixText: widget.question.unit,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
      ),
      onChanged: (val) {
        if (val.isEmpty) {
          widget.onChanged(null);
          return;
        }
        // Accept integers only — tryParse handles "157", rejects "1.0"
        final intVal = int.tryParse(val);
        if (intVal != null) {
          widget.onChanged(intVal.toDouble());
        }
      },
    );
  }
}
