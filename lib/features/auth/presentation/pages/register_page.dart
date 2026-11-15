import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/config/env.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/auth_providers.dart';
import '../widgets/google_web_button/google_web_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;
  bool _isGoogleLoading = false;
  StreamSubscription<GoogleSignInAccount?>? _googleSignInSubscription;
  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      serverClientId: isAndroid ? Env.googleWebClientId : null,
      clientId: kIsWeb ? Env.googleWebClientId : null,
    );

    if (kIsWeb) {
      _googleSignInSubscription = _googleSignIn.onCurrentUserChanged.listen(
        (GoogleSignInAccount? account) {
          if (account != null) {
            _processGoogleAuth(account);
          }
        },
        onError: (err) {
          debugPrint('[GOOGLE WEB SIGNUP] onCurrentUserChanged error: $err');
        },
      );
      _googleSignIn.signInSilently();
    }
  }

  @override
  void dispose() {
    _googleSignInSubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final passwordConfirmation = _passwordConfirmationController.text;

    final success = await ref.read(authNotifierProvider.notifier).register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan masuk dengan akun Anda.'),
          backgroundColor: Color(0xFFFA6978),
          duration: Duration(seconds: 3),
        ),
      );
      context.go('/login');
    } else {
      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Registrasi gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _processGoogleAuth(GoogleSignInAccount googleUser) async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      debugPrint('[GOOGLE SIGNUP] accessToken: ${googleAuth.accessToken != null}');
      debugPrint('[GOOGLE SIGNUP] idToken: ${idToken != null}');

      if (idToken == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Gagal mendapatkan token autentikasi Google. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;

      final success = await ref
          .read(authNotifierProvider.notifier)
          .loginWithGoogle(idToken);

      if (!mounted) return;

      if (success) {
        await ref.read(profileNotifierProvider.notifier).loadProfile();
        final profileState = ref.read(profileNotifierProvider);

        if (!mounted) return;

        if (profileState.hasProfile) {
          context.go('/home');
        } else {
          context.go('/profile-onboarding');
        }
      } else {
        final error = ref.read(authNotifierProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                error ?? 'Daftar dengan Google gagal. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('[GOOGLE SIGNUP] Auth error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kendala saat menghubungkan akun Google.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled account picker
        return;
      }
      await _processGoogleAuth(googleUser);
    } catch (e) {
      debugPrint('[GOOGLE SIGNUP] Error: $e');
      if (!mounted) return;
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('sign_in_canceled') ||
          errorStr.contains('canceled') ||
          errorStr.contains('popup_closed_by_user')) {
        return;
      }

      String friendlyMessage;
      if (errorStr.contains('network_error') ||
          errorStr.contains('socketexception') ||
          errorStr.contains('connection')) {
        friendlyMessage =
            'Koneksi internet bermasalah. Periksa jaringan Anda dan coba lagi.';
      } else if (errorStr.contains('apiexception: 10') ||
          errorStr.contains('developer_error')) {
        friendlyMessage =
            'Konfigurasi autentikasi Google belum sesuai dengan tanda tangan aplikasi.';
      } else {
        friendlyMessage =
            'Terjadi kendala saat mendaftar dengan Google. Silakan coba lagi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF424242)),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 32),
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildPasswordConfirmationField(),
                  const SizedBox(height: 32),
                  _buildRegisterButton(authState),
                  const SizedBox(height: 20),
                  _buildCustomDivider(),
                  const SizedBox(height: 20),
                  _buildGoogleSignUpButton(authState),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFFA6978),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Masukkan nama lengkap',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'contoh@gmail.com',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email wajib diisi';
            }
            if (!value.contains('@')) {
              return 'Email tidak valid';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kata Sandi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Minimal 6 karakter',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password wajib diisi';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordConfirmationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfirmasi Kata Sandi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordConfirmationController,
          obscureText: _obscurePasswordConfirmation,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Masukkan ulang kata sandi',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePasswordConfirmation ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Konfirmasi password wajib diisi';
            }
            if (value != _passwordController.text) {
              return 'Password tidak sama';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFA6978),
          disabledBackgroundColor: const Color(0xFFFA6978).withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: authState.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildCustomDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Atau daftar dengan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
            child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleSignUpButton(AuthState authState) {
    if (kIsWeb) {
      return buildGoogleWebButton(isSignUp: true);
    }
    final isDisabled = authState.isLoading || _isGoogleLoading;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: isDisabled ? null : _handleGoogleSignUp,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isGoogleLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Menghubungkan Akun Google...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Daftar dengan Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF424242),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sudah Punya Akun? ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          TextButton(
            onPressed: () => context.go('/login'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFFA6978),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

