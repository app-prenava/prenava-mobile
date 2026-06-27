import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/core/utils/image_url_helper.dart';

import '../../../pregnancy/presentation/providers/pregnancy_providers.dart';
import '../providers/sport_recommendation_providers.dart';
import '../widgets/assessment_form_view.dart';
import '../widgets/lmp_bottom_sheet.dart';
import '../../domain/entities/sport_recommendation.dart';
import 'sport_detail_page.dart';

class RekomendasiGerakanPage extends ConsumerStatefulWidget {
  const RekomendasiGerakanPage({super.key});

  @override
  ConsumerState<RekomendasiGerakanPage> createState() =>
      _RekomendasiGerakanPageState();
}

class _RekomendasiGerakanPageState extends ConsumerState<RekomendasiGerakanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _sheetOpened = false;
  bool _assessmentSheetDismissed = false;
  bool _assessmentSheetScheduled = false;
  bool _redirectedToProfile = false;
  bool _redirectedToLogin = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── bottom sheets ────────────────────────────────────────────────────────

  void _showAssessmentSheet({
    bool showUpdateBanner = false,
    String? errorMessage,
    bool allowDismissAndShowData = false,
  }) {
    if (_sheetOpened) return;

    _sheetOpened = true;
    _assessmentSheetScheduled = false;

    bool submitted = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: AssessmentFormView(
              onSubmit: (payload) {
                submitted = true;
                Navigator.of(context).pop();
                ref
                    .read(sportRecommendationNotifierProvider.notifier)
                    .submitAssessment(payload);
              },
              isSubmitting: false,
              showUpdateBanner: showUpdateBanner,
              errorMessage: errorMessage,
              scrollController: scrollController,
              existingAssessment: ref
                  .read(sportRecommendationNotifierProvider)
                  .existingAssessment,
            ),
          );
        },
      ),
    ).whenComplete(() {
      _sheetOpened = false;
      _assessmentSheetScheduled = false;

      if (submitted) {
        _assessmentSheetDismissed = allowDismissAndShowData;

        ref
            .read(sportRecommendationNotifierProvider.notifier)
            .clearAssessmentFlag();

        return;
      }

      _assessmentSheetDismissed = true;

      if (allowDismissAndShowData) {
        return;
      }

      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _showLmpSheet() {
    if (_sheetOpened || _assessmentSheetDismissed) return;
    _sheetOpened = true;

    bool submitted = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => LmpBottomSheet(
        onSuccess: (hpht, gestationalAge, isMultiple) async {
          submitted = true;

          final success = await ref
              .read(pregnancyNotifierProvider.notifier)
              .savePregnancy(hpht: hpht, babyGender: null);

          if (success && sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }

          if (success && mounted) {
            await ref
                .read(pregnancyNotifierProvider.notifier)
                .createPregnancyRecord(
                  lmpDate: hpht,
                  gestationalAgeWeeks: gestationalAge,
                  multipleGestation: isMultiple,
                );

            await ref
                .read(pregnancyNotifierProvider.notifier)
                .loadMyPregnancy();

            ref
                .read(sportRecommendationNotifierProvider.notifier)
                .clearLmpFlag();

            await ref
                .read(sportRecommendationNotifierProvider.notifier)
                .fetchRecommendations();

            await ref
                .read(sportRecommendationNotifierProvider.notifier)
                .fetchExistingAssessment();
          }
        },
      ),
    ).whenComplete(() {
      _sheetOpened = false;
      _assessmentSheetScheduled = false;

      if (!submitted) {
        _assessmentSheetDismissed = true;

        ref
            .read(sportRecommendationNotifierProvider.notifier)
            .clearLmpFlag();

        if (mounted) {
          context.go('/home');
        }

        return;
      }
    });
  }

  void _scheduleAssessmentSheet({
    bool showUpdateBanner = false,
    String? errorMessage,
    bool allowDismissAndShowData = false,
  }) {
    if (_sheetOpened || _assessmentSheetDismissed || _assessmentSheetScheduled) {
      return;
    }

    _assessmentSheetScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _assessmentSheetScheduled = false;
        return;
      }

      if (_sheetOpened || _assessmentSheetDismissed) {
        _assessmentSheetScheduled = false;
        return;
      }

      _showAssessmentSheet(
        showUpdateBanner: showUpdateBanner,
        errorMessage: errorMessage,
        allowDismissAndShowData: allowDismissAndShowData,
      );
    });
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  void _redirectToProfile() {
    if (_redirectedToProfile) return;
    _redirectedToProfile = true;
    context.go('/profile-onboarding');
  }

  void _redirectToLogin() {
    if (_redirectedToLogin) return;
    _redirectedToLogin = true;

    if (_sheetOpened) {
      Navigator.of(context).pop();
      _sheetOpened = false;
    }

    context.go('/login');
  }

  Future<void> _refresh() async {
    _assessmentSheetDismissed = false;
    _assessmentSheetScheduled = false;

    await ref
        .read(sportRecommendationNotifierProvider.notifier)
        .fetchRecommendations();
    await ref
        .read(sportRecommendationNotifierProvider.notifier)
        .fetchExistingAssessment();
  }

  bool _isServiceUnavailableError(String? error) {
    if (error == null) return false;

    final lowerError = error.toLowerCase();

    return error.contains('Layanan sedang tidak tersedia') ||
        lowerError.contains('500') ||
        lowerError.contains('internal server error') ||
        lowerError.contains('failed to fetch sport recommendations') ||
        lowerError.contains('failed to fetch all sports');
  }

  String? _normalizeSportImageUrl(String? url) {
    if (url == null || url.isEmpty || url == 'data not found') {
      return null;
    }

    var fixedUrl = ImageUrlHelper.normalizeImageUrl(url);

    if (fixedUrl == null || fixedUrl.isEmpty || fixedUrl == 'data not found') {
      return null;
    }

    fixedUrl = fixedUrl.replaceFirst('/api/storage/', '/storage/');

    fixedUrl = fixedUrl.replaceFirst(
      'http://localhost:8000',
      'https://prenavabe.cloud',
    );
    fixedUrl = fixedUrl.replaceFirst(
      'https://localhost:8000',
      'https://prenavabe.cloud',
    );
    fixedUrl = fixedUrl.replaceFirst(
      'http://10.0.2.2:8000',
      'https://prenavabe.cloud',
    );

    return fixedUrl;
  }

  // ─── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sportRecommendationNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFA6978),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Rekomendasi Olahraga',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showAssessmentSheet(
              showUpdateBanner: false,
              allowDismissAndShowData: true,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  // ─── tab bar ──────────────────────────────────────────────────────────────

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabButton(title: 'Rekomendasi', index: 0),
              _buildTabButton(title: 'Semua Olahraga', index: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    final isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFA6978) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ─── body routing ─────────────────────────────────────────────────────────

  Widget _buildBody(SportRecommendationState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFA6978)),
            SizedBox(height: 16),
            Text(
              'Memuat rekomendasi...',
              style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
            ),
          ],
        ),
      );
    }

    if (state.tokenExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _redirectToLogin();
      });
      return _buildPlaceholderBody();
    }

    if (state.needsLmp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened && !_assessmentSheetDismissed) {
          _showLmpSheet();
        }
      });
      return _buildPlaceholderBody();
    }

    if (state.needsProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _redirectToProfile();
      });
      return _buildPlaceholderBody();
    }

    if (state.needsAssessment) {
      _scheduleAssessmentSheet();
      return _buildPlaceholderBody();
    }

    if (state.error != null && state.recommendations.isEmpty) {
      if (_isServiceUnavailableError(state.error)) {
        return _buildServiceUnavailableBody();
      }

      _scheduleAssessmentSheet(errorMessage: state.error);
      return _buildPlaceholderBody();
    }

    if (state.needUpdateData) {
      _scheduleAssessmentSheet(
        showUpdateBanner: true,
        allowDismissAndShowData: true,
      );

      if (state.recommendations.isNotEmpty) {
        return TabBarView(
          controller: _tabController,
          children: [
            _buildRecommendationsList(state.recommendations),
            _buildAllSportsList(state.recommendations),
          ],
        );
      }

      return _buildPlaceholderBody();
    }

    if (state.recommendations.isEmpty) {
      return _buildPlaceholderBody();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRecommendationsList(state.recommendations),
        _buildAllSportsList(state.recommendations),
      ],
    );
  }

  // ─── list builders ────────────────────────────────────────────────────────

  Widget _buildRecommendationsList(List<SportRecommendation> recommendations) {
    final filtered = recommendations.where((item) {
      return item.recommendationLevel == 'highly_recommended' ||
          item.recommendationLevel == 'allowed_with_caution';
    }).toList();

    if (filtered.isEmpty) {
      return _buildRefreshableEmpty('Belum ada rekomendasi');
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) => _buildSportCard(filtered[index]),
      ),
    );
  }

  Widget _buildAllSportsList(List<SportRecommendation> recommendations) {
    if (recommendations.isEmpty) {
      return _buildRefreshableEmpty('Belum ada data olahraga');
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recommendations.length,
        itemBuilder: (context, index) =>
            _buildSportCard(recommendations[index]),
      ),
    );
  }

  Widget _buildRefreshableEmpty(String message) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
            ),
          ),
        ),
      ),
    );
  }

  // ─── sport card ───────────────────────────────────────────────────────────

  String? _getYoutubeThumbnail(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      String? videoId;

      if (uri.host.contains('youtube.com')) {
        if (uri.queryParameters.containsKey('v')) {
          videoId = uri.queryParameters['v'];
        } else if (uri.pathSegments.contains('live')) {
          videoId = uri.pathSegments.last;
        } else if (uri.pathSegments.contains('shorts')) {
          videoId = uri.pathSegments.last;
        }
      } else if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }

      if (videoId != null && videoId.isNotEmpty) {
        return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
      }
    } catch (_) {}
    return null;
  }

  Widget _buildSportCard(SportRecommendation item) {
    final activity = item.name.isNotEmpty ? item.name : 'Tanpa nama';

    final rawPicture =
        (item.picture1 != null && item.picture1 != 'data not found')
            ? item.picture1
            : _getYoutubeThumbnail(item.videoLink);

    final picture = _normalizeSportImageUrl(rawPicture);

    final longText =
        item.longText ?? 'Belum ada deskripsi untuk olahraga ini.';

    final isWarning = item.recommendationLevel == 'allowed_with_caution';
    final isDanger = item.recommendationLevel == 'avoid';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SportDetailPage(sport: item)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCardImage(picture),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          activity,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (isWarning)
                        _buildBadge(
                          label: 'Dengan Pengawasan',
                          bg: const Color(0xFFFFF3CD),
                          fg: const Color(0xFF856404),
                        ),
                      if (isDanger)
                        _buildBadge(
                          label: 'Tidak Disarankan',
                          bg: const Color(0xFFF8D7DA),
                          fg: const Color(0xFF721C24),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    longText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(String? picture) {
    if (picture == null || picture.isEmpty) {
      return _buildImagePlaceholder();
    }

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.network(
              picture,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return Container(
                  color: const Color(0xFFF5F5F5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFA6978),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            ),
          ),
          if (picture.contains('youtube.com') || picture.contains('img.youtube.com'))
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildServiceUnavailableBody() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                'Layanan sedang tidak tersedia.\nSilakan coba beberapa saat lagi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderBody() {
    return const Center(
      child: Text(
        'Belum ada rekomendasi',
        style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
      ),
    );
  }
}
