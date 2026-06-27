import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  Timer? _countdownTimer;
  int _remainingSeconds = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _startCountdown();

    // Auto-focus first field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _remainingSeconds = 60;
      _canResend = false;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        if (mounted) setState(() => _canResend = true);
      } else {
        if (mounted) setState(() => _remainingSeconds--);
      }
    });
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  void _clearOtp() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  Future<void> _handleVerify() async {
    final otp = _otpCode;
    if (otp.length < 6) {
      _shakeController.forward().then((_) => _shakeController.reset());
      return;
    }

    setState(() => _isVerifying = true);

    final success = await ref
        .read(authNotifierProvider.notifier)
        .verifyEmail(widget.email, otp);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isVerifying = false;
        _showSuccess = true;
      });

      // Brief success animation before navigating
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      await ref.read(profileNotifierProvider.notifier).loadProfile();
      final profileState = ref.read(profileNotifierProvider);

      if (!mounted) return;

      if (profileState.hasProfile) {
        context.go('/home');
      } else {
        context.go('/profile-onboarding');
      }
    } else {
      setState(() => _isVerifying = false);
      _shakeController.forward().then((_) => _shakeController.reset());
      _clearOtp();

      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Kode OTP tidak valid'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    final message = await ref
        .read(authNotifierProvider.notifier)
        .resendVerification(widget.email);

    if (!mounted) return;

    if (message != null) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF43A047),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Gagal mengirim ulang OTP'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onOtpDigitChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-submit when all 6 digits are filled
    if (_otpCode.length == 6) {
      _handleVerify();
    }
  }

  void _onOtpKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF424242),
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: const Size(44, 44),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildHeaderIcon(),
                    const SizedBox(height: 32),
                    _buildTitle(),
                    const SizedBox(height: 12),
                    _buildSubtitle(),
                    const SizedBox(height: 48),
                    _buildOtpFields(),
                    const SizedBox(height: 40),
                    _buildVerifyButton(authState),
                    const SizedBox(height: 32),
                    _buildResendSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _showSuccess
          ? Container(
              key: const ValueKey('success'),
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF43A047).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 44,
              ),
            )
          : Container(
              key: const ValueKey('email'),
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFA6978), Color(0xFFFF8A9E)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFA6978).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mark_email_unread_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
    );
  }

  Widget _buildTitle() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _showSuccess ? 'Verifikasi Berhasil!' : 'Verifikasi Email',
        key: ValueKey(_showSuccess),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    if (_showSuccess) {
      return const Text(
        'Email Anda berhasil diverifikasi.\nMengarahkan ke halaman utama...',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF43A047),
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF757575),
          height: 1.6,
        ),
        children: [
          const TextSpan(
            text: 'Masukkan 6 digit kode OTP yang telah\ndikirim ke ',
          ),
          TextSpan(
            text: widget.email,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFields() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value *
                (_shakeController.status == AnimationStatus.forward ? 1 : -1),
            0,
          ),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final isFilled = _controllers[index].text.isNotEmpty;
          return Container(
            width: 50,
            height: 60,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : (index == 3 ? 16 : 6),
              right: index == 2 ? 0 : 0,
            ),
            child: KeyboardListener(
              focusNode: FocusNode(), // proxy node for key events
              onKeyEvent: (event) => _onOtpKeyEvent(event, index),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                onChanged: (value) => _onOtpDigitChanged(value, index),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isFilled
                      ? const Color(0xFFFA6978)
                      : const Color(0xFF424242),
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  filled: true,
                  fillColor: isFilled
                      ? const Color(0xFFFFF0F2)
                      : const Color(0xFFF8F8F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isFilled
                          ? const Color(0xFFFA6978)
                          : const Color(0xFFE0E0E0),
                      width: isFilled ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: isFilled
                          ? const Color(0xFFFA6978)
                          : const Color(0xFFE0E0E0),
                      width: isFilled ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFFFA6978),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerifyButton(AuthState authState) {
    final isReady = _otpCode.length == 6;
    final isLoading = authState.isLoading || _isVerifying;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isReady && !isLoading
              ? const LinearGradient(
                  colors: [Color(0xFFFA6978), Color(0xFFFF8A9E)],
                )
              : null,
          color: isReady || isLoading ? null : const Color(0xFFE0E0E0),
          boxShadow: isReady && !isLoading
              ? [
                  BoxShadow(
                    color: const Color(0xFFFA6978).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading || !isReady ? null : _handleVerify,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Verifikasi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isReady ? Colors.white : const Color(0xFF9E9E9E),
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          'Tidak menerima kode?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        if (_canResend)
          TextButton(
            onPressed: _handleResend,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Kirim Ulang OTP',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFA6978),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  'Kirim ulang dalam ${_remainingSeconds}s',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
