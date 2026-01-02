import 'package:flutter/material.dart';
import 'dart:ui';

/// Glass morphism container widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: 20,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: onTap != null
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}

/// Bento grid item for displaying metrics
class BentoGridItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accentColor;
  final Animation<double> animation;

  const BentoGridItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? const Color(0xFFFA6978);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: effectiveAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: effectiveAccentColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: effectiveAccentColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated progress bar with slide-in animation
class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final String currentAge;
  final String trimester;
  final Animation<double> animation;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.currentAge,
    required this.trimester,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Usia Kehamilan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    currentAge,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          widthFactor: (progress / 100) * animation.value,
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B9D), Color(0xFFFA6978)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFA6978).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFA6978).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      trimester,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA6978),
                      ),
                    ),
                  ),
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating animation for baby gender icon
class FloatingGenderIcon extends StatefulWidget {
  final String gender;
  final double size;

  const FloatingGenderIcon({
    super.key,
    required this.gender,
    this.size = 60,
  });

  @override
  State<FloatingGenderIcon> createState() => _FloatingGenderIconState();
}

class _FloatingGenderIconState extends State<FloatingGenderIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.gender == 'L'
                ? [
                    const Color(0xFF2196F3).withOpacity(0.2),
                    const Color(0xFF1976D2).withOpacity(0.2),
                  ]
                : [
                    const Color(0xFFE91E63).withOpacity(0.2),
                    const Color(0xFFC2185B).withOpacity(0.2),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.gender == 'L'
                ? const Color(0xFF2196F3).withOpacity(0.3)
                : const Color(0xFFE91E63).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.gender == 'L'
                  ? const Color(0xFF2196F3).withOpacity(0.2)
                  : const Color(0xFFE91E63).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.gender == 'L' ? Icons.male : Icons.female,
            size: widget.size * 0.5,
            color: widget.gender == 'L'
                ? const Color(0xFF2196F3)
                : const Color(0xFFE91E63),
          ),
        ),
      ),
    );
  }
}

/// Sticky glowing button
class GlowingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;

  const GlowingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: isOutlined
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFA6978).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLoading ? 0.7 : 1.0,
        child: isOutlined
            ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFA6978),
                  side: const BorderSide(color: Color(0xFFFA6978), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA6978)),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isOutlined ? Icons.update : Icons.save),
                          const SizedBox(width: 10),
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              )
            : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isOutlined ? Icons.update : Icons.save),
                          const SizedBox(width: 10),
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
