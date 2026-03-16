import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  AnimationController? _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late List<Animation<double>> _petAnims;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    final controller = _entryController!;

    _fadeAnim = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.2, 0.75, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
    ));

    // Staggered elastic pop for each pet badge
    _petAnims = List.generate(3, (i) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            i * 0.1,
            0.45 + i * 0.08,
            curve: Curves.elasticOut,
          ),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _entryController?.forward();
    });
  }

  @override
  void dispose() {
    _entryController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(authStateProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(e.toString().replaceAll('Exception: ', ''))),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ── Three pet badges ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _petAnims[0],
                    child:
                        const _PetBadge(emoji: '🐕', color: Color(0xFFF4511E)),
                  ),
                  const SizedBox(width: 22),
                  ScaleTransition(
                    scale: _petAnims[1],
                    child:
                        const _PetBadge(emoji: '🐈', color: Color(0xFFC2185B)),
                  ),
                  const SizedBox(width: 22),
                  ScaleTransition(
                    scale: _petAnims[2],
                    child:
                        const _PetBadge(emoji: '🦜', color: Color(0xFF1A3558)),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ── Triple-ring paw logo ──────────────────────────────────────
              ScaleTransition(
                scale: _petAnims[1],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFC2185B).withOpacity(0.08),
                      ),
                    ),
                    Container(
                      width: 94,
                      height: 94,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFC2185B).withOpacity(0.15),
                      ),
                    ),
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC2185B).withOpacity(0.28),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.pets,
                            size: 36, color: Color(0xFFC2185B)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Brand name & tagline ──────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      'ANIVET',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A3558),
                        letterSpacing: 5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your Pet\'s Health Partner',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[500],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Form card ────────────────────────────────────────────────
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 36,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A3558),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Sign in to manage your pet\'s health',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Email
                                _buildField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'you@example.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter your email';
                                    if (!v.contains('@'))
                                      return 'Enter a valid email';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Password
                                _buildField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: '••••••••',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  suffixIcon: GestureDetector(
                                    onTap: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 20,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter your password';
                                    if (v.length < 6)
                                      return 'Minimum 6 characters';
                                    return null;
                                  },
                                ),

                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 0),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFC2185B),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Sign In button
                                GestureDetector(
                                  onTap:
                                      authState.isLoading ? null : _handleLogin,
                                  child: Container(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFC2185B),
                                          Color(0xFF1A3558)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFC2185B)
                                              .withOpacity(0.32),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: authState.isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'Sign In',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A3558),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style:
              GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1A3558)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(icon, size: 20, color: Colors.grey[400]),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 44),
            filled: true,
            fillColor: const Color(0xFFF9F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFC2185B), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// ── Pet badge ─────────────────────────────────────────────────────────────────
class _PetBadge extends StatelessWidget {
  final String emoji;
  final Color color;

  const _PetBadge({required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.28), width: 1.5),
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }
}
