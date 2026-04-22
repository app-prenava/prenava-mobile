import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref
          .read(sportRecommendationNotifierProvider.notifier)
          .fetchRecommendations();
      ref
          .read(sportRecommendationNotifierProvider.notifier)
          .fetchExistingAssessment();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAssessmentSheet({
    bool showUpdateBanner = false,
    String? errorMessage,
  }) {
    if (_sheetOpened) return;
    _sheetOpened = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: true,
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
    });
  }

  void _showLmpSheet() {
    if (_sheetOpened) return;
    _sheetOpened = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => LmpBottomSheet(
        onSuccess: (hpht, gestationalAge, isMultiple) async {
          // Step 1: Save to pregnancy_calculators
          final success = await ref
              .read(pregnancyNotifierProvider.notifier)
              .savePregnancy(hpht: hpht, babyGender: null);

          if (success && sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }

          if (success && mounted) {
            // Step 2: Create record in pregnancies table for sport recommendations
            await ref
                .read(pregnancyNotifierProvider.notifier)
                .createPregnancyRecord(
                  lmpDate: hpht,
                  gestationalAgeWeeks: gestationalAge,
                  multipleGestation: isMultiple,
                );

            // Step 3: Refresh pregnancy data
            await ref
                .read(pregnancyNotifierProvider.notifier)
                .loadMyPregnancy();

            // Step 4: Small delay then submit default assessment
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              _submitDefaultAssessment();
            }
          }
        },
      ),
    ).whenComplete(() {
      _sheetOpened = false;
    });
  }

  void _submitDefaultAssessment() {
    // Submit with default values to get recommendations
    // BMI 22.0 is considered normal/healthy range
    final payload = SportAssessmentPayload(
      bmi: 22.0,
      hypertension: false,
      isDiabetes: false,
      gestationalDiabetes: false,
      isFever: false,
      isHighHeartRate: false,
      previousComplications: false,
      mentalHealthIssue: false,
      lowImpactPref: true,
      waterAccess:
          false, // water_access_rupture - false means no water rupture issue
      backPain: false,
      placentaPositionRestriction: false,
    );
    ref
        .read(sportRecommendationNotifierProvider.notifier)
        .submitAssessment(payload);
  }

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
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF5F5F5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                _buildTabButton(
                  title: 'Rekomendasi',
                  index: 0,
                ),
                _buildTabButton(
                  title: 'Semua Olahraga',
                  index: 1,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF333333)),
            onPressed: () => _showAssessmentSheet(showUpdateBanner: true),
          ),
        ],
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

    // Check if LMP is needed first
    if (state.needsLmp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showLmpSheet();
        }
      });
      return _buildPlaceholderBody();
    }

    // Check if Profile is needed
    if (state.needsProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan lengkapi profil Anda terlebih dahulu'),
          ),
        );
      });
      return _buildPlaceholderBody();
    }

    if (state.error != null &&
        state.recommendations.isEmpty &&
        !state.needsLmp &&
        !state.needsProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showAssessmentSheet(errorMessage: state.error);
        }
      });
      return _buildPlaceholderBody();
    }

    if (state.needUpdateData || state.recommendations.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showAssessmentSheet(showUpdateBanner: state.needUpdateData);
        }
      });
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

  Widget _buildRecommendationsList(List recommendations) {
    if (recommendations.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(sportRecommendationNotifierProvider.notifier)
              .fetchRecommendations();
          await ref
              .read(sportRecommendationNotifierProvider.notifier)
              .fetchExistingAssessment();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: const Text('Belum ada rekomendasi'),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(sportRecommendationNotifierProvider.notifier)
            .fetchRecommendations();
        await ref
            .read(sportRecommendationNotifierProvider.notifier)
            .fetchExistingAssessment();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final item = recommendations[index];
          return _buildSportCard(item, index + 1);
        },
      ),
    );
  }

  Widget _buildAllSportsList(List recommendations) {
    if (recommendations.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(sportRecommendationNotifierProvider.notifier)
              .fetchRecommendations();
          await ref
              .read(sportRecommendationNotifierProvider.notifier)
              .fetchExistingAssessment();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: const Text('Belum ada data olahraga'),
          ),
        ),
      );
    }

    // Sort by score descending for "all sports" view
    final sortedRecs = List.from(recommendations)
      ..sort((a, b) => b.score.compareTo(a.score));

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(sportRecommendationNotifierProvider.notifier)
            .fetchRecommendations();
        await ref
            .read(sportRecommendationNotifierProvider.notifier)
            .fetchExistingAssessment();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedRecs.length,
        itemBuilder: (context, index) {
          final item = sortedRecs[index];
          return _buildSportCard(item, index + 1);
        },
      ),
    );
  }

  String? _getYoutubeThumbnail(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      String? videoId;
      if (uri.host.contains('youtube.com')) {
        videoId = uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://img.youtube.com/vi/$videoId/0.jpg';
      }
    } catch (_) {}
    return null;
  }

  Widget _buildSportCard(dynamic item, int rank) {
    final activity = item.activity ?? 'Tanpa nama';
    final picture = (item.picture1 != null && item.picture1 != 'data not found') 
        ? item.picture1 
        : _getYoutubeThumbnail(item.videoLink);
    final longText = item.longText ?? 'Belum ada deskripsi untuk olahraga ini.';

    // Format activity name to be title case (e.g., "walking" -> "Walking", "prenatal_yoga" -> "Prenatal Yoga")
    final formattedTitle = activity
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SportDetailPage(sport: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (picture != null && picture.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      picture,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
                    if (picture.contains('youtube.com') || picture.contains('img.youtube.com'))
                      const Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                  ],
                ),
              )
            else
              _buildImagePlaceholder(),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
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

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Color(0xFF9E9E9E),
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
