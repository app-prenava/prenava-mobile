import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ---------------------------------------------------------------------------
// Design Tokens — Stunting Food Module (Pink–White Theme)
// ---------------------------------------------------------------------------

class StuntingFoodColors {
  static const primaryPink = Color(0xFFFA6978); // Matching Home Page
  static const primaryDarkPink = Color(0xFFD25564); // Darker shade of FA6978
  static const lightPinkSurface = Color(0xFFFFFFFF);
  static const background = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB); // Neutral light grey
  static const divider = Color(0xFFF1F5F9);
  static const success = Color(0xFF16A34A);
  static const successBg = Color(0xFFF0FDF4); // Even lighter success bg
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFFFFFBEB); // Even lighter warning bg
  static const error = Color(0xFFEF4444);
  static const errorBg = Color(0xFFFEF2F2); // Even lighter error bg
}

// ---------------------------------------------------------------------------
// Typography Helpers — Google Fonts Poppins
// ---------------------------------------------------------------------------

class StuntingFoodTypo {
  static TextStyle heading24({
    Color color = StuntingFoodColors.textPrimary,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.poppins(fontSize: 24, fontWeight: weight, color: color, height: 1.2);

  static TextStyle heading18({
    Color color = StuntingFoodColors.textPrimary,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.poppins(fontSize: 18, fontWeight: weight, color: color, height: 1.3);

  static TextStyle heading16({
    Color color = StuntingFoodColors.textPrimary,
    FontWeight weight = FontWeight.w700,
  }) =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: weight, color: color, height: 1.3);

  static TextStyle body14({
    Color color = StuntingFoodColors.textPrimary,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: weight, color: color, height: 1.5);

  static TextStyle body13({
    Color color = StuntingFoodColors.textSecondary,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.poppins(fontSize: 13, fontWeight: weight, color: color, height: 1.5);

  static TextStyle caption12({
    Color color = StuntingFoodColors.textSecondary,
    FontWeight weight = FontWeight.w400,
  }) =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: weight, color: color, height: 1.4);

  static TextStyle button({
    Color color = Colors.white,
    FontWeight weight = FontWeight.w600,
  }) =>
      GoogleFonts.poppins(fontSize: 15, fontWeight: weight, color: color, height: 1.3);
}

// ---------------------------------------------------------------------------
// AppCard — Clean card with soft shadow
// ---------------------------------------------------------------------------

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StuntingFoodColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StuntingFoodColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// PrimaryButton — Full-width pink CTA (48px height for touch target)
// ---------------------------------------------------------------------------

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback? onPressed;
  const PrimaryButton({
    super.key,
    required this.text,
    this.loading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: StuntingFoodColors.primaryPink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: StuntingFoodColors.primaryPink.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: StuntingFoodTypo.button()),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SecondaryButton — Outlined pink button
// ---------------------------------------------------------------------------

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: StuntingFoodColors.primaryPink,
          side: const BorderSide(color: StuntingFoodColors.primaryPink),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(text, style: StuntingFoodTypo.button(color: StuntingFoodColors.primaryPink)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NutrientChip — Light pink badge with dark pink text
// ---------------------------------------------------------------------------

class NutrientChip extends StatelessWidget {
  final String label;
  const NutrientChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StuntingFoodColors.border),
      ),
      child: Text(
        label,
        style: StuntingFoodTypo.caption12(
          color: StuntingFoodColors.primaryDarkPink,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SectionHeader — Poppins heading + subtitle
// ---------------------------------------------------------------------------

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: StuntingFoodTypo.heading18()),
        const SizedBox(height: 4),
        Text(subtitle, style: StuntingFoodTypo.body14(color: StuntingFoodColors.textSecondary)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// EmptyStateView — Centered empty state with icon + CTA
// ---------------------------------------------------------------------------

class EmptyStateView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onTap;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: StuntingFoodColors.border),
              ),
              child: const Icon(
                Icons.restaurant_menu_outlined,
                size: 36,
                color: StuntingFoodColors.primaryPink,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: StuntingFoodTypo.heading16(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: StuntingFoodTypo.body14(color: StuntingFoodColors.textSecondary),
            ),
            const SizedBox(height: 24),
            PrimaryButton(text: ctaText, onPressed: onTap),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ErrorStateView — Error state with retry
// ---------------------------------------------------------------------------

class ErrorStateView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  const ErrorStateView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: StuntingFoodColors.errorBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: StuntingFoodColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: StuntingFoodTypo.heading16(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: StuntingFoodTypo.body14(color: StuntingFoodColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('Coba Lagi', style: StuntingFoodTypo.button(color: StuntingFoodColors.primaryPink)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: StuntingFoodColors.primaryPink,
                  side: const BorderSide(color: StuntingFoodColors.primaryPink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LoadingShimmerList — Skeleton loading
// ---------------------------------------------------------------------------

class LoadingShimmerList extends StatelessWidget {
  const LoadingShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// FoodRecommendationCard — Food card with image, name, nutrients, reason
// ---------------------------------------------------------------------------

class FoodRecommendationCard extends StatelessWidget {
  final String name;
  final String? category;
  final String? imageUrl;
  final double calories;
  final double protein;
  final double? iron;
  final double? calcium;
  final String reason;
  final bool hasRecipe;
  final VoidCallback? onTap;

  const FoodRecommendationCard({
    super.key,
    required this.name,
    this.category,
    this.imageUrl,
    required this.calories,
    required this.protein,
    this.iron,
    this.calcium,
    required this.reason,
    this.hasRecipe = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: StuntingFoodColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: StuntingFoodColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: StuntingFoodTypo.heading16(),
                        ),
                      ),
                      if (hasRecipe)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: StuntingFoodColors.successBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Resep',
                            style: StuntingFoodTypo.caption12(
                              color: StuntingFoodColors.success,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (category != null) ...[
                    const SizedBox(height: 4),
                    Text(category!, style: StuntingFoodTypo.caption12()),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      NutrientChip('${calories.toStringAsFixed(0)} kal'),
                      NutrientChip('${protein.toStringAsFixed(0)}g protein'),
                      if (iron != null)
                        NutrientChip('${iron!.toStringAsFixed(1)} iron'),
                      if (calcium != null)
                        NutrientChip('${calcium!.toStringAsFixed(0)} calcium'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reason,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: StuntingFoodTypo.body13(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final placeholder = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StuntingFoodColors.border),
      ),
      child: const Icon(
        Icons.restaurant_menu_outlined,
        color: StuntingFoodColors.primaryPink,
        size: 32,
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SourceLinkButton
// ---------------------------------------------------------------------------

class SourceLinkButton extends StatelessWidget {
  final String? sourceUrl;
  final VoidCallback onTap;

  const SourceLinkButton({
    super.key,
    required this.sourceUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sourceUrl == null || sourceUrl!.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.open_in_new_rounded, size: 16),
      label: Text('Buka Sumber', style: StuntingFoodTypo.caption12(
        color: StuntingFoodColors.primaryPink,
        weight: FontWeight.w600,
      )),
      style: TextButton.styleFrom(
        foregroundColor: StuntingFoodColors.primaryPink,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// StuntingAppBar — Consistent Poppins AppBar
// ---------------------------------------------------------------------------

AppBar stuntingAppBar({
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: StuntingFoodTypo.heading18(weight: FontWeight.w600),
    ),
    iconTheme: const IconThemeData(color: StuntingFoodColors.textPrimary),
    actions: actions,
  );
}
